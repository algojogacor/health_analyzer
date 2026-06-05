import http from 'node:http';
import { randomUUID } from 'node:crypto';
import { fileURLToPath } from 'node:url';

const port = Number(process.env.PORT || 3000);
const baseUrl = process.env.PUBLIC_BASE_URL || `http://localhost:${port}`;
const tursoUrl =
  process.env.COMMUNITY_TURSO_DATABASE_URL || process.env.TURSO_DATABASE_URL || '';
const tursoToken =
  process.env.COMMUNITY_TURSO_AUTH_TOKEN || process.env.TURSO_AUTH_TOKEN || '';
const mapPackCatalog = process.env.MAP_PACK_CATALOG_JSON || '[]';
const personalApiToken = process.env.PERSONAL_API_TOKEN || '';
const personalTursoUrl = process.env.PERSONAL_TURSO_DATABASE_URL || '';
const personalTursoToken = process.env.PERSONAL_TURSO_AUTH_TOKEN || '';

const memory = {
  activities: new Map(),
  profiles: new Map(),
  challenges: new Map(),
};

function tursoEnabled() {
  return tursoUrl.trim() && tursoToken.trim();
}

function personalApiEnabled() {
  return personalApiToken.trim() && personalTursoUrl.trim() && personalTursoToken.trim();
}

function personalAuthorized(req) {
  const auth = String(req.headers.authorization || '');
  return auth === `Bearer ${personalApiToken}`;
}

function normalizeTursoUrl(url) {
  const trimmed = url.trim();
  if (trimmed.startsWith('libsql://')) return `https://${trimmed.slice(9)}`;
  if (trimmed.startsWith('http://')) return `https://${trimmed.slice(7)}`;
  if (trimmed.startsWith('https://')) return trimmed;
  if (trimmed.includes('.turso.io')) return `https://${trimmed}`;
  return `https://${trimmed}.turso.io`;
}

function sendJson(res, status, body) {
  const payload = JSON.stringify(body);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(payload),
  });
  res.end(payload);
}

function sendHtml(res, status, html) {
  res.writeHead(status, {
    'Content-Type': 'text/html; charset=utf-8',
    'Content-Length': Buffer.byteLength(html),
  });
  res.end(html);
}

function wantsJson(req, url) {
  if (url.searchParams.get('format') === 'json') return true;
  const accept = String(req.headers.accept || '');
  return accept.includes('application/json') && !accept.includes('text/html');
}

function readJson(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
      if (body.length > 64 * 1024) {
        reject(new Error('Payload too large'));
        req.destroy();
      }
    });
    req.on('end', () => {
      if (!body.trim()) return resolve({});
      try {
        resolve(JSON.parse(body));
      } catch (error) {
        reject(error);
      }
    });
  });
}

function sqlValue(value) {
  if (value == null) return { type: 'null' };
  if (Number.isInteger(value)) {
    return { type: 'integer', value: String(value) };
  }
  if (typeof value === 'number') {
    return { type: 'float', value };
  }
  return { type: 'text', value: String(value) };
}

async function tursoPipeline(requests) {
  if (!tursoEnabled()) throw new Error('Turso community DB is not configured');
  return tursoPipelineFor(tursoUrl, tursoToken, requests);
}

async function tursoPipelineFor(databaseUrl, authToken, requests) {
  const response = await fetch(`${normalizeTursoUrl(databaseUrl).replace(/\/+$/, '')}/v2/pipeline`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${authToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ requests }),
  });
  if (!response.ok) {
    throw new Error(`Turso HTTP ${response.status}`);
  }
  const payload = await response.json();
  for (const result of payload.results || []) {
    if (result.type === 'error') {
      throw new Error(result.error?.message || result.error || 'Turso statement error');
    }
  }
  return payload.results || [];
}

async function execute(sql, args = []) {
  const results = await tursoPipeline([
    {
      type: 'execute',
      stmt: { sql, args: args.map(sqlValue) },
    },
  ]);
  return results[0]?.response?.result || results[0]?.result || {};
}

