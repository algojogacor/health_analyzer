# Privacy Notice

This repository is for an early-stage personal health and fitness app. This file
documents the intended privacy model for contributors and users. It is not a
formal legal privacy policy.

## Data Categories

The app may process:

- Health Connect records such as steps, sleep, heart rate, SpO2, activity, and
  related wearable metrics when available.
- GPS activity routes and activity points.
- Local activity summaries, AI summaries, and training insights.
- User-provided Turso credentials, AI provider API keys, map API keys, and
  optional webhook or external-agent settings.

## Storage Model

- The native app stores personal data locally using Drift/SQLite and secure
  storage.
- User-owned Turso can be configured as a personal sync database.
- Koyeb gateway is intended for sanitized public/community data only.
- Termux/Telegram external agent setup is optional and controlled by the user.

## Sharing Rules

By default:

- Raw health records should not be sent to public/community endpoints.
- Raw route points should not be shared unless the user explicitly enables route
  detail sharing.
- AI context should use summaries and sanitized data before raw data.
- Public activity cards should use privacy-filtered route data or route
  thumbnails only when allowed.

## User-Controlled Keys

Users may provide their own:

- Turso database URL and auth token
- OpenAI-compatible AI provider base URL, model, and API key
- Map provider keys
- Koyeb/community gateway URL
- Webhook/external agent settings

These values must not be committed to the repository.

## Health Disclaimer

Health Analyzer is for wellness, fitness tracking, and personal insight. It is
not a medical device, does not diagnose disease, and should not be used for
emergency triage, medication decisions, or replacing professional medical care.

## Contributor Expectations

Contributors should avoid adding telemetry, hidden network calls, or broad data
collection. Any new data flow must be documented and should include explicit
user-facing controls.
