import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import '../database/database.dart';
import '../services/ai_conversation_service.dart';
import '../services/ai_agent_service.dart';
import '../services/ai_tier_service.dart';
import '../services/activity_ai_summary_service.dart';
import '../services/activity_analysis_service.dart';
import '../services/activity_heatmap_service.dart';
import '../services/activity_recorder_service.dart';
import '../services/ai_tool_executor_service.dart';
import '../services/android_widget_service.dart';
import '../services/cadence_analysis_service.dart';
import '../services/community_service.dart';
import '../services/data_export_service.dart';
import '../services/fitness_profile_service.dart';
import '../services/gpx_service.dart';
import '../services/health_service.dart';
import '../services/heart_rate_zone_service.dart';
import '../services/lap_analysis_service.dart';
import '../services/llm_service.dart';
import '../services/offline_map_service.dart';
import '../services/local_notification_service.dart';
import '../services/map_tile_provider_service.dart';
import '../services/notification_settings_service.dart';
import '../services/onboarding_service.dart';
import '../services/personal_record_service.dart';
import '../services/proactive_insight_service.dart';
import '../services/route_builder_service.dart';
import '../services/route_target_service.dart';
import '../services/saved_route_service.dart';
import '../services/share_card_service.dart';
import '../services/theme_settings_service.dart';
import '../services/training_goal_service.dart';
import '../services/training_insights_service.dart';
import '../services/training_plan_service.dart';
import '../services/turso_service.dart';
import '../services/vo2max_service.dart';
import '../services/voice_coach_service.dart';
import '../services/voice_coach_settings_service.dart';
import '../services/webhook_service.dart';
import '../services/webhook_settings_service.dart';
import '../services/workout_narrative_service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

// ─── Database ───

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final themeSettingsServiceProvider = Provider<ThemeSettingsService>((ref) {
  return ThemeSettingsService(storage: ref.read(secureStorageProvider));
});

final themeModeProvider = FutureProvider<ThemeMode>((ref) {
  return ref.read(themeSettingsServiceProvider).loadThemeMode();
});

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService(storage: ref.read(secureStorageProvider));
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) {
  return ref.read(onboardingServiceProvider).isCompleted();
});

final androidWidgetServiceProvider = Provider<AndroidWidgetService>((ref) {
  return const AndroidWidgetService();
});

// ─── Health Service ───

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

final activityRecorderProvider = Provider<ActivityRecorderService>((ref) {
  final service = ActivityRecorderService(
    ref.read(databaseProvider),
    ref.read(healthServiceProvider),
    storage: ref.read(secureStorageProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final activityRecorderSnapshotProvider =
    StreamProvider<ActivityRecorderSnapshot>((ref) {
      final service = ref.watch(activityRecorderProvider);
      service.loadActiveSession();
      return service.snapshots;
    });

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService();
});

final notificationSettingsServiceProvider =
    Provider<NotificationSettingsService>((ref) {
      return NotificationSettingsService(
        storage: ref.read(secureStorageProvider),
      );
    });

final notificationSettingsProvider = FutureProvider<HealthNotificationSettings>(
  (ref) {
    return ref.read(notificationSettingsServiceProvider).loadSettings();
  },
);

final voiceCoachSettingsServiceProvider = Provider<VoiceCoachSettingsService>((
  ref,
) {
  return VoiceCoachSettingsService(storage: ref.read(secureStorageProvider));
});

final voiceCoachSettingsProvider = FutureProvider<VoiceCoachSettings>((ref) {
  return ref.read(voiceCoachSettingsServiceProvider).loadSettings();
});

final voiceCoachServiceProvider = Provider<VoiceCoachService>((ref) {
  return VoiceCoachService(
    settingsService: ref.read(voiceCoachSettingsServiceProvider),
  );
});

final proactiveInsightServiceProvider = Provider<ProactiveInsightService>((
  ref,
) {
  return ProactiveInsightService(
    db: ref.read(databaseProvider),
    storage: ref.read(secureStorageProvider),
    notifications: ref.read(localNotificationServiceProvider),
    settingsService: ref.read(notificationSettingsServiceProvider),
  );
});

/// Provider: status izin Health Connect
final healthPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(healthServiceProvider);
  return service.requestPermissions();
});

