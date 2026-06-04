import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import 'activity_analysis_service.dart';

class AiToolService {
  final AppDatabase db;
  final ActivityAnalysisService analysisService;

  const AiToolService({required this.db, required this.analysisService});

  Future<Map<String, dynamic>> call(
    String toolName,
    Map<String, dynamic> input,
  ) async {
    final result = switch (toolName) {
      'get_daily_health_summary' => await getDailyHealthSummary(
        date: input['date']?.toString(),
      ),
      'get_activity_detail' => await getActivityDetail(
        sessionLocalId: input['session_local_id']?.toString() ?? '',
      ),
      'get_training_load' => await getTrainingLoad(
        days: _int(input['days'], 7),
      ),
      'compare_workouts' => await compareWorkouts(
        leftLocalId: input['left_session_local_id']?.toString() ?? '',
        rightLocalId: input['right_session_local_id']?.toString() ?? '',
      ),
      'find_data_gaps' => await findDataGaps(),
      'generate_recovery_advice' => await generateRecoveryAdvice(),
      'load_route_summary' => await loadRouteSummary(
        sessionLocalId: input['session_local_id']?.toString() ?? '',
      ),
      'get_privacy_status' => await getPrivacyStatus(
        sessionLocalId: input['session_local_id']?.toString() ?? '',
      ),
      _ => {'error': 'unknown_tool', 'tool': toolName},
    };
    await db.insertAiToolCall(
      AiToolCallsCompanion.insert(
        toolName: toolName,
        inputJson: jsonEncode(input),
        resultJson: jsonEncode(result),
        status: Value(result.containsKey('error') ? 'error' : 'success'),
      ),
    );
    return result;
  }

  Future<Map<String, dynamic>> getDailyHealthSummary({String? date}) async {
    final day = date == null ? DateTime.now() : DateTime.tryParse(date);
    final localDay = day ?? DateTime.now();
    final start = DateTime(localDay.year, localDay.month, localDay.day);
    final end = start.add(const Duration(days: 1));
    final records = await db.getRecordsBetween(start, end);
    double sum(String type) => records
        .where((record) => record.dataType == type)
        .fold(0.0, (total, record) => total + record.value);
    List<HealthRecord> rows(String type) =>
        records.where((record) => record.dataType == type).toList();
    double? avg(String type) {
      final values = rows(type);
      if (values.isEmpty) return null;
      return values.fold<double>(0, (total, record) => total + record.value) /
          values.length;
    }

    return {
      'date': start.toIso8601String().substring(0, 10),
      'record_count': records.length,
      'steps': sum('STEPS').round(),
      'active_calories': sum('ACTIVE_ENERGY_BURNED'),
      'sleep_minutes': [
        'SLEEP_ASLEEP',
        'SLEEP_DEEP',
        'SLEEP_LIGHT',
        'SLEEP_REM',
      ].fold<double>(0, (total, type) => total + sum(type)),
      'heart_rate_avg': avg('HEART_RATE'),
      'spo2_avg': avg('BLOOD_OXYGEN'),
      'hrv_avg_ms': avg('HEART_RATE_VARIABILITY_RMSSD'),
    };
  }

  Future<Map<String, dynamic>> getActivityDetail({
    required String sessionLocalId,
  }) async {
    final session = await db.getActivitySession(sessionLocalId);
    if (session == null) return {'error': 'activity_not_found'};
    final points = await db.getActivityPoints(sessionLocalId);
    final analysis = analysisService.analyze(session, points);
    return {
      'session_local_id': session.localId,
      'title': session.title ?? session.sportName,
      'sport': session.sportName,
      'started_at': session.startedAt.toIso8601String(),
      'ended_at': session.endedAt?.toIso8601String(),
      'duration': {
        'elapsed_seconds': session.elapsedSeconds,
        'moving_seconds': session.movingSeconds,
        'stopped_seconds': session.stoppedSeconds,
      },
      'distance_meters': session.distanceMeters,
      'ascent_meters': session.ascentMeters,
      'descent_meters': session.descentMeters,
      'gps_quality': {
        'good': analysis.gpsQuality.good,
        'usable': analysis.gpsQuality.usable,
        'low': analysis.gpsQuality.low,
        'unknown': analysis.gpsQuality.unknown,
      },
      'privacy': await getPrivacyStatus(sessionLocalId: sessionLocalId),
    };
  }

