import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import 'activity_analysis_service.dart';

class AiToolExecutorService {
  final AppDatabase db;
  final ActivityAnalysisService analysisService;

  AiToolExecutorService(this.db, this.analysisService);

  Future<Map<String, dynamic>> runTool(
    String toolName,
    Map<String, dynamic> input, {
    String? conversationId,
    String? messageId,
    String? usageWindowId,
    String tier = 'free',
    int tokenInput = 0,
    int tokenOutput = 0,
    double estimatedCost = 0,
  }) async {
    final result = await _run(toolName, input);
    await db.insertAiToolCall(
      AiToolCallsCompanion.insert(
        conversationId: Value(conversationId),
        messageId: Value(messageId),
        usageWindowId: Value(usageWindowId),
        tier: Value(tier),
        toolName: toolName,
        inputJson: jsonEncode(input),
        resultJson: jsonEncode(result),
        model: const Value('local-tool'),
        tokenInput: Value(tokenInput),
        tokenOutput: Value(tokenOutput),
        estimatedCost: Value(estimatedCost),
      ),
    );
    return result;
  }

  Future<Map<String, dynamic>> _run(
    String toolName,
    Map<String, dynamic> input,
  ) async {
    return switch (toolName) {
      'get_daily_health_summary' => _getDailyHealthSummary(input),
      'get_activity_detail' => _getActivityDetail(input),
      'get_training_load' => _getTrainingLoad(input),
      'compare_workouts' => _compareWorkouts(input),
      'find_data_gaps' => _findDataGaps(input),
      'generate_recovery_advice' => _generateRecoveryAdvice(input),
      'load_route_summary' => _loadRouteSummary(input),
      'get_privacy_status' => _getPrivacyStatus(input),
      _ => throw ArgumentError('Unknown AI tool: $toolName'),
    };
  }

  Future<Map<String, dynamic>> _getDailyHealthSummary(
    Map<String, dynamic> input,
  ) async {
    final date = _dateOnly(input['date']?.toString());
    final end = date.add(const Duration(days: 1));
    final records = await db.getRecordsBetween(date, end);
    double sum(String type) => records
        .where((record) => record.dataType == type)
        .fold(0, (total, record) => total + record.value);
    double? avg(String type) {
      final rows = records.where((record) => record.dataType == type).toList();
      if (rows.isEmpty) return null;
      return rows.fold<double>(0, (total, record) => total + record.value) /
          rows.length;
    }

    return {
      'date': _dateKey(date),
      'record_count': records.length,
      'steps': sum('STEPS').round(),
      'active_calories_kcal': sum('ACTIVE_ENERGY_BURNED'),
      'sleep_minutes': records
          .where(
            (record) => {
              'SLEEP_ASLEEP',
              'SLEEP_DEEP',
              'SLEEP_LIGHT',
              'SLEEP_REM',
            }.contains(record.dataType),
          )
          .fold<double>(0, (total, record) => total + record.value),
      'avg_heart_rate_bpm': avg('HEART_RATE'),
      'avg_spo2_percent': avg('BLOOD_OXYGEN'),
      'avg_hrv_ms': avg('HEART_RATE_VARIABILITY_RMSSD'),
      'data_gaps': _healthGaps(records),
    };
  }

  Future<Map<String, dynamic>> _getActivityDetail(
    Map<String, dynamic> input,
  ) async {
    final session = await _sessionFromInput(input);
    if (session == null) return {'found': false};
    final points = await db.getActivityPoints(session.localId);
    final analysis = analysisService.analyze(session, points);
    return {
      'found': true,
      'activity': _sessionSummary(session),
      'gps_quality': analysis.gpsQuality.toJson(),
      'splits':
          analysis.splits
              .map(
                (split) => {
                  'index': split.index,
                  'distance_meters': split.distanceMeters,
                  'elapsed_seconds': split.elapsedSeconds,
                  'moving_seconds': split.movingSeconds,
                  'avg_speed_mps': split.avgSpeedMps,
                  'ascent_meters': split.ascentMeters,
                },
              )
              .toList(),
      'raw_route_points_included': false,
    };
  }

  Future<Map<String, dynamic>> _getTrainingLoad(
    Map<String, dynamic> input,
  ) async {
    final days = int.tryParse(input['days']?.toString() ?? '') ?? 7;
    final activities = await db.activitySessionsRecent(100).get();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final rows = activities.where(
      (activity) => activity.startedAt.isAfter(cutoff),
    );
    final movingSeconds = rows.fold<int>(
      0,
      (total, activity) => total + activity.movingSeconds,
    );
    final distanceMeters = rows.fold<double>(
      0,
      (total, activity) => total + activity.distanceMeters,
    );
    return {
      'days': days,
      'activity_count': rows.length,
      'moving_seconds': movingSeconds,
      'distance_meters': distanceMeters,
      'training_load_score': (movingSeconds / 60) + (distanceMeters / 1000 * 8),
    };
  }