/// Provider: data kesehatan (last N hours)
final healthDataProvider = FutureProvider.family<List<HealthDataPoint>, int>((
  ref,
  hoursBack,
) async {
  final service = ref.read(healthServiceProvider);
  final now = DateTime.now();
  return service.fetchHealthData(
    start: now.subtract(Duration(hours: hoursBack)),
    end: now,
  );
});

// ─── Turso Service ───

final tursoServiceProvider = FutureProvider<TursoService?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final creds = await TursoService.loadCredentials(storage);
  if (creds == null) return null;

  return TursoService(dbName: creds.dbName, authToken: creds.authToken);
});

/// Provider: status koneksi Turso
final tursoStatusProvider = FutureProvider<bool>((ref) async {
  final turso = await ref.watch(tursoServiceProvider.future);
  if (turso == null) return false;
  return turso.healthCheck();
});

// ─── Sync State ───

/// Provider: jumlah unsynced records
final unsyncedCountProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getUnsyncedCount();
});

// ─── Credentials Setup ───

/// Provider: apakah kredensial sudah di-setup
final credentialsConfiguredProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final creds = await TursoService.loadCredentials(storage);
  return creds != null;
});

final activityPrivacyDefaultsProvider = FutureProvider<ActivityPrivacyDefaults>(
  (ref) {
    return ref.read(activityRecorderProvider).loadPrivacyDefaults();
  },
);

// ─── Dashboard Coverage ───

class HealthCoverageSummary {
  final DateTime generatedAt;
  final int recordCount;
  final int wearableSteps;
  final int phoneSteps;
  final double activeCalories;
  final double? avgHeartRate;
  final double? minHeartRate;
  final double? avgSpo2;
  final double? minSpo2;
  final double? hrvAvgMs;
  final double? latestWeightKg;
  final double asleepMinutes;
  final double timeInBedMinutes;
  final DateTime? latestWearableDataAt;
  final DateTime? latestRecordAt;
  final SyncLog? latestLog;
  final List<String> missingSignals;
  final List<String> qualityNotes;
  final String confidence;

  const HealthCoverageSummary({
    required this.generatedAt,
    required this.recordCount,
    required this.wearableSteps,
    required this.phoneSteps,
    required this.activeCalories,
    required this.avgHeartRate,
    required this.minHeartRate,
    required this.avgSpo2,
    required this.minSpo2,
    required this.hrvAvgMs,
    required this.latestWeightKg,
    required this.asleepMinutes,
    required this.timeInBedMinutes,
    required this.latestWearableDataAt,
    required this.latestRecordAt,
    required this.latestLog,
    required this.missingSignals,
    required this.qualityNotes,
    required this.confidence,
  });

  bool get hasWearableData => latestWearableDataAt != null;
  int get totalStepsIfMixed => wearableSteps + phoneSteps;
}