  Future<Map<String, dynamic>> getTrainingLoad({int days = 7}) async {
    final sessions = await db.activitySessionsRecent(100).get();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recent = sessions.where(
      (session) => session.startedAt.isAfter(cutoff),
    );
    return {
      'days': days,
      'activity_count': recent.length,
      'total_distance_meters': recent.fold<double>(
        0,
        (total, session) => total + session.distanceMeters,
      ),
      'total_moving_seconds': recent.fold<int>(
        0,
        (total, session) => total + session.movingSeconds,
      ),
      'total_calories_kcal': recent.fold<double>(
        0,
        (total, session) => total + session.caloriesKcal,
      ),
    };
  }

  Future<Map<String, dynamic>> compareWorkouts({
    required String leftLocalId,
    required String rightLocalId,
  }) async {
    final left = await db.getActivitySession(leftLocalId);
    final right = await db.getActivitySession(rightLocalId);
    if (left == null || right == null) return {'error': 'activity_not_found'};
    return {
      'left': await getActivityDetail(sessionLocalId: left.localId),
      'right': await getActivityDetail(sessionLocalId: right.localId),
      'delta': {
        'distance_meters': left.distanceMeters - right.distanceMeters,
        'moving_seconds': left.movingSeconds - right.movingSeconds,
        'ascent_meters': left.ascentMeters - right.ascentMeters,
      },
    };
  }

  Future<Map<String, dynamic>> findDataGaps() async {
    final today = await getDailyHealthSummary();
    final missing = <String>[];
    if ((today['steps'] as int) <= 0) missing.add('steps');
    if (today['heart_rate_avg'] == null) missing.add('heart_rate');
    if (today['spo2_avg'] == null) missing.add('blood_oxygen');
    if (today['hrv_avg_ms'] == null) missing.add('hrv_or_stress_proxy');
    if ((today['sleep_minutes'] as double) <= 0) missing.add('sleep');
    return {
      'missing': missing,
      'confidence': missing.length <= 1 ? 'good' : 'partial',
    };
  }

  Future<Map<String, dynamic>> generateRecoveryAdvice() async {
    final today = await getDailyHealthSummary();
    final load = await getTrainingLoad(days: 2);
    return {
      'sleep_minutes': today['sleep_minutes'],
      'hrv_avg_ms': today['hrv_avg_ms'],
      'recent_moving_seconds': load['total_moving_seconds'],
      'advice_basis':
          'wellness_only_sleep_hrv_and_recent_activity_load_context',
    };
  }

  Future<Map<String, dynamic>> loadRouteSummary({
    required String sessionLocalId,
  }) async {
    final session = await db.getActivitySession(sessionLocalId);
    if (session == null) return {'error': 'activity_not_found'};
    final points = await db.getActivityPoints(sessionLocalId);
    return {
      'session_local_id': sessionLocalId,
      'distance_meters': session.distanceMeters,
      'ascent_meters': session.ascentMeters,
      'descent_meters': session.descentMeters,
      'point_count': points.length,
      'raw_points_included': session.syncRouteDetail,
    };
  }

  Future<Map<String, dynamic>> getPrivacyStatus({
    required String sessionLocalId,
  }) async {
    final session = await db.getActivitySession(sessionLocalId);
    if (session == null) return {'error': 'activity_not_found'};
    return {
      'route_visibility': session.routeVisibility,
      'hide_start_end_meters': session.hideStartEndMeters,
      'sync_route_detail': session.syncRouteDetail,
      'raw_route_points_allowed': session.syncRouteDetail,
    };
  }

  int _int(Object? value, int fallback) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