async function executePersonal(sql, args = []) {
  const results = await tursoPipelineFor(personalTursoUrl, personalTursoToken, [
    {
      type: 'execute',
      stmt: { sql, args: args.map(sqlValue) },
    },
  ]);
  return results[0]?.response?.result || results[0]?.result || {};
}

async function queryOne(sql, args = []) {
  const result = await execute(sql, args);
  const cols = result.cols || [];
  const rows = result.rows || [];
  if (!rows.length) return null;
  return rowToObject(cols, rows[0]);
}

async function queryOnePersonal(sql, args = []) {
  const result = await executePersonal(sql, args);
  const cols = result.cols || [];
  const rows = result.rows || [];
  if (!rows.length) return null;
  return rowToObject(cols, rows[0]);
}

function rowToObject(cols, row) {
  const out = {};
  cols.forEach((col, index) => {
    const name = typeof col === 'string' ? col : col.name;
    const value = row[index];
    out[name] = decodeSqlValue(value);
  });
  return out;
}

function decodeSqlValue(value) {
  if (!value || value.type === 'null') return null;
  if (value.type === 'integer') return Number(value.value);
  if (value.type === 'float') return Number(value.value);
  return value.value;
}

async function ensureSchema() {
  if (!tursoEnabled()) return;
  await tursoPipeline([
    {
      type: 'execute',
      stmt: {
        sql: `CREATE TABLE IF NOT EXISTS community_activities (
          share_id TEXT NOT NULL PRIMARY KEY,
          payload_json TEXT NOT NULL,
          created_at TEXT NOT NULL
        )`,
      },
    },
    {
      type: 'execute',
      stmt: {
        sql: `CREATE TABLE IF NOT EXISTS community_challenges (
          challenge_id TEXT NOT NULL PRIMARY KEY,
          payload_json TEXT NOT NULL,
          created_at TEXT NOT NULL
        )`,
      },
    },
    {
      type: 'execute',
      stmt: {
        sql: `CREATE TABLE IF NOT EXISTS community_profiles (
          username TEXT NOT NULL PRIMARY KEY,
          payload_json TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )`,
      },
    },
    {
      type: 'execute',
      stmt: {
        sql: `CREATE TABLE IF NOT EXISTS community_reactions (
          id TEXT NOT NULL PRIMARY KEY,
          target_type TEXT NOT NULL,
          target_id TEXT NOT NULL,
          reaction TEXT NOT NULL,
          actor_hash TEXT NOT NULL,
          created_at TEXT NOT NULL,
          UNIQUE(target_type, target_id, reaction, actor_hash)
        )`,
      },
    },
  ]);
}

function sanitizedActivity(input) {
  return {
    title: String(input.title || 'Activity').slice(0, 120),
    sport: String(input.sport || 'Activity').slice(0, 80),
    sport_key: String(input.sport_key || '').slice(0, 80),
    date: String(input.date || new Date().toISOString()),
    distance_meters: Number(input.distance_meters || 0),
    duration_seconds: Number(input.duration_seconds || 0),
    pace_seconds_per_km:
      input.pace_seconds_per_km == null ? null : Number(input.pace_seconds_per_km),
    speed_mps: input.speed_mps == null ? null : Number(input.speed_mps),
    calories_kcal: input.calories_kcal == null ? null : Number(input.calories_kcal),
    ascent_meters: Number(input.ascent_meters || 0),
    route_thumbnail: input.route_thumbnail || null,
    privacy: {
      route_visibility: input.privacy?.route_visibility || 'private',
      hide_start_end_meters: Number(input.privacy?.hide_start_end_meters || 0),
      raw_health_included: false,
      raw_route_included: false,
    },
  };
}

