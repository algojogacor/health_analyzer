import '../database/database.dart';
import 'training_goal_service.dart';

class TrainingInsightSummary {
  final DateTime generatedAt;
  final int readinessScore;
  final String readinessLabel;
  final String readinessReason;
  final int activeDays;
  final int streakDays;
  final double weeklyDistanceMeters;
  final int weeklyMovingSeconds;
  final double weeklyCalories;
  final int weeklySteps;
  final int sleepDebtMinutes;
  final List<TrainingGoalProgress> goals;
  final List<TrainingAchievement> achievements;
  final List<TrainingRecommendation> recommendations;
  final List<TrainingCalendarDay> calendarDays;
  final TrainingLoadSummary trainingLoad;
  final ReadinessBaseline readinessBaseline;

  const TrainingInsightSummary({
    required this.generatedAt,
    required this.readinessScore,
    required this.readinessLabel,
    required this.readinessReason,
    required this.activeDays,
    required this.streakDays,
    required this.weeklyDistanceMeters,
    required this.weeklyMovingSeconds,
    required this.weeklyCalories,
    required this.weeklySteps,
    required this.sleepDebtMinutes,
    required this.goals,
    required this.achievements,
    required this.recommendations,
    required this.calendarDays,
    required this.trainingLoad,
    required this.readinessBaseline,
  });
}

class ReadinessBaseline {
  final String status;
  final double? currentHrvMs;
  final double? baselineHrvMs;
  final double? currentRestingHr;
  final double? baselineRestingHr;
  final List<String> missingSensors;

  const ReadinessBaseline({
    required this.status,
    required this.currentHrvMs,
    required this.baselineHrvMs,
    required this.currentRestingHr,
    required this.baselineRestingHr,
    required this.missingSensors,
  });

  bool get hasPersonalSignals =>
      currentHrvMs != null ||
      currentRestingHr != null ||
      baselineHrvMs != null ||
      baselineRestingHr != null;
}

class TrainingGoalProgress {
  final String key;
  final String label;
  final String valueLabel;
  final String targetLabel;
  final double progress;
  final String status;

  const TrainingGoalProgress({
    required this.key,
    required this.label,
    required this.valueLabel,
    required this.targetLabel,
    required this.progress,
    required this.status,
  });
}

class TrainingAchievement {
  final String title;
  final String body;
  final bool unlocked;
  final String iconKey;

  const TrainingAchievement({
    required this.title,
    required this.body,
    required this.unlocked,
    required this.iconKey,
  });
}

class TrainingRecommendation {
  final String title;
  final String body;
  final String priority;

  const TrainingRecommendation({
    required this.title,
    required this.body,
    required this.priority,
  });
}

class TrainingCalendarDay {
  final DateTime date;
  final bool hasActivity;
  final int steps;
  final int movingSeconds;
  final double distanceMeters;

  const TrainingCalendarDay({
    required this.date,
    required this.hasActivity,
    required this.steps,
    required this.movingSeconds,
    required this.distanceMeters,
  });
}

class TrainingLoadDay {
  final DateTime date;
  final double dailyLoad;
  final double atl;
  final double ctl;
  final double tsb;

  const TrainingLoadDay({
    required this.date,
    required this.dailyLoad,
    required this.atl,
    required this.ctl,
    required this.tsb,
  });
}

class TrainingLoadSummary {
  final double atl;
  final double ctl;
  final double tsb;
  final String label;
  final String confidence;
  final List<TrainingLoadDay> days;

  const TrainingLoadSummary({
    required this.atl,
    required this.ctl,
    required this.tsb,
    required this.label,
    required this.confidence,
    required this.days,
  });
}

class TrainingInsightsService {
  final AppDatabase _db;

  const TrainingInsightsService(this._db);

