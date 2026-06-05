# Security Policy

Health Analyzer stores and processes sensitive health, activity, location, and
AI-provider credential data. Please report security and privacy issues
privately.

## Supported Versions

This project is early-stage. Security fixes target the latest `main` branch
unless release branches are created later.

## Reporting a Vulnerability

Do not open a public GitHub issue for vulnerabilities.

Email or contact the maintainer privately with:

- A clear description of the issue
- Steps to reproduce
- Impacted data or feature area
- Whether credentials, route data, or health records may be exposed
- Suggested fix, if known

If no private contact is published yet, open a minimal public issue asking for a
private security contact without including exploit details.

## Sensitive Data Rules

Never commit:

- Turso database URLs or auth tokens
- AI API keys
- Telegram bot tokens
- Android signing keys or keystores
- Health exports, local SQLite databases, PMTiles generated from private data,
  GPX exports, screenshots containing personal data, or raw route files

## Scope Examples

In scope:

- Unauthorized access to health, route, AI, or sync data
- Raw route leakage despite privacy settings
- Token/key exposure
- Public Koyeb endpoints exposing non-public data
- AI context including raw data without explicit permission

Out of scope:

- Social engineering
- Physical access to an unlocked device
- Issues caused by user-published credentials
- Denial-of-service against third-party free tile providers
