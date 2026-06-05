import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HealthNotificationSettings {
  final bool syncComplete;
  final bool recovery;
  final bool personalRecord;
  final bool streakReminder;
  final bool trainingPlan;
  final bool challengeUpdate;

  const HealthNotificationSettings({
    required this.syncComplete,
    required this.recovery,
    required this.personalRecord,
    required this.streakReminder,
    required this.trainingPlan,
    required this.challengeUpdate,
  });

  static const defaults = HealthNotificationSettings(
    syncComplete: true,
    recovery: true,
    personalRecord: true,
    streakReminder: true,
    trainingPlan: true,
    challengeUpdate: true,
  );

  HealthNotificationSettings copyWith({
    bool? syncComplete,
    bool? recovery,
    bool? personalRecord,
    bool? streakReminder,
    bool? trainingPlan,
    bool? challengeUpdate,
  }) {
    return HealthNotificationSettings(
      syncComplete: syncComplete ?? this.syncComplete,
      recovery: recovery ?? this.recovery,
      personalRecord: personalRecord ?? this.personalRecord,
      streakReminder: streakReminder ?? this.streakReminder,
      trainingPlan: trainingPlan ?? this.trainingPlan,
      challengeUpdate: challengeUpdate ?? this.challengeUpdate,
    );
  }
}

class NotificationSettingsService {
  static const _syncCompleteKey = 'notifications.sync_complete';
  static const _recoveryKey = 'notifications.recovery';
  static const _personalRecordKey = 'notifications.personal_record';
  static const _streakReminderKey = 'notifications.streak_reminder';
  static const _trainingPlanKey = 'notifications.training_plan';
  static const _challengeUpdateKey = 'notifications.challenge_update';

  final FlutterSecureStorage storage;

  const NotificationSettingsService({required this.storage});

  Future<HealthNotificationSettings> loadSettings() async {
    final defaults = HealthNotificationSettings.defaults;
    return HealthNotificationSettings(
      syncComplete: await _readBool(_syncCompleteKey, defaults.syncComplete),
      recovery: await _readBool(_recoveryKey, defaults.recovery),
      personalRecord: await _readBool(
        _personalRecordKey,
        defaults.personalRecord,
      ),
      streakReminder: await _readBool(
        _streakReminderKey,
        defaults.streakReminder,
      ),
      trainingPlan: await _readBool(_trainingPlanKey, defaults.trainingPlan),
      challengeUpdate: await _readBool(
        _challengeUpdateKey,
        defaults.challengeUpdate,
      ),
    );
  }

  Future<void> saveSettings(HealthNotificationSettings settings) {
    return Future.wait([
      _writeBool(_syncCompleteKey, settings.syncComplete),
      _writeBool(_recoveryKey, settings.recovery),
      _writeBool(_personalRecordKey, settings.personalRecord),
      _writeBool(_streakReminderKey, settings.streakReminder),
      _writeBool(_trainingPlanKey, settings.trainingPlan),
      _writeBool(_challengeUpdateKey, settings.challengeUpdate),
    ]);
  }

  Future<bool> _readBool(String key, bool fallback) async {
    final raw = await storage.read(key: key);
    if (raw == null) return fallback;
    return raw == 'true';
  }

  Future<void> _writeBool(String key, bool value) {
    return storage.write(key: key, value: value.toString());
  }
}