function loadMapCatalog() {
  try {
    const parsed = JSON.parse(mapPackCatalog);
    if (!Array.isArray(parsed)) return [];
    return parsed.slice(0, 100).map((item) => ({
      id: String(item.id || '').slice(0, 80),
      name: String(item.name || 'Offline map pack').slice(0, 120),
      layer: String(item.layer || 'satellite').slice(0, 40),
      url: String(item.url || '').slice(0, 600),
      source: String(item.source || 'unknown').slice(0, 120),
      license: String(item.license || 'review required').slice(0, 160),
      attribution: String(item.attribution || '').slice(0, 240),
      size_bytes: Number(item.size_bytes || 0),
      min_zoom: Number(item.min_zoom || 0),
      max_zoom: Number(item.max_zoom || 0),
      bounds: {
        north: Number(item.bounds?.north || 0),
        south: Number(item.bounds?.south || 0),
        east: Number(item.bounds?.east || 0),
        west: Number(item.bounds?.west || 0),
      },
    })).filter((item) => item.id && item.url);
  } catch (_) {
    return [];
  }
}

function sanitizedProfile(input) {
  const username = String(input.username || '')
    .toLowerCase()
    .replace(/[^a-z0-9._-]/g, '')
    .slice(0, 40);
  if (!username) throw new Error('username_required');
  return {
    username,
    display_name: String(input.display_name || username).slice(0, 80),
    bio: String(input.bio || '').slice(0, 180),
    public_totals: {
      activity_count: Number(input.public_totals?.activity_count || 0),
      distance_meters: Number(input.public_totals?.distance_meters || 0),
      active_days: Number(input.public_totals?.active_days || 0),
      streak_days: Number(input.public_totals?.streak_days || 0),
    },
    achievements: Array.isArray(input.achievements)
      ? input.achievements.slice(0, 12).map((item) => String(item).slice(0, 80))
      : [],
    privacy: {
      raw_health_included: false,
      raw_route_included: false,
    },
  };
}

