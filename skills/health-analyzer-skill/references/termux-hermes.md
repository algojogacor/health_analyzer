# Termux Hermes Notes

Use this reference when installing the skill on Android Termux.

## Runtime Shape

- Run Hermes Agent in Termux.
- Use a cloud model provider such as DeepSeek API or OpenRouter routing to DeepSeek.
- Keep heavy work off the phone: Termux should run orchestration, scripts, memory, and summaries only.

## Environment Variables

Set these in `~/.hermes/.env`, `~/.bashrc`, or `~/.zshrc`:

```sh
export TURSO_DATABASE_URL='libsql://your-db.turso.io'
export TURSO_AUTH_TOKEN='your-token'
export HEALTH_PREFERRED_STEP_SOURCE='com.xiaomi.wearable'
```

DeepSeek configuration depends on the Hermes provider setup. If Hermes supports a direct DeepSeek provider in the installed version, configure it through `hermes model` or `hermes setup`. Otherwise use an OpenAI-compatible route such as OpenRouter and select a DeepSeek model there.

## Generate Summary

From the skill folder:

```sh
python scripts/generate_daily_summary.py --date 2026-06-04 --out-dir ~/health
```

The script automatically reads `~/.hermes/.env` when shell environment variables are not set. Do not `source ~/.hermes/.env` unless every key in that file is a valid shell variable name.

Outputs:

- `health-summary-YYYY-MM-DD.md`
- `health-summary-YYYY-MM-DD.json`

Tell Hermes to read the markdown file before answering health trend questions.
