# Health Analyzer Data Contract

## Source

The Flutter app writes Health Connect records to Turso table `health_records`.

Expected columns:

- `id`: integer primary key
- `data_type`: Health Connect type name, for example `STEPS`, `BLOOD_OXYGEN`, `SLEEP_DEEP`, `HEART_RATE_VARIABILITY_RMSSD`, `WEIGHT`
- `value`: numeric value
- `unit`: unit name, for example `COUNT`, `PERCENT`, `KILOCALORIE`
- `date_from`: ISO timestamp, normally `+07:00` WIB
- `date_to`: ISO timestamp, normally `+07:00` WIB
- `source_name`: source app/package
- `source_id`: source-specific identifier
- `created_at`: Turso insertion timestamp

## Interpretation Rules

- Treat `health_records` as raw interval data, not a daily summary.
- Do not sum `STEPS` across all sources unless source overlap has been resolved.
- Prefer `com.xiaomi.wearable` for Xiaomi band daily steps when available.
- Report `steps.by_source` whenever multiple step sources are present.
- Treat sleep stage values as minutes when Health Connect reports sleep stage records.
- Treat SpO2 (`BLOOD_OXYGEN`) as percent.
- Treat HRV (`HEART_RATE_VARIABILITY_RMSSD`) as milliseconds. It can support stress/recovery discussion, but it is not the same as Mi Fitness' proprietary Stress score.
- Treat `WEIGHT` as kilograms.
- Treat `ACTIVE_ENERGY_BURNED` as kcal when unit is `KILOCALORIE`.

## Agent Safety

- Provide wellness insights and trend summaries, not diagnosis.
- Do not prescribe, recommend stopping medication, or make emergency triage claims.
- Ask for missing context before interpreting abnormal values.
- Recommend professional care for severe symptoms, persistent abnormalities, or emergency-like situations.