function escapeHtml(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function distanceLabel(meters) {
  const value = Number(meters || 0);
  if (value <= 0) return '--';
  return `${(value / 1000).toFixed(2)} km`;
}

function durationLabel(seconds) {
  const value = Math.max(0, Number(seconds || 0));
  const hours = Math.floor(value / 3600);
  const minutes = Math.floor((value % 3600) / 60);
  const secs = Math.floor(value % 60);
  const two = (n) => String(n).padStart(2, '0');
  return hours > 0 ? `${hours}:${two(minutes)}:${two(secs)}` : `${minutes}:${two(secs)}`;
}

function paceLabel(secondsPerKm, speedMps) {
  if (secondsPerKm != null && Number(secondsPerKm) > 0) {
    const seconds = Math.round(Number(secondsPerKm));
    return `${Math.floor(seconds / 60)}:${String(seconds % 60).padStart(2, '0')} /km`;
  }
  if (speedMps != null && Number(speedMps) > 0) {
    return `${(Number(speedMps) * 3.6).toFixed(1)} km/h`;
  }
  return '--';
}

function activityPageHtml(row) {
  const activity = row.activity || {};
  const title = escapeHtml(activity.title || activity.sport || 'Activity');
  const sport = escapeHtml(activity.sport || 'Activity');
  const date = escapeHtml(new Date(activity.date || row.createdAt).toLocaleString('en-US', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }));
  const privacy = activity.privacy || {};
  const privacyLabel = privacy.raw_route_included
    ? 'Route shared'
    : privacy.route_visibility === 'public'
      ? 'Public metrics, route hidden'
      : 'Private route';
  const kudos = row.reactions?.kudos || 0;

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title} - Health Analyzer</title>
  <style>
    :root {
      color-scheme: light dark;
      --ink: #172026;
      --muted: #6c7780;
      --line: #e6eaed;
      --cyan: #20b8d6;
      --mint: #31c48d;
      --coral: #ff4d5e;
      --surface: #ffffff;
      --canvas: #f7f9fa;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: Inter, Roboto, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: radial-gradient(circle at 100% 0%, rgba(32,184,214,.18), transparent 30%),
        linear-gradient(160deg, var(--canvas), #eef4f5);
      color: var(--ink);
      min-height: 100vh;
      display: grid;
      place-items: center;
      padding: 24px;
    }
    main {
      width: min(720px, 100%);
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: 18px;
      overflow: hidden;
      box-shadow: 0 24px 70px rgba(23,32,38,.14);
    }
    header {
      padding: 28px;
      background: linear-gradient(135deg, #151f24, #0e1518);
      color: #f4f7f8;
    }
    .pill {
      display: inline-flex;
      padding: 8px 12px;
      border-radius: 999px;
      color: #071014;
      background: var(--cyan);
      font-size: 12px;
      font-weight: 900;
      letter-spacing: .02em;
      text-transform: uppercase;
    }
    h1 {
      margin: 18px 0 8px;
      font-size: clamp(30px, 7vw, 56px);
      line-height: .96;
      letter-spacing: 0;
    }
    .date { color: rgba(244,247,248,.72); font-weight: 700; }
    .stats {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 12px;
      padding: 20px;
    }
    .stat {
      min-height: 106px;
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 16px;
      background: #fff;
    }
    .label { color: var(--muted); font-size: 13px; font-weight: 800; }
    .value { margin-top: 8px; font-size: 28px; font-weight: 950; }
    .note {
      margin: 0 20px 20px;
      border: 1px solid rgba(32,184,214,.28);
      border-radius: 14px;
      padding: 14px 16px;
      color: var(--muted);
      background: rgba(32,184,214,.08);
      font-weight: 650;
    }
    .actions {
      display: flex;
      gap: 10px;
      margin: 0 20px 4px;
    }
    .reaction {
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 10px 12px;
      color: var(--ink);
      background: var(--surface);
      font-weight: 900;
    }
    footer {
      display: flex;
      justify-content: space-between;
      gap: 16px;
      padding: 18px 20px 22px;
      color: var(--muted);
      font-size: 13px;
      font-weight: 800;
    }
    @media (prefers-color-scheme: dark) {
      body {
        background: radial-gradient(circle at 100% 0%, rgba(32,184,214,.18), transparent 30%),
          linear-gradient(160deg, #0e1518, #151f24);
      }
      main { background: #151f24; border-color: #26343b; }
      .stat { background: #0e1518; border-color: #26343b; }
      .reaction { background: #0e1518; border-color: #26343b; color: #f4f7f8; }
      .value { color: #f4f7f8; }
      .note { border-color: rgba(32,184,214,.36); color: #9aa6ad; }
    }
  </style>
</head>
<body>
  <main>
    <header>
      <span class="pill">${sport}</span>
      <h1>${title}</h1>
      <div class="date">${date}</div>
    </header>
    <section class="stats">
      <div class="stat"><div class="label">Distance</div><div class="value">${distanceLabel(activity.distance_meters)}</div></div>
      <div class="stat"><div class="label">Moving time</div><div class="value">${durationLabel(activity.duration_seconds)}</div></div>
      <div class="stat"><div class="label">Pace / speed</div><div class="value">${paceLabel(activity.pace_seconds_per_km, activity.speed_mps)}</div></div>
      <div class="stat"><div class="label">Ascent</div><div class="value">${Math.round(Number(activity.ascent_meters || 0))} m</div></div>
    </section>
    <p class="note">${escapeHtml(privacyLabel)}. Raw health records and raw route points are not included in this public card.</p>
    <div class="actions"><span class="reaction">Kudos ${kudos}</span></div>
    <footer>
      <span>Health Analyzer</span>
      <span>${escapeHtml(row.shareId)}</span>
    </footer>
  </main>
</body>
</html>`;
}

function profilePageHtml(profile) {
  const name = escapeHtml(profile.display_name || profile.username);
  const username = escapeHtml(profile.username);
  const totals = profile.public_totals || {};
  const achievements = Array.isArray(profile.achievements) ? profile.achievements : [];
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${name} - Health Analyzer</title>
  <style>
    body { margin:0; font-family: Inter, Roboto, system-ui, sans-serif; background:#f7f9fa; color:#172026; padding:24px; }
    main { width:min(760px,100%); margin:auto; background:#fff; border:1px solid #e6eaed; border-radius:18px; overflow:hidden; box-shadow:0 18px 54px rgba(23,32,38,.12); }
    header { padding:30px; background:#151f24; color:#f4f7f8; }
    h1 { margin:0; font-size:clamp(34px,7vw,58px); letter-spacing:0; }
    .user { color:#9aa6ad; font-weight:800; margin-top:6px; }
    .bio { margin-top:18px; color:#d9e2e6; max-width:60ch; line-height:1.45; }
    .grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:12px; padding:20px; }
    .stat { border:1px solid #e6eaed; border-radius:14px; padding:16px; }
    .label { color:#6c7780; font-size:13px; font-weight:800; }
    .value { margin-top:8px; font-size:28px; font-weight:950; }
    .chips { display:flex; flex-wrap:wrap; gap:8px; padding:0 20px 22px; }
    .chip { border-radius:999px; padding:8px 12px; background:rgba(32,184,214,.12); color:#137e94; font-weight:900; }
    .note { margin:0 20px 22px; color:#6c7780; font-weight:700; }
    @media (prefers-color-scheme: dark) {
      body { background:#0e1518; color:#f4f7f8; }
      main { background:#151f24; border-color:#26343b; }
      .stat { border-color:#26343b; }
      .note, .label { color:#9aa6ad; }
    }
  </style>
</head>
<body>
  <main>
    <header>
      <h1>${name}</h1>
      <div class="user">@${username}</div>
      <div class="bio">${escapeHtml(profile.bio || 'Health Analyzer public profile')}</div>
    </header>
    <section class="grid">
      <div class="stat"><div class="label">Activities</div><div class="value">${Math.round(Number(totals.activity_count || 0))}</div></div>
      <div class="stat"><div class="label">Distance</div><div class="value">${distanceLabel(totals.distance_meters)}</div></div>
      <div class="stat"><div class="label">Active days</div><div class="value">${Math.round(Number(totals.active_days || 0))}</div></div>
      <div class="stat"><div class="label">Streak</div><div class="value">${Math.round(Number(totals.streak_days || 0))}</div></div>
    </section>
    <div class="chips">${achievements.map((item) => `<span class="chip">${escapeHtml(item)}</span>`).join('')}</div>
    <p class="note">This public profile contains sanitized totals only. Raw health records and raw routes are not published.</p>
  </main>
</body>
</html>`;
}

function challengePageHtml(challenge) {
  const leaderboard = Array.isArray(challenge.leaderboard) ? challenge.leaderboard : [];
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${escapeHtml(challenge.title)} - Health Analyzer</title>
  <style>
    body { margin:0; font-family: Inter, Roboto, system-ui, sans-serif; background:#f7f9fa; color:#172026; padding:24px; }
    main { width:min(720px,100%); margin:auto; background:#fff; border:1px solid #e6eaed; border-radius:18px; overflow:hidden; box-shadow:0 18px 54px rgba(23,32,38,.12); }
    header { padding:28px; background:linear-gradient(135deg,#151f24,#0e1518); color:#f4f7f8; }
    h1 { margin:0; font-size:clamp(32px,7vw,54px); letter-spacing:0; }
    .meta { margin-top:12px; color:#9aa6ad; font-weight:800; }
    .rows { padding:20px; display:grid; gap:10px; }
    .row { display:flex; justify-content:space-between; border:1px solid #e6eaed; border-radius:12px; padding:14px; font-weight:850; }
    .empty { color:#6c7780; font-weight:700; padding:20px; }
    @media (prefers-color-scheme: dark) {
      body { background:#0e1518; color:#f4f7f8; }
      main { background:#151f24; border-color:#26343b; }
      .row { border-color:#26343b; }
      .empty { color:#9aa6ad; }
    }
  </style>
</head>
<body>
  <main>
    <header>
      <h1>${escapeHtml(challenge.title)}</h1>
      <div class="meta">${escapeHtml(challenge.metric)} target: ${escapeHtml(challenge.target_value)}</div>
    </header>
    ${
      leaderboard.length
        ? `<section class="rows">${leaderboard.map((row, index) => `<div class="row"><span>${index + 1}. ${escapeHtml(row.name || 'Athlete')}</span><span>${escapeHtml(row.value || 0)}</span></div>`).join('')}</section>`
        : '<p class="empty">Leaderboard is waiting for participants.</p>'
    }
  </main>
</body>
</html>`;
}

async function storeActivity(shareId, activity) {
  const row = { shareId, activity, createdAt: new Date().toISOString() };
  if (!tursoEnabled()) {
    memory.activities.set(shareId, row);
    return row;
  }
  await execute(
    `INSERT OR REPLACE INTO community_activities
      (share_id, payload_json, created_at)
      VALUES (?, ?, ?)`,
    [shareId, JSON.stringify(activity), row.createdAt],
  );
  return row;
}

async function loadActivity(shareId) {
  if (!tursoEnabled()) return memory.activities.get(shareId) || null;
  const row = await queryOne(
    'SELECT share_id, payload_json, created_at FROM community_activities WHERE share_id = ? LIMIT 1',
    [shareId],
  );
  if (!row) return null;
  return {
    shareId: row.share_id,
    activity: JSON.parse(row.payload_json),
    createdAt: row.created_at,
  };
}

async function storeChallenge(challenge) {
  if (!tursoEnabled()) {
    memory.challenges.set(challenge.id, challenge);
    return challenge;
  }
  await execute(
    `INSERT OR REPLACE INTO community_challenges
      (challenge_id, payload_json, created_at)
      VALUES (?, ?, ?)`,
    [challenge.id, JSON.stringify(challenge), challenge.createdAt],
  );
  return challenge;
}

async function loadChallenge(id) {
  if (!tursoEnabled()) return memory.challenges.get(id) || null;
  const row = await queryOne(
    'SELECT challenge_id, payload_json, created_at FROM community_challenges WHERE challenge_id = ? LIMIT 1',
    [id],
  );
  if (!row) return null;
  return JSON.parse(row.payload_json);
}

async function loadProfile(username) {
  if (!tursoEnabled()) {
    return memory.profiles.get(username) || { username, activities: [] };
  }
  const row = await queryOne(
    'SELECT username, payload_json, updated_at FROM community_profiles WHERE username = ? LIMIT 1',
    [username],
  );
  if (!row) return { username, activities: [] };
  return JSON.parse(row.payload_json);
}

async function storeProfile(profile) {
  const row = { ...profile, updated_at: new Date().toISOString() };
  if (!tursoEnabled()) {
    memory.profiles.set(profile.username, row);
    return row;
  }
  await execute(
    `INSERT OR REPLACE INTO community_profiles
      (username, payload_json, updated_at)
      VALUES (?, ?, ?)`,
    [profile.username, JSON.stringify(row), row.updated_at],
  );
  return row;
}

async function storeReaction({ targetType, targetId, reaction, actorHash }) {
  const id = randomUUID();
  const createdAt = new Date().toISOString();
  const cleanReaction = String(reaction || 'kudos').slice(0, 24);
  const cleanActor = String(actorHash || 'anonymous').slice(0, 80);
  if (!tursoEnabled()) {
    const key = `${targetType}:${targetId}:${cleanReaction}:${cleanActor}`;
    memory.challenges.set(`reaction:${key}`, {
      id,
      targetType,
      targetId,
      reaction: cleanReaction,
      actorHash: cleanActor,
      createdAt,
    });
    return { ok: true };
  }
  await execute(
    `INSERT OR IGNORE INTO community_reactions
      (id, target_type, target_id, reaction, actor_hash, created_at)
      VALUES (?, ?, ?, ?, ?, ?)`,
    [id, targetType, targetId, cleanReaction, cleanActor, createdAt],
  );
  return { ok: true };
}

async function reactionCounts(targetType, targetId) {
  if (!tursoEnabled()) {
    const counts = {};
    for (const [key, value] of memory.challenges.entries()) {
      if (!key.startsWith('reaction:')) continue;
      if (value.targetType === targetType && value.targetId === targetId) {
        counts[value.reaction] = (counts[value.reaction] || 0) + 1;
      }
    }
    return counts;
  }
  const result = await execute(
    `SELECT reaction, COUNT(*) AS count
      FROM community_reactions
      WHERE target_type = ? AND target_id = ?
      GROUP BY reaction`,
    [targetType, targetId],
  );
  const cols = result.cols || [];
  const rows = result.rows || [];
  const counts = {};
  for (const row of rows) {
    const object = rowToObject(cols, row);
    counts[object.reaction] = object.count;
  }
  return counts;
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url || '/', baseUrl);

  try {
    if (req.method === 'GET' && url.pathname === '/health') {
      return sendJson(res, 200, {
        ok: true,
        service: 'health-analyzer-community',
        persistence: tursoEnabled() ? 'turso' : 'memory',
        personal_api: personalApiEnabled(),
      });
    }

    if (req.method === 'GET' && url.pathname === '/personal/health') {
      if (!personalApiEnabled()) return sendJson(res, 503, { error: 'personal_api_not_configured' });
      if (!personalAuthorized(req)) return sendJson(res, 401, { error: 'unauthorized' });
      return sendJson(res, 200, {
        ok: true,
        scopes: ['daily_summaries', 'activity_summaries'],
        raw_health_enabled: false,
        raw_route_enabled: false,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/personal/health/daily/')) {
      if (!personalApiEnabled()) return sendJson(res, 503, { error: 'personal_api_not_configured' });
      if (!personalAuthorized(req)) return sendJson(res, 401, { error: 'unauthorized' });
      const date = url.pathname.split('/').pop();
      const row = await queryOnePersonal(
        'SELECT local_date, json_summary, markdown_summary, generated_at, model, confidence FROM daily_summaries WHERE local_date = ? LIMIT 1',
        [date],
      );
      if (!row) return sendJson(res, 404, { error: 'daily_summary_not_found' });
      return sendJson(res, 200, {
        local_date: row.local_date,
        json_summary: JSON.parse(row.json_summary),
        markdown_summary: row.markdown_summary,
        generated_at: row.generated_at,
        model: row.model,
        confidence: row.confidence,
        raw_health_included: false,
        raw_route_included: false,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/personal/activity/')) {
      if (!personalApiEnabled()) return sendJson(res, 503, { error: 'personal_api_not_configured' });
      if (!personalAuthorized(req)) return sendJson(res, 401, { error: 'unauthorized' });
      const parts = url.pathname.split('/');
      const sessionId = parts[3];
      if (parts[4] !== 'summary') return sendJson(res, 404, { error: 'not_found' });
      const row = await queryOnePersonal(
        'SELECT session_local_id, json_summary, markdown_summary, generated_at, model, confidence, generated_by, agent_notes FROM activity_summaries WHERE session_local_id = ? LIMIT 1',
        [sessionId],
      );
      if (!row) return sendJson(res, 404, { error: 'activity_summary_not_found' });
      return sendJson(res, 200, {
        session_local_id: row.session_local_id,
        json_summary: JSON.parse(row.json_summary),
        markdown_summary: row.markdown_summary,
        generated_at: row.generated_at,
        model: row.model,
        confidence: row.confidence,
        generated_by: row.generated_by,
        agent_notes: row.agent_notes,
        raw_health_included: false,
        raw_route_included: false,
      });
    }

    if (req.method === 'GET' && url.pathname === '/maps/catalog') {
      return sendJson(res, 200, {
        packs: loadMapCatalog(),
        note: 'Catalog metadata only. The app downloads PMTiles directly from the listed pack URLs.',
      });
    }

    if (req.method === 'POST' && url.pathname === '/share/activity') {
      const body = await readJson(req);
      const activity = sanitizedActivity(body);
      const shareId = randomUUID();
      await storeActivity(shareId, activity);
      return sendJson(res, 201, {
        shareId,
        publicUrl: `${baseUrl.replace(/\/+$/, '')}/activity/${shareId}`,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/activity/')) {
      const shareId = url.pathname.split('/').pop();
      const activity = await loadActivity(shareId);
      if (!activity) return sendJson(res, 404, { error: 'activity_not_found' });
      activity.reactions = await reactionCounts('activity', shareId);
      if (!wantsJson(req, url)) {
        return sendHtml(res, 200, activityPageHtml(activity));
      }
      return sendJson(res, 200, activity);
    }

    if (req.method === 'POST' && url.pathname.match(/^\/activity\/[^/]+\/reaction$/)) {
      const parts = url.pathname.split('/');
      const shareId = parts[2];
      const activity = await loadActivity(shareId);
      if (!activity) return sendJson(res, 404, { error: 'activity_not_found' });
      const body = await readJson(req);
      await storeReaction({
        targetType: 'activity',
        targetId: shareId,
        reaction: body.reaction || 'kudos',
        actorHash: body.actor_hash || req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'anonymous',
      });
      return sendJson(res, 200, {
        ok: true,
        reactions: await reactionCounts('activity', shareId),
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/u/')) {
      const username = url.pathname.split('/').pop();
      const profile = await loadProfile(username);
      if (!wantsJson(req, url)) {
        return sendHtml(res, 200, profilePageHtml(profile));
      }
      return sendJson(res, 200, {
        username,
        profile,
      });
    }

    if (req.method === 'POST' && url.pathname === '/profile') {
      const body = await readJson(req);
      const profile = await storeProfile(sanitizedProfile(body));
      return sendJson(res, 201, {
        username: profile.username,
        publicUrl: `${baseUrl.replace(/\/+$/, '')}/u/${profile.username}`,
      });
    }

    if (req.method === 'POST' && url.pathname === '/challenge/invite') {
      const body = await readJson(req);
      const id = randomUUID();
      const challenge = {
        id,
        title: String(body.title || 'Friend challenge').slice(0, 120),
        metric: String(body.metric || 'distance').slice(0, 40),
        target_value: Number(body.target_value || 0),
        leaderboard: [],
        createdAt: new Date().toISOString(),
      };
      await storeChallenge(challenge);
      return sendJson(res, 201, {
        challengeId: id,
        inviteUrl: `${baseUrl.replace(/\/+$/, '')}/challenge/${id}`,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/challenge/')) {
      const id = url.pathname.split('/').pop();
      const challenge = await loadChallenge(id);
      if (!challenge) return sendJson(res, 404, { error: 'challenge_not_found' });
      if (!wantsJson(req, url)) {
        return sendHtml(res, 200, challengePageHtml(challenge));
      }
      return sendJson(res, 200, challenge);
    }

    if (req.method === 'POST' && url.pathname === '/telegram/webhook') {
      await readJson(req);
      return sendJson(res, 200, {
        ok: true,
        note: 'Telegram relay is optional and not required by the native app.',
      });
    }

    return sendJson(res, 404, { error: 'not_found' });
  } catch (error) {
    return sendJson(res, 400, { error: error.message || 'bad_request' });
  }
});

async function startServer() {
  await ensureSchema();
  server.listen(port, () => {
    console.log(
      `Health Analyzer community gateway listening on ${port} (${tursoEnabled() ? 'turso' : 'memory'})`,
    );
  });
}

const isMainModule = process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1];

if (isMainModule) {
  startServer().catch((error) => {
    console.error('Failed to initialize gateway:', error);
    process.exit(1);
  });
}

export {
  ensureSchema,
  loadMapCatalog,
  personalApiEnabled,
  personalAuthorized,
  sanitizedActivity,
  sanitizedProfile,
  server,
  startServer,
};
