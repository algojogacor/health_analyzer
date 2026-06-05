import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebhookSettings {
  final bool enabled;
  final String url;
  final String secret;
  final bool activitySaved;
  final bool syncCompleted;
  final bool personalRecord;
  final bool readinessChanged;

  const WebhookSettings({
    this.enabled = false,
    this.url = '',
    this.secret = '',
    this.activitySaved = true,
    this.syncCompleted = true,
    this.personalRecord = true,
    this.readinessChanged = false,
  });

  bool get configured => enabled && url.trim().startsWith('http');

  WebhookSettings copyWith({
    bool? enabled,
    String? url,
    String? secret,
    bool? activitySaved,
    bool? syncCompleted,
    bool? personalRecord,
    bool? readinessChanged,
  }) {
    return WebhookSettings(
      enabled: enabled ?? this.enabled,
      url: url ?? this.url,
      secret: secret ?? this.secret,
      activitySaved: activitySaved ?? this.activitySaved,
      syncCompleted: syncCompleted ?? this.syncCompleted,
      personalRecord: personalRecord ?? this.personalRecord,
      readinessChanged: readinessChanged ?? this.readinessChanged,
    );
  }
}

class WebhookSettingsService {
  static const _enabledKey = 'webhook.enabled';
  static const _urlKey = 'webhook.url';
  static const _secretKey = 'webhook.secret';
  static const _activitySavedKey = 'webhook.event.activity_saved';
  static const _syncCompletedKey = 'webhook.event.sync_completed';
  static const _personalRecordKey = 'webhook.event.personal_record';
  static const _readinessChangedKey = 'webhook.event.readiness_changed';

  final FlutterSecureStorage storage;

  const WebhookSettingsService({required this.storage});

  Future<WebhookSettings> loadSettings() async {
    return WebhookSettings(
      enabled: (await storage.read(key: _enabledKey)) == 'true',
      url: await storage.read(key: _urlKey) ?? '',
      secret: await storage.read(key: _secretKey) ?? '',
      activitySaved: (await storage.read(key: _activitySavedKey)) != 'false',
      syncCompleted: (await storage.read(key: _syncCompletedKey)) != 'false',
      personalRecord: (await storage.read(key: _personalRecordKey)) != 'false',
      readinessChanged:
          (await storage.read(key: _readinessChangedKey)) == 'true',
    );
  }

  Future<void> saveSettings(WebhookSettings settings) async {
    await Future.wait([
      storage.write(key: _enabledKey, value: settings.enabled.toString()),
      storage.write(key: _urlKey, value: settings.url.trim()),
      storage.write(key: _secretKey, value: settings.secret.trim()),
      storage.write(
        key: _activitySavedKey,
        value: settings.activitySaved.toString(),
      ),
      storage.write(
        key: _syncCompletedKey,
        value: settings.syncCompleted.toString(),
      ),
      storage.write(
        key: _personalRecordKey,
        value: settings.personalRecord.toString(),
      ),
      storage.write(
        key: _readinessChangedKey,
        value: settings.readinessChanged.toString(),
      ),
    ]);
  }
}
