#!/usr/bin/env sh
set -eu

REPO_URL="${HEALTH_ANALYZER_REPO_URL:-https://github.com/algojogacor/health_analyzer.git}"
WORK_DIR="${HEALTH_ANALYZER_SETUP_WORK_DIR:-$HOME/.health-analyzer-agent/repo}"
AGENT_DIR="${HEALTH_ANALYZER_AGENT_DIR:-$HOME/.health-analyzer-agent}"
HERMES_DIR="${HERMES_HOME:-$HOME/.hermes}"
SKILL_NAME="health-analyzer-skill"
HERMES_SKILL_DIR="$HERMES_DIR/skills/$SKILL_NAME"
ENV_FILE="$AGENT_DIR/.env"

info() {
  printf '\033[1;36m%s\033[0m\n' "$1"
}

warn() {
  printf '\033[1;33m%s\033[0m\n' "$1"
}

if command -v pkg >/dev/null 2>&1; then
  info "Installing Termux packages..."
  pkg update -y
  pkg install -y python git openssh coreutils
else
  warn "pkg command not found. Continuing without Termux package install."
fi

mkdir -p "$AGENT_DIR" "$HERMES_DIR/skills"

if [ -d "skills/$SKILL_NAME" ]; then
  SOURCE_DIR="$(pwd)"
elif [ -d "$WORK_DIR/.git" ]; then
  info "Updating existing repo at $WORK_DIR..."
  git -C "$WORK_DIR" pull --ff-only
  SOURCE_DIR="$WORK_DIR"
else
  info "Cloning Health Analyzer repo..."
  rm -rf "$WORK_DIR"
  git clone --depth 1 "$REPO_URL" "$WORK_DIR"
  SOURCE_DIR="$WORK_DIR"
fi

info "Installing skill into $HERMES_SKILL_DIR..."
rm -rf "$HERMES_SKILL_DIR"
cp -R "$SOURCE_DIR/skills/$SKILL_NAME" "$HERMES_SKILL_DIR"
find "$HERMES_SKILL_DIR" -type d -name __pycache__ -prune -exec rm -rf {} +

if [ ! -f "$ENV_FILE" ]; then
  info "Creating env template at $ENV_FILE..."
  cp "$HERMES_SKILL_DIR/agent.env.example" "$ENV_FILE"
  chmod 600 "$ENV_FILE"
else
  warn "Keeping existing env file: $ENV_FILE"
fi

mkdir -p "$AGENT_DIR/bin"

cat > "$AGENT_DIR/bin/generate-today" <<'SCRIPT'
#!/usr/bin/env sh
set -eu
ENV_FILE="${HEALTH_ANALYZER_AGENT_ENV:-$HOME/.health-analyzer-agent/.env}"
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
fi
DAY="${1:-$(date +%F)}"
OUT_DIR="${SUMMARY_OUTPUT_DIR:-$HOME/health-analyzer-summaries}"
SKILL_DIR="${HEALTH_ANALYZER_SKILL_DIR:-$HOME/.hermes/skills/health-analyzer-skill}"
python "$SKILL_DIR/scripts/generate_daily_summary.py" --date "$DAY" --out-dir "$OUT_DIR"
SCRIPT

cat > "$AGENT_DIR/bin/telegram-health-bot" <<'SCRIPT'
#!/usr/bin/env sh
set -eu
ENV_FILE="${HEALTH_ANALYZER_AGENT_ENV:-$HOME/.health-analyzer-agent/.env}"
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
fi
SKILL_DIR="${HEALTH_ANALYZER_SKILL_DIR:-$HOME/.hermes/skills/health-analyzer-skill}"
python "$SKILL_DIR/scripts/telegram_health_bot.py"
SCRIPT

chmod +x "$AGENT_DIR/bin/generate-today" "$AGENT_DIR/bin/telegram-health-bot"

info "Done."
printf '\nNext steps:\n'
printf '1. Edit: %s\n' "$ENV_FILE"
printf '2. Fill TURSO_DATABASE_URL, TURSO_AUTH_TOKEN, LLM_API_KEY, and optional TELEGRAM_BOT_TOKEN.\n'
printf '3. Test summary: %s/bin/generate-today\n' "$AGENT_DIR"
printf '4. Start Telegram bot: %s/bin/telegram-health-bot\n' "$AGENT_DIR"
