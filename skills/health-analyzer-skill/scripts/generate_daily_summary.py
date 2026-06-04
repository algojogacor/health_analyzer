#!/usr/bin/env python3
"""Generate an agent-friendly daily health summary from Turso health_records."""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from collections import defaultdict
from datetime import date, datetime, time, timedelta, timezone
from pathlib import Path
from statistics import mean
from typing import Any


WIB = timezone(timedelta(hours=7))
DEFAULT_STEP_SOURCE = "com.xiaomi.wearable"


def load_dotenv() -> None:
    candidates = [
        Path.cwd() / ".env",
        Path.home() / ".hermes" / ".env",
    ]
    for path in candidates:
        if not path.exists():
            continue
        for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip().strip("'\"")
            if key and key not in os.environ:
                os.environ[key] = value


def parse_args() -> argparse.Namespace:
    load_dotenv()
    parser = argparse.ArgumentParser(
        description="Query Turso health_records and write daily markdown/json summaries."
    )
    parser.add_argument(
        "--date",
        default=datetime.now(WIB).date().isoformat(),
        help="Local date to summarize in YYYY-MM-DD. Defaults to today.",
    )
    parser.add_argument(
        "--db-url",
        default=os.getenv("TURSO_DATABASE_URL") or os.getenv("TURSO_DB_URL"),
        help="Turso URL, e.g. libsql://name.turso.io. Defaults to TURSO_DATABASE_URL.",
    )
    parser.add_argument(
        "--auth-token",
        default=os.getenv("TURSO_AUTH_TOKEN"),
        help="Turso auth token. Defaults to TURSO_AUTH_TOKEN.",
    )
    parser.add_argument(
        "--step-source",
        default=os.getenv("HEALTH_PREFERRED_STEP_SOURCE", DEFAULT_STEP_SOURCE),
        help="Preferred source_name for daily steps.",
    )
    parser.add_argument(
        "--out-dir",
        default="health",
        help="Directory for generated summary files.",
    )
    parser.add_argument(
        "--json-only",
        action="store_true",
        help="Only write JSON output.",
    )
    return parser.parse_args()


def normalize_turso_url(url: str) -> str:
    url = url.strip()
    if url.startswith("libsql://"):
        return "https://" + url[len("libsql://") :]
    if url.startswith("http://"):
        return "https://" + url[len("http://") :]
    if url.startswith("https://"):
        return url
    if ".turso.io" in url:
        return "https://" + url
    return f"https://{url}.turso.io"


def turso_value(cell: dict[str, Any]) -> Any:
    kind = cell.get("type")
    value = cell.get("value")
    if kind == "integer":
        return int(value)
    if kind == "float":
        return float(value)
    if kind == "null":
        return None
    return value


def execute_query(db_url: str, token: str, sql: str) -> list[dict[str, Any]]:
    payload = {
        "requests": [
            {
                "type": "execute",
                "stmt": {"sql": sql},
            }
        ]
    }
    request = urllib.request.Request(
        normalize_turso_url(db_url).rstrip("/") + "/v2/pipeline",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            data = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"Turso HTTP error {exc.code}: {body}") from exc

    result = data["results"][0]
    if result.get("type") == "error":
        raise SystemExit(f"Turso query error: {result.get('error')}")

    table = result["response"]["result"]
    columns = [col["name"] for col in table["cols"]]
    rows = []
    for row in table["rows"]:
        rows.append({columns[i]: turso_value(cell) for i, cell in enumerate(row)})
    return rows


def query_records(db_url: str, token: str, target_date: date) -> list[dict[str, Any]]:
    start = datetime.combine(target_date, time.min, tzinfo=WIB).isoformat()
    end = datetime.combine(target_date + timedelta(days=1), time.min, tzinfo=WIB).isoformat()
    sql = f"""
        SELECT id, data_type, value, unit, date_from, date_to, source_name, source_id, created_at
        FROM health_records
        WHERE date_from >= '{start}'
          AND date_from < '{end}'
        ORDER BY date_from ASC, id ASC
    """
    return execute_query(db_url, token, sql)


def values(records: list[dict[str, Any]], data_type: str) -> list[float]:
    return [float(r["value"]) for r in records if r.get("data_type") == data_type]


def values_any(records: list[dict[str, Any]], data_types: list[str]) -> list[float]:
    wanted = set(data_types)
    return [float(r["value"]) for r in records if r.get("data_type") in wanted]


def records_by_type(records: list[dict[str, Any]], data_type: str) -> list[dict[str, Any]]:
    return [r for r in records if r.get("data_type") == data_type]


def sum_by_source(records: list[dict[str, Any]], data_type: str) -> dict[str, float]:
    totals: dict[str, float] = defaultdict(float)
    for record in records_by_type(records, data_type):
        source = record.get("source_name") or "unknown"
        totals[source] += float(record["value"])
    return dict(sorted(totals.items(), key=lambda item: item[1], reverse=True))


