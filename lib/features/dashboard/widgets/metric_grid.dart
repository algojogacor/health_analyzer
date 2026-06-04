import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../shared/utils/formatters.dart';

class MetricGrid extends StatelessWidget {
  final HealthCoverageSummary summary;
  final DashboardMetricTrends? trends;
  final DashboardWidgetPreferences preferences;
  final ValueChanged<String>? onMetricTap;

  const MetricGrid({
    super.key,
    required this.summary,
    required this.preferences,
    this.trends,
    this.onMetricTap,
  });

  @override
  Widget build(BuildContext context) {
    final recoveryScore = _recoveryScore(summary);
    final sleepDebtHours = ((480 - summary.asleepMinutes).clamp(0, 480) / 60);
    final weeklySteps =
        trends?.steps.fold<double>(0, (total, value) => total + value) ?? 0;
    final cards = [
      MetricCard(
        metricKey: 'steps',
        title: 'Steps',
        period: 'Today',
        value: fmtNumber(summary.wearableSteps),
        detail:
            summary.phoneSteps > 0
                ? 'Phone source ${summary.phoneSteps} not merged'
                : 'Wearable source',
        icon: Icons.directions_walk,
        color: Colors.blue,
        progress: (summary.wearableSteps / 10000).clamp(0, 1).toDouble(),
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'calories',
        title: 'Calories',
        period: 'Today',
        value: fmtNumber(summary.activeCalories, suffix: 'kcal'),
        detail: '-500 kcal target',
        icon: Icons.local_fire_department,
        color: Colors.amber.shade700,
        progress: (summary.activeCalories / 500).clamp(0, 1).toDouble(),
        trendValues: trends?.calories,
      ),
      MetricCard(
        metricKey: 'sleep',
        title: 'Sleep',
        period: 'Last night',
        value: fmtMinutes(summary.asleepMinutes),
        detail: 'In bed ${fmtMinutes(summary.timeInBedMinutes)}',
        icon: Icons.nightlight_round,
        color: Colors.deepPurple,
        progress: (summary.asleepMinutes / 480).clamp(0, 1).toDouble(),
        trendValues: trends?.sleepMinutes,
      ),
      MetricCard(
        metricKey: 'heart_rate',
        title: 'Heart rate',
        period: 'Today',
        value: fmtNumber(summary.avgHeartRate, suffix: 'bpm'),
        detail: 'Min ${fmtNumber(summary.minHeartRate, suffix: 'bpm')}',
        icon: Icons.favorite,
        color: Colors.red,
      ),
      MetricCard(
        metricKey: 'blood_oxygen',
        title: 'Blood oxygen',
        period: 'Today',
        value: fmtNumber(summary.avgSpo2, decimals: 1, suffix: '%'),
        detail: 'Min ${fmtNumber(summary.minSpo2, decimals: 1, suffix: '%')}',
        icon: Icons.bloodtype,
        color: Colors.pink,
      ),
      MetricCard(
        metricKey: 'hrv',
        title: 'HRV',
        period: 'Today',
        value: fmtNumber(summary.hrvAvgMs, decimals: 1, suffix: 'ms'),
        detail: summary.hrvAvgMs == null ? 'No exported data' : 'Stress proxy',
        icon: Icons.monitor_heart,
        color: Colors.lightGreen,
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
        color: Colors.teal,
      ),
      MetricCard(
        metricKey: 'recovery',
        title: 'Recovery',
        period: 'Today',
        value: '${recoveryScore.round()}%',
        detail: summary.confidence,
        icon: Icons.favorite_border,
        color: Colors.red.shade400,
        progress: (recoveryScore / 100).clamp(0, 1).toDouble(),
      ),
      MetricCard(
        metricKey: 'training_load',
        title: 'Training load',
        period: '7 days',
        value: '${(weeklySteps / 1000).round()}k steps',
        detail: 'Lightweight load proxy',
        icon: Icons.query_stats,
        color: Colors.indigo,
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'weekly_activity',
        title: 'Weekly activity',
        period: '7 days',
        value: fmtNumber(weeklySteps.round()),
        detail: 'Activity calendar proxy',
        icon: Icons.calendar_month_outlined,
        color: Colors.cyan.shade700,
        trendValues: trends?.steps,
      ),
      MetricCard(
        metricKey: 'sleep_debt',
        title: 'Sleep debt',
        period: 'Last night',
        value: '${sleepDebtHours.toStringAsFixed(1)} h',
        detail: 'Target 8 h sleep',
        icon: Icons.bedtime_outlined,
        color: Colors.deepPurple.shade300,
        progress: (1 - (sleepDebtHours / 8)).clamp(0, 1).toDouble(),
      ),
      MetricCard(
        metricKey: 'resources',
        title: 'Resources',
        period: 'Now',
        value: '${recoveryScore.round()}%',
        detail: 'Recovery and data confidence',
        icon: Icons.energy_savings_leaf_outlined,
        color: Colors.lightGreen.shade700,
        progress: (recoveryScore / 100).clamp(0, 1).toDouble(),
      ),
      MetricCard(
        metricKey: 'activity_calendar',
        title: 'Activity dots',
        period: '7 days',
        value: '${trends?.steps.where((value) => value > 0).length ?? 0}/7',
        detail: 'Days with movement data',
        icon: Icons.apps_outage_outlined,
        color: Colors.blueGrey,
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
        childAspectRatio: 0.92,
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Icon(icon, color: color),
                ],
              ),
              const SizedBox(height: 2),
              Text(period, style: TextStyle(color: Colors.grey.shade600)),
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              if (trendValues == null)
                LinearProgressIndicator(
                  value: progress ?? 0,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(999),
                  color: color,
                  backgroundColor: Colors.grey.shade100,
                )
              else
                _MiniTrendBars(values: trendValues!, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniTrendBars extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _MiniTrendBars({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );
    return SizedBox(
      height: 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values
            .map((value) {
              final normalized =
                  maxValue <= 0 ? 0.08 : (value / maxValue).clamp(0.08, 1);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FractionallySizedBox(
                    heightFactor: normalized.toDouble(),
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            value <= 0
                                ? Colors.grey.shade200
                                : color.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