  Future<Map<String, dynamic>> _compareWorkouts(
    Map<String, dynamic> input,
  ) async {
    final a = await db.getActivitySession(input['a']?.toString() ?? '');
    final b = await db.getActivitySession(input['b']?.toString() ?? '');
    return {
      'a': a == null ? null : _sessionSummary(a),
      'b': b == null ? null : _sessionSummary(b),
      'delta':
          a == null || b == null
              ? null
              : {
                'distance_meters': a.distanceMeters - b.distanceMeters,
                'moving_seconds': a.movingSeconds - b.movingSeconds,
                'ascent_meters': a.ascentMeters - b.ascentMeters,
              },
    };
  }

  Future<Map<String, dynamic>> _findDataGaps(Map<String, dynamic> input) async {
    final date = _dateOnly(input['date']?.toString());
    final records = await db.getRecordsBetween(
      date,
      date.add(const Duration(days: 1)),
    );
    return {'date': _dateKey(date), 'data_gaps': _healthGaps(records)};
  }

  Future<Map<String, dynamic>> _generateRecoveryAdvice(
    Map<String, dynamic> input,
  ) async {
    final summary = await _getDailyHealthSummary(input);
    final sleep = (summary['sleep_minutes'] as num).toDouble();
    final gaps = summary['data_gaps'] as List<String>;
    final advice = <String>[
      if (sleep > 0 && sleep < 360)
        'Prioritize sleep recovery before hard intensity.'
      else if (sleep >= 420)
        'Sleep duration supports normal training today.'
      else
        'Sleep data is incomplete; keep advice conservative.',
      if (gaps.contains('heart_rate_missing'))
        'Heart-rate context is missing, so avoid over-reading readiness.',
      'Use this as wellness guidance, not medical diagnosis.',
    ];
    return {'date': summary['date'], 'advice': advice, 'source': summary};
  }

  Future<Map<String, dynamic>> _loadRouteSummary(
    Map<String, dynamic> input,
  ) async {
    final session = await _sessionFromInput(input);
    if (session == null) return {'found': false};
    final points = await db.getActivityPoints(session.localId);
    return {
      'found': true,
      'session_local_id': session.localId,
      'distance_meters': session.distanceMeters,
      'point_count': points.length,
      'route_visibility': session.routeVisibility,
      'hide_start_end_meters': session.hideStartEndMeters,
      'raw_route_points_included':
          session.syncRouteDetail == true && input['include_raw_route'] == true,
      'points':
          session.syncRouteDetail == true && input['include_raw_route'] == true
              ? points
                  .map(
                    (point) => {
                      'lat': point.latitude,
                      'lng': point.longitude,
                      't': point.timestamp.toIso8601String(),
                    },
                  )
                  .toList()
              : null,
    };
  }

  Future<Map<String, dynamic>> _getPrivacyStatus(
    Map<String, dynamic> input,
  ) async {
    final session = await _sessionFromInput(input);
    if (session == null) return {'found': false};
    return {
      'found': true,
      'session_local_id': session.localId,
      'route_visibility': session.routeVisibility,
      'hide_start_end_meters': session.hideStartEndMeters,
      'sync_route_detail': session.syncRouteDetail,
      'raw_gps_allowed_for_ai': session.syncRouteDetail,
    };
  }

  Future<ActivitySession?> _sessionFromInput(Map<String, dynamic> input) {
    return db.getActivitySession(input['session_local_id']?.toString() ?? '');
  }

  Map<String, dynamic> _sessionSummary(ActivitySession session) {
    return {
      'local_id': session.localId,
      'title': session.title,
      'sport': session.sportName,
      'started_at': session.startedAt.toIso8601String(),
      'duration_seconds': session.movingSeconds,
      'distance_meters': session.distanceMeters,
      'ascent_meters': session.ascentMeters,
      'calories_kcal': session.caloriesKcal,
      'privacy': {
        'route_visibility': session.routeVisibility,
        'hide_start_end_meters': session.hideStartEndMeters,
        'sync_route_detail': session.syncRouteDetail,
      },
    };
  }

  List<String> _healthGaps(List<HealthRecord> records) {
    bool has(String type) => records.any((record) => record.dataType == type);
    return [
      if (!has('HEART_RATE')) 'heart_rate_missing',
      if (!has('BLOOD_OXYGEN')) 'spo2_missing',
      if (!has('HEART_RATE_VARIABILITY_RMSSD')) 'hrv_missing',
      if (!records.any((record) => record.dataType.startsWith('SLEEP')))
        'sleep_missing',
      if (!has('STEPS')) 'steps_missing',
    ];
  }

  DateTime _dateOnly(String? value) {
    final parsed = value == null ? null : DateTime.tryParse(value);
    final raw = parsed ?? DateTime.now();
    return DateTime(raw.year, raw.month, raw.day);
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

extension on ActivityGpsQuality {
  Map<String, dynamic> toJson() {
    return {
      'good': good,
      'usable': usable,
      'low': low,
      'unknown': unknown,
      'total': total,
    };
  }
}
