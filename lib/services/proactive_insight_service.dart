import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/database.dart';
import 'local_notification_service.dart';
import 'notification_settings_service.dart';
import 'personal_record_service.dart';
import 'training_goal_service.dart';
import 'training_insights_service.dart';
import 'training_plan_service.dart';

class ProactiveInsightService {
  final AppDatabase db;
  final FlutterSecureStorage storage;
  final LocalNotificationService notifications;
  final NotificationSettingsService settingsService;

  ProactiveInsightService({
    required this.db,
    required this.storage,
    LocalNotificationService? notifications,
    NotificationSettingsService? settingsService,
  }) : notifications = notifications ?? LocalNotificationService(),
       settingsService =
           settingsService ?? NotificationSettingsService(storage: storage);

  Future<void> initialize({bool requestPermission = false}) {
    return notifications.initialize(requestPermission: requestPermission);
  }

  Future<void> maybeNotifyAfterSync({
    required int insertedCount,
    required int syncedCount,
    required String message,
  }) async {
    await initialize();
    final settings = await settingsService.loadSettings();
    if (settings.syncComplete && insertedCount + syncedCount > 0) {
      await _notifyThrottled(
        key: 'notifications.last_sync_complete_at',
        minGap: const Duration(hours: 3),
        id: 4101,
        title: 'Health sync complete',
        body:
            insertedCount > 0
                ? 'Collected $insertedCount new records. $message'
                : message,
      );
    }
    await maybeNotifyTrainingSignals(settings: settings);
  }

  Future<void> maybeNotifyActivitySaved(String sessionLocalId) async {
    await initialize();
    final settings = await settingsService.loadSettings();
    if (!settings.personalRecord) return;
    final records = await PersonalRecordService(
      db,
    ).recordsForSession(sessionLocalId);
    if (records.isEmpty) return;
    final record = records.first;
    final key = '${record.sessionLocalId}:${record.recordKey}';
    if (await _alreadySent('notifications.last_pr_key', key)) return;
    await notifications.show(
      id: 4201,
      title: 'New personal record',
      body: '${record.label} unlocked. Nice work.',
      payload: 'personal_record:$key',
    );
    await storage.write(key: 'notifications.last_pr_key', value: key);
  }

  Future<void> maybeNotifyTrainingSignals({
    HealthNotificationSettings? settings,
  }) async {
    await initialize();
    final resolved = settings ?? await settingsService.loadSettings();
    final todayKey = _dateKey(DateTime.now());
    final goals = await TrainingGoalService(storage: storage).loadGoals();
    final insights = await TrainingInsightsService(db).buildSummary(goals);
    final plan = await TrainingPlanService(db).loadActiveSnapshot();

    if (resolved.recovery && insights.sleepDebtMinutes >= 180) {
      await _notifyOncePerDay(
        keyPrefix: 'notifications.recovery',
        dateKey: todayKey,
        id: 4301,
        title: 'Recovery first today',
        body:
            'Sleep debt is about ${(insights.sleepDebtMinutes / 60).toStringAsFixed(1)} h. Keep training easy.',
      );
    }

    if (resolved.trainingPlan && plan.today.isNotEmpty) {
      final workout = plan.today.first;
      await _notifyOncePerDay(
        keyPrefix: 'notifications.training_plan',
        dateKey: todayKey,
        id: 4302,
        title: 'Training plan today',
        body:
            '${workout.title}: ${_targetLabel(workout)} at ${workout.intensity} effort.',
      );
    }

    if (resolved.streakReminder && _needsStreakNudge(insights)) {
      await _notifyOncePerDay(
        keyPrefix: 'notifications.streak',
        dateKey: todayKey,
        id: 4303,
        title: 'Keep the week alive',
        body:
            'A short walk or easy session can help progress your weekly goals.',
      );
    }
  }

  Future<void> _notifyThrottled({
    required String key,
    required Duration minGap,
    required int id,
    required String title,
    required String body,
  }) async {
    final raw = await storage.read(key: key);
    final last = raw == null ? null : DateTime.tryParse(raw);
    final now = DateTime.now();
    if (last != null && now.difference(last) < minGap) return;
    await notifications.show(id: id, title: title, body: body);
    await storage.write(key: key, value: now.toIso8601String());
  }

  Future<void> _notifyOncePerDay({
    required String keyPrefix,
    required String dateKey,
    required int id,
    required String title,
    required String body,
  }) async {
    final key = '$keyPrefix.$dateKey';
    if (await _alreadySent(key, 'sent')) return;
    await notifications.show(id: id, title: title, body: body);
    await storage.write(key: key, value: 'sent');
  }

  Future<bool> _alreadySent(String key, String value) async {
    return await storage.read(key: key) == value;
  }

  bool _needsStreakNudge(TrainingInsightSummary insights) {
    final today = DateTime.now();
    if (today.hour < 16) return false;
    final hasActivityToday =
        insights.calendarDays.isNotEmpty &&
        insights.calendarDays.last.hasActivity;
    return !hasActivityToday && insights.activeDays < 5;
  }

  String _targetLabel(TrainingPlanWorkout workout) {
    if (workout.targetDistanceMeters > 0) {
      return '${(workout.targetDistanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${workout.targetDurationMinutes} min';
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
