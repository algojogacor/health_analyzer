# Health Analyzer Community Gateway

Lightweight Koyeb gateway for public/community features.

This service intentionally stores only sanitized public activity cards and
challenge stubs. It must not receive raw Health Connect records or raw GPS
points from the native app.

Persistence:

- If `COMMUNITY_TURSO_DATABASE_URL` and `COMMUNITY_TURSO_AUTH_TOKEN` are set,
  the gateway persists shares/challenges in Turso via HTTP pipeline.
- If Turso env vars are missing, the gateway falls back to in-memory storage
  for local development only.

Use a **community Turso database**, not a user's personal Health Analyzer DB.

## Endpoints

- `GET /health`
- `GET /maps/catalog`
- `GET /personal/health` - requires `Authorization: Bearer PERSONAL_API_TOKEN`
- `GET /personal/health/daily/:date` - summary-only personal API
- `GET /personal/activity/:sessionLocalId/summary` - summary-only personal API
- `POST /share/activity`
- `GET /activity/:shareId` - browser HTML card by default, JSON when
  `Accept: application/json` or `?format=json` is used.
- `POST /activity/:shareId/reaction`
- `POST /profile`
- `GET /u/:username`
- `POST /challenge/invite`
- `GET /challenge/:id` - browser HTML card by default, JSON when
  `Accept: application/json` or `?format=json` is used.
- `POST /telegram/webhook`

## Run

```sh
npm start
```

Set `PUBLIC_BASE_URL` in Koyeb so generated links use the deployed domain.

Koyeb env:

Copy `.env.example` when running locally, or set the same variables in Koyeb.

```sh
PUBLIC_BASE_URL=https://your-app.koyeb.app
COMMUNITY_TURSO_DATABASE_URL=libsql://your-community-db.turso.io
COMMUNITY_TURSO_AUTH_TOKEN=your-community-db-token
MAP_PACK_CATALOG_JSON=[]
PERSONAL_API_TOKEN=
PERSONAL_TURSO_DATABASE_URL=
PERSONAL_TURSO_AUTH_TOKEN=
```

`PERSONAL_*` env vars are optional power-user settings. They expose summary-only
personal API endpoints with bearer auth. They must not use the community Turso
database unless the owner explicitly wants that. Raw health records and raw route
points are not served by these endpoints.

`MAP_PACK_CATALOG_JSON` is an optional JSON array of PMTiles pack metadata:

```json
[
  {
    "id": "surabaya-sentinel2-demo",
    "name": "Surabaya Satellite Demo",
    "layer": "satellite",
    "format": "raster_pmtiles",
    "url": "https://example.com/surabaya.pmtiles",
    "source": "Sentinel-2",
    "license": "review required",
    "attribution": "Contains modified Sentinel-2 imagery",
    "size_bytes": 52428800,
    "min_zoom": 10,
    "max_zoom": 15,
    "bounds": { "north": -7.1, "south": -7.4, "east": 112.9, "west": 112.5 }
  }
]
```

The Flutter app renders local PMTiles through `flutter_map_pmtiles`, which
supports raster PMTiles. Do not publish vector-only `.pmtiles` packs in this
catalog until the native app adds a vector renderer.
