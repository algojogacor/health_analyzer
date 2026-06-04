# PRD: Health Analyzer UX Upgrade
**Versi:** 1.2  
**Tanggal:** 2026-06-05  
**Status:** Implemented with bounded future stubs

---

## 1. Ringkasan Eksekutif

Health Analyzer sekarang diposisikan sebagai personal fitness + health app dengan UX yang mendekati Strava untuk recording/activity flow dan Suunto untuk dashboard clean white.

Scope yang sudah masuk:

- Recording map-first, pause/resume, stop confirmation, save review, activity detail, splits, charts, and recovery banner.
- Dashboard widget grid, customize widgets, mini 7-day visuals, recent activity widget.
- Privacy-first route handling: route detail sync opt-in, hide start/end radius, route crop preview.
- AI local summaries, DeepSeek chat/tool-agent, usage tracking foundation, and deterministic fallback mode.
- Offline map manager foundation with public tile failure handling and local offline region metadata.
- Community coming-soon interest saved local-only.

Scope yang tetap tidak masuk:

- Full social feed, comments, kudos, clubs, media storage, and full Strava segment network.
- Copy kode/aset dari Strava/Suunto.
- BLE direct extraction from Xiaomi Smart Band.
- Medical diagnosis, medication prescription, or emergency triage.
- Developer-owned raw health backend. Personal health source of truth tetap user-owned local DB/Turso.

---

## 2. Status Codebase Saat Ini

| Fitur | File/Lokasi | Status | Catatan |
|-------|-------------|--------|---------|
| App shell | `lib/main.dart`, `lib/app.dart` | Selesai | WorkManager init, offline map cache init, and `HealthAnalyzerApp` aktif. |
| Main navigation | `lib/features/dashboard/dashboard_page.dart` | Selesai | Dashboard, Activity, Settings bottom navigation. |
| Dashboard | `lib/features/dashboard/dashboard_page.dart`, `dashboard_customize_page.dart`, `widgets/metric_grid.dart` | Selesai | Widget grid, hide/show preferences, mini 7-day visuals, recent activity widget. |
| Metric detail | `lib/features/health_detail/metric_detail_page.dart` | Partial | Summary dan record list tersedia; deeper charts per metric masih future. |
| Activity prepare page | `lib/features/activity/activity_page.dart` | Selesai | GPS behavior info, preview map, active banner, recorder panel, history. |
| Recording screen | `lib/features/activity/activity_recording_page.dart`, `widgets/recording_map_controls.dart`, `widgets/recording_stat_sheet.dart` | Selesai | Map-first, controls, street/satellite, recenter, stats sheet, indoor fallback. |
| Pause/resume/stop | `lib/services/activity_recorder_service.dart`, `activity_recording_page.dart` | Selesai | Manual pause/resume, stop sheet Resume/Finish/Discard, paused metadata. |
| Save summary | `lib/features/activity/activity_save_page.dart` | Selesai | Title edit, route visibility, hide radius, route detail sync, Health Connect toggle, Save/Discard. |
| Route map widget | `lib/features/activity/widgets/route_map.dart` | Selesai | Street/satellite tiles, FMTC cache-first tile provider, grey fallback, route line remains visible. |
| Route crop privacy | `lib/services/route_crop_service.dart`, `lib/features/activity/widgets/route_crop_preview.dart` | Selesai | Clamp state keeps minimum visible route; draggable handles and slider sync to valid state. |
| Activity history | `lib/features/activity/activity_history_list.dart` | Selesai | Completed activities only; discarded/reviewing excluded. |
| Activity detail | `lib/features/activity/activity_detail_page.dart`, `activity_analysis_service.dart` | Selesai | Route hero, metrics, GPS quality, splits, charts, HR overlap, privacy edit, AI summary panel. |
| Recovery banner | `lib/features/activity/widgets/active_activity_banner.dart` | Selesai | Dashboard and Activity tab; Open and Stop & Review actions. |
| Privacy settings | `lib/features/settings/privacy_settings_page.dart` | Selesai | Defaults persisted locally; saved activity privacy can be edited. |
| Map settings | `lib/features/settings/map_settings_page.dart`, `lib/services/offline_map_service.dart` | Selesai | Download UI for street/satellite/both, satellite failure dialog, local offline region records. |
| Community interest | `lib/features/community/community_page.dart`, `lib/services/community_service.dart` | Selesai | "Notify me / I'm interested" saves local-only flag and timestamp. |
| Health Connect fetch | `lib/services/health_service.dart` | Selesai | Reads HR, resting HR, HRV RMSSD, SpO2, steps, distance, sleep, calories, respiratory rate, workout, speed, weight. |
| Health Connect workout write | `lib/services/health_service.dart` | Selesai | Workout summary written only after Save when enabled. |
| Turso sync | `lib/services/turso_service.dart`, `activity_sync_mapper.dart` | Selesai | Pushes health records, activity sessions, optional points, and activity summaries. |
| Background sync | `lib/services/background_service.dart` | Selesai | Periodically collects Health Connect and syncs pending records/activities/summaries. GPS is not active 24/7. |
| Local database | `lib/database/tables.drift`, `database.dart` | Selesai | Schema version 8 with idempotent-ish migration helpers. |
| Sport modes | `lib/models/sport_mode.dart` | Selesai | 50 Xiaomi Smart Band 9 Active modes available. |
| AI summary export | `lib/services/activity_ai_summary_service.dart` | Selesai | Generates deterministic JSON and Markdown. |
| AI tier/tool-agent | `lib/services/ai_tier_service.dart`, `ai_agent_service.dart`, `ai_tool_executor_service.dart` | Selesai | Free tier config, paid stub, usage windows, bounded tool loop, local_rules fallback. |

