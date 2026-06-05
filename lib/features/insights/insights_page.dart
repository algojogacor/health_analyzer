import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/training_insights_service.dart';
import '../../services/training_plan_service.dart';
import '../../services/vo2max_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/animated_section.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import '../settings/goal_settings_page.dart';
import '../settings/training_plan_page.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(trainingInsightsProvider);
    final personalRecords = ref.watch(personalRecordsProvider);
    final trainingPlan = ref.watch(activeTrainingPlanProvider);
    final vo2 = ref.watch(vo2MaxProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        insights.when(
          data:
              (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSection(
                    index: 0,
                    child: _ReadinessHero(summary: summary),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 1,
                    child: _WeeklyCalendar(days: summary.calendarDays),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 2,
                    child: _TrainingLoadPanel(load: summary.trainingLoad),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 3,
                    child: trainingPlan.when(
                      data:
                          (plan) => _TrainingPlanTodayPanel(
                            snapshot: plan,
                            onOpen:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const TrainingPlanPage(),
                                  ),
                                ),
                          ),
                      loading: () => const LinearProgressIndicator(),
                      error:
                          (error, _) => InfoPanel(
                            icon: Icons.event_note_outlined,
                            title: 'Training plan unavailable',
                            body: error.toString(),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 4,
                    child: _GoalProgressPanel(
                      goals: summary.goals,
                      onEdit:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const GoalSettingsPage(),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 5,
                    child: vo2.when(
                      data: (summary) => _Vo2MaxPanel(summary: summary),
                      loading: () => const LinearProgressIndicator(),
                      error:
                          (error, _) => InfoPanel(
                            icon: Icons.monitor_heart_outlined,
                            title: 'VO2 trend unavailable',
                            body: error.toString(),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 6,
                    child: _CoachPlanPanel(
                      recommendations: summary.recommendations,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 7,
                    child: _AchievementsPanel(
                      achievements: summary.achievements,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 8,
                    child: personalRecords.when(
                      data:
                          (records) => _PersonalRecordsPanel(records: records),
                      loading: () => const LinearProgressIndicator(),
                      error:
                          (error, _) => InfoPanel(
                            icon: Icons.error_outline,
                            title: 'Personal records unavailable',
                            body: error.toString(),
                          ),
                    ),
                  ),
                ],
              ),
          loading:
              () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
          error:
              (error, _) => InfoPanel(
                icon: Icons.error_outline,
                title: 'Insights unavailable',
                body: error.toString(),
              ),
        ),
      ],
    );
  }
}

class _TrainingLoadPanel extends StatelessWidget {
  final TrainingLoadSummary load;

  const _TrainingLoadPanel({required this.load});

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    final color = switch (load.label) {
      'Fresh' => AppTheme.mint,
      'Balanced' => AppTheme.cyan,
      'Building load' => AppTheme.amber,
      _ => AppTheme.coral,
    };
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AccentIconBox(icon: Icons.query_stats, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Training load',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${load.label} / confidence ${load.confidence}',
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _LoadStat(label: 'ATL 7d', value: load.atl)),
              const SizedBox(width: 10),
              Expanded(child: _LoadStat(label: 'CTL 42d', value: load.ctl)),
              const SizedBox(width: 10),
              Expanded(child: _LoadStat(label: 'TSB', value: load.tsb)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrainingLoadPainter(
                load.days,
                gridColor: AppTheme.border(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingPlanTodayPanel extends StatelessWidget {
  final TrainingPlanSnapshot snapshot;
  final VoidCallback onOpen;

  const _TrainingPlanTodayPanel({required this.snapshot, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    final plan = snapshot.plan;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.event_note_outlined,
                color: AppTheme.violet,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Training plan',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      plan == null ? 'No active plan' : plan.title,
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.chevron_right, size: 18),
                label: Text(plan == null ? 'Choose' : 'Open'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (plan == null)
            Text(
              'Pick a deterministic template. Missing wearable sensors stay optional, so the plan still works with phone GPS only.',
              style: TextStyle(color: muted, height: 1.35),
            )
          else if (snapshot.today.isEmpty)
            Text(
              'No scheduled workout today. Use recovery, walking, or mobility if you want easy movement.',
              style: TextStyle(color: muted, height: 1.35),
            )
          else
            ...snapshot.today.map((workout) => _PlanWorkoutTile(workout)),
        ],
      ),
    );
  }
}

class _Vo2MaxPanel extends StatelessWidget {
  final Vo2MaxSummary summary;

  const _Vo2MaxPanel({required this.summary});

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    if (!summary.available || summary.latest == null) {
      return InfoPanel(
        icon: Icons.monitor_heart_outlined,
        title: 'VO2 trend not ready',
        body:
            '${summary.status}\n\nSensor status: ${summary.sensorStatus}. Xiaomi Band 9 Active and other watches are supported when their heart-rate data reaches Health Connect.',
      );
    }
    final latest = summary.latest!;
    final trend = summary.trendDelta;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.speed_outlined,
                color: AppTheme.mint,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VO2 trend',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${latest.confidence} confidence / ${summary.sensorStatus}',
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
              Text(
                latest.estimate.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(summary.status, style: TextStyle(color: muted, height: 1.35)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LoadStat(label: 'Avg HR', value: latest.avgHeartRate),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LoadStat(
                  label: 'Pace s/km',
                  value: latest.paceSecondsPerKm,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _LoadStat(label: 'Trend', value: trend ?? 0)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanWorkoutTile extends StatelessWidget {
  final TrainingPlanWorkout workout;

  const _PlanWorkoutTile(this.workout);

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    final target =
        workout.targetDistanceMeters > 0
            ? '${(workout.targetDistanceMeters / 1000).toStringAsFixed(1)} km'
            : '${workout.targetDurationMinutes} min';
    return Row(
      children: [
        Icon(Icons.directions_run, color: _colorFor(workout.intensity)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.title,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 3),
              Text(
                '$target / ${workout.intensity}',
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _colorFor(String intensity) {
    return switch (intensity) {
      'moderate' => AppTheme.amber,
      'hard' => AppTheme.coral,
      _ => AppTheme.mint,
    };
  }
}

class _LoadStat extends StatelessWidget {
  final String label;
  final double value;

  const _LoadStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.softSurface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.mutedText(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingLoadPainter extends CustomPainter {
  final List<TrainingLoadDay> days;
  final Color gridColor;

  const _TrainingLoadPainter(this.days, {required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (days.length < 2) return;
    final maxY = days
        .expand((day) => [day.atl, day.ctl])
        .fold<double>(1, (max, value) => value > max ? value : max);
    final gridPaint =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Path pathFor(double Function(TrainingLoadDay day) valueOf) {
      Offset map(int index, TrainingLoadDay day) {
        final x = size.width * index / (days.length - 1);
        final y = size.height - (valueOf(day) / maxY).clamp(0, 1) * size.height;
        return Offset(x, y);
      }

      final path = Path()..moveTo(map(0, days.first).dx, map(0, days.first).dy);
      for (var i = 1; i < days.length; i++) {
        final point = map(i, days[i]);
        path.lineTo(point.dx, point.dy);
      }
      return path;
    }

    canvas.drawPath(
      pathFor((day) => day.ctl),
      Paint()
        ..color = AppTheme.cyan
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      pathFor((day) => day.atl),
      Paint()
        ..color = AppTheme.coral
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TrainingLoadPainter oldDelegate) {
    return oldDelegate.days != days || oldDelegate.gridColor != gridColor;
  }
}

class _PersonalRecordsPanel extends StatelessWidget {
  final List<PersonalRecord> records;

  const _PersonalRecordsPanel({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const InfoPanel(
        icon: Icons.emoji_events_outlined,
        title: 'Personal records',
        body:
            'Record or import a GPS activity to unlock fastest efforts and longest-route badges.',
      );
    }
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              AccentIconBox(icon: Icons.emoji_events, color: AppTheme.amber),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Personal records',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...records.take(8).map((record) => _RecordRow(record: record)),
        ],
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final PersonalRecord record;

  const _RecordRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: AppTheme.amber, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  record.sportKey.replaceAll('_', ' '),
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            _recordValue(record),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  String _recordValue(PersonalRecord record) {
    return switch (record.unit) {
      'seconds' => fmtDuration(record.value.round()),
      'meters' => '${(record.value / 1000).toStringAsFixed(2)} km',
      'mps' => '${(record.value * 3.6).toStringAsFixed(1)} km/h',
      _ => record.value.toStringAsFixed(1),
    };
  }
}

class _ReadinessHero extends StatelessWidget {
  final TrainingInsightSummary summary;

  const _ReadinessHero({required this.summary});

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(summary.readinessScore);
    return PremiumCard(
      color: AppTheme.ink,
      borderColor: AppTheme.ink,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Training intelligence',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      summary.readinessReason,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: summary.readinessScore / 100,
                      strokeWidth: 8,
                      color: color,
                      backgroundColor: Colors.white.withValues(alpha: 0.14),
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${summary.readinessScore}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'READY',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMiniStat(
                  label: 'Load',
                  value: fmtDuration(summary.weeklyMovingSeconds),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroMiniStat(
                  label: 'Distance',
                  value:
                      '${(summary.weeklyDistanceMeters / 1000).toStringAsFixed(1)} km',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroMiniStat(
                  label: 'Streak',
                  value: '${summary.streakDays} d',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BaselineStrip(baseline: summary.readinessBaseline),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                summary.readinessLabel,
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 82) return AppTheme.mint;
    if (score >= 64) return AppTheme.cyan;
    if (score >= 45) return AppTheme.amber;
    return AppTheme.coral;
  }
}

class _BaselineStrip extends StatelessWidget {
  final ReadinessBaseline baseline;

  const _BaselineStrip({required this.baseline});

  @override
  Widget build(BuildContext context) {
    final active = baseline.hasPersonalSignals;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              active ? Icons.sensors : Icons.sensors_off_outlined,
              color: active ? AppTheme.mint : AppTheme.amber,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                active
                    ? 'Personal baseline active: HRV ${_value(baseline.currentHrvMs, 'ms')} / RHR ${_value(baseline.currentRestingHr, 'bpm')}'
                    : 'Optional sensors not found: ${baseline.missingSensors.join(', ')}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _value(double? value, String unit) {
    if (value == null) return '--';
    return '${value.toStringAsFixed(0)} $unit';
  }
}

class _HeroMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.70),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyCalendar extends StatelessWidget {
  final List<TrainingCalendarDay> days;

  const _WeeklyCalendar({required this.days});

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxSteps = days.fold<int>(
      0,
      (max, day) => day.steps > max ? day.steps : max,
    );
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly rhythm',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                days.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  final height =
                      maxSteps == 0
                          ? 0.12
                          : (day.steps / maxSteps).clamp(0.12, 1).toDouble();
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 76,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: height,
                              child: Container(
                                width: 18,
                                decoration: BoxDecoration(
                                  color:
                                      day.hasActivity
                                          ? AppTheme.cyan
                                          : AppTheme.border(context),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels[index.clamp(0, labels.length - 1)],
                          style: TextStyle(
                            color: AppTheme.mutedText(context),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _GoalProgressPanel extends StatelessWidget {
  final List<TrainingGoalProgress> goals;
  final VoidCallback onEdit;

  const _GoalProgressPanel({required this.goals, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Goals',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...goals.map((goal) => _GoalRow(goal: goal)),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final TrainingGoalProgress goal;

  const _GoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '${goal.valueLabel} / ${goal.targetLabel}',
                style: TextStyle(
                  color: AppTheme.mutedText(context),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(height: 9, color: AppTheme.border(context)),
                FractionallySizedBox(
                  widthFactor: goal.progress.clamp(0, 1).toDouble(),
                  child: Container(height: 9, color: AppTheme.cyan),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachPlanPanel extends StatelessWidget {
  final List<TrainingRecommendation> recommendations;

  const _CoachPlanPanel({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              AccentIconBox(icon: Icons.psychology_alt, color: AppTheme.violet),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Coach plan',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map((item) => _RecommendationTile(item: item)),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  final TrainingRecommendation item;

  const _RecommendationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = switch (item.priority) {
      'high' => AppTheme.coral,
      'medium' => AppTheme.amber,
      _ => AppTheme.cyan,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: TextStyle(
                    color: AppTheme.mutedText(context),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsPanel extends StatelessWidget {
  final List<TrainingAchievement> achievements;

  const _AchievementsPanel({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.18,
            ),
            itemBuilder:
                (context, index) =>
                    _AchievementTile(achievement: achievements[index]),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final TrainingAchievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final color =
        achievement.unlocked ? AppTheme.mint : AppTheme.mutedText(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            achievement.unlocked
                ? AppTheme.mint.withValues(alpha: 0.10)
                : AppTheme.softSurface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              achievement.unlocked
                  ? AppTheme.mint.withValues(alpha: 0.28)
                  : AppTheme.border(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_iconFor(achievement.iconKey), color: color),
            const Spacer(),
            Text(
              achievement.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              achievement.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppTheme.mutedText(context),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String key) {
    return switch (key) {
      'flag' => Icons.flag,
      'calendar' => Icons.calendar_month,
      'streak' => Icons.local_fire_department,
      'route' => Icons.route,
      'steps' => Icons.directions_walk,
      'distance' => Icons.social_distance,
      _ => Icons.emoji_events,
    };
  }
}