final coverageSummaryProvider = FutureProvider<HealthCoverageSummary>((
  ref,
) async {
  final db = ref.read(databaseProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  final records = await db.getRecordsBetween(start, end);
  final logs = await db.latestSyncLogs(1).get();
  final latestLog = logs.isEmpty ? null : logs.first;

  Iterable<HealthRecord> byType(String type) =>
      records.where((r) => r.dataType == type);
  Iterable<HealthRecord> byTypes(Set<String> types) =>
      records.where((r) => types.contains(r.dataType));

  double sum(Iterable<HealthRecord> rows) =>
      rows.fold(0.0, (total, row) => total + row.value);

  double? avg(Iterable<HealthRecord> rows) {
    final list = rows.toList();
    if (list.isEmpty) return null;
    return sum(list) / list.length;
  }

  double? minValue(Iterable<HealthRecord> rows) {
    final list = rows.toList();
    if (list.isEmpty) return null;
    return list.map((r) => r.value).reduce((a, b) => a < b ? a : b);
  }

  DateTime? latest(Iterable<HealthRecord> rows) {
    DateTime? value;
    for (final row in rows) {
      if (value == null || row.dateFrom.isAfter(value)) value = row.dateFrom;
    }
    return value;
  }

  bool isWearableSource(HealthRecord record) {
    final source =
        '${record.sourceName ?? ''} ${record.sourceId ?? ''}'.toLowerCase();
    if (source.trim().isEmpty) return false;
    const watchTerms = [
      'xiaomi',
      'mi fitness',
      'com.xiaomi.wearable',
      'wearable',
      'watch',
      'band',
      'garmin',
      'samsung health',
      'fitbit',
      'huawei',
      'amazfit',
      'zepp',
      'polar',
      'suunto',
      'coros',
      'whoop',
      'oura',
    ];
    return watchTerms.any(source.contains);
  }

  final wearableRows = records.where(isWearableSource);
  final wearableStepRows = wearableRows.where((r) => r.dataType == 'STEPS');
  final phoneStepRows = byType(
    'STEPS',
  ).where((r) => !wearableStepRows.any((w) => w.id == r.id));

  final heartRows = byType('HEART_RATE');
  final spo2Rows = byType('BLOOD_OXYGEN');
  final hrvRows = byType('HEART_RATE_VARIABILITY_RMSSD');
  final weightRows =
      byType('WEIGHT').toList()
        ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

  final asleepMinutes = sum(
    byTypes({'SLEEP_ASLEEP', 'SLEEP_DEEP', 'SLEEP_LIGHT', 'SLEEP_REM'}),
  );
  final timeInBedMinutes = sum(byType('SLEEP_SESSION'));

  final missing = <String>[];
  if (heartRows.isEmpty) missing.add('Heart rate');
  if (spo2Rows.isEmpty) missing.add('Blood oxygen');
  if (hrvRows.isEmpty) missing.add('HRV / stress proxy');
  if (byType('SLEEP_SESSION').isEmpty) missing.add('Sleep session');
  if (wearableStepRows.isEmpty) missing.add('Wearable steps');

  final notes = <String>[];
  if (wearableStepRows.isNotEmpty && phoneStepRows.isNotEmpty) {
    notes.add('Step data has wearable and phone sources; use wearable total.');
  }
  if (hrvRows.isEmpty) {
    notes.add('Mi Fitness has Stress, but HRV/stress is not exported today.');
  }
  final latestWearable = latest(wearableRows);
  if (latestWearable == null) {
    notes.add('No supported wearable records found today.');
  } else if (now.difference(latestWearable).inHours >= 3) {
    notes.add('Wearable data is more than 3 hours old.');
  }

  final confidence = switch (missing.length) {
    0 || 1 => 'Good',
    2 || 3 => 'Partial',
    _ => 'Limited',
  };

  return HealthCoverageSummary(
    generatedAt: now,
    recordCount: records.length,
    wearableSteps: sum(wearableStepRows).round(),
    phoneSteps: sum(phoneStepRows).round(),
    activeCalories: sum(byType('ACTIVE_ENERGY_BURNED')),
    avgHeartRate: avg(heartRows),
    minHeartRate: minValue(heartRows),
    avgSpo2: avg(spo2Rows),
    minSpo2: minValue(spo2Rows),
    hrvAvgMs: avg(hrvRows),
    latestWeightKg: weightRows.isEmpty ? null : weightRows.last.value,
    asleepMinutes: asleepMinutes,
    timeInBedMinutes: timeInBedMinutes,
    latestWearableDataAt: latestWearable,
    latestRecordAt: latest(records),
    latestLog: latestLog,
    missingSignals: missing,
    qualityNotes: notes,
    confidence: confidence,
  );
});

final healthMetricRecordsProvider =
    FutureProvider.family<List<HealthRecord>, Set<String>>((ref, types) async {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final end = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 1));
      final start = end.subtract(const Duration(days: 30));
      final records = await db.getRecordsBetween(start, end);
      return records.where((record) => types.contains(record.dataType)).toList()
        ..sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    });

class DashboardWidgetDefinition {
  final String key;
  final String label;

  const DashboardWidgetDefinition({required this.key, required this.label});
}

