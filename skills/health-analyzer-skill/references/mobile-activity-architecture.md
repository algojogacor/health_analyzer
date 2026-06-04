# Mobile Activity Architecture Notes

These notes are based on public Android package metadata visible through ADB,
not proprietary code or assets.

## Observed Patterns

- Fitness apps expose `vnd.google.fitness.TRACK` intents for activity starts.
- Activity recording uses foreground location services, not periodic jobs.
- Background sync and recovery use WorkManager/JobScheduler.
- GPS route features require `ACCESS_FINE_LOCATION` and
  `FOREGROUND_SERVICE_LOCATION`.
- Phone activity classification commonly asks for `ACTIVITY_RECOGNITION`.
- Health Connect can be used for both reading wellness data and writing
  completed exercise/distance/calorie records.
- Dashboard UX is widget-based: each tile shows metric, freshness, and data
  quality instead of pretending missing data is available.

## Health Analyzer Roadmap

1. Keep Health Connect collection as the passive wearable data source.
2. Add a foreground workout recorder for user-started GPS activities.
3. Store activity sessions locally with route points.
4. Sync activity sessions to each user's Turso database.
5. Optionally write completed workouts back to Health Connect.
6. Keep Xiaomi band data and phone GPS data separate, then merge in summaries.

## Data Quality Rules

- Do not infer GPS route from step intervals.
- Do not infer stress from HR unless HRV/stress records are unavailable and the
  answer clearly states the limitation.
- Prefer wearable steps for daily totals when Xiaomi and phone sources overlap.
- Mark activity routes as phone-GPS sourced.
