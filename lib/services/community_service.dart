import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class CommunitySettings {
  final String baseUrl;
  final bool interest;
  final DateTime? interestAt;

  const CommunitySettings({
    required this.baseUrl,
    required this.interest,
    required this.interestAt,
  });

  bool get isConfigured => baseUrl.trim().isNotEmpty;
}

class CommunityShareResult {
  final String localId;
  final String? shareId;
  final String? publicUrl;
  final String status;

  const CommunityShareResult({
    required this.localId,
    required this.shareId,
    required this.publicUrl,
    required this.status,
  });
}

class CommunityService {
  static const baseUrlKey = 'community_base_url';
  static const interestKey = 'community_interest';
  static const interestAtKey = 'community_interest_at';

  final AppDatabase db;
  final FlutterSecureStorage storage;
  final Dio dio;
  final _uuid = const Uuid();

  CommunityService(this.db, {required this.storage, Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 40),
            ),
          );

  Future<CommunitySettings> loadSettings() async {
    return CommunitySettings(
      baseUrl: await storage.read(key: baseUrlKey) ?? '',
      interest: (await storage.read(key: interestKey)) == 'true',
      interestAt: DateTime.tryParse(
        await storage.read(key: interestAtKey) ?? '',
      ),
    );
  }

  Future<void> saveSettings(String baseUrl) async {
    await storage.write(key: baseUrlKey, value: baseUrl.trim());
  }

  Future<void> saveCommunityInterest() async {
    await storage.write(key: interestKey, value: 'true');
    await storage.write(
      key: interestAtKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<void> createChallengeDraft({
    required String title,
    required String metric,
    required double targetValue,
  }) {
    return db.upsertChallengeInvite(
      ChallengeInvitesCompanion.insert(
        localId: _uuid.v4(),
        title: title,
        metric: metric,
        targetValue: Value(targetValue),
        status: const Value('draft'),
        expiresAt: Value(DateTime.now().add(const Duration(days: 7))),
      ),
    );
  }

  Future<CommunityShareResult> shareActivity(ActivitySession session) async {
    final settings = await loadSettings();
    final payload = buildPublicActivityPayload(session);
    final localId = _uuid.v4();

    if (!settings.isConfigured) {
      await _storeShare(
        localId: localId,
        session: session,
        payload: payload,
        status: 'draft',
      );
      return CommunityShareResult(
        localId: localId,
        shareId: null,
        publicUrl: null,
        status: 'draft',
      );
    }

    final response = await dio.post<Map<String, dynamic>>(
      '${settings.baseUrl.replaceAll(RegExp(r'/+$'), '')}/share/activity',
      data: payload,
    );
    final data = response.data ?? const <String, dynamic>{};
    final shareId = data['shareId']?.toString();
    final publicUrl = data['publicUrl']?.toString();

    await _storeShare(
      localId: localId,
      session: session,
      payload: payload,
      status: 'shared',
      shareId: shareId,
      publicUrl: publicUrl,
      sharedAt: DateTime.now(),
    );

    return CommunityShareResult(
      localId: localId,
      shareId: shareId,
      publicUrl: publicUrl,
      status: 'shared',
    );
  }

  Map<String, dynamic> buildPublicActivityPayload(ActivitySession session) {
    final paceSecondsPerKm =
        session.distanceMeters <= 0 || session.movingSeconds <= 0
            ? null
            : session.movingSeconds / (session.distanceMeters / 1000);
    return {
      'title': session.title ?? session.sportName,
      'sport': session.sportName,
      'sport_key': session.sportKey,
      'date': session.startedAt.toIso8601String(),
      'distance_meters': session.distanceMeters,
      'duration_seconds': session.movingSeconds,
      'pace_seconds_per_km': paceSecondsPerKm,
      'speed_mps': session.avgSpeedMps,
      'calories_kcal': session.caloriesKcal <= 0 ? null : session.caloriesKcal,
      'ascent_meters': session.ascentMeters,
      'privacy': {
        'route_visibility': session.routeVisibility,
        'hide_start_end_meters': session.hideStartEndMeters,
        'raw_health_included': false,
        'raw_route_included': false,
      },
      'route_thumbnail': null,
    };
  }

  Future<void> _storeShare({
    required String localId,
    required ActivitySession session,
    required Map<String, dynamic> payload,
    required String status,
    String? shareId,
    String? publicUrl,
    DateTime? sharedAt,
  }) {
    return db.upsertCommunityShare(
      CommunityShareRecordsCompanion.insert(
        localId: localId,
        sessionLocalId: Value(session.localId),
        shareId: Value(shareId),
        publicUrl: Value(publicUrl),
        payloadJson: jsonEncode(payload),
        status: Value(status),
        sharedAt: Value(sharedAt),
      ),
    );
  }
}