const dashboardWidgetDefinitions = [
  DashboardWidgetDefinition(key: 'steps', label: 'Steps'),
  DashboardWidgetDefinition(key: 'calories', label: 'Calories'),
  DashboardWidgetDefinition(key: 'sleep', label: 'Sleep'),
  DashboardWidgetDefinition(key: 'heart_rate', label: 'Heart rate'),
  DashboardWidgetDefinition(key: 'blood_oxygen', label: 'Blood oxygen'),
  DashboardWidgetDefinition(key: 'hrv', label: 'HRV'),
  DashboardWidgetDefinition(key: 'weight', label: 'Weight'),
  DashboardWidgetDefinition(key: 'recovery', label: 'Recovery'),
  DashboardWidgetDefinition(key: 'training_load', label: 'Training load'),
  DashboardWidgetDefinition(key: 'weekly_activity', label: 'Weekly activity'),
  DashboardWidgetDefinition(key: 'sleep_debt', label: 'Sleep debt'),
  DashboardWidgetDefinition(key: 'resources', label: 'Resources'),
  DashboardWidgetDefinition(
    key: 'activity_calendar',
    label: 'Activity calendar',
  ),
  DashboardWidgetDefinition(key: 'recent_activity', label: 'Recent activity'),
];

class DashboardWidgetPreferences {
  final Set<String> visibleKeys;

  const DashboardWidgetPreferences({required this.visibleKeys});

  bool isVisible(String key) => visibleKeys.contains(key);
}

final dashboardWidgetPreferencesProvider =
    FutureProvider<DashboardWidgetPreferences>((ref) async {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
      final raw = await storage.read(key: 'dashboard.visible_widgets');
      final allKeys =
          dashboardWidgetDefinitions.map((item) => item.key).toSet();
      if (raw == null || raw.trim().isEmpty) {
        return DashboardWidgetPreferences(visibleKeys: allKeys);
      }
      final visible = raw.split(',').where(allKeys.contains).toSet();
      return DashboardWidgetPreferences(
        visibleKeys: visible.isEmpty ? allKeys : visible,
      );
    });

Future<void> saveDashboardWidgetPreferences(Set<String> visibleKeys) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  await storage.write(
    key: 'dashboard.visible_widgets',
    value: visibleKeys.join(','),
  );
}

class DashboardMetricTrends {
  final List<double> steps;
  final List<double> sleepMinutes;
  final List<double> calories;

  const DashboardMetricTrends({
    required this.steps,
    required this.sleepMinutes,
    required this.calories,
  });
}

final dashboardMetricTrendsProvider = FutureProvider<DashboardMetricTrends>((
  ref,
) async {
  final db = ref.read(databaseProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 6));
  final end = today.add(const Duration(days: 1));
  final records = await db.getRecordsBetween(start, end);
  final steps = List<double>.filled(7, 0);
  final sleep = List<double>.filled(7, 0);
  final calories = List<double>.filled(7, 0);

  int dayIndex(DateTime value) => value.difference(start).inDays;

  for (final record in records) {
    final index = dayIndex(
      DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
      ),
    );
    if (index < 0 || index >= 7) continue;
    switch (record.dataType) {
      case 'STEPS':
        final source =
            '${record.sourceName ?? ''} ${record.sourceId ?? ''}'.toLowerCase();
        final fromWearable = [
          'xiaomi',
          'mi fitness',
          'com.xiaomi.wearable',
          'wearable',
          'watch',
          'band',
          'garmin',
          'samsung health',
          'fitbit',
          'huawei',
          'amazfit',
          'zepp',
          'polar',
          'suunto',
          'coros',
          'whoop',
          'oura',
        ].any(source.contains);
        if (fromWearable) {
          steps[index] += record.value;
        } else if (steps[index] == 0) {
          steps[index] += record.value;
        }
      case 'SLEEP_ASLEEP':
      case 'SLEEP_DEEP':
      case 'SLEEP_LIGHT':
      case 'SLEEP_REM':
        sleep[index] += record.value;
      case 'ACTIVE_ENERGY_BURNED':
        calories[index] += record.value;
    }
  }

  return DashboardMetricTrends(
    steps: steps,
    sleepMinutes: sleep,
    calories: calories,
  );
});

final activityHistoryProvider = FutureProvider<List<ActivitySession>>((
  ref,
) async {
  final db = ref.read(databaseProvider);
  return db.activitySessionsRecent(30).get();
});

