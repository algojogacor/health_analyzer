# Installation Guide

Health Analyzer is currently distributed as an APK for direct installation or
developer-side ADB install. Play Store publishing is not required.

## Android APK Install

For normal users:

1. Download the APK from the project release or from the developer.
2. On Android, allow "Install unknown apps" for the app you use to open the APK.
3. Open the APK and install.
4. Open Health Analyzer.
5. Complete onboarding:
   - Health Connect permissions
   - profile/goals
   - favorite sports
   - optional Turso credentials
   - optional AI provider key

Health Analyzer handles missing sensors safely. If a smartwatch or Health
Connect source does not expose HRV, stress, cadence, SpO2, or another metric,
the app should show unavailable/sensor-not-found states instead of crashing.

## Developer USB Install

Requirements:

- Flutter SDK
- Android SDK / ADB
- USB debugging enabled on the phone
- RSA prompt approved on the phone

Windows PowerShell:

```powershell
.\scripts\install_android_debug.ps1 -Build -Launch
```

Install an already-built APK:

```powershell
.\scripts\install_android_debug.ps1
```

Uninstall first, then install:

```powershell
.\scripts\install_android_debug.ps1 -Build -UninstallFirst -Launch
```

Linux/macOS/Git Bash:

```sh
BUILD_APK=1 LAUNCH_APP=1 sh scripts/install_android_debug.sh
```

The APK path is:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Termux External AI Agent Setup

The native app does not require Termux. Termux is an optional developer/power
user add-on for Telegram/ZeroClaw/Hermes-style agents.

### One-command setup after cloning

```sh
sh scripts/termux_agent_setup.sh
```

### One-command setup from GitHub

```sh
pkg install -y curl
curl -fsSL https://raw.githubusercontent.com/algojogacor/health_analyzer/main/scripts/termux_agent_setup.sh | sh
```

The script:

- Installs Termux packages: Python, Git, OpenSSH, coreutils.
- Clones/updates the Health Analyzer repo if needed.
- Installs `health-analyzer-skill` into `~/.hermes/skills/`.
- Creates `~/.health-analyzer-agent/.env` from the template if missing.
- Creates helper commands:
  - `~/.health-analyzer-agent/bin/generate-today`
  - `~/.health-analyzer-agent/bin/telegram-health-bot`

Edit the env file:

```sh
nano ~/.health-analyzer-agent/.env
```

Required for summaries:

```sh
TURSO_DATABASE_URL=libsql://your-db.turso.io
TURSO_AUTH_TOKEN=your-user-owned-token
```

Required for cloud AI replies:

```sh
LLM_BASE_URL=https://api.deepseek.com
LLM_API_KEY=your-model-api-key
LLM_MODEL=deepseek-chat
```

Required for Telegram bot mode:

```sh
TELEGRAM_BOT_TOKEN=your-private-bot-token
TELEGRAM_ALLOWED_USER_IDS=your-telegram-user-id
```

Test summary generation:

```sh
~/.health-analyzer-agent/bin/generate-today
```

Start Telegram bot:

```sh
~/.health-analyzer-agent/bin/telegram-health-bot
```

## Koyeb Gateway Setup

See [koyeb_gateway/README.md](../koyeb_gateway/README.md).

Use `koyeb_gateway/.env.example` as the local template. The Koyeb gateway is for
sanitized community/share data, not raw personal health storage.

## Verification Commands

```sh
flutter analyze
flutter test
flutter build apk --debug
node --check koyeb_gateway/server.js
cd koyeb_gateway && npm test
```
