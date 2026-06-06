# Contributing to Health Analyzer

Thanks for wanting to help. Health Analyzer handles sensitive health and
location data, so contributions should be careful, privacy-first, and easy to
review.

## Project Principles

- Keep personal health data user-owned.
- Do not upload raw health records or raw route points unless the user clearly
  enables that behavior.
- Do not add hidden tracking, analytics, or telemetry.
- Handle missing smartwatch sensors gracefully. Show "sensor not found" or
  "data unavailable" instead of crashing or inventing values.
- Keep AI features grounded in summarized/sanitized context by default.
- Treat health output as wellness guidance, not medical advice.

## Development Setup

Requirements:

- Flutter SDK compatible with `pubspec.yaml`
- Android SDK for Android builds
- Node.js 20+ for the Koyeb gateway
- A test Android device or emulator for UI/permission changes

Common commands:

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
node --check koyeb_gateway/server.js
cd koyeb_gateway && npm test
```

If Drift generated files become stale:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Pull Request Checklist

Before opening a PR:

- Run `flutter analyze`.
- Run `flutter test`.
- Run `flutter build apk --debug` for app-facing changes.
- Run `node --check koyeb_gateway/server.js` for gateway changes.
- Run `cd koyeb_gateway && npm test` for gateway behavior changes.
- Add or update tests when behavior changes.
- Update docs when changing privacy, sync, AI, map, or data contracts.
- Confirm no secrets, tokens, keystores, local databases, screenshots, or health
  exports are committed.

For UI changes:

- Check both dark and light mode when practical.
- Avoid cramped rows that force labels to wrap one character per line.
- Keep the primary action on each screen obvious.
- Prefer unavailable/sensor-not-found states over empty or misleading cards.
- Verify on a real Android screen when the change affects layout density.

## Sensitive Areas

Ask for extra review when changing:

- Health Connect permissions or record collection
- GPS recording and route privacy
- Turso sync payloads
- AI context generation and tool calls
- Koyeb public/community endpoints
- Map tile providers and offline map licensing
- Secure storage keys

## Code Style

- Follow existing Flutter/Riverpod/Drift patterns.
- Keep UI readable in dark and light mode.
- Prefer explicit unavailable states over silent failures.
- Avoid large unrelated refactors in feature PRs.
- Keep feature files focused; shared UI primitives belong under `lib/shared/`.
- Use sanitized summaries for AI/community flows unless raw sharing is clearly
  user-enabled.

## Local Files To Avoid

Do not commit generated or personal files such as:

- `build/`, `.dart_tool/`, `.gradle/`
- APKs generated outside release automation
- `auth.json`, `.env`, Turso tokens, AI keys, Telegram tokens
- `.sqlite`, `.db`, `.gpx`, `.pmtiles`, exports, screenshots with personal data
- Internal planning files ignored under `docs/`

## License

By contributing, you agree that your contribution is licensed under the Apache
License 2.0.