final activitySessionProvider = FutureProvider.family<ActivitySession?, String>(
  (ref, sessionLocalId) {
    final db = ref.read(databaseProvider);
    return db.getActivitySession(sessionLocalId);
  },
);

final activityPointsProvider =
    FutureProvider.family<List<ActivityPoint>, String>((ref, sessionLocalId) {
      final db = ref.read(databaseProvider);
      return db.getActivityPoints(sessionLocalId);
    });

final activityAnalysisServiceProvider = Provider<ActivityAnalysisService>((
  ref,
) {
  return ActivityAnalysisService();
});

final activityHeatmapServiceProvider = Provider<ActivityHeatmapService>((ref) {
  return ActivityHeatmapService(ref.read(databaseProvider));
});

final activityHeatmapProvider = FutureProvider<ActivityHeatmapSummary>((ref) {
  return ref.read(activityHeatmapServiceProvider).build();
});

final workoutNarrativeServiceProvider = Provider<WorkoutNarrativeService>((
  ref,
) {
  return const WorkoutNarrativeService();
});

final activityAnalysisProvider =
    FutureProvider.family<ActivityAnalysis?, String>((
      ref,
      sessionLocalId,
    ) async {
      final db = ref.read(databaseProvider);
      final session = await db.getActivitySession(sessionLocalId);
      if (session == null) return null;
      final points = await db.getActivityPoints(sessionLocalId);
      return ref.read(activityAnalysisServiceProvider).analyze(session, points);
    });

final activityAiSummaryServiceProvider = Provider<ActivityAiSummaryService>((
  ref,
) {
  return ActivityAiSummaryService(
    ref.read(activityAnalysisServiceProvider),
    ref.read(workoutNarrativeServiceProvider),
  );
});

final savedRouteServiceProvider = Provider<SavedRouteService>((ref) {
  return SavedRouteService(ref.read(databaseProvider));
});

final gpxServiceProvider = Provider<GpxService>((ref) {
  return GpxService(ref.read(databaseProvider));
});

final activityShareCardServiceProvider = Provider<ActivityShareCardService>((
  ref,
) {
  return const ActivityShareCardService();
});

final dataExportServiceProvider = Provider<DataExportService>((ref) {
  return DataExportService(
    ref.read(databaseProvider),
    gpxService: ref.read(gpxServiceProvider),
  );
});

final webhookSettingsServiceProvider = Provider<WebhookSettingsService>((ref) {
  return WebhookSettingsService(storage: ref.read(secureStorageProvider));
});

final webhookSettingsProvider = FutureProvider<WebhookSettings>((ref) {
  return ref.read(webhookSettingsServiceProvider).loadSettings();
});

final webhookServiceProvider = Provider<WebhookService>((ref) {
  return WebhookService(
    settingsService: ref.read(webhookSettingsServiceProvider),
  );
});

final savedRoutesProvider = FutureProvider<List<SavedRoute>>((ref) {
  return ref.read(databaseProvider).getRecentSavedRoutes();
});

final savedRouteProvider = FutureProvider.family<SavedRoute?, String>((
  ref,
  localId,
) {
  return ref.read(databaseProvider).getSavedRoute(localId);
});

final routeBuilderServiceProvider = Provider<RouteBuilderService>((ref) {
  return RouteBuilderService();
});

final routeTargetServiceProvider = Provider<RouteTargetService>((ref) {
  return RouteTargetService(
    db: ref.read(databaseProvider),
    storage: ref.read(secureStorageProvider),
  );
});

final routeTargetProvider = FutureProvider<SavedRoute?>((ref) {
  return ref.read(routeTargetServiceProvider).loadTarget();
});

final llmServiceProvider = Provider<LlmService>((ref) {
  return LlmService(storage: ref.read(secureStorageProvider));
});

final llmSettingsProvider = FutureProvider<LlmSettings>((ref) {
  return ref.read(llmServiceProvider).loadSettings();
});