---

## 3. Spesifikasi Fitur

### F-01: Recording Screen

**Status:** Selesai

Implemented:

- Start activity opens dedicated `ActivityRecordingPage`.
- GPS modes render map as primary surface with floating controls and bottom stat sheet.
- Current marker, route line, and accuracy circle appear after GPS points exist.
- Street/satellite switch, recenter/follow, paused badge, and indoor fallback are supported.

### F-02: Pause/Resume + Stop Confirmation

**Status:** Selesai

Implemented:

- `ActivityRecorderService.pause()` and `resume()` update active session state.
- Manual paused points are excluded from moving-time calculation.
- Stop opens Resume/Finish/Discard confirmation.
- Finish routes to save summary; Discard marks the session `discarded`.

### F-03: Post-Workout Save Summary

**Status:** Selesai

Implemented:

- Stop > Finish sets session to `reviewing`.
- Save page shows summary, route preview, editable title, privacy controls, and Health Connect toggle.
- Save finalizes as `completed`; Discard excludes from completed history and sync.

### F-04: Activity Detail

**Status:** Selesai

Implemented:

- Route hero, metric strip, GPS quality, splits, speed/elevation charts.
- HR overlap chart from `HEART_RATE` records that overlap activity start/end.
- Privacy panel can edit `route_visibility`, `hide_start_end_meters`, and route detail sync.
- AI summary section can generate and display saved activity summary.

Primary files:

- `lib/features/activity/activity_detail_page.dart`
- `lib/services/activity_analysis_service.dart`
- `lib/features/activity/widgets/activity_charts.dart`
- `lib/features/activity/widgets/route_crop_preview.dart`

### F-05: Dashboard Suunto-Like

**Status:** Selesai

Implemented:

- Clean white widget grid with stable card sizing.
- Hide/show widget preferences persist locally.
- Steps, Sleep, Calories include mini 7-day visuals.
- Recent activity widget opens `ActivityDetailPage`.

### F-06: Recovery Banner

**Status:** Selesai

Implemented:

- Active session banner appears on Dashboard and Activity tab.
- Open action opens recording screen.
- Stop & Review calls `finishForReview()` and opens save summary directly.
- Banner disappears after save/discard.

### F-07: Privacy Settings UI

**Status:** Selesai

Implemented:

