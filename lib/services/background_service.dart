import 'dart:developer' as developer;
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import 'package:workmanager/workmanager.dart';

import '../database/database.dart';
import 'activity_sync_mapper.dart';
import 'health_service.dart';
import 'proactive_insight_service.dart';
import 'turso_service.dart';
import 'webhook_service.dart';
import 'webhook_settings_service.dart';

/// Unique task names.
const String healthSyncTask = 'com.healthanalyzer.sync';
const String healthPeriodicTask = 'com.healthanalyzer.periodicSync';

/// Callback dispatcher for WorkManager. Must stay top-level/static.
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    try {
      developer.log(
        'Background task: $task at ${DateTime.now()}',
        name: 'BackgroundService',
      );

      switch (task) {
        case healthSyncTask:
        case healthPeriodicTask:
          await _executeHealthSync();
        default:
          developer.log('Unknown task: $task', name: 'BackgroundService');
          return Future.value(false);
      }

      return Future.value(true);
    } catch (e, stack) {
      developer.log(
        'Background task failed: $e',
        name: 'BackgroundService',
        error: e,
        stackTrace: stack,
      );
      return Future.value(false);
    }
  });
}

/// Reads Health Connect, stores local records, then pushes pending records.
Future<void> _executeHealthSync() async {
  final startedAt = DateTime.now();
  final db = AppDatabase();
  final healthService = HealthService();
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  var syncSuccess = true;
  var syncMessage = 'Background sync complete';
  var insertedCount = 0;
  var syncedCount = 0;
  List<HealthDataPoint> healthData = [];

  try {
    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    try {
      final hasPermissions = await healthService.hasPermissions();
      final hasBackgroundPermission =
          await healthService.hasBackgroundPermission();
      if (hasPermissions && hasBackgroundPermission) {
        healthData = await healthService.fetchHealthData(
          start: oneHourAgo,
          end: now,
        );
        developer.log(
          'Collected ${healthData.length} health records in background',
          name: 'BackgroundService',
        );
      } else if (!hasBackgroundPermission) {
        syncMessage = 'Health Connect background access is not authorized';
        developer.log(syncMessage, name: 'BackgroundService');
      } else {
        syncMessage = 'Health Connect permission is not available';
        developer.log(syncMessage, name: 'BackgroundService');
      }
    } catch (e) {
      syncMessage = 'Health Connect background read failed: $e';
      developer.log(syncMessage, name: 'BackgroundService', error: e);
    }

    final newRecords =
        healthData.map((point) {
          final value = point.value;
          double numericValue = 0.0;
          if (value is NumericHealthValue) {
            numericValue = value.numericValue.toDouble();
          }
          return HealthRecordsCompanion.insert(
            dataType: point.type.name,
            value: numericValue,
            unit: point.unit.name,
            dateFrom: point.dateFrom,
            dateTo: point.dateTo,
            sourceName: Value(point.sourceName),
            sourceId: Value(point.sourceId),
            syncStatus: const Value('pending'),
          );
        }).toList();

    if (newRecords.isNotEmpty) {
      insertedCount = await db.insertNewRecords(newRecords);
      developer.log(
        'Saved $insertedCount new health records locally',
        name: 'BackgroundService',
      );
    }

    if (!isOnline) {
      syncMessage = 'Offline; saved locally';
      return;
    }

    final unsyncedRecords = await db.getUnsyncedRecords();
    final pendingActivities = await db.getPendingActivitySessions();
    final pendingSummaries = await db.getPendingActivitySummaries();
    if (unsyncedRecords.isEmpty &&
        pendingActivities.isEmpty &&
        pendingSummaries.isEmpty) {
      syncMessage =
          insertedCount > 0
              ? 'Inserted $insertedCount records; nothing pending'
              : syncMessage;
      return;
    }

    final creds = await TursoService.loadCredentials(storage);
    if (creds == null) {
      syncSuccess = false;
      syncMessage = 'No Turso credentials configured';
      developer.log(syncMessage, name: 'BackgroundService');
      return;
    }

    final tursoService = TursoService(
      dbName: creds.dbName,
      authToken: creds.authToken,
    );
    final recordsJson =
        unsyncedRecords
            .map(
              (r) => {
                'data_type': r.dataType,
                'value': r.value,
                'unit': r.unit,
                'date_from': TursoService.formatToWib(r.dateFrom),
                'date_to': TursoService.formatToWib(r.dateTo),
                'source_name': r.sourceName ?? '',
                'source_id': r.sourceId ?? '',
              },
            )
            .toList();

    final activitySessionsJson =
        pendingActivities.map(activitySessionToTurso).toList();
    final activityPointsJson = <Map<String, dynamic>>[];
    for (final activity in pendingActivities.where((a) => a.syncRouteDetail)) {
      final points = await db.getActivityPoints(activity.localId);
      activityPointsJson.addAll(points.map(activityPointToTurso));
    }
    final activitySummariesJson =
        pendingSummaries.map(activitySummaryToTurso).toList();

    final success =
        await tursoService.pushRecords(recordsJson) &&
        await tursoService.pushActivitySessions(activitySessionsJson) &&
        await tursoService.pushActivityPoints(activityPointsJson) &&
        await tursoService.pushActivitySummaries(activitySummariesJson);
    if (success) {
      await db.markAsSynced(unsyncedRecords.map((r) => r.id).toList());
      await db.markActivitySessionsSynced(
        pendingActivities.map((a) => a.localId).toList(),
      );
      await db.markActivitySummariesSynced(
        pendingSummaries.map((s) => s.sessionLocalId).toList(),
      );
      syncedCount =
          unsyncedRecords.length +
          pendingActivities.length +
          pendingSummaries.length;
      syncMessage =
          'Synced ${unsyncedRecords.length} records, ${pendingActivities.length} activities, ${pendingSummaries.length} summaries';
      developer.log(syncMessage, name: 'BackgroundService');
    } else {
      syncSuccess = false;
      syncMessage =
          'Failed to sync ${unsyncedRecords.length} records and ${pendingActivities.length} activities';
      developer.log(syncMessage, name: 'BackgroundService');
    }
  } finally {
    await db.insertSyncLog(
      SyncLogsCompanion.insert(
        operation: 'background_periodic_sync',
        status: syncSuccess ? 'success' : 'failed',
        startedAt: startedAt,
        finishedAt: Value(DateTime.now()),
        collectedCount: Value(healthData.length),
        insertedCount: Value(insertedCount),
        syncedCount: Value(syncedCount),
        message: Value(syncMessage),
      ),
    );
    try {
      if (syncSuccess) {
        await ProactiveInsightService(
          db: db,
          storage: storage,
        ).maybeNotifyAfterSync(
          insertedCount: insertedCount,
          syncedCount: syncedCount,
          message: syncMessage,
        );
        await WebhookService(
          settingsService: WebhookSettingsService(storage: storage),
        ).sendSyncCompleted(
          insertedCount: insertedCount,
          syncedCount: syncedCount,
          message: syncMessage,
        );
      }
    } catch (e, stack) {
      developer.log(
        'Post-sync notification/webhook failed: $e',
        name: 'BackgroundService',
        error: e,
        stackTrace: stack,
      );
    }
    await db.close();
  }
}
