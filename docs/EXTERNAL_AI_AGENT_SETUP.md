# External AI Agent Setup

**Status:** Optional developer / power-user add-on  
**Product dependency:** Not required for the native app, Turso sync, Koyeb community, or normal AI settings.

## Purpose

External agents such as ZeroClaw, Hermes, or a Telegram bot can read Health Analyzer summaries and answer broader personal health/fitness questions. This mode is meant for developers and advanced users who want a long-running assistant in Termux, VPS, or a private machine.

The official user product remains:

- Flutter native app
- User-owned Turso database
- Optional Koyeb community gateway
- Native app AI using user-provided OpenAI-compatible keys

## Privacy Rules

- Prefer generated markdown/JSON summaries over raw tables.
- Do not expose Turso credentials to other users.
- Keep `ALLOW_RAW_ROUTE_POINTS=false` unless the user explicitly wants raw route analysis.
- Never send raw health records, raw GPS points, API keys, or Telegram tokens to Koyeb community endpoints.
- Treat outputs as wellness guidance, not medical diagnosis.

## Files To Use

- Skill: `skills/health-analyzer-skill/SKILL.md`
- Daily summary script: `skills/health-analyzer-skill/scripts/generate_daily_summary.py`
- Telegram dev bot script: `skills/health-analyzer-skill/scripts/telegram_health_bot.py`
- Data contract: `skills/health-analyzer-skill/references/data-contract.md`
- Environment template: `skills/health-analyzer-skill/agent.env.example`

## Termux Quick Setup

One-command setup from a cloned repo:

```sh
sh scripts/termux_agent_setup.sh
```

Or install directly from GitHub:

```sh
pkg install -y curl
curl -fsSL https://raw.githubusercontent.com/algojogacor/health_analyzer/main/scripts/termux_agent_setup.sh | sh
```

The script creates `~/.health-analyzer-agent/.env`, installs the skill into
`~/.hermes/skills/health-analyzer-skill`, and creates helper commands:

- `~/.health-analyzer-agent/bin/generate-today`
- `~/.health-analyzer-agent/bin/telegram-health-bot`

Manual setup:

```sh
pkg update
pkg install python git openssh
mkdir -p ~/.health-analyzer-agent
cp skills/health-analyzer-skill/agent.env.example ~/.health-analyzer-agent/.env
nano ~/.health-analyzer-agent/.env
```

Generate a daily summary:

```sh
export $(grep -v '^#' ~/.health-analyzer-agent/.env | xargs)
python skills/health-analyzer-skill/scripts/generate_daily_summary.py \
  --date 2026-06-05 \
  --out-dir ~/health-analyzer-summaries
```

## ZeroClaw / Hermes Shape

Use Health Analyzer as a skill/tool source:

1. Load `SKILL.md` into the agent skill directory.
2. Configure Turso URL/token from `agent.env.example`.
3. Configure model provider separately. The app does not ship a Telegram model key.
4. Instruct the agent to read `health-summary-YYYY-MM-DD.md` before answering health trend questions.
5. Use raw route/detail data only after explicit user consent.

## Telegram Developer Bot

Telegram mode is a developer convenience, not a required product feature.

```sh
export $(grep -v '^#' ~/.health-analyzer-agent/.env | xargs)
python skills/health-analyzer-skill/scripts/telegram_health_bot.py
```

The bot should remain private. Restrict allowed chat/user IDs when possible.

## Native App Integration

The native app should expose this as documentation/setup only:

- Explain that external agent mode is optional.
- Export or point to the skill folder and env template.
- Let users bring their own model, Telegram token, and framework.
- Keep normal users on the native AI tab and Koyeb community layer.

## Troubleshooting

- If steps look duplicated, prefer `com.xiaomi.wearable` and inspect source breakdown.
- If HRV/stress is missing, report sensor/export unavailable instead of inferring exact Mi Fitness stress.
- If sleep differs from Mi Fitness, compare sleep stage totals and source timestamps.
- If the agent cannot access Turso, test the daily summary script before debugging the agent framework.
