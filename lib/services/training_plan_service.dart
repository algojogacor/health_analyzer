import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class TrainingPlanTemplate {
  final String key;
  final String title;
  final String sportKey;
  final String level;
  final int weeks;
  final String description;

  const TrainingPlanTemplate({
    required this.key,
    required this.title,
    required this.sportKey,
    required this.level,
    required this.weeks,
    required this.description,
  });
}

class TrainingPlanSnapshot {
  final TrainingPlan? plan;
  final List<TrainingPlanWorkout> workouts;
  final List<TrainingPlanWorkout> today;
  final List<TrainingPlanWorkout> nextSevenDays;

  const TrainingPlanSnapshot({
    required this.plan,
    required this.workouts,
    required this.today,
    required this.nextSevenDays,
  });

  bool get hasPlan => plan != null;
}

class TrainingPlanService {
  final AppDatabase db;
  final _uuid = const Uuid();

  const TrainingPlanService(this.db);

  static const templates = [
    TrainingPlanTemplate(
      key: 'run_5k_beginner',
      title: '5K Beginner',
      sportKey: 'outdoor_running',
      level: 'beginner',
      weeks: 6,
      description:
          'Three easy sessions per week with gradual run/walk progression.',
    ),
    TrainingPlanTemplate(
      key: 'run_10k_base',
      title: '10K Base',
      sportKey: 'outdoor_running',
      level: 'intermediate',
      weeks: 8,
      description:
          'Build aerobic volume with one quality session and one long run.',
    ),
    TrainingPlanTemplate(
      key: 'half_marathon_builder',
      title: 'Half Marathon Builder',
      sportKey: 'outdoor_running',
      level: 'intermediate',
      weeks: 10,
      description:
          'Long-run focused plan with conservative intensity and recovery weeks.',
    ),
  ];

  Future<TrainingPlanSnapshot> loadActiveSnapshot() async {
    final plan = await db.getActiveTrainingPlan();
    if (plan == null) {
      return const TrainingPlanSnapshot(
        plan: null,
        workouts: [],
        today: [],
        nextSevenDays: [],
      );
    }
    final workouts = await db.getTrainingPlanWorkouts(plan.localId);
    final today = _dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));
    return TrainingPlanSnapshot(
      plan: plan,
      workouts: workouts,
      today: workouts
          .where(
            (workout) =>
                !workout.scheduledDate.isBefore(today) &&
                workout.scheduledDate.isBefore(tomorrow),
          )
          .toList(growable: false),
      nextSevenDays: workouts
          .where(
            (workout) =>
                !workout.scheduledDate.isBefore(today) &&
                workout.scheduledDate.isBefore(nextWeek),
          )
          .toList(growable: false),
    );
  }

  Future<TrainingPlanSnapshot> createPlan({
    required String templateKey,
    DateTime? startDate,
  }) async {
    final template = templates.firstWhere(
      (item) => item.key == templateKey,
      orElse: () => templates.first,
    );
    final now = DateTime.now();
    final planId = _uuid.v4();
    final start = _dateOnly(startDate ?? now);

    await db.transaction(() async {
      await db.deactivateActiveTrainingPlans();
      await db.upsertTrainingPlan(
        TrainingPlansCompanion.insert(
          localId: planId,
          planKey: template.key,
          title: template.title,
          sportKey: template.sportKey,
          level: template.level,
          startDate: start,
          weeks: template.weeks,
          createdAt: now,
          updatedAt: now,
        ),
      );
      for (final draft in _generateWorkouts(template, start)) {
        await db.upsertTrainingPlanWorkout(
          TrainingPlanWorkoutsCompanion.insert(
            localId: _uuid.v4(),
            planLocalId: planId,
            weekIndex: draft.weekIndex,
            dayIndex: draft.dayIndex,
            scheduledDate: draft.scheduledDate,
            title: draft.title,
            workoutType: draft.workoutType,
            targetDurationMinutes: Value(draft.targetDurationMinutes),
            targetDistanceMeters: Value(draft.targetDistanceMeters),
            intensity: Value(draft.intensity),
            notes: Value(draft.notes),
            createdAt: now,
            updatedAt: Value(now),
          ),
        );
      }
    });

    return loadActiveSnapshot();
  }

  Future<void> archiveActivePlan() async {
    await db.deactivateActiveTrainingPlans();
  }

  List<_WorkoutDraft> _generateWorkouts(
    TrainingPlanTemplate template,
    DateTime start,
  ) {
    final rows = <_WorkoutDraft>[];
    for (var week = 0; week < template.weeks; week++) {
      final baseDate = start.add(Duration(days: week * 7));
      final recoveryWeek = week > 0 && (week + 1) % 4 == 0;
      final multiplier = recoveryWeek ? 0.72 : 1 + (week * 0.10);
      final longRunKm = switch (template.key) {
        'run_5k_beginner' => 2.4 + week * 0.55,
        'run_10k_base' => 5.5 + week * 0.75,
        _ => 7.0 + week * 1.0,
      };
      rows.addAll([
        _WorkoutDraft(
          weekIndex: week + 1,
          dayIndex: 1,
          scheduledDate: baseDate,
          title: recoveryWeek ? 'Recovery easy run' : 'Easy aerobic run',
          workoutType: 'easy_run',
          targetDurationMinutes: (24 * multiplier).round().clamp(18, 55),
          targetDistanceMeters: 0,
          intensity: 'easy',
          notes:
              'Keep conversational effort. Stop early if sleep debt is high.',
        ),
        _WorkoutDraft(
          weekIndex: week + 1,
          dayIndex: 3,
          scheduledDate: baseDate.add(const Duration(days: 2)),
          title:
              template.level == 'beginner'
                  ? 'Run/walk progression'
                  : 'Steady aerobic intervals',
          workoutType:
              template.level == 'beginner' ? 'run_walk' : 'steady_intervals',
          targetDurationMinutes: (28 * multiplier).round().clamp(20, 65),
          targetDistanceMeters: 0,
          intensity: recoveryWeek ? 'easy' : 'moderate',
          notes:
              template.level == 'beginner'
                  ? 'Alternate easy jogging and walking. Smooth rhythm beats speed.'
                  : 'Stay below hard effort. You should finish controlled.',
        ),
        _WorkoutDraft(
          weekIndex: week + 1,
          dayIndex: 6,
          scheduledDate: baseDate.add(const Duration(days: 5)),
          title: recoveryWeek ? 'Short long run' : 'Long run',
          workoutType: 'long_run',
          targetDurationMinutes: 0,
          targetDistanceMeters: (longRunKm * multiplier * 1000).roundToDouble(),
          intensity: 'easy',
          notes: 'Route comfort first. Use walk breaks if needed.',
        ),
      ]);
    }
    return rows;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

class _WorkoutDraft {
  final int weekIndex;
  final int dayIndex;
  final DateTime scheduledDate;
  final String title;
  final String workoutType;
  final int targetDurationMinutes;
  final double targetDistanceMeters;
  final String intensity;
  final String notes;

  const _WorkoutDraft({
    required this.weekIndex,
    required this.dayIndex,
    required this.scheduledDate,
    required this.title,
    required this.workoutType,
    required this.targetDurationMinutes,
    required this.targetDistanceMeters,
    required this.intensity,
    required this.notes,
  });
}
