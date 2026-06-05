import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(include: {'tables.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(syncLogs);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_sync_logs_started ON sync_logs(started_at)',
        );
      }
      if (from < 3) {
        await m.createTable(activitySessions);
        await m.createTable(activityPoints);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_activity_sessions_status ON activity_sessions(status, started_at)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_activity_sessions_sync ON activity_sessions(sync_status)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_activity_points_session_time ON activity_points(session_local_id, timestamp)',
        );
      }
      if (from < 4) {
        if (from >= 3) {
          await _addColumnIfMissing(
            'activity_sessions',
            'title',
            'ALTER TABLE activity_sessions ADD COLUMN title TEXT',
          );
          await _addColumnIfMissing(
            'activity_sessions',
            'manual_paused_seconds',
            'ALTER TABLE activity_sessions ADD COLUMN manual_paused_seconds INTEGER NOT NULL DEFAULT 0',
          );
        }
        await m.createTable(activityEvents);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_activity_events_session_time ON activity_events(session_local_id, timestamp)',
        );
      }
      if (from < 5) {
        await m.createTable(activitySummaries);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_activity_summaries_sync ON activity_summaries(sync_status)',
        );
      }
      if (from < 6) {
        await m.createTable(offlineMapRegions);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_offline_map_regions_status ON offline_map_regions(status)',
        );
      }
      if (from < 7) {
        if (from >= 3) {
          await _addColumnIfMissing(
            'activity_sessions',
            'notes',
            'ALTER TABLE activity_sessions ADD COLUMN notes TEXT',
          );
          await _addColumnIfMissing(
            'activity_sessions',
            'feeling',
            'ALTER TABLE activity_sessions ADD COLUMN feeling TEXT',
          );
          await _addColumnIfMissing(
            'activity_sessions',
            'rpe',
            'ALTER TABLE activity_sessions ADD COLUMN rpe INTEGER',
          );
          await _addColumnIfMissing(
            'activity_sessions',
            'gear_id',
            'ALTER TABLE activity_sessions ADD COLUMN gear_id TEXT',
          );
        }
        if (from >= 5) {
          await _addColumnIfMissing(
            'activity_summaries',
            'model',
            'ALTER TABLE activity_summaries ADD COLUMN model TEXT',
          );
          await _addColumnIfMissing(
            'activity_summaries',
            'confidence',
            'ALTER TABLE activity_summaries ADD COLUMN confidence TEXT',
          );
          await _addColumnIfMissing(
            'activity_summaries',
            'generated_by',
            "ALTER TABLE activity_summaries ADD COLUMN generated_by TEXT NOT NULL DEFAULT 'local'",
          );
          await _addColumnIfMissing(
            'activity_summaries',
            'agent_notes',
            'ALTER TABLE activity_summaries ADD COLUMN agent_notes TEXT',
          );
        }
        await m.createTable(savedRoutes);
        await m.createTable(dailySummaries);
        await m.createTable(aiToolCalls);
        await m.createTable(communityShareRecords);
        await m.createTable(challengeInvites);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_saved_routes_source ON saved_routes(source_session_local_id)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_daily_summaries_sync ON daily_summaries(sync_status)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_ai_tool_calls_created ON ai_tool_calls(created_at)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_community_share_session ON community_share_records(session_local_id)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_challenge_invites_status ON challenge_invites(status)',
        );
      }
      if (from < 8) {
        if (from >= 7) {
          await _addColumnIfMissing(
            'ai_tool_calls',
            'conversation_id',
            'ALTER TABLE ai_tool_calls ADD COLUMN conversation_id TEXT',
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'message_id',
            'ALTER TABLE ai_tool_calls ADD COLUMN message_id TEXT',
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'usage_window_id',
            'ALTER TABLE ai_tool_calls ADD COLUMN usage_window_id TEXT',
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'tier',
            "ALTER TABLE ai_tool_calls ADD COLUMN tier TEXT NOT NULL DEFAULT 'free'",
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'token_input',
            'ALTER TABLE ai_tool_calls ADD COLUMN token_input INTEGER NOT NULL DEFAULT 0',
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'token_output',
            'ALTER TABLE ai_tool_calls ADD COLUMN token_output INTEGER NOT NULL DEFAULT 0',
          );
          await _addColumnIfMissing(
            'ai_tool_calls',
            'estimated_cost',
            'ALTER TABLE ai_tool_calls ADD COLUMN estimated_cost REAL NOT NULL DEFAULT 0',
          );
        }
        await customStatement('''
          CREATE TABLE IF NOT EXISTS ai_usage_windows (
            window_id TEXT NOT NULL PRIMARY KEY,
            tier TEXT NOT NULL DEFAULT 'free',
            started_at DATETIME NOT NULL,
            resets_at DATETIME,
            tool_calls_used INTEGER NOT NULL DEFAULT 0,
            input_tokens INTEGER NOT NULL DEFAULT 0,
            output_tokens INTEGER NOT NULL DEFAULT 0,
            estimated_cost REAL NOT NULL DEFAULT 0,
            created_at DATETIME NOT NULL DEFAULT (strftime('%s', 'now')),
            updated_at DATETIME
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_ai_tool_calls_window ON ai_tool_calls(usage_window_id)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_ai_usage_windows_tier_started ON ai_usage_windows(tier, started_at)',
        );
      }
      if (from < 9) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS personal_records (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            local_id TEXT NOT NULL UNIQUE,
            sport_key TEXT NOT NULL,
            record_key TEXT NOT NULL,
            label TEXT NOT NULL,
            metric TEXT NOT NULL,
            value REAL NOT NULL,
            unit TEXT NOT NULL,
            session_local_id TEXT NOT NULL,
            achieved_at DATETIME NOT NULL,
            created_at DATETIME NOT NULL DEFAULT (strftime('%s', 'now')),
            updated_at DATETIME,
            UNIQUE(sport_key, record_key)
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_personal_records_sport ON personal_records(sport_key, record_key)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_personal_records_session ON personal_records(session_local_id)',
        );
      }
      if (from < 10) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS ai_conversations (
            local_id TEXT NOT NULL PRIMARY KEY,
            title TEXT NOT NULL,
            summary TEXT,
            context_mode TEXT NOT NULL DEFAULT 'daily',
            message_count INTEGER NOT NULL DEFAULT 0,
            created_at DATETIME NOT NULL,
            updated_at DATETIME NOT NULL,
            compacted_at DATETIME
          )
        ''');
        await customStatement('''
          CREATE TABLE IF NOT EXISTS ai_messages (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            local_id TEXT NOT NULL UNIQUE,
            conversation_id TEXT NOT NULL,
            role TEXT NOT NULL,
            content TEXT NOT NULL,
            mode TEXT,
            tool_calls_used INTEGER NOT NULL DEFAULT 0,
            error TEXT,
            created_at DATETIME NOT NULL
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_ai_conversations_updated ON ai_conversations(updated_at)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation_time ON ai_messages(conversation_id, created_at)',
        );
      }
      if (from < 11) {
        if (from >= 3) {
          await _addColumnIfMissing(
            'activity_sessions',
            'tags',
            "ALTER TABLE activity_sessions ADD COLUMN tags TEXT NOT NULL DEFAULT ''",
          );
        }
      }
      if (from < 12) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS training_plans (
            local_id TEXT NOT NULL PRIMARY KEY,
            plan_key TEXT NOT NULL,
            title TEXT NOT NULL,
            sport_key TEXT NOT NULL,
            level TEXT NOT NULL,
            start_date DATETIME NOT NULL,
            weeks INTEGER NOT NULL,
            status TEXT NOT NULL DEFAULT 'active',
            created_at DATETIME NOT NULL,
            updated_at DATETIME NOT NULL,
            completed_at DATETIME
          )
        ''');
        await customStatement('''
          CREATE TABLE IF NOT EXISTS training_plan_workouts (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            local_id TEXT NOT NULL UNIQUE,
            plan_local_id TEXT NOT NULL,
            week_index INTEGER NOT NULL,
            day_index INTEGER NOT NULL,
            scheduled_date DATETIME NOT NULL,
            title TEXT NOT NULL,
            workout_type TEXT NOT NULL,
            target_duration_minutes INTEGER NOT NULL DEFAULT 0,
            target_distance_meters REAL NOT NULL DEFAULT 0,
            intensity TEXT NOT NULL DEFAULT 'easy',
            status TEXT NOT NULL DEFAULT 'planned',
            notes TEXT,
            created_at DATETIME NOT NULL,
            updated_at DATETIME
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_training_plans_status ON training_plans(status, start_date)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_training_plan_workouts_plan ON training_plan_workouts(plan_local_id, scheduled_date)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_training_plan_workouts_date ON training_plan_workouts(scheduled_date, status)',
        );
      }
    },
  );

  Future<bool> _columnExists(String tableName, String columnName) async {
    final rows = await customSelect('PRAGMA table_info($tableName)').get();
    return rows.any((row) => row.data['name'] == columnName);
  }

  Future<void> _addColumnIfMissing(
    String tableName,
    String columnName,
    String sql,
  ) async {
    if (await _columnExists(tableName, columnName)) return;
    await customStatement(sql);
  }

  /// Insert a batch of health records
  Future<void> insertRecords(List<HealthRecordsCompanion> records) {
    return batch((batch) {
      batch.insertAll(healthRecords, records);
    });
  }

  /// Insert only records that are not already present locally.
  Future<int> insertNewRecords(List<HealthRecordsCompanion> records) async {
    var inserted = 0;

    await transaction(() async {
      for (final record in records) {
        final existing =
            await (select(healthRecords)
                  ..where(
                    (tbl) =>
                        tbl.dataType.equals(record.dataType.value) &
                        tbl.value.equals(record.value.value) &
                        tbl.unit.equals(record.unit.value) &
                        tbl.dateFrom.equals(record.dateFrom.value) &
                        tbl.dateTo.equals(record.dateTo.value) &
                        tbl.sourceName.equalsNullable(record.sourceName.value) &
                        tbl.sourceId.equalsNullable(record.sourceId.value),
                  )
                  ..limit(1))
                .getSingleOrNull();

        if (existing == null) {
          await into(healthRecords).insert(record);
          inserted++;
        }
      }
    });

    return inserted;
  }

  /// Get unsynced records
  Future<List<HealthRecord>> getUnsyncedRecords() {
    return unsyncedRecords().get();
  }

  /// Mark records as synced
  Future<void> markAsSynced(List<int> ids) async {
    await (update(healthRecords)..where((tbl) => tbl.id.isIn(ids))).write(
      HealthRecordsCompanion(
        syncStatus: const Value('synced'),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Count unsynced records
  Future<int> getUnsyncedCount() async {
    return await unsyncedCount().getSingle();
  }

  /// Clean old synced records
  Future<int> cleanSyncedRecords(String daysAgo) {
    return cleanOldRecords(daysAgo);
  }

  /// Insert a sync/collect status log for dashboard quality reporting.
  Future<int> insertSyncLog(SyncLogsCompanion log) {
    return into(syncLogs).insert(log);
  }

  /// Read health records for a local date window.
  Future<List<HealthRecord>> getRecordsBetween(DateTime start, DateTime end) {
    return (select(healthRecords)
          ..where((tbl) => tbl.dateFrom.isBiggerOrEqualValue(start))
          ..where((tbl) => tbl.dateFrom.isSmallerThanValue(end))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.dateFrom)]))
        .get();
  }

  /// Last successfully synced local record timestamp.
  Future<DateTime?> getLatestSyncedRecordTime() async {
    final row =
        await (select(healthRecords)
              ..where((tbl) => tbl.syncStatus.equals('synced'))
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.syncedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.syncedAt;
  }

  Future<int> insertActivitySession(ActivitySessionsCompanion session) {
    return into(activitySessions).insert(session);
  }

  Future<int> insertActivityPoint(ActivityPointsCompanion point) {
    return into(activityPoints).insert(point);
  }

  Future<int> insertActivityEvent(ActivityEventsCompanion event) {
    return into(activityEvents).insert(event);
  }

  Future<List<ActivityEvent>> getActivityEvents(String sessionLocalId) {
    return (select(activityEvents)
          ..where((tbl) => tbl.sessionLocalId.equals(sessionLocalId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]))
        .get();
  }

  Future<void> updateActivitySession(
    String localId,
    ActivitySessionsCompanion session,
  ) {
    return (update(activitySessions)
      ..where((tbl) => tbl.localId.equals(localId))).write(session);
  }

  Future<List<ActivitySession>> getPendingActivitySessions() {
    return (select(activitySessions)
          ..where((tbl) => tbl.syncStatus.equals('pending'))
          ..where((tbl) => tbl.status.equals('completed'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.startedAt)]))
        .get();
  }

  Future<List<ActivityPoint>> getActivityPoints(String sessionLocalId) {
    return activityPointsForSession(sessionLocalId).get();
  }

  Future<ActivitySession?> getActivitySession(String localId) {
    return activitySessionByLocalId(localId).getSingleOrNull();
  }

  Future<void> markActivitySessionsSynced(List<String> localIds) {
    return (update(activitySessions)
      ..where((tbl) => tbl.localId.isIn(localIds))).write(
      ActivitySessionsCompanion(
        syncStatus: const Value('synced'),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setActivityRouteDetailSync(String localId, bool enabled) {
    return (update(activitySessions)
      ..where((tbl) => tbl.localId.equals(localId))).write(
      ActivitySessionsCompanion(
        syncRouteDetail: Value(enabled),
        syncStatus: const Value('pending'),
        syncedAt: const Value(null),
      ),
    );
  }

  Future<void> setActivityPrivacy(
    String localId, {
    required String routeVisibility,
    required double hideStartEndMeters,
  }) {
    return (update(activitySessions)
      ..where((tbl) => tbl.localId.equals(localId))).write(
      ActivitySessionsCompanion(
        routeVisibility: Value(routeVisibility),
        hideStartEndMeters: Value(hideStartEndMeters),
      ),
    );
  }

  Future<void> upsertActivitySummary(ActivitySummariesCompanion summary) {
    return into(activitySummaries).insertOnConflictUpdate(summary);
  }

  Future<ActivitySummary?> getActivitySummary(String sessionLocalId) {
    return activitySummaryBySession(sessionLocalId).getSingleOrNull();
  }

  Future<List<ActivitySummary>> getPendingActivitySummaries() {
    return (select(activitySummaries)
          ..where((tbl) => tbl.syncStatus.equals('pending'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.generatedAt)]))
        .get();
  }

  Future<void> markActivitySummariesSynced(List<String> sessionLocalIds) {
    return (update(activitySummaries)
      ..where((tbl) => tbl.sessionLocalId.isIn(sessionLocalIds))).write(
      ActivitySummariesCompanion(
        syncStatus: const Value('synced'),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> upsertSavedRoute(SavedRoutesCompanion route) {
    return into(savedRoutes).insertOnConflictUpdate(route);
  }

  Future<List<SavedRoute>> getRecentSavedRoutes({int limit = 20}) {
    return savedRoutesRecent(limit).get();
  }

  Future<SavedRoute?> getSavedRoute(String localId) {
    return savedRouteByLocalId(localId).getSingleOrNull();
  }

  Future<void> upsertDailySummary(DailySummariesCompanion summary) {
    return into(dailySummaries).insertOnConflictUpdate(summary);
  }

  Future<DailySummary?> getDailySummary(String localDate) {
    return dailySummaryByDate(localDate).getSingleOrNull();
  }

  Future<int> insertAiToolCall(AiToolCallsCompanion call) {
    return into(aiToolCalls).insert(call);
  }

  Future<void> upsertAiUsageWindow(AiUsageWindowsCompanion window) {
    return into(aiUsageWindows).insertOnConflictUpdate(window);
  }

  Future<AiUsageWindow?> getAiUsageWindow(String windowId) {
    return aiUsageWindowById(windowId).getSingleOrNull();
  }

  Future<AiUsageWindow?> getLatestAiUsageWindowForTier(String tier) {
    return latestAiUsageWindowForTier(tier).getSingleOrNull();
  }

  Future<int> upsertAiConversation(AiConversationsCompanion conversation) {
    return into(aiConversations).insertOnConflictUpdate(conversation);
  }

  Future<List<AiConversation>> getRecentAiConversations({int limit = 20}) {
    return aiConversationsRecent(limit).get();
  }

  Future<AiConversation?> getAiConversation(String localId) {
    return aiConversationById(localId).getSingleOrNull();
  }

  Future<int> insertAiMessage(AiMessagesCompanion message) {
    return into(aiMessages).insert(message);
  }

  Future<List<AiMessage>> getAiMessagesForConversation(
    String conversationId, {
    int limit = 80,
  }) {
    return aiMessagesForConversation(conversationId, limit).get();
  }

  Future<int> upsertCommunityShare(CommunityShareRecordsCompanion share) {
    return into(communityShareRecords).insertOnConflictUpdate(share);
  }

  Future<List<CommunityShareRecord>> getRecentCommunityShares({
    int limit = 20,
  }) {
    return communitySharesRecent(limit).get();
  }

  Future<int> upsertChallengeInvite(ChallengeInvitesCompanion invite) {
    return into(challengeInvites).insertOnConflictUpdate(invite);
  }

  Future<List<ChallengeInvite>> getRecentChallengeInvites({int limit = 20}) {
    return challengeInvitesRecent(limit).get();
  }

  Future<void> clearPersonalRecords() {
    return delete(personalRecords).go();
  }

  Future<int> upsertPersonalRecord(PersonalRecordsCompanion record) {
    return into(personalRecords).insertOnConflictUpdate(record);
  }

  Future<List<PersonalRecord>> getRecentPersonalRecords({int limit = 20}) {
    return personalRecordsRecent(limit).get();
  }

  Future<List<PersonalRecord>> getPersonalRecordsForSession(
    String sessionLocalId,
  ) {
    return personalRecordsForSession(sessionLocalId).get();
  }

  Future<int> upsertTrainingPlan(TrainingPlansCompanion plan) {
    return into(trainingPlans).insertOnConflictUpdate(plan);
  }

  Future<int> upsertTrainingPlanWorkout(TrainingPlanWorkoutsCompanion workout) {
    return into(trainingPlanWorkouts).insertOnConflictUpdate(workout);
  }

  Future<TrainingPlan?> getActiveTrainingPlan() {
    return activeTrainingPlan().getSingleOrNull();
  }

  Future<TrainingPlan?> getTrainingPlan(String localId) {
    return trainingPlanByLocalId(localId).getSingleOrNull();
  }

  Future<List<TrainingPlanWorkout>> getTrainingPlanWorkouts(
    String planLocalId,
  ) {
    return trainingPlanWorkoutsForPlan(planLocalId).get();
  }

  Future<List<TrainingPlanWorkout>> getTrainingPlanWorkoutsBetween(
    DateTime start,
    DateTime end,
  ) {
    return trainingPlanWorkoutsBetween(start, end).get();
  }

  Future<void> deactivateActiveTrainingPlans() async {
    await (update(trainingPlans)
      ..where((tbl) => tbl.status.equals('active'))).write(
      TrainingPlansCompanion(
        status: const Value('archived'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'health_analyzer.db'));
    return NativeDatabase.createInBackground(file);
  });
}