def summarize(records: list[dict[str, Any]], target_date: date, step_source: str) -> dict[str, Any]:
    step_totals = sum_by_source(records, "STEPS")
    selected_step_source = step_source if step_source in step_totals else None
    if selected_step_source is None and step_totals:
        selected_step_source = next(iter(step_totals))

    heart_rates = values(records, "HEART_RATE")
    resting_hr = values(records, "RESTING_HEART_RATE")
    spo2 = values(records, "BLOOD_OXYGEN")
    active_calories = values(records, "ACTIVE_ENERGY_BURNED")
    basal_calories = values(records, "BASAL_ENERGY_BURNED")
    distance = values(records, "DISTANCE_DELTA")
    sleep_deep = values(records, "SLEEP_DEEP")
    sleep_light = values(records, "SLEEP_LIGHT")
    sleep_rem = values(records, "SLEEP_REM")
    sleep_asleep = values(records, "SLEEP_ASLEEP")
    sleep_awake = values_any(records, ["SLEEP_AWAKE", "SLEEP_AWAKE_IN_BED"])
    sleep_out_of_bed = values(records, "SLEEP_OUT_OF_BED")
    sleep_unknown = values(records, "SLEEP_UNKNOWN")
    sleep_session = values(records, "SLEEP_SESSION")
    stress = values(records, "STRESS")
    hrv = values_any(records, ["HRV", "HEART_RATE_VARIABILITY_RMSSD"])
    weight = values(records, "WEIGHT")

    data_types = defaultdict(int)
    for record in records:
        data_types[record["data_type"]] += 1

    notes = []
    if len(step_totals) > 1:
        notes.append(
            "Multiple step sources are present. Use the selected source for daily totals; "
            "do not sum all sources unless source overlap has been resolved."
        )
    if not records:
        notes.append("No records found for this date.")
    if not heart_rates and not resting_hr:
        notes.append("No heart-rate records found for this date.")
    if not spo2:
        notes.append("No SpO2 records found for this date.")

    sleep_stage_minutes = {
        "asleep_unspecified": round(sum(sleep_asleep), 1),
        "deep": round(sum(sleep_deep), 1),
        "light": round(sum(sleep_light), 1),
        "rem": round(sum(sleep_rem), 1),
        "awake": round(sum(sleep_awake), 1),
        "out_of_bed": round(sum(sleep_out_of_bed), 1),
        "unknown": round(sum(sleep_unknown), 1),
    }
    asleep_minutes = round(
        sleep_stage_minutes["asleep_unspecified"]
        + sleep_stage_minutes["deep"]
        + sleep_stage_minutes["light"]
        + sleep_stage_minutes["rem"],
        1,
    )

    return {
        "date": target_date.isoformat(),
        "record_count": len(records),
        "data_type_counts": dict(sorted(data_types.items())),
        "steps": {
            "selected_source": selected_step_source,
            "selected_total": round(step_totals.get(selected_step_source or "", 0.0), 1),
            "by_source": step_totals,
        },
        "calories": {
            "active_kcal": round(sum(active_calories), 1),
            "basal_kcal": round(sum(basal_calories), 1),
        },
        "distance": {
            "meters": round(sum(distance), 1),
        },
        "heart_rate": {
            "count": len(heart_rates),
            "avg_bpm": round(mean(heart_rates), 1) if heart_rates else None,
            "min_bpm": round(min(heart_rates), 1) if heart_rates else None,
            "max_bpm": round(max(heart_rates), 1) if heart_rates else None,
            "resting_avg_bpm": round(mean(resting_hr), 1) if resting_hr else None,
        },
        "spo2": {
            "count": len(spo2),
            "avg_percent": round(mean(spo2), 1) if spo2 else None,
            "min_percent": round(min(spo2), 1) if spo2 else None,
        },
        "sleep": {
            "session_minutes": round(sum(sleep_session), 1),
            "stage_minutes": sleep_stage_minutes,
            "asleep_minutes": asleep_minutes,
            "stage_total_minutes": round(sum(sleep_stage_minutes.values()), 1),
        },
        "stress": {
            "count": len(stress),
            "avg": round(mean(stress), 1) if stress else None,
            "max": round(max(stress), 1) if stress else None,
        },
        "hrv": {
            "count": len(hrv),
            "avg_ms": round(mean(hrv), 1) if hrv else None,
        },
        "body": {
            "weight_kg_latest": round(weight[-1], 2) if weight else None,
            "weight_records": len(weight),
        },
        "data_quality_notes": notes,
    }


def fmt(value: Any, unit: str = "") -> str:
    if value is None:
        return "not available"
    if isinstance(value, float) and value.is_integer():
        value = int(value)
    return f"{value}{unit}"