- Settings page links to privacy defaults.
- Defaults include route visibility, hide start/end radius, route detail sync, and Health Connect write.
- New activity uses saved defaults.
- Activity detail can edit saved privacy fields without changing prior sync state.
- Route crop preview enforces minimum visible route via state controller.

### F-08: Offline Map & Download Settings

**Status:** Selesai dengan public tile caveat

Implemented:

- GPS recording remains offline-capable because points are saved locally.
- `RouteMap` uses cache-first tile providers and grey fallback if tiles fail.
- Route line and markers remain visible even if map tiles are unavailable.
- `MapSettingsPage` explains: "GPS records offline; map tiles require internet."
- User can choose street, satellite, or both for download.
- If satellite download fails, the app marks satellite failed and shows Retry satellite / Continue street only / Cancel.
- Offline region metadata is stored locally in `offline_map_regions`.

Important caveat:

- `flutter_map_tile_caching` is GPL-v3. Distribution terms must be reviewed before commercial/closed-source release.
- Public tile providers must be rate-limit/terms reviewed before broad public launch.

Primary files:

- `lib/services/offline_map_service.dart`
- `lib/features/settings/map_settings_page.dart`
- `lib/features/activity/widgets/route_map.dart`

### F-09: AI Activity Summary Export

**Status:** Selesai

Implemented:

- `ActivityAiSummaryService` generates JSON and Markdown summaries.
- JSON contains `sport`, `date`, `duration`, `distance`, `pace`, `ascent`, `auto_pause_segments`, `gps_quality`, `privacy_status`, `data_gaps`, and `health_context`.
- Markdown summary is readable without querying raw points.
- Summary never includes raw latitude/longitude unless a future explicit route-detail flow is added.
- Generate button saves summary to local DB.
- Pending summaries sync to Turso.

### F-10: AI Tier, Usage, and Tool-Agent

**Status:** Selesai

Implemented:

- `AiTierPolicy` stores `user_tier` and `ai_tier_config_version`.
- Free tier uses `maxToolCallsPerMessage = 6`; paid tier is schema/config placeholder only.
- `ai_usage_windows` tracks tool calls, token counts, and estimated cost.
- `ai_tool_calls` stores conversation/message/tier/token/window metadata.
- `AiAgentService` supports `online_llm` with DeepSeek and `local_rules` fallback.
- DeepSeek failure returns a clear degraded response while local deterministic tools remain usable.
- Tool loop validates allowed tool names and enforces tier max calls.

Primary files:

- `lib/services/ai_tier_service.dart`
- `lib/services/ai_agent_service.dart`
- `lib/services/ai_tool_executor_service.dart`
- `lib/features/ai/ai_page.dart`

### F-11: Community Coming Soon Interest

**Status:** Selesai

Implemented:

- Community/challenge future state is visible without pretending backend features are live.
- User can tap "Notify me / I'm interested".
- Interest flag and timestamp are saved local-only.
- No email is requested and no server submit occurs in v1.

---

## 4. Dependency & Paket Baru

| Paket | Kegunaan | Status |
|-------|----------|--------|
| `flutter_map` | Map rendering, route polyline, online street/satellite tiles | Ada |
| `flutter_map_tile_caching` | Cache-first tiles and offline map region download foundation | Ada; GPL-v3 caveat |
| `flutter_map_dragmarker` | Route crop draggable handles | Ada |
| `latlong2` | Coordinates and bounds | Ada |
| `geolocator` | GPS stream | Ada |
| `health` | Health Connect read/write | Ada |
| `drift` | Local SQLite ORM | Ada |
| `sqlite3_flutter_libs` | SQLite runtime | Ada |
| `workmanager` | Periodic Health Connect sync | Ada |
| `connectivity_plus` | Online/offline detection | Ada |
| `flutter_secure_storage` | Credentials, tier/settings, privacy defaults, dashboard/community preferences | Ada |
| `permission_handler` | Android permission helper | Ada |
| `uuid` | Local IDs | Ada |
| Chart package | Not required | Custom painters are used |
| Geoid correction package | Corrected elevation | Belum masuk PRD 1.2 |

