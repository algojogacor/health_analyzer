import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/training_plan_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class TrainingPlanPage extends ConsumerStatefulWidget {
  const TrainingPlanPage({super.key});

  @override
  ConsumerState<TrainingPlanPage> createState() => _TrainingPlanPageState();
}

class _TrainingPlanPageState extends ConsumerState<TrainingPlanPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(activeTrainingPlanProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Training plan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          snapshot.when(
            data:
                (value) => _CurrentPlanPanel(
                  snapshot: value,
                  busy: _busy,
                  onArchive: _archivePlan,
                ),
            loading: () => const LinearProgressIndicator(),
            error:
                (error, _) => InfoPanel(
                  icon: Icons.error_outline,
                  title: 'Training plan unavailable',
                  body: error.toString(),
                ),
          ),
          const SizedBox(height: 16),
          const _CompatibilityPanel(),
          const SizedBox(height: 16),
          Text(
            'Templates',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...TrainingPlanService.templates.map(
            (template) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TemplateCard(
                template: template,
                busy: _busy,
                onStart: () => _startPlan(template),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startPlan(TrainingPlanTemplate template) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(trainingPlanServiceProvider)
          .createPlan(templateKey: template.key);
      ref.invalidate(activeTrainingPlanProvider);
      ref.invalidate(trainingInsightsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${template.title} started')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan failed: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _archivePlan() async {
    setState(() => _busy = true);
    try {
      await ref.read(trainingPlanServiceProvider).archiveActivePlan();
      ref.invalidate(activeTrainingPlanProvider);
      ref.invalidate(trainingInsightsProvider);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _CurrentPlanPanel extends StatelessWidget {
  final TrainingPlanSnapshot snapshot;
  final bool busy;
  final Future<void> Function() onArchive;

  const _CurrentPlanPanel({
    required this.snapshot,
    required this.busy,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final plan = snapshot.plan;
    if (plan == null) {
      return const InfoPanel(
        icon: Icons.event_note_outlined,
        title: 'No active plan',
        body:
            'Choose a template below. Plans are local, deterministic, and can be adjusted later by AI once cloud mode is configured.',
      );
    }
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(icon: Icons.flag, color: AppTheme.violet),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${plan.level} / ${plan.weeks} weeks / starts ${fmtTime(plan.startDate)}',
                      style: const TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: busy ? null : onArchive,
                child: const Text('Archive'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (snapshot.today.isEmpty)
            const Text(
              'No planned workout today.',
              style: TextStyle(color: AppTheme.muted),
            )
          else
            ...snapshot.today.map((workout) => _WorkoutRow(workout: workout)),
          const SizedBox(height: 14),
          const Text(
            'Next 7 days',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          ...snapshot.nextSevenDays
              .take(6)
              .map((workout) => _WorkoutRow(workout: workout)),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TrainingPlanTemplate template;
  final bool busy;
  final VoidCallback onStart;

  const _TemplateCard({
    required this.template,
    required this.busy,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccentIconBox(icon: Icons.directions_run, color: AppTheme.cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${template.level} / ${template.weeks} weeks',
                  style: const TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 8),
                Text(template.description),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: busy ? null : onStart,
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  final TrainingPlanWorkout workout;

  const _WorkoutRow({required this.workout});

  @override
  Widget build(BuildContext context) {
    final target =
        workout.targetDistanceMeters > 0
            ? '${(workout.targetDistanceMeters / 1000).toStringAsFixed(1)} km'
            : '${workout.targetDurationMinutes} min';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: _colorFor(workout.intensity).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.event,
                color: _colorFor(workout.intensity),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_dateLabel(workout.scheduledDate)} / $target / ${workout.intensity}',
                  style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(String intensity) {
    return switch (intensity) {
      'moderate' => AppTheme.amber,
      'hard' => AppTheme.coral,
      _ => AppTheme.mint,
    };
  }

  String _dateLabel(DateTime date) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(date.weekday - 1).clamp(0, names.length - 1)];
  }
}

class _CompatibilityPanel extends StatelessWidget {
  const _CompatibilityPanel();

  @override
  Widget build(BuildContext context) {
    return const InfoPanel(
      icon: Icons.watch_outlined,
      title: 'Smartwatch compatibility',
      body:
          'Plans work with Xiaomi Smart Band 9 Active, phone GPS, or any Health Connect source. Missing HR, HRV, SpO2, stress, cadence, or GPS data is treated as unavailable instead of inferred.',
    );
  }
}
