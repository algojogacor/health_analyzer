import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../services/training_goal_service.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/formatters.dart';
import '../../../shared/widgets/premium_card.dart';

class MetricGrid extends StatelessWidget {
  final HealthCoverageSummary summary;
  final DashboardMetricTrends? trends;
  final TrainingGoals goals;
  final DashboardWidgetPreferences preferences;
  final ValueChanged<String>? onMetricTap;

  const MetricGrid({
    super.key,
    required this.summary,
    required this.preferences,
    required this.goals,
    this.trends,
    this.onMetricTap,
  });

  @override
  Widget build(BuildContext context) {
    final recoveryScore = _recoveryScore(summary);
    final sleepDebtHours = ((480 - summary.asleepMinutes).clamp(0, 480) / 60);
    final weeklySteps =
        trends?.steps.fold<double>(0, (total, value) => total + value) ?? 0;
    final accent = AppTheme.accent(context);
    final cards = [
      MetricCard(
        metricKey: 'steps',
        title: 'Steps',
        period: 'Today',
        value: fmtNumber(summary.wearableSteps),
        detail:
            summary.wearableSteps <= 0 && summary.phoneSteps <= 0
                ? 'Wearable steps not found'
                : summary.phoneSteps > 0
                ? 'Phone source ${summary.phoneSteps} not merged'
                : 'Target ${fmtNumber(goals.dailySteps)}',
        icon: Icons.directions_walk,
        color: accent,
        progress:
            (summary.wearableSteps / goals.dailySteps).clamp(0, 1).toDouble(),
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'calories',
        title: 'Calories',
        period: 'Today',
        value: fmtNumber(summary.activeCalories, suffix: 'kcal'),
        detail: '-500 kcal target',
        icon: Icons.local_fire_department,
        color: accent,
        progress: (summary.activeCalories / 500).clamp(0, 1).toDouble(),
        trendValues: trends?.calories,
      ),
      MetricCard(
        metricKey: 'sleep',
        title: 'Sleep',
        period: 'Last night',
        value: fmtMinutes(summary.asleepMinutes),
        detail:
            summary.asleepMinutes <= 0
                ? 'Sleep sensor not found'
                : 'Target ${goals.sleepTargetLabel}',
        icon: Icons.nightlight_round,
        color: accent,
        progress:
            (summary.asleepMinutes / goals.sleepTargetMinutes)
                .clamp(0, 1)
                .toDouble(),
        trendValues: trends?.sleepMinutes,
      ),
      MetricCard(
        metricKey: 'heart_rate',
        title: 'Heart rate',
        period: 'Today',
        value: fmtNumber(summary.avgHeartRate, suffix: 'bpm'),
        detail:
            summary.avgHeartRate == null
                ? 'Heart-rate sensor not found'
                : 'Min ${fmtNumber(summary.minHeartRate, suffix: 'bpm')}',
        icon: Icons.favorite,
        color: accent,
      ),
      MetricCard(
        metricKey: 'blood_oxygen',
        title: 'Blood oxygen',
        period: 'Today',
        value: fmtNumber(summary.avgSpo2, decimals: 1, suffix: '%'),
        detail:
            summary.avgSpo2 == null
                ? 'SpO2 sensor not found'
                : 'Min ${fmtNumber(summary.minSpo2, decimals: 1, suffix: '%')}',
        icon: Icons.bloodtype,
        color: accent,
      ),
      MetricCard(
        metricKey: 'hrv',
        title: 'HRV',
        period: 'Today',
        value: fmtNumber(summary.hrvAvgMs, decimals: 1, suffix: 'ms'),
        detail:
            summary.hrvAvgMs == null
                ? 'HRV/stress export not found'
                : 'Stress proxy',
        icon: Icons.monitor_heart,
        color: accent,
      ),
      MetricCard(
        metricKey: 'weight',
        title: 'Weight',
        period: 'Latest',
        value: fmtNumber(summary.latestWeightKg, decimals: 1, suffix: 'kg'),
        detail:
            summary.latestWeightKg == null
                ? 'Manual entry not found'
                : 'Manual source',
        icon: Icons.scale,
        color: accent,
      ),
      MetricCard(
        metricKey: 'recovery',
        title: 'Recovery',
        period: 'Today',
        value: '${recoveryScore.round()}%',
        detail: summary.confidence,
        icon: Icons.favorite_border,
        color: accent,
        progress: (recoveryScore / 100).clamp(0, 1).toDouble(),
      ),
      MetricCard(
        metricKey: 'training_load',
        title: 'Training load',
        period: '7 days',
        value: '${(weeklySteps / 1000).round()}k steps',
        detail: 'Lightweight load proxy',
        icon: Icons.query_stats,
        color: accent,
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'weekly_activity',
        title: 'Weekly activity',
        period: '7 days',
        value: fmtNumber(weeklySteps.round()),
        detail: 'Target ${fmtNumber(goals.weeklyStepTarget)}',
        icon: Icons.calendar_month_outlined,
        color: accent,
        progress: (weeklySteps / goals.weeklyStepTarget).clamp(0, 1).toDouble(),
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'sleep_debt',
        title: 'Sleep debt',
        period: 'Last night',
        value: '${sleepDebtHours.toStringAsFixed(1)} h',
        detail: 'Target ${goals.sleepTargetLabel} sleep',
        icon: Icons.bedtime_outlined,
        color: accent,
        progress:
            (1 - (sleepDebtHours / (goals.sleepTargetMinutes / 60)))
                .clamp(0, 1)
                .toDouble(),
      ),
      MetricCard(
        metricKey: 'resources',
        title: 'Resources',
        period: 'Now',
        value: '${recoveryScore.round()}%',
        detail: 'Recovery and data confidence',
        icon: Icons.energy_savings_leaf_outlined,
        color: accent,
        progress: (recoveryScore / 100).clamp(0, 1).toDouble(),
      ),
      MetricCard(
        metricKey: 'activity_calendar',
        title: 'Activity dots',
        period: '7 days',
        value: '${trends?.steps.where((value) => value > 0).length ?? 0}/7',
        detail: 'Days with movement data',
        icon: Icons.apps_outage_outlined,
        color: accent,
        trendValues: trends?.steps,
      ),
    ];

    final visibleCards =
        cards.where((card) => preferences.isVisible(card.metricKey)).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleCards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 222,
      ),
      itemBuilder: (context, index) {
        final card = visibleCards[index];
        return MetricCard(
          metricKey: card.metricKey,
          title: card.title,
          period: card.period,
          value: card.value,
          detail: card.detail,
          icon: card.icon,
          color: card.color,
          progress: card.progress,
          trendValues: card.trendValues,
          onTap:
              onMetricTap == null ? null : () => onMetricTap!(card.metricKey),
        );
      },
    );
  }

  double _recoveryScore(HealthCoverageSummary summary) {
    var score = 50.0;
    if (summary.asleepMinutes >= 420) score += 20;
    if (summary.asleepMinutes > 0 && summary.asleepMinutes < 360) score -= 15;
    if (summary.hrvAvgMs != null) score += 10;
    if (summary.avgHeartRate != null && summary.avgHeartRate! < 75) score += 10;
    if (summary.missingSignals.length <= 1) score += 10;
    return score.clamp(0, 100).toDouble();
  }
}