final aiToolExecutorProvider = Provider<AiToolExecutorService>((ref) {
  return AiToolExecutorService(
    ref.read(databaseProvider),
    ref.read(activityAnalysisServiceProvider),
    ref.read(trainingGoalServiceProvider),
    ref.read(trainingInsightsServiceProvider),
    ref.read(trainingPlanServiceProvider),
    ref.read(fitnessProfileServiceProvider),
    ref.read(heartRateZoneServiceProvider),
    ref.read(cadenceAnalysisServiceProvider),
  );
});

final aiConversationServiceProvider = Provider<AiConversationService>((ref) {
  return AiConversationService(ref.read(databaseProvider));
});

final aiTierPolicyProvider = Provider<AiTierPolicy>((ref) {
  return AiTierPolicy(storage: ref.read(secureStorageProvider));
});

final aiTierConfigProvider = FutureProvider<AiTierConfig>((ref) {
  return ref.read(aiTierPolicyProvider).loadConfig();
});

final aiUsageTrackerProvider = Provider<AiUsageTracker>((ref) {
  return AiUsageTracker(
    db: ref.read(databaseProvider),
    tierPolicy: ref.read(aiTierPolicyProvider),
  );
});

final aiAgentServiceProvider = Provider<AiAgentService>((ref) {
  return AiAgentService(
    llmService: ref.read(llmServiceProvider),
    tools: ref.read(aiToolExecutorProvider),
    tierPolicy: ref.read(aiTierPolicyProvider),
    usageTracker: ref.read(aiUsageTrackerProvider),
  );
});

final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService(
    ref.read(databaseProvider),
    storage: ref.read(secureStorageProvider),
  );
});

final communitySettingsProvider = FutureProvider<CommunitySettings>((ref) {
  return ref.read(communityServiceProvider).loadSettings();
});

final communitySharesProvider = FutureProvider<List<CommunityShareRecord>>((
  ref,
) {
  return ref.read(databaseProvider).getRecentCommunityShares();
});

final offlineMapServiceProvider = Provider<OfflineMapService>((ref) {
  return OfflineMapService(ref.read(databaseProvider));
});

final mapTileProviderServiceProvider = Provider<MapTileProviderService>((ref) {
  return MapTileProviderService(storage: ref.read(secureStorageProvider));
});

final mapTileSettingsProvider = FutureProvider<MapTileSettings>((ref) {
  return ref.read(mapTileProviderServiceProvider).loadSettings();
});

final offlineMapRegionsProvider = FutureProvider<List<OfflineMapRegion>>((ref) {
  return ref.read(offlineMapServiceProvider).regions();
});

final offlineMapCatalogProvider =
    FutureProvider.family<List<OfflineMapCatalogPack>, String>((ref, baseUrl) {
      return ref.read(offlineMapServiceProvider).fetchCatalog(baseUrl);
    });

final challengeInvitesProvider = FutureProvider<List<ChallengeInvite>>((ref) {
  return ref.read(databaseProvider).getRecentChallengeInvites();
});

final activitySummaryProvider = FutureProvider.family<ActivitySummary?, String>(
  (ref, sessionLocalId) {
    return ref.read(databaseProvider).getActivitySummary(sessionLocalId);
  },
);

final activityHeartRateRecordsProvider =
    FutureProvider.family<List<HealthRecord>, String>((
      ref,
      sessionLocalId,
    ) async {
      final db = ref.read(databaseProvider);
      final session = await db.getActivitySession(sessionLocalId);
      if (session == null) return const [];
      final end = session.endedAt ?? DateTime.now();
      final records = await db.getRecordsBetween(session.startedAt, end);
      return records.where((record) => record.dataType == 'HEART_RATE').toList()
        ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    });

final activityEventsProvider =
    FutureProvider.family<List<ActivityEvent>, String>((ref, sessionLocalId) {
      return ref.read(databaseProvider).getActivityEvents(sessionLocalId);
    });

final lapAnalysisServiceProvider = Provider<LapAnalysisService>((ref) {
  return LapAnalysisService();
});