def fmt_minutes(value: Any) -> str:
    if value is None:
        return "not available"
    minutes = int(round(float(value)))
    hours = minutes // 60
    remainder = minutes % 60
    if hours and remainder:
        return f"{hours}h {remainder}m"
    if hours:
        return f"{hours}h"
    return f"{remainder}m"


def render_markdown(summary: dict[str, Any]) -> str:
    steps = summary["steps"]
    hr = summary["heart_rate"]
    spo2 = summary["spo2"]
    sleep = summary["sleep"]
    calories = summary["calories"]
    distance = summary["distance"]
    stress = summary["stress"]
    hrv = summary["hrv"]
    body = summary["body"]

    lines = [
        f"# Health Summary - {summary['date']}",
        "",
        "This summary is for wellness insight and trend review, not diagnosis or emergency guidance.",
        "",
        "## Overview",
        f"- Records analyzed: {summary['record_count']}",
        f"- Data types: {', '.join(summary['data_type_counts'].keys()) or 'none'}",
        "",
        "## Activity",
        f"- Steps: {fmt(steps['selected_total'])} "
        f"(source: {steps['selected_source'] or 'not available'})",
        f"- Active calories: {fmt(calories['active_kcal'], ' kcal')}",
        f"- Distance: {fmt(distance['meters'], ' m')}",
        "",
        "## Heart",
        f"- Heart-rate records: {hr['count']}",
        f"- Average HR: {fmt(hr['avg_bpm'], ' bpm')}",
        f"- HR range: {fmt(hr['min_bpm'], ' bpm')} - {fmt(hr['max_bpm'], ' bpm')}",
        f"- Resting HR average: {fmt(hr['resting_avg_bpm'], ' bpm')}",
        f"- HRV average: {fmt(hrv['avg_ms'], ' ms')}",
        "",
        "## Body",
        f"- Latest weight: {fmt(body['weight_kg_latest'], ' kg')}",
        f"- Weight records: {body['weight_records']}",
        "",
        "## Oxygen",
        f"- SpO2 records: {spo2['count']}",
        f"- Average SpO2: {fmt(spo2['avg_percent'], '%')}",
        f"- Minimum SpO2: {fmt(spo2['min_percent'], '%')}",
        "",
        "## Sleep",
        f"- Sleep duration: {fmt_minutes(sleep['asleep_minutes'])} (excludes awake time)",
        f"- Time in bed/session: {fmt_minutes(sleep['session_minutes'])}",
        f"- Asleep unspecified: {fmt_minutes(sleep['stage_minutes']['asleep_unspecified'])}",
        f"- Deep: {fmt_minutes(sleep['stage_minutes']['deep'])}",
        f"- Light: {fmt_minutes(sleep['stage_minutes']['light'])}",
        f"- REM: {fmt_minutes(sleep['stage_minutes']['rem'])}",
        f"- Awake: {fmt_minutes(sleep['stage_minutes']['awake'])}",
        f"- Out of bed: {fmt_minutes(sleep['stage_minutes']['out_of_bed'])}",
        f"- Unknown: {fmt_minutes(sleep['stage_minutes']['unknown'])}",
        "",
        "## Stress",
        f"- Stress records: {stress['count']}",
        f"- Average stress: {fmt(stress['avg'])}",
        f"- Max stress: {fmt(stress['max'])}",
        "",
        "## Data Quality",
    ]

    if summary["steps"]["by_source"]:
        lines.append("- Step totals by source:")
        for source, total in summary["steps"]["by_source"].items():
            lines.append(f"  - {source}: {fmt(round(total, 1))}")

    if summary["data_quality_notes"]:
        lines.extend(f"- {note}" for note in summary["data_quality_notes"])
    else:
        lines.append("- No obvious data quality issues detected.")

    lines.extend(
        [
            "",
            "## Agent Guidance",
            "- Use this file for wellness summaries and trend discussion.",
            "- Do not diagnose disease, prescribe medication, or advise stopping medication.",
            "- Ask follow-up questions when data is missing, contradictory, or clinically ambiguous.",
            "- Recommend professional medical care for severe symptoms, persistent abnormalities, or emergencies.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    if not args.db_url:
        print("Missing --db-url or TURSO_DATABASE_URL.", file=sys.stderr)
        return 2
    if not args.auth_token:
        print("Missing --auth-token or TURSO_AUTH_TOKEN.", file=sys.stderr)
        return 2

    try:
        target_date = date.fromisoformat(args.date)
    except ValueError:
        print("--date must be YYYY-MM-DD.", file=sys.stderr)
        return 2

    records = query_records(args.db_url, args.auth_token, target_date)
    summary = summarize(records, target_date, args.step_source)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    json_path = out_dir / f"health-summary-{target_date.isoformat()}.json"
    json_path.write_text(json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8")

    if not args.json_only:
        md_path = out_dir / f"health-summary-{target_date.isoformat()}.md"
        md_path.write_text(render_markdown(summary), encoding="utf-8")
        print(md_path)
    print(json_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
