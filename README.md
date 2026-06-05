# Health Analyzer

Health Analyzer is a Flutter app for personal fitness and wearable-health
intelligence. It records workouts, collects Health Connect data, syncs to a
user-owned Turso database, and provides AI-assisted summaries while keeping raw
health and route data under user control.

The project is early-stage and open source under the Apache License 2.0.

## What It Does

- Collects health data from Android Health Connect.
- Works with smartwatch/wearable data exposed through Health Connect, including
  Xiaomi Smart Band 9 Active via Mi Fitness sync.
- Records outdoor GPS activities with foreground-service support.
- Stores local activity sessions, points, summaries, AI usage, routes, and
  settings in Drift/SQLite.
- Syncs user-owned data to Turso.
- Provides AI coach features through configurable OpenAI-compatible providers.
- Supports Koyeb as a lightweight community/share gateway.
- Supports online street/satellite maps and regional offline raster PMTiles map
  packs.
- Includes optional Termux/Telegram/ZeroClaw-style external agent docs for power
  users.

## Privacy Model

Health Analyzer is designed as a user-owned data app:

- Raw health records are not stored in the developer-owned backend.
- Raw route points are not shared publicly unless the user explicitly enables
  route detail sharing.
- Koyeb community payloads should remain sanitized/public-only.
- AI receives summarized/sanitized context by default.
- API keys, Turso credentials, and model settings are stored locally through
  secure storage.

This app is not a medical device and does not provide diagnosis, emergency
triage, or medication advice.

## Architecture

- `lib/` - Flutter app
- `lib/database/` - Drift tables and local persistence
- `lib/services/` - Health, activity, AI, map, sync, and export services
- `lib/features/` - Feature-based UI modules
- `koyeb_gateway/` - Node.js community/share gateway
- `skills/health-analyzer-skill/` - Optional external AI-agent skill/template
- `docs/` - Product roadmap, PRD, map license notes, and setup docs

## Getting Started

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

The debug APK is generated at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Install and setup instructions are in [docs/INSTALLATION.md](docs/INSTALLATION.md).

## Koyeb Gateway

The community gateway lives in `koyeb_gateway/`.

```sh
cd koyeb_gateway
node --check server.js
node server.js
```

See [koyeb_gateway/README.md](koyeb_gateway/README.md) for environment
variables, Turso persistence, map catalog setup, and endpoint details.

## Maps

Default online satellite source:

- EOX Sentinel-2 Cloudless 2017
- License: CC BY 4.0 with attribution
- Resolution is not Google/Esri-level; it is intended as a free/open baseline.

Optional providers:

- Esri World Imagery
- MapTiler Satellite with user-provided API key
- Custom HTTPS tile URLs
- Regional raster PMTiles packs for offline use

See [docs/MAP_LICENSE_DECISION.md](docs/MAP_LICENSE_DECISION.md).

## AI Providers

The app supports configurable OpenAI-compatible providers. Users can bring their
own:

- Base URL
- Model name
- API key

The default product direction uses summarized context and local rule-based
fallbacks when cloud AI is unavailable.

## Development Notes

Useful commands:

```sh
flutter analyze
flutter test
flutter build apk --debug
node --check koyeb_gateway/server.js
```

Regenerate Drift code when schema changes:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing. The intended
data model is documented in [PRIVACY.md](PRIVACY.md).

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) and
[NOTICE](NOTICE).
