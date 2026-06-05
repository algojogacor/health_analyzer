import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../database/database.dart';
import 'webhook_settings_service.dart';

class WebhookService {
  final WebhookSettingsService settingsService;
  final Dio _dio;

  WebhookService({required this.settingsService, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );

  Future<void> sendActivitySaved(ActivitySession session) async {
    final settings = await settingsService.loadSettings();
    if (!settings.configured || !settings.activitySaved) return;
    await _send(settings, 'activity_saved', {
      'activity': _sessionPayload(session),
      'privacy_note':
          'No raw health records or raw route points are included in webhook payloads.',
    });
  }

  Future<void> sendSyncCompleted({
    required int insertedCount,
    required int syncedCount,
    required String message,
  }) async {
    final settings = await settingsService.loadSettings();
    if (!settings.configured || !settings.syncCompleted) return;
    await _send(settings, 'sync_completed', {
      'inserted_count': insertedCount,
      'synced_count': syncedCount,
      'message': message,
    });
  }

  Future<void> sendPersonalRecords(
    ActivitySession session,
    List<PersonalRecord> records,
  ) async {
    if (records.isEmpty) return;
    final settings = await settingsService.loadSettings();
    if (!settings.configured || !settings.personalRecord) return;
    await _send(settings, 'personal_record_new', {
      'activity': _sessionPayload(session),
      'records':
          records
              .map(
                (record) => {
                  'sport_key': record.sportKey,
                  'record_key': record.recordKey,
                  'label': record.label,
                  'metric': record.metric,
                  'value': record.value,
                  'unit': record.unit,
                  'achieved_at': record.achievedAt.toIso8601String(),
                },
              )
              .toList(),
    });
  }

  Future<void> sendTest() async {
    final settings = await settingsService.loadSettings();
    if (!settings.configured) {
      throw StateError('Webhook URL is not configured');
    }
    await _send(settings, 'test', {
      'message': 'Health Analyzer webhook test',
    }, rethrowErrors: true);
  }

  Future<void> _send(
    WebhookSettings settings,
    String event,
    Map<String, dynamic> payload, {
    bool rethrowErrors = false,
  }) async {
    final body = {
      'event': event,
      'sent_at': DateTime.now().toUtc().toIso8601String(),
      'source': 'health_analyzer',
      'payload': payload,
    };
    final headers = <String, dynamic>{
      if (settings.secret.trim().isNotEmpty)
        'X-Health-Analyzer-Secret': settings.secret.trim(),
    };
    try {
      await _dio.post(
        settings.url.trim(),
        data: body,
        options: Options(headers: headers),
      );
    } catch (error) {
      developer.log(
        'Webhook send failed for $event: $error',
        name: 'WebhookService',
      );
      if (rethrowErrors) rethrow;
    }
  }

  Map<String, dynamic> _sessionPayload(ActivitySession session) {
    return {
      'local_id': session.localId,
      'title': session.title ?? session.sportName,
      'sport_key': session.sportKey,
      'sport_name': session.sportName,
      'started_at': session.startedAt.toIso8601String(),
      'duration_seconds': session.movingSeconds,
      'elapsed_seconds': session.elapsedSeconds,
      'distance_meters': session.distanceMeters,
      'calories_kcal': session.caloriesKcal,
      'ascent_meters': session.ascentMeters,
      'route_visibility': session.routeVisibility,
      'sync_route_detail': session.syncRouteDetail,
      'tags':
          session.tags
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList(),
    };
  }
}
