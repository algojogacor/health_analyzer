import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import 'activity_analysis_service.dart';
import 'cadence_analysis_service.dart';
import 'fitness_profile_service.dart';
import 'heart_rate_zone_service.dart';
import 'personal_record_service.dart';
import 'saved_route_service.dart';
import 'training_goal_service.dart';
import 'training_insights_service.dart';
import 'training_plan_service.dart';
import 'vo2max_service.dart';

class AiToolExecutorService {
  final AppDatabase db;
  final ActivityAnalysisService analysisService;
  final TrainingGoalService goalService;
  final TrainingInsightsService insightsService;
  final TrainingPlanService trainingPlanService;
  final FitnessProfileService fitnessProfileService;
  final HeartRateZoneService heartRateZoneService;
  final CadenceAnalysisService cadenceAnalysisService;

  AiToolExecutorService(
    this.db,
    this.analysisService,
    this.goalService,
    this.insightsService,
    this.trainingPlanService,
    this.fitnessProfileService,
    this.heartRateZoneService,
    this.cadenceAnalysisService,
  );

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
      'get_pr_history' => _getPrHistory(input),
      'get_best_efforts' => _getPrHistory(input),
      'get_goal_progress' => _getGoalProgress(input),
      'get_hr_zone_summary' => _getHrZoneSummary(input),
      'get_vo2max_trend' => _getVo2MaxTrend(input),
      'suggest_next_workout' => _suggestNextWorkout(input),
      'get_training_plan_status' => _getTrainingPlanStatus(input),
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
    final end = session.endedAt ?? DateTime.now();
    final records = await db.getRecordsBetween(session.startedAt, end);
    final cadence = cadenceAnalysisService.analyze(
      session: session,
      stepRecords:
          records.where((record) => record.dataType == 'STEPS').toList(),
    );
    return {
      'found': true,
      'activity': _sessionSummary(session),
      'gps_quality': analysis.gpsQuality.toJson(),
      'cadence': _cadenceSummary(cadence),
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
    final routeLocalId = input['route_local_id']?.toString() ?? '';
    if (routeLocalId.trim().isNotEmpty) {
      final route = await db.getSavedRoute(routeLocalId);
      if (route == null) return {'found': false};
      final geometry = SavedRouteService(db).geometryFor(route);
      return {
        'found': true,
        'type': 'saved_route',
        'route_local_id': route.localId,
        'name': route.name,
        'sport_key': route.sportKey,
        'distance_meters': route.distanceMeters,
        'ascent_meters': route.ascentMeters,
        'descent_meters': route.descentMeters,
        'point_count': route.pointCount,
        'route_visibility': route.routeVisibility,
        'geometry_available': geometry.points.length >= 2,
        'raw_route_points_included': false,
        'elevation_status':
            route.ascentMeters <= 0 && route.descentMeters <= 0
                ? 'unavailable'
                : 'recorded_or_imported',
      };
    }
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

  Future<Map<String, dynamic>> _getPrHistory(Map<String, dynamic> input) async {
    final limit = int.tryParse(input['limit']?.toString() ?? '') ?? 10;
    final records = await PersonalRecordService(
      db,
    ).rebuildAndLoadRecords(limit: limit.clamp(1, 30).toInt());
    final sport = input['sport_key']?.toString().toLowerCase();
    final filtered =
        sport == null || sport.isEmpty
            ? records
            : records
                .where((record) => record.sportKey.toLowerCase() == sport)
                .toList();
    return {
      'count': filtered.length,
      'records': filtered.map(_personalRecordSummary).toList(),
      'note':
          'Records are calculated locally from saved activity sessions. Standard-distance efforts are estimated from whole-activity pace unless split-level data exists later.',
    };
  }

  Future<Map<String, dynamic>> _getGoalProgress(
    Map<String, dynamic> input,
  ) async {
    final goals = await goalService.loadGoals();
    final summary = await insightsService.buildSummary(goals);
    return {
      'generated_at': summary.generatedAt.toIso8601String(),
      'readiness': {
        'score': summary.readinessScore,
        'label': summary.readinessLabel,
        'reason': summary.readinessReason,
        'baseline': {
          'status': summary.readinessBaseline.status,
          'current_hrv_ms': summary.readinessBaseline.currentHrvMs,
          'baseline_hrv_ms': summary.readinessBaseline.baselineHrvMs,
          'current_resting_hr': summary.readinessBaseline.currentRestingHr,
          'baseline_resting_hr': summary.readinessBaseline.baselineRestingHr,
          'missing_sensors': summary.readinessBaseline.missingSensors,
        },
      },
      'weekly': {
        'active_days': summary.activeDays,
        'streak_days': summary.streakDays,
        'distance_meters': summary.weeklyDistanceMeters,
        'moving_seconds': summary.weeklyMovingSeconds,
        'steps': summary.weeklySteps,
        'sleep_debt_minutes': summary.sleepDebtMinutes,
      },
      'goals':
          summary.goals
              .map(
                (goal) => {
                  'key': goal.key,
                  'label': goal.label,
                  'value': goal.valueLabel,
                  'target': goal.targetLabel,
                  'progress': goal.progress,
                  'status': goal.status,
                },
              )
              .toList(),
    };
  }

  Future<Map<String, dynamic>> _getHrZoneSummary(
    Map<String, dynamic> input,
  ) async {
    final session = await _sessionFromInput(input);
    if (session == null) return {'found': false};
    final profile = await fitnessProfileService.loadProfile();
    final end = session.endedAt ?? DateTime.now();
    final records = await db.getRecordsBetween(session.startedAt, end);
    final heartRateRecords =
        records.where((record) => record.dataType == 'HEART_RATE').toList()
          ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    final result = heartRateZoneService.analyze(
      profile: profile,
      heartRateRecords: heartRateRecords,
    );
    return {
      'found': true,
      'session_local_id': session.localId,
      'has_max_hr': profile.hasHeartRateZones,
      'heart_rate_record_count': heartRateRecords.length,
      if (result != null) ...{
        'max_heart_rate': result.maxHeartRate,
        'total_seconds': result.totalSeconds,
        'zones':
            result.zones
                .map(
                  (zone) => {
                    'zone': zone.zone,
                    'label': zone.label,
                    'min_bpm': zone.minBpm,
                    'max_bpm': zone.maxBpm,
                    'seconds': zone.seconds,
                    'percent': zone.percent,
                  },
                )
                .toList(),
      },
      if (result == null)
        'note':
            'HR zone summary needs max HR in profile and at least two overlapping heart-rate records.',
    };
  }

  Future<Map<String, dynamic>> _suggestNextWorkout(
    Map<String, dynamic> input,
  ) async {
    final goals = await goalService.loadGoals();
    final summary = await insightsService.buildSummary(goals);
    final recommendation =
        summary.recommendations.isEmpty
            ? const TrainingRecommendation(
              title: 'Easy aerobic session',
              body:
                  'Keep the next workout comfortable and use it to collect clean baseline data.',
              priority: 'normal',
            )
            : summary.recommendations.first;
    final intensity =
        summary.readinessScore < 55
            ? 'recovery'
            : summary.trainingLoad.tsb < -15
            ? 'easy'
            : 'moderate';
    return {
      'readiness_score': summary.readinessScore,
      'training_load': {
        'atl': summary.trainingLoad.atl,
        'ctl': summary.trainingLoad.ctl,
        'tsb': summary.trainingLoad.tsb,
        'label': summary.trainingLoad.label,
        'confidence': summary.trainingLoad.confidence,
      },
      'suggestion': {
        'title': recommendation.title,
        'body': recommendation.body,
        'priority': recommendation.priority,
        'intensity': intensity,
      },
      'guardrails': [
        'Adjust down if sleep debt is high or wearable data is missing.',
        'This is wellness coaching, not medical advice.',
      ],
    };
  }

  Future<Map<String, dynamic>> _getVo2MaxTrend(
    Map<String, dynamic> input,
  ) async {
    final summary =
        await Vo2MaxService(
          db: db,
          fitnessProfileService: fitnessProfileService,
        ).estimate();
    return {
      'available': summary.available,
      'status': summary.status,
      'sensor_status': summary.sensorStatus,
      'latest':
          summary.latest == null
              ? null
              : {
                'session_local_id': summary.latest!.sessionLocalId,
                'date': summary.latest!.date.toIso8601String(),
                'sport': summary.latest!.sportName,
                'estimate': summary.latest!.estimate,
                'avg_heart_rate': summary.latest!.avgHeartRate,
                'pace_seconds_per_km': summary.latest!.paceSecondsPerKm,
                'confidence': summary.latest!.confidence,
              },
      'trend_delta': summary.trendDelta,
      'sample_count': summary.samples.length,
      'sensor_policy':
          'If HR overlap or max HR profile is missing, VO2 trend must stay unavailable instead of inferred.',
    };
  }

  Future<Map<String, dynamic>> _getTrainingPlanStatus(
    Map<String, dynamic> input,
  ) async {
    final goals = await goalService.loadGoals();
    final snapshot = await trainingPlanService.loadActiveSnapshot();
    final plan = snapshot.plan;
    return {
      'configured': plan != null,
      'status': plan?.status ?? 'template_plan_not_created_yet',
      if (plan != null)
        'plan': {
          'local_id': plan.localId,
          'title': plan.title,
          'plan_key': plan.planKey,
          'sport_key': plan.sportKey,
          'level': plan.level,
          'start_date': plan.startDate.toIso8601String(),
          'weeks': plan.weeks,
        },
      'today': snapshot.today.map(_trainingWorkoutSummary).toList(),
      'next_seven_days':
          snapshot.nextSevenDays.map(_trainingWorkoutSummary).toList(),
      'available_now': const [
        'weekly_goals',
        'readiness',
        'training_load',
        'suggest_next_workout',
      ],
      'goal_baseline': {
        'daily_steps': goals.dailySteps,
        'weekly_active_days': goals.weeklyActiveDays,
        'weekly_active_minutes': goals.weeklyActiveMinutes,
        'weekly_distance_km': goals.weeklyDistanceKm,
      },
      'sensor_policy':
          'Training plans do not require a specific smartwatch. HR, GPS, cadence, HRV, SpO2, and stress are optional context; missing sensors should be reported as unavailable, not inferred.',
      'next_step':
          plan == null
              ? 'Create a training plan from Settings > Training plan.'
              : 'Follow today workout if recovery signals look acceptable.',
    };
  }

  Future<ActivitySession?> _sessionFromInput(Map<String, dynamic> input) async {
    final localId = input['session_local_id']?.toString() ?? '';
    if (localId.trim().isNotEmpty) return db.getActivitySession(localId);
    final recent = await db.activitySessionsRecent(1).get();
    return recent.isEmpty ? null : recent.first;
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
      'tags': _tagsList(session.tags),
      'privacy': {
        'route_visibility': session.routeVisibility,
        'hide_start_end_meters': session.hideStartEndMeters,
        'sync_route_detail': session.syncRouteDetail,
      },
    };
  }