class MetricCard extends StatelessWidget {
  final String metricKey;
  final String title;
  final String period;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
  final double? progress;
  final List<double>? trendValues;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.metricKey,
    required this.title,
    required this.period,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
    this.progress,
    this.trendValues,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      borderColor: AppTheme.border(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              AccentIconBox(icon: icon, color: color, size: 34),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            period,
            style: TextStyle(
              color: muted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 34,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.text(context),
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: muted, fontSize: 12, height: 1.25),
          ),
          const SizedBox(height: 12),
          if (trendValues == null)
            _ProgressTrack(value: progress ?? 0, color: color)
          else
            _MiniTrendBars(values: trendValues!, color: color),
        ],
      ),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  final double value;
  final Color color;

  const _ProgressTrack({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 1).toDouble();
    final muted = AppTheme.mutedText(context);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(height: 8, color: AppTheme.border(context)),
              FractionallySizedBox(
                widthFactor: clamped,
                child: Container(height: 8, color: color),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('0%', style: TextStyle(color: muted, fontSize: 11)),
            const Spacer(),
            Text(
              '${(clamped * 100).round()}%',
              style: TextStyle(
                color: muted,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniTrendBars extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _MiniTrendBars({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.mutedText(context);
    final emptyColor = AppTheme.border(context);
    final maxValue = values.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return SizedBox(
      height: 38,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final value = entry.value;
              final normalized =
                  maxValue <= 0 ? 0.08 : (value / maxValue).clamp(0.08, 1);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: normalized.toDouble(),
                            alignment: Alignment.bottomCenter,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color:
                                    value <= 0
                                        ? emptyColor
                                        : color.withValues(alpha: 0.88),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[index.clamp(0, labels.length - 1)],
                        style: TextStyle(
                          color: muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