---

## 5. Skema Data

Schema version: **8**

SQLite local tables:

- `health_records`
- `sync_logs`
- `activity_sessions`
  - Includes `title`, `manual_paused_seconds`, privacy fields, sync flags.
  - Lifecycle statuses include `recording`, `paused`, `reviewing`, `completed`, `discarded`.
- `activity_points`
- `activity_events`
- `activity_summaries`
  - Includes model/confidence/generated_by/agent notes fields.
- `saved_routes`
- `daily_summaries`
- `ai_tool_calls`
  - Includes `conversation_id`, `message_id`, `usage_window_id`, `tier`, `token_input`, `token_output`, `estimated_cost`.
- `ai_usage_windows`
  - Tracks tier window, reset time, tool calls, token usage, estimated cost.
- `community_share_records`
- `challenge_invites`
- `offline_map_regions`
  - Stores bounds, zoom, style, status, storage bytes, and provider metadata.

Local-only configuration:

- Activity privacy defaults: `FlutterSecureStorage`
- Dashboard widget visibility: `FlutterSecureStorage`
- AI tier: `user_tier`, `ai_tier_config_version`
- Community interest: `community_interest`, `community_interest_at`
- DeepSeek key/model and map tile keys remain user/device settings.

Remote Turso tables initialized by `TursoService.healthCheck()`:

- `health_records`
- `activity_sessions`
- `activity_points`
- `activity_summaries`

Koyeb/community backend remains future/community-only and must not receive raw health records by default.

---

## 6. Verification Checklist

Implemented acceptance criteria:

1. Start opens recording screen.
2. GPS mode shows map-first UI; indoor mode shows non-map fallback.
3. Pause/resume update active session state.
4. Stop opens Resume/Finish/Discard confirmation.
5. Finish opens save summary and does not sync before Save.
6. Save marks activity completed and history-visible.
7. Discard excludes activity from completed history.
8. Activity detail shows route hero, metrics, GPS quality, splits, charts, and HR overlap when records exist.
9. Activity detail privacy edit saves visibility/radius without changing sync status.
10. Route crop UI clamps state so minimum visible route remains visible.
11. Recovery banner appears in Dashboard and Activity.
12. Stop & Review from banner opens save summary directly.
13. Dashboard customize persists visible widgets.
14. Steps/Sleep/Calories show 7-day mini visuals.
15. Recent activity widget opens detail.
16. AI Generate creates local JSON/Markdown summary.
17. AI tool-agent enforces free tier max tool calls via config, not hard-coded UI logic.
18. DeepSeek failure degrades to local_rules response.
19. Summary sync path exists for manual and background sync.
20. Tile failure fallback keeps route visible on neutral background.
21. Satellite download failure shows explicit Retry / Continue street only / Cancel choices.
22. Community interest is saved local-only.

---

## 7. Hal yang Masih Stub atau Future Work

- Paid AI tier has config/schema placeholders only; no payment or subscription logic.
- Offline tile download uses public tile sources; production launch needs provider terms, quota strategy, and possibly paid tile provider.
- Satellite offline download availability depends on source/provider permissions and network conditions.
- Community backend is not implemented in this sprint; interest is local-only.
- AI chat is structured but still lightweight; no long-term vector memory or full agent autonomy.
- No dedicated native Android foreground location service yet; recording uses app process location stream.
- No geoid correction yet; elevation uses GPS altitude or corrected field if available.
- No route heatmap, segments, clubs, comments, or media upload.

---

## 8. Risiko & Catatan Teknis

- Long-running GPS recording can still be affected by Android/OEM battery policy if the app process is killed.
- `ACTIVITY_RECOGNITION` permission exists, but actual Android activity recognition integration is not implemented.
- Route detail sync default remains off for privacy; user must opt in.
- Editing saved privacy fields intentionally does not re-mark already synced sessions as pending.
- `activity_summaries` can sync independently from activity sessions.
- Dashboard, AI tier, and community preferences are per-device local settings.
- `flutter_map_tile_caching` license must be reviewed before closed-source distribution.
