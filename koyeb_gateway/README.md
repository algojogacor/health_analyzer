# Health Analyzer Community Gateway

Lightweight Koyeb gateway for public/community features.

This service intentionally stores only sanitized public activity cards and
challenge stubs. It must not receive raw Health Connect records or raw GPS
points from the native app.

## Endpoints

- `GET /health`
- `POST /share/activity`
- `GET /activity/:shareId`
- `GET /u/:username`
- `POST /challenge/invite`
- `GET /challenge/:id`
- `POST /telegram/webhook`

## Run

```sh
npm start
```

Set `PUBLIC_BASE_URL` in Koyeb so generated links use the deployed domain.