final activityLapSummariesProvider =
    FutureProvider.family<List<ActivityLapSummary>, String>((
      ref,
      sessionLocalId,
    ) async {
      final db = ref.read(databaseProvider);
      final session = await db.getActivitySession(sessionLocalId);
      if (session == null) return const [];
      final points = await db.getActivityPoints(sessionLocalId);
      final events = await db.getActivityEvents(sessionLocalId);
      final heartRateRecords = await ref.read(
        activityHeartRateRecordsProvider(sessionLocalId).future,
      );
      return ref
          .read(lapAnalysisServiceProvider)
          .analyze(
            session: session,
            points: points,
            events: events,
            heartRateRecords: heartRateRecords,
          );
    });

final fitnessProfileServiceProvider = Provider<FitnessProfileService>((ref) {
  return FitnessProfileService(storage: ref.read(secureStorageProvider));
});

final fitnessProfileProvider = FutureProvider<FitnessProfile>((ref) {
  return ref.read(fitnessProfileServiceProvider).loadProfile();
});

final heartRateZoneServiceProvider = Provider<HeartRateZoneService>((ref) {
  return HeartRateZoneService();
});

final cadenceAnalysisServiceProvider = Provider<CadenceAnalysisService>((ref) {
  return CadenceAnalysisService();
});

final activityHeartRateZonesProvider =
    FutureProvider.family<HeartRateZoneResult?, String>((
      ref,
      sessionLocalId,
    ) async {
      final profile = await ref.watch(fitnessProfileProvider.future);
      final heartRateRecords = await ref.watch(
        activityHeartRateRecordsProvider(sessionLocalId).future,
      );
      return ref
          .read(heartRateZoneServiceProvider)
          .analyze(profile: profile, heartRateRecords: heartRateRecords);
    });

final activityCadenceAnalysisProvider =
    FutureProvider.family<CadenceAnalysis?, String>((
      ref,
      sessionLocalId,
    ) async {
      final db = ref.read(databaseProvider);
      final session = await db.getActivitySession(sessionLocalId);
      if (session == null) return null;
      final end = session.endedAt ?? DateTime.now();
      final records = await db.getRecordsBetween(session.startedAt, end);
      final stepRecords =
          records.where((record) => record.dataType == 'STEPS').toList();
      return ref
          .read(cadenceAnalysisServiceProvider)
          .analyze(session: session, stepRecords: stepRecords);
    });

final trainingInsightsServiceProvider = Provider<TrainingInsightsService>((
  ref,
) {
  return TrainingInsightsService(ref.read(databaseProvider));
});

final trainingGoalServiceProvider = Provider<TrainingGoalService>((ref) {
  return TrainingGoalService(storage: ref.read(secureStorageProvider));
});

final trainingGoalsProvider = FutureProvider<TrainingGoals>((ref) {
  return ref.read(trainingGoalServiceProvider).loadGoals();
});

final trainingInsightsProvider = FutureProvider<TrainingInsightSummary>((
  ref,
) async {
  final goals = await ref.watch(trainingGoalsProvider.future);
  return ref.read(trainingInsightsServiceProvider).buildSummary(goals);
});

final trainingPlanServiceProvider = Provider<TrainingPlanService>((ref) {
  return TrainingPlanService(ref.read(databaseProvider));
});

final activeTrainingPlanProvider = FutureProvider<TrainingPlanSnapshot>((ref) {
  return ref.read(trainingPlanServiceProvider).loadActiveSnapshot();
});

final vo2MaxServiceProvider = Provider<Vo2MaxService>((ref) {
  return Vo2MaxService(
    db: ref.read(databaseProvider),
    fitnessProfileService: ref.read(fitnessProfileServiceProvider),
  );
});

final vo2MaxProvider = FutureProvider<Vo2MaxSummary>((ref) {
  return ref.read(vo2MaxServiceProvider).estimate();
});

final personalRecordServiceProvider = Provider<PersonalRecordService>((ref) {
  return PersonalRecordService(ref.read(databaseProvider));
});

final personalRecordsProvider = FutureProvider<List<PersonalRecord>>((ref) {
  return ref.read(personalRecordServiceProvider).rebuildAndLoadRecords();
});

final activityPersonalRecordsProvider =
    FutureProvider.family<List<PersonalRecord>, String>((ref, sessionLocalId) {
      return ref
          .read(personalRecordServiceProvider)
          .recordsForSession(sessionLocalId);
    });
