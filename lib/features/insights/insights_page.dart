import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/training_insights_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/animated_section.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(trainingInsightsProvider);

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
                    child: _GoalProgressPanel(goals: summary.goals),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 3,
                    child: _CoachPlanPanel(
                      recommendations: summary.recommendations,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 4,
                    child: _AchievementsPanel(
                      achievements: summary.achievements,
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
                                          : AppTheme.line,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels[index.clamp(0, labels.length - 1)],
                          style: const TextStyle(
                            color: AppTheme.muted,
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

  const _GoalProgressPanel({required this.goals});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goals',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
                style: const TextStyle(
                  color: AppTheme.muted,
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
                Container(height: 9, color: AppTheme.line),
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
                  style: const TextStyle(color: AppTheme.muted, height: 1.35),
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
    final color = achievement.unlocked ? AppTheme.mint : AppTheme.muted;
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            achievement.unlocked
                ? AppTheme.mint.withValues(alpha: 0.10)
                : AppTheme.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              achievement.unlocked
                  ? AppTheme.mint.withValues(alpha: 0.28)
                  : AppTheme.line,
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
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
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
