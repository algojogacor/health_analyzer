import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import '../database/database.dart';
import '../services/ai_agent_service.dart';
import '../services/ai_tier_service.dart';
import '../services/activity_ai_summary_service.dart';
import '../services/activity_analysis_service.dart';
import '../services/activity_recorder_service.dart';
import '../services/ai_tool_executor_service.dart';
import '../services/community_service.dart';
import '../services/deepseek_service.dart';
import '../services/health_service.dart';
import '../services/offline_map_service.dart';
import '../services/saved_route_service.dart';
import '../services/turso_service.dart';

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

  final wearableRows = records.where(
    (r) =>
        (r.sourceName ?? '').contains('xiaomi') ||
        (r.sourceName ?? '').contains('wearable'),
  );
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
    notes.add('No Xiaomi wearable records found today.');
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
      final start = end.subtract(const Duration(days: 7));
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
        final source = (record.sourceName ?? '').toLowerCase();
        if (source.contains('xiaomi') || source.contains('wearable')) {
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
  return ActivityAiSummaryService(ref.read(activityAnalysisServiceProvider));
});

final savedRouteServiceProvider = Provider<SavedRouteService>((ref) {
  return SavedRouteService(ref.read(databaseProvider));
});

final savedRoutesProvider = FutureProvider<List<SavedRoute>>((ref) {
  return ref.read(databaseProvider).getRecentSavedRoutes();
});

final deepSeekServiceProvider = Provider<DeepSeekService>((ref) {
  return DeepSeekService(storage: ref.read(secureStorageProvider));
});

final deepSeekSettingsProvider = FutureProvider<DeepSeekSettings>((ref) {
  return ref.read(deepSeekServiceProvider).loadSettings();
});

final aiToolExecutorProvider = Provider<AiToolExecutorService>((ref) {
  return AiToolExecutorService(
    ref.read(databaseProvider),
    ref.read(activityAnalysisServiceProvider),
  );
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
    deepSeekService: ref.read(deepSeekServiceProvider),
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

final offlineMapRegionsProvider = FutureProvider<List<OfflineMapRegion>>((ref) {
  return ref.read(offlineMapServiceProvider).regions();
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
