import http from 'node:http';
import { randomUUID } from 'node:crypto';

const port = Number(process.env.PORT || 3000);
const baseUrl = process.env.PUBLIC_BASE_URL || `http://localhost:${port}`;
const activities = new Map();
const profiles = new Map();
const challenges = new Map();

function sendJson(res, status, body) {
  const payload = JSON.stringify(body);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(payload),
  });
  res.end(payload);
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

function sanitizedActivity(input) {
  const allowed = {
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
  return allowed;
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url || '/', baseUrl);

  try {
    if (req.method === 'GET' && url.pathname === '/health') {
      return sendJson(res, 200, { ok: true, service: 'health-analyzer-community' });
    }

    if (req.method === 'POST' && url.pathname === '/share/activity') {
      const body = await readJson(req);
      const activity = sanitizedActivity(body);
      const shareId = randomUUID();
      activities.set(shareId, { shareId, activity, createdAt: new Date().toISOString() });
      return sendJson(res, 201, {
        shareId,
        publicUrl: `${baseUrl.replace(/\/+$/, '')}/activity/${shareId}`,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/activity/')) {
      const shareId = url.pathname.split('/').pop();
      const activity = activities.get(shareId);
      if (!activity) return sendJson(res, 404, { error: 'activity_not_found' });
      return sendJson(res, 200, activity);
    }

    if (req.method === 'GET' && url.pathname.startsWith('/u/')) {
      const username = url.pathname.split('/').pop();
      return sendJson(res, 200, {
        username,
        profile: profiles.get(username) || { username, activities: [] },
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
      challenges.set(id, challenge);
      return sendJson(res, 201, {
        challengeId: id,
        inviteUrl: `${baseUrl.replace(/\/+$/, '')}/challenge/${id}`,
      });
    }

    if (req.method === 'GET' && url.pathname.startsWith('/challenge/')) {
      const id = url.pathname.split('/').pop();
      const challenge = challenges.get(id);
      if (!challenge) return sendJson(res, 404, { error: 'challenge_not_found' });
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

server.listen(port, () => {
  console.log(`Health Analyzer community gateway listening on ${port}`);
});
