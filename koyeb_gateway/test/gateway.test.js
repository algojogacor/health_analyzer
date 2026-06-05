import assert from 'node:assert/strict';
import { after, before, describe, it } from 'node:test';

import {
  sanitizedActivity,
  sanitizedProfile,
  server,
} from '../server.js';

let baseUrl;

before(async () => {
  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', resolve);
  });
  const address = server.address();
  baseUrl = `http://127.0.0.1:${address.port}`;
});

after(async () => {
  await new Promise((resolve, reject) => {
    server.close((error) => (error ? reject(error) : resolve()));
  });
});

async function request(path, options = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    ...options,
    headers: {
      accept: 'application/json',
      ...(options.body ? { 'content-type': 'application/json' } : {}),
      ...(options.headers || {}),
    },
  });
  const body = await response.json();
  return { response, body };
}

describe('sanitizers', () => {
  it('forces activity privacy flags to false', () => {
    const activity = sanitizedActivity({
      title: 'Morning Ride',
      sport: 'Cycling',
      privacy: {
        route_visibility: 'public',
        hide_start_end_meters: 0,
        raw_health_included: true,
        raw_route_included: true,
      },
      raw_health_records: [{ type: 'HEART_RATE', value: 180 }],
      points: [{ lat: -7.1, lon: 112.7 }],
    });

    assert.equal(activity.privacy.raw_health_included, false);
    assert.equal(activity.privacy.raw_route_included, false);
    assert.equal(activity.raw_health_records, undefined);
    assert.equal(activity.points, undefined);
  });

  it('normalizes public profile usernames and privacy', () => {
    const profile = sanitizedProfile({
      username: ' Arya Health!! ',
      display_name: 'Arya',
      privacy: {
        raw_health_included: true,
        raw_route_included: true,
      },
    });

    assert.equal(profile.username, 'aryahealth');
    assert.equal(profile.privacy.raw_health_included, false);
    assert.equal(profile.privacy.raw_route_included, false);
  });
});

describe('gateway endpoints', () => {
  it('reports healthy memory-mode status', async () => {
    const { response, body } = await request('/health');

    assert.equal(response.status, 200);
    assert.equal(body.ok, true);
    assert.equal(body.persistence, 'memory');
  });

  it('shares sanitized activities only', async () => {
    const create = await request('/share/activity', {
      method: 'POST',
      body: JSON.stringify({
        title: 'Raw Route Test',
        sport: 'Run',
        distance_meters: 5000,
        duration_seconds: 1800,
        privacy: {
          route_visibility: 'public',
          raw_health_included: true,
          raw_route_included: true,
        },
        raw_health_records: [{ type: 'SLEEP', value: 'private' }],
        raw_route_points: [{ lat: -7.1, lon: 112.7 }],
      }),
    });

    assert.equal(create.response.status, 201);
    assert.ok(create.body.shareId);

    const loaded = await request(`/activity/${create.body.shareId}?format=json`);

    assert.equal(loaded.response.status, 200);
    assert.equal(loaded.body.activity.title, 'Raw Route Test');
    assert.equal(loaded.body.activity.privacy.raw_health_included, false);
    assert.equal(loaded.body.activity.privacy.raw_route_included, false);
    assert.equal(loaded.body.activity.raw_health_records, undefined);
    assert.equal(loaded.body.activity.raw_route_points, undefined);
  });

  it('rejects personal API without explicit configuration', async () => {
    const { response, body } = await request('/personal/health');

    assert.equal(response.status, 503);
    assert.equal(body.error, 'personal_api_not_configured');
  });
});