  Map<String, dynamic> _cadenceSummary(CadenceAnalysis cadence) {
    return {
      'applicable': cadence.applicable,
      'available': cadence.available,
      'status': cadence.status,
      'average_steps_per_minute': cadence.averageStepsPerMinute,
      'max_steps_per_minute': cadence.maxStepsPerMinute,
      'total_steps': cadence.totalSteps,
      'sample_count': cadence.samples.length,
      'sources': cadence.sources,
      'sensor_policy':
          'Cadence is reported only when overlapping step data exists for step-based sports. Missing cadence remains unavailable and must not be inferred.',
    };
  }

  List<String> _tagsList(String raw) {
    return raw
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> _personalRecordSummary(PersonalRecord record) {
    return {
      'sport_key': record.sportKey,
      'record_key': record.recordKey,
      'label': record.label,
      'metric': record.metric,
      'value': record.value,
      'unit': record.unit,
      'session_local_id': record.sessionLocalId,
      'achieved_at': record.achievedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _trainingWorkoutSummary(TrainingPlanWorkout workout) {
    return {
      'local_id': workout.localId,
      'week': workout.weekIndex,
      'day': workout.dayIndex,
      'scheduled_date': workout.scheduledDate.toIso8601String(),
      'title': workout.title,
      'type': workout.workoutType,
      'duration_minutes': workout.targetDurationMinutes,
      'distance_meters': workout.targetDistanceMeters,
      'intensity': workout.intensity,
      'status': workout.status,
      'notes': workout.notes,
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
