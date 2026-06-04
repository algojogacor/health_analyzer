#!/usr/bin/env python3
"""Tiny Telegram health bot for Termux.

This is intentionally dependency-free. It uses Telegram long polling, the
Health Analyzer daily summary script, and a DeepSeek/OpenAI-compatible endpoint.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


WIB = timezone(timedelta(hours=7))
HOME = Path.home()
HERMES_ENV = HOME / ".hermes" / ".env"
SKILL_DIR = HOME / ".hermes" / "skills" / "health-analyzer-skill"
SUMMARY_SCRIPT = SKILL_DIR / "scripts" / "generate_daily_summary.py"
OUT_DIR = HOME / "health"


def load_dotenv(path: Path = HERMES_ENV) -> None:
    if not path.exists():
        return
    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip("'\"")
        if key and key not in os.environ:
            os.environ[key] = value


def api_json(url: str, payload: dict[str, Any] | None = None, timeout: int = 60) -> dict[str, Any]:
    data = None if payload is None else urllib.parse.urlencode(payload).encode("utf-8")
    request = urllib.request.Request(url, data=data, method="POST" if payload else "GET")
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def telegram(method: str, payload: dict[str, Any] | None = None, timeout: int = 60) -> dict[str, Any]:
    token = os.environ["TELEGRAM_BOT_TOKEN"]
    return api_json(f"https://api.telegram.org/bot{token}/{method}", payload, timeout)


def send_message(chat_id: int | str, text: str) -> None:
    # Telegram's practical message limit is 4096 chars.
    chunks = [text[i : i + 3800] for i in range(0, len(text), 3800)] or [""]
    for chunk in chunks:
        telegram("sendMessage", {"chat_id": str(chat_id), "text": chunk})


def set_commands() -> None:
    commands = [
        {"command": "status", "description": "Cek status health bot"},
        {"command": "summary", "description": "Tampilkan summary kesehatan hari ini"},
        {"command": "health", "description": "Tanya ringkasan kesehatan harian"},
        {"command": "help", "description": "Lihat bantuan command"},
        {"command": "new", "description": "Mulai konteks ringan baru"},
    ]
    telegram("setMyCommands", {"commands": json.dumps(commands)})


def allowed(user_id: int | None, chat_id: int | None) -> bool:
    raw = os.environ.get("TELEGRAM_ALLOWED_USERS", "").strip()
    if raw in {"*", "all"}:
        return True
    allowed_ids = {x.strip() for x in raw.split(",") if x.strip()}
    if not allowed_ids:
        home = os.environ.get("TELEGRAM_HOME_CHANNEL", "").strip()
        allowed_ids = {home} if home else set()
    return str(user_id) in allowed_ids or str(chat_id) in allowed_ids


def target_date_from_text(text: str) -> str:
    parts = text.split()
    if len(parts) >= 2:
        try:
            datetime.fromisoformat(parts[1])
            return parts[1]
        except ValueError:
            pass
    return datetime.now(WIB).date().isoformat()


def generate_summary(day: str) -> tuple[Path, str]:
    env = os.environ.copy()
    print(f"generating summary for {day}", flush=True)
    result = subprocess.run(
        [sys.executable, str(SUMMARY_SCRIPT), "--date", day, "--out-dir", str(OUT_DIR)],
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=45,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    md_path = OUT_DIR / f"health-summary-{day}.md"
    if not md_path.exists():
        raise RuntimeError(f"Summary file not found: {md_path}")
    print(f"summary ready {md_path}", flush=True)
    return md_path, md_path.read_text(encoding="utf-8", errors="replace")


def deepseek_reply(user_text: str, summary_md: str) -> str:
    api_key = os.environ.get("DEEPSEEK_API_KEY")
    if not api_key:
        return (
            "Summary ready, tapi DEEPSEEK_API_KEY belum ada di environment bot. "
            "Aku belum bisa bikin respons AI."
        )
    base_url = os.environ.get("DEEPSEEK_BASE_URL", "https://api.deepseek.com").rstrip("/")
    if not base_url.endswith("/v1"):
        base_url = base_url + "/v1"
    model = os.environ.get("HEALTH_BOT_MODEL") or os.environ.get("DEEPSEEK_MODEL") or "deepseek-chat"
    payload = {
        "model": model,
        "messages": [
            {
                "role": "system",
                "content": (
                    "Kamu asisten wellness pribadi. Gunakan health summary yang diberikan. "
                    "Jangan diagnosis, jangan memberi resep, jangan menyuruh stop obat. "
                    "Bahasa Indonesia, singkat, jelas, dan sebutkan data quality issue jika ada."
                ),
            },
            {
                "role": "user",
                "content": f"Pertanyaan user: {user_text}\n\nHealth summary:\n{summary_md}",
            },
        ],
        "temperature": 0.3,
        "max_tokens": 900,
    }
    request = urllib.request.Request(
        base_url + "/chat/completions",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=35) as response:
            data = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        return f"DeepSeek error {exc.code}: {body[:1000]}"
    return data["choices"][0]["message"]["content"].strip()


def is_greeting(text: str) -> bool:
    normalized = text.lower().strip(" ?!.,")
    greetings = {
        "hi",
        "hai",
        "halo",
        "hallo",
        "hello",
        "halo?",
        "agent",
        "hi ai agent ku",
        "hai ai agent ku",
    }
    return normalized in greetings or normalized.startswith(("hi ", "hai ", "halo ", "hallo "))


def handle_message(message: dict[str, Any]) -> None:
    text = (message.get("text") or "").strip()
    chat = message.get("chat") or {}
    sender = message.get("from") or {}
    chat_id = chat.get("id")
    user_id = sender.get("id")
    print(f"inbound chat={chat_id} user={user_id} text={text[:80]!r}", flush=True)
    if not chat_id or not allowed(user_id, chat_id):
        print(f"ignored unauthorized chat={chat_id} user={user_id}", flush=True)
        return

    if text.startswith("/status"):
        print("replying status", flush=True)
        send_message(chat_id, "Aktif. Health bot Termux tersambung ke Telegram, Turso, dan DeepSeek.")
        return

    if text.startswith("/help"):
        send_message(
            chat_id,
            "Command health bot:\n"
            "/status - cek status bot\n"
            "/summary [YYYY-MM-DD] - tampilkan summary mentah harian\n"
            "/health [YYYY-MM-DD] - tampilkan summary mentah harian\n"
            "/new - reset ringan; bot ini stateless jadi tidak ada session panjang\n\n"
            "Kamu juga bisa langsung tanya, misalnya: 'gimana tidurku hari ini?'",
        )
        return

    if text.startswith("/new"):
        send_message(chat_id, "Siap. Konteks ringan baru. Bot ini stateless dan akan membaca summary terbaru saat kamu bertanya.")
        return

    if text.startswith("/summary") or text.startswith("/health"):
        day = target_date_from_text(text)
        try:
            _, summary = generate_summary(day)
        except Exception as exc:
            print(f"summary error: {exc}", flush=True)
            send_message(chat_id, f"Gagal generate summary: {exc}")
            return
        print(f"sending summary {day}", flush=True)
        send_message(chat_id, summary[:3500])
        return

    if not text:
        return

    if is_greeting(text):
        send_message(
            chat_id,
            "Aktif. Aku health bot ringan di Termux. Tanya saja soal ringkasan kesehatan hari ini, "
            "atau pakai /summary untuk lihat data mentah harian.",
        )
        return

    day = datetime.now(WIB).date().isoformat()
    try:
        _, summary = generate_summary(day)
        print("calling deepseek", flush=True)
        reply = deepseek_reply(text, summary)
    except Exception as exc:
        reply = f"Aku aktif, tapi gagal membaca/analyze data health: {exc}"
        print(f"analysis error: {exc}", flush=True)
    send_message(chat_id, reply)


def main() -> int:
    load_dotenv()
    if not os.environ.get("TELEGRAM_BOT_TOKEN"):
        print("Missing TELEGRAM_BOT_TOKEN", file=sys.stderr)
        return 2
    set_commands()
    print("Health Telegram bot started", flush=True)
    offset = None
    while True:
        try:
            payload: dict[str, Any] = {"timeout": "45"}
            if offset is not None:
                payload["offset"] = str(offset)
            data = telegram("getUpdates", payload, timeout=60)
            if data.get("result"):
                print(f"received {len(data.get('result', []))} update(s)", flush=True)
            for update in data.get("result", []):
                offset = int(update["update_id"]) + 1
                message = update.get("message") or update.get("edited_message")
                if message:
                    handle_message(message)
        except KeyboardInterrupt:
            return 0
        except Exception as exc:
            print(f"bot loop error: {exc}", flush=True)
            time.sleep(5)


if __name__ == "__main__":
    raise SystemExit(main())
