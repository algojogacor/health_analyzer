---
name: health-analyzer-skill
description: Generate agent-friendly wearable health summaries from Turso `health_records` data collected by the Health Analyzer Flutter app. Use when an agent needs to query personal Health Connect/wearable data, create daily markdown or JSON health summaries, distinguish raw interval records from safe daily aggregates, inspect activity/sleep/SpO2/heart-rate trends, or prepare context for a wellness-focused AI health assistant using Hermes, OpenClaw, or similar skill-based agents.
---

# Health Analyzer Skill

## Overview

Use this skill to turn raw Health Connect records in Turso into concise daily summaries that an AI agent can safely reference. Prefer summaries over raw records for conversation because raw wearable intervals may overlap across sources.

## Quick Start

Run the bundled script:

```sh
python scripts/generate_daily_summary.py --date YYYY-MM-DD --out-dir ./health
```

Required configuration:

```sh
export TURSO_DATABASE_URL='libsql://your-db.turso.io'
export TURSO_AUTH_TOKEN='your-token'
export HEALTH_PREFERRED_STEP_SOURCE='com.xiaomi.wearable'
```

The script writes:

- `health-summary-YYYY-MM-DD.md`
- `health-summary-YYYY-MM-DD.json`

Load the markdown summary before answering user questions about daily health trends.

## Workflow

1. Generate the daily summary with `scripts/generate_daily_summary.py`.
2. Read the markdown output for conversational answers.
3. Use the JSON output for structured checks or downstream tooling.
4. If values look inconsistent, inspect `steps.by_source` and `data_quality_notes` before giving conclusions.
5. Ask follow-up questions when the data is missing, contradictory, or clinically ambiguous.

## Interpretation Rules

- Treat Turso `health_records` as raw interval data, not ground-truth daily totals.
- Do not sum steps across all sources by default.
- Prefer `com.xiaomi.wearable` for Xiaomi band steps when available.
- Report uncertainty when Android/Health Connect phone sources overlap with wearable sources.
- Use `HEART_RATE_VARIABILITY_RMSSD` as a stress/recovery proxy only; do not claim it is the exact Mi Fitness Stress score unless `STRESS` records exist.
- Use summaries for wellness insights, trend review, and habit feedback only.
- Do not diagnose disease, prescribe medication, recommend stopping medication, or provide emergency triage.

For schema and source rules, read `references/data-contract.md`.

For Android Termux and Hermes setup notes, read `references/termux-hermes.md`.

## Script Notes

`scripts/generate_daily_summary.py` uses only Python standard library modules. It is intended to run in Termux, Linux, macOS, Windows, or lightweight cloud containers.

Useful options:

```sh
python scripts/generate_daily_summary.py --date 2026-06-04
python scripts/generate_daily_summary.py --date 2026-06-04 --step-source com.xiaomi.wearable
python scripts/generate_daily_summary.py --date 2026-06-04 --json-only
```

If `TURSO_DATABASE_URL` starts with `libsql://`, the script converts it to Turso's HTTPS pipeline endpoint automatically.
