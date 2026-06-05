import '../database/database.dart';

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
  });
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

class TrainingInsightsService {
  final AppDatabase _db;

  const TrainingInsightsService(this._db);

  Future<TrainingInsightSummary> buildSummary() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 6));
    final end = today.add(const Duration(days: 1));
    final records = await _db.getRecordsBetween(start, end);
    final sessions = await _db.activitySessionsRecent(60).get();
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

    final sleepDebtMinutes = _sleepDebtMinutes(records, today);
    final activeDays = calendar.where((day) => day.hasActivity).length;
    final streakDays = _streakDays(calendar);
    final readiness = _readinessScore(
      records: records,
      activeDays: activeDays,
      sleepDebtMinutes: sleepDebtMinutes,
      weeklyMovingSeconds: weeklyMovingSeconds,
    );
    final label = _readinessLabel(readiness);

    final goals = _goals(
      weeklySteps: weeklySteps,
      activeDays: activeDays,
      weeklyMovingSeconds: weeklyMovingSeconds,
      sleepDebtMinutes: sleepDebtMinutes,
    );
    final achievements = _achievements(
      activeDays: activeDays,
      streakDays: streakDays,
      weeklyDistanceMeters: weeklyDistance,
      weeklySteps: weeklySteps,
      sessions: sessions,
    );
    final recommendations = _recommendations(
      readiness: readiness,
      activeDays: activeDays,
      sleepDebtMinutes: sleepDebtMinutes,
      weeklyMovingSeconds: weeklyMovingSeconds,
      weeklySteps: weeklySteps,
    );

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

  int _sleepDebtMinutes(List<HealthRecord> records, DateTime today) {
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
    return (480 - sleepMinutes).clamp(0, 480).round();
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

  List<TrainingGoalProgress> _goals({
    required int weeklySteps,
    required int activeDays,
    required int weeklyMovingSeconds,
    required int sleepDebtMinutes,
  }) {
    return [
      TrainingGoalProgress(
        key: 'weekly_steps',
        label: 'Weekly steps',
        valueLabel: _compactNumber(weeklySteps),
        targetLabel: '70k',
        progress: (weeklySteps / 70000).clamp(0, 1).toDouble(),
        status: weeklySteps >= 70000 ? 'Complete' : 'In progress',
      ),
      TrainingGoalProgress(
        key: 'active_days',
        label: 'Active days',
        valueLabel: '$activeDays',
        targetLabel: '5 days',
        progress: (activeDays / 5).clamp(0, 1).toDouble(),
        status: activeDays >= 5 ? 'Complete' : 'Build streak',
      ),
      TrainingGoalProgress(
        key: 'weekly_minutes',
        label: 'Training minutes',
        valueLabel: '${(weeklyMovingSeconds / 60).round()}',
        targetLabel: '150 min',
        progress: (weeklyMovingSeconds / (150 * 60)).clamp(0, 1).toDouble(),
        status: weeklyMovingSeconds >= 150 * 60 ? 'Complete' : 'Add movement',
      ),
      TrainingGoalProgress(
        key: 'sleep_debt',
        label: 'Sleep debt',
        valueLabel: '${(sleepDebtMinutes / 60).toStringAsFixed(1)} h',
        targetLabel: '< 1 h',
        progress: (1 - (sleepDebtMinutes / 480)).clamp(0, 1).toDouble(),
        status: sleepDebtMinutes <= 60 ? 'Good' : 'Recover',
      ),
    ];
  }

  List<TrainingAchievement> _achievements({
    required int activeDays,
    required int streakDays,
    required double weeklyDistanceMeters,
    required int weeklySteps,
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
        title: '70K week',
        body: 'Reach 70,000 wearable steps.',
        unlocked: weeklySteps >= 70000,
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
    if (weeklyMovingSeconds < 150 * 60) {
      items.add(
        const TrainingRecommendation(
          title: 'Close the weekly minute gap',
          body:
              'Add 20-30 minutes of easy movement to progress toward 150 min.',
          priority: 'medium',
        ),
      );
    }
    if (activeDays < 4) {
      items.add(
        const TrainingRecommendation(
          title: 'Build consistency',
          body: 'A short session today matters more than a hard session.',
          priority: 'medium',
        ),
      );
    }
    if (weeklySteps < 35000) {
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

  String _compactNumber(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return '$value';
  }
}