  Future<TrainingInsightSummary> buildSummary(TrainingGoals goalsConfig) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 6));
    final end = today.add(const Duration(days: 1));
    final records = await _db.getRecordsBetween(start, end);
    final baselineRecords = await _db.getRecordsBetween(
      today.subtract(const Duration(days: 42)),
      end,
    );
    final sessions = await _db.activitySessionsRecent(120).get();
    final weekSessions =
        sessions
            .where(
              (session) =>
                  !session.startedAt.isBefore(start) &&
                  session.startedAt.isBefore(end),
            )
            .toList();

    final calendar = _buildCalendar(start, records, weekSessions);
    final weeklySteps = calendar.fold<int>(
      0,
      (total, day) => total + day.steps,
    );
    final weeklyDistance = weekSessions.fold<double>(
      0,
      (total, session) => total + session.distanceMeters,
    );
    final weeklyMovingSeconds = weekSessions.fold<int>(
      0,
      (total, session) => total + session.movingSeconds,
    );
    final weeklyCalories = records
        .where((record) => record.dataType == 'ACTIVE_ENERGY_BURNED')
        .fold<double>(0, (total, record) => total + record.value);

    final sleepDebtMinutes = _sleepDebtMinutes(
      records,
      today,
      goalsConfig.sleepTargetMinutes,
    );
    final activeDays = calendar.where((day) => day.hasActivity).length;
    final streakDays = _streakDays(calendar);
    final baseline = _readinessBaseline(baselineRecords, today);
    final readiness = _readinessScore(
      records: records,
      activeDays: activeDays,
      sleepDebtMinutes: sleepDebtMinutes,
      weeklyMovingSeconds: weeklyMovingSeconds,
      baseline: baseline,
    );
    final label = _readinessLabel(readiness);

    final goals = _goals(
      goalsConfig: goalsConfig,
      weeklySteps: weeklySteps,
      activeDays: activeDays,
      weeklyMovingSeconds: weeklyMovingSeconds,
      weeklyDistanceMeters: weeklyDistance,
      sleepDebtMinutes: sleepDebtMinutes,
    );
    final achievements = _achievements(
      activeDays: activeDays,
      streakDays: streakDays,
      weeklyDistanceMeters: weeklyDistance,
      weeklySteps: weeklySteps,
      weeklyStepTarget: goalsConfig.weeklyStepTarget,
      sessions: sessions,
    );
    final recommendations = _recommendations(
      readiness: readiness,
      activeDays: activeDays,
      sleepDebtMinutes: sleepDebtMinutes,
      weeklyMovingSeconds: weeklyMovingSeconds,
      weeklySteps: weeklySteps,
      goalsConfig: goalsConfig,
    );
    final trainingLoad = _trainingLoad(sessions, today);

    return TrainingInsightSummary(
      generatedAt: now,
      readinessScore: readiness,
      readinessLabel: label,
      readinessReason: _readinessReason(readiness, sleepDebtMinutes),
      activeDays: activeDays,
      streakDays: streakDays,
      weeklyDistanceMeters: weeklyDistance,
      weeklyMovingSeconds: weeklyMovingSeconds,
      weeklyCalories: weeklyCalories,
      weeklySteps: weeklySteps,
      sleepDebtMinutes: sleepDebtMinutes,
      goals: goals,
      achievements: achievements,
      recommendations: recommendations,
      calendarDays: calendar,
      trainingLoad: trainingLoad,
      readinessBaseline: baseline,
    );
  }

  List<TrainingCalendarDay> _buildCalendar(
    DateTime start,
    List<HealthRecord> records,
    List<ActivitySession> sessions,
  ) {
    return List.generate(7, (index) {
      final date = start.add(Duration(days: index));
      final next = date.add(const Duration(days: 1));
      final dayRecords = records.where(
        (record) =>
            !record.dateFrom.isBefore(date) && record.dateFrom.isBefore(next),
      );
      final daySessions = sessions.where(
        (session) =>
            !session.startedAt.isBefore(date) &&
            session.startedAt.isBefore(next),
      );
      final wearableSteps = dayRecords.where((record) {
        if (record.dataType != 'STEPS') return false;
        final source = (record.sourceName ?? '').toLowerCase();
        return source.contains('xiaomi') || source.contains('wearable');
      });
      final allSteps = dayRecords.where((record) => record.dataType == 'STEPS');
      final stepsSource = wearableSteps.isEmpty ? allSteps : wearableSteps;
      final steps = stepsSource.fold<double>(
        0,
        (total, record) => total + record.value,
      );
      final movingSeconds = daySessions.fold<int>(
        0,
        (total, session) => total + session.movingSeconds,
      );
      final distance = daySessions.fold<double>(
        0,
        (total, session) => total + session.distanceMeters,
      );
      return TrainingCalendarDay(
        date: date,
        hasActivity: movingSeconds > 0 || steps >= 2500,
        steps: steps.round(),
        movingSeconds: movingSeconds,
        distanceMeters: distance,
      );
    });
  }

  int _sleepDebtMinutes(
    List<HealthRecord> records,
    DateTime today,
    int sleepTargetMinutes,
  ) {
    final yesterday = today.subtract(const Duration(days: 1));
    final sleepRows = records.where(
      (record) =>
          !record.dateFrom.isBefore(yesterday) &&
          record.dateFrom.isBefore(today.add(const Duration(days: 1))) &&
          {
            'SLEEP_ASLEEP',
            'SLEEP_DEEP',
            'SLEEP_LIGHT',
            'SLEEP_REM',
          }.contains(record.dataType),
    );
    final sleepMinutes = sleepRows.fold<double>(
      0,
      (total, record) => total + record.value,
    );
    return (sleepTargetMinutes - sleepMinutes)
        .clamp(0, sleepTargetMinutes)
        .round();
  }

  int _streakDays(List<TrainingCalendarDay> days) {
    var streak = 0;
    for (final day in days.reversed) {
      if (!day.hasActivity) break;
      streak++;
    }
    return streak;
  }

  int _readinessScore({
    required List<HealthRecord> records,
    required int activeDays,
    required int sleepDebtMinutes,
    required int weeklyMovingSeconds,
    required ReadinessBaseline baseline,
  }) {
    var score = 62;
    if (sleepDebtMinutes <= 60) score += 18;
    if (sleepDebtMinutes >= 180) score -= 18;
    if (activeDays >= 4) score += 8;
    if (weeklyMovingSeconds >= 240 * 60) score += 8;
    if (weeklyMovingSeconds > 600 * 60) score -= 10;

    final hrvRows = records.where(
      (record) => record.dataType == 'HEART_RATE_VARIABILITY_RMSSD',
    );
    if (hrvRows.isNotEmpty) score += 6;
    final heartRows = records.where(
      (record) => record.dataType == 'HEART_RATE',
    );
    if (heartRows.isNotEmpty) {
      final avg =
          heartRows.fold<double>(0, (total, record) => total + record.value) /
          heartRows.length;
      if (avg > 95) score -= 8;
      if (avg < 75) score += 5;
    }
    final currentHrv = baseline.currentHrvMs;
    final baselineHrv = baseline.baselineHrvMs;
    if (currentHrv != null && baselineHrv != null && baselineHrv > 0) {
      final ratio = currentHrv / baselineHrv;
      if (ratio < 0.85) score -= 10;
      if (ratio > 1.08) score += 6;
    }
    final currentRhr = baseline.currentRestingHr;
    final baselineRhr = baseline.baselineRestingHr;
    if (currentRhr != null && baselineRhr != null) {
      final delta = currentRhr - baselineRhr;
      if (delta >= 8) score -= 8;
      if (delta <= 2) score += 4;
    }
    return score.clamp(0, 100);
  }

  String _readinessLabel(int score) {
    if (score >= 82) return 'Ready to push';
    if (score >= 64) return 'Balanced';
    if (score >= 45) return 'Keep it light';
    return 'Recovery first';
  }

  String _readinessReason(int score, int sleepDebtMinutes) {
    if (sleepDebtMinutes >= 180) {
      return 'Sleep debt is the biggest limiter today.';
    }
    if (score >= 82) {
      return 'Your recent sleep, movement, and load look supportive.';
    }
    if (score >= 64) {
      return 'A normal training day looks reasonable.';
    }
    return 'Prefer easy movement until recovery signals improve.';
  }

  ReadinessBaseline _readinessBaseline(
    List<HealthRecord> records,
    DateTime today,
  ) {
    final currentStart = today.subtract(const Duration(days: 2));
    final baselineStart = today.subtract(const Duration(days: 42));
    final baselineEnd = today.subtract(const Duration(days: 7));

    final currentHrv = _avgValue(
      records,
      'HEART_RATE_VARIABILITY_RMSSD',
      currentStart,
      today.add(const Duration(days: 1)),
    );
    final baselineHrv = _avgValue(
      records,
      'HEART_RATE_VARIABILITY_RMSSD',
      baselineStart,
      baselineEnd,
    );
    final currentRhr = _restingHrProxy(
      records,
      currentStart,
      today.add(const Duration(days: 1)),
    );
    final baselineRhr = _restingHrProxy(records, baselineStart, baselineEnd);
    final missing = <String>[
      if (currentHrv == null && baselineHrv == null) 'hrv',
      if (currentRhr == null && baselineRhr == null) 'resting_hr',
    ];
    final status =
        missing.length == 2
            ? 'sensor_baseline_unavailable'
            : missing.isNotEmpty
            ? 'partial_personal_baseline'
            : 'personal_baseline_active';
    return ReadinessBaseline(
      status: status,
      currentHrvMs: currentHrv,
      baselineHrvMs: baselineHrv,
      currentRestingHr: currentRhr,
      baselineRestingHr: baselineRhr,
      missingSensors: missing,
    );
  }

  double? _avgValue(
    List<HealthRecord> records,
    String type,
    DateTime start,
    DateTime end,
  ) {
    final rows = records
        .where(
          (record) =>
              record.dataType == type &&
              !record.dateFrom.isBefore(start) &&
              record.dateFrom.isBefore(end),
        )
        .toList(growable: false);
    if (rows.isEmpty) return null;
    return rows.fold<double>(0, (sum, record) => sum + record.value) /
        rows.length;
  }

  double? _restingHrProxy(
    List<HealthRecord> records,
    DateTime start,
    DateTime end,
  ) {
    final rows = records
        .where(
          (record) =>
              record.dataType == 'HEART_RATE' &&
              !record.dateFrom.isBefore(start) &&
              record.dateFrom.isBefore(end),
        )
        .map((record) => record.value)
        .where((value) => value >= 35 && value <= 140)
        .toList(growable: false);
    if (rows.length < 3) return null;
    rows.sort();
    final take = (rows.length * 0.2).ceil().clamp(3, rows.length).toInt();
    return rows.take(take).fold<double>(0, (sum, value) => sum + value) / take;
  }

  List<TrainingGoalProgress> _goals({
    required TrainingGoals goalsConfig,
    required int weeklySteps,
    required int activeDays,
    required int weeklyMovingSeconds,
    required double weeklyDistanceMeters,
    required int sleepDebtMinutes,
  }) {
    final weeklyStepTarget = goalsConfig.weeklyStepTarget;
    final weeklyActiveSeconds = goalsConfig.weeklyActiveMinutes * 60;
    final weeklyDistanceTargetMeters = goalsConfig.weeklyDistanceKm * 1000;
    return [
      TrainingGoalProgress(
        key: 'weekly_steps',
        label: 'Weekly steps',
        valueLabel: _compactNumber(weeklySteps),
        targetLabel: _compactNumber(weeklyStepTarget),
        progress: (weeklySteps / weeklyStepTarget).clamp(0, 1).toDouble(),
        status: weeklySteps >= weeklyStepTarget ? 'Complete' : 'In progress',
      ),
      TrainingGoalProgress(
        key: 'active_days',
        label: 'Active days',
        valueLabel: '$activeDays',
        targetLabel: '${goalsConfig.weeklyActiveDays} days',
        progress:
            (activeDays / goalsConfig.weeklyActiveDays).clamp(0, 1).toDouble(),
        status:
            activeDays >= goalsConfig.weeklyActiveDays
                ? 'Complete'
                : 'Build streak',
      ),
      TrainingGoalProgress(
        key: 'weekly_minutes',
        label: 'Training minutes',
        valueLabel: '${(weeklyMovingSeconds / 60).round()}',
        targetLabel: '${goalsConfig.weeklyActiveMinutes} min',
        progress:
            (weeklyMovingSeconds / weeklyActiveSeconds).clamp(0, 1).toDouble(),
        status:
            weeklyMovingSeconds >= weeklyActiveSeconds
                ? 'Complete'
                : 'Add movement',
      ),
      TrainingGoalProgress(
        key: 'weekly_distance',
        label: 'Recorded distance',
        valueLabel: '${(weeklyDistanceMeters / 1000).toStringAsFixed(1)} km',
        targetLabel: '${goalsConfig.weeklyDistanceKm.toStringAsFixed(1)} km',
        progress:
            weeklyDistanceTargetMeters <= 0
                ? 1
                : (weeklyDistanceMeters / weeklyDistanceTargetMeters)
                    .clamp(0, 1)
                    .toDouble(),
        status:
            weeklyDistanceMeters >= weeklyDistanceTargetMeters
                ? 'Complete'
                : 'Keep going',
      ),
      TrainingGoalProgress(
        key: 'sleep_debt',
        label: 'Sleep debt',
        valueLabel: '${(sleepDebtMinutes / 60).toStringAsFixed(1)} h',
        targetLabel: '< 1 h / ${goalsConfig.sleepTargetLabel}',
        progress:
            (1 - (sleepDebtMinutes / goalsConfig.sleepTargetMinutes))
                .clamp(0, 1)
                .toDouble(),
        status: sleepDebtMinutes <= 60 ? 'Good' : 'Recover',
      ),
    ];
  }

  List<TrainingAchievement> _achievements({
    required int activeDays,
    required int streakDays,
    required double weeklyDistanceMeters,
    required int weeklySteps,
    required int weeklyStepTarget,
    required List<ActivitySession> sessions,
  }) {
    final longActivity = sessions.fold<double>(
      0,
      (max, session) =>
          session.distanceMeters > max ? session.distanceMeters : max,
    );
    return [
      TrainingAchievement(
        title: 'First finish',
        body: 'Save one complete activity.',
        unlocked: sessions.isNotEmpty,
        iconKey: 'flag',
      ),
      TrainingAchievement(
        title: '3-day rhythm',
        body: 'Move on three days this week.',
        unlocked: activeDays >= 3,
        iconKey: 'calendar',
      ),
      TrainingAchievement(
        title: 'Streak builder',
        body: 'Keep two active days in a row.',
        unlocked: streakDays >= 2,
        iconKey: 'streak',
      ),
      TrainingAchievement(
        title: '10K route',
        body: 'Record a route over 10 km.',
        unlocked: longActivity >= 10000,
        iconKey: 'route',
      ),
      TrainingAchievement(
        title: 'Step goal week',
        body: 'Reach ${_compactNumber(weeklyStepTarget)} wearable steps.',
        unlocked: weeklySteps >= weeklyStepTarget,
        iconKey: 'steps',
      ),
      TrainingAchievement(
        title: 'Distance week',
        body: 'Cover 20 km of recorded activities.',
        unlocked: weeklyDistanceMeters >= 20000,
        iconKey: 'distance',
      ),
    ];
  }

  List<TrainingRecommendation> _recommendations({
    required int readiness,
    required int activeDays,
    required int sleepDebtMinutes,
    required int weeklyMovingSeconds,
    required int weeklySteps,
    required TrainingGoals goalsConfig,
  }) {
    final items = <TrainingRecommendation>[];
    if (readiness < 55 || sleepDebtMinutes >= 180) {
      items.add(
        const TrainingRecommendation(
          title: 'Recovery bias',
          body:
              'Choose walking, mobility, or an easy indoor session. Keep intensity low.',
          priority: 'high',
        ),
      );
    } else {
      items.add(
        const TrainingRecommendation(
          title: 'Good day to train',
          body:
              'A moderate run, walk, or cycling session should fit the current load.',
          priority: 'high',
        ),
      );
    }
    if (weeklyMovingSeconds < goalsConfig.weeklyActiveMinutes * 60) {
      items.add(
        TrainingRecommendation(
          title: 'Close the weekly minute gap',
          body:
              'Add 20-30 minutes of easy movement to progress toward ${goalsConfig.weeklyActiveMinutes} min.',
          priority: 'medium',
        ),
      );
    }
    if (activeDays < goalsConfig.weeklyActiveDays) {
      items.add(
        const TrainingRecommendation(
          title: 'Build consistency',
          body: 'A short session today matters more than a hard session.',
          priority: 'medium',
        ),
      );
    }
    if (weeklySteps < goalsConfig.weeklyStepTarget * 0.5) {
      items.add(
        const TrainingRecommendation(
          title: 'Raise baseline activity',
          body: 'Try two short walks instead of one long push.',
          priority: 'low',
        ),
      );
    }
    return items.take(4).toList(growable: false);
  }

  TrainingLoadSummary _trainingLoad(
    List<ActivitySession> sessions,
    DateTime today,
  ) {
    final start = today.subtract(const Duration(days: 41));
    final daily = List<double>.filled(42, 0);
    for (final session in sessions) {
      final day = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      final index = day.difference(start).inDays;
      if (index < 0 || index >= daily.length) continue;
      daily[index] += _sessionLoad(session);
    }

    final days = <TrainingLoadDay>[];
    for (var i = 0; i < daily.length; i++) {
      final atlStart = (i - 6).clamp(0, i);
      final ctlStart = (i - 41).clamp(0, i);
      final atlValues = daily.sublist(atlStart, i + 1);
      final ctlValues = daily.sublist(ctlStart, i + 1);
      final atl =
          atlValues.fold<double>(0, (sum, value) => sum + value) /
          atlValues.length;
      final ctl =
          ctlValues.fold<double>(0, (sum, value) => sum + value) /
          ctlValues.length;
      days.add(
        TrainingLoadDay(
          date: start.add(Duration(days: i)),
          dailyLoad: daily[i],
          atl: atl,
          ctl: ctl,
          tsb: ctl - atl,
        ),
      );
    }

    final latest = days.last;
    final completedSessions =
        sessions.where((session) => session.status == 'completed').length;
    final confidence =
        completedSessions >= 14
            ? 'Good'
            : completedSessions >= 5
            ? 'Partial'
            : 'Limited';
    return TrainingLoadSummary(
      atl: latest.atl,
      ctl: latest.ctl,
      tsb: latest.tsb,
      label: _trainingLoadLabel(latest.tsb),
      confidence: confidence,
      days: days,
    );
  }

  double _sessionLoad(ActivitySession session) {
    final minutes = session.movingSeconds / 60;
    final distanceKm = session.distanceMeters / 1000;
    final intensity =
        session.avgSpeedMps == null
            ? 1.0
            : (session.avgSpeedMps! / 3.0).clamp(0.6, 2.0).toDouble();
    return (minutes * intensity) + (distanceKm * 3);
  }

  String _trainingLoadLabel(double tsb) {
    if (tsb >= 12) return 'Fresh';
    if (tsb >= -10) return 'Balanced';
    if (tsb >= -25) return 'Building load';
    return 'Recovery risk';
  }

  String _compactNumber(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return '$value';
  }
}
