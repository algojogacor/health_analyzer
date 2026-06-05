import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/formatters.dart';

class HeroPanel extends StatelessWidget {
  final HealthCoverageSummary summary;

  const HeroPanel({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final recovery = _recoveryScore(summary).round();
    final confidenceColor = switch (summary.confidence) {
      'Good' => AppTheme.mint,
      'Partial' => AppTheme.amber,
      _ => AppTheme.coral,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 224),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ink.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withValues(alpha: 0.68),
              Colors.black.withValues(alpha: 0.30),
              AppTheme.cyan.withValues(alpha: 0.18),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Latest wearable data ${fmtTime(summary.latestWearableDataAt)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeroScore(score: recovery, color: confidenceColor),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _HeroStat(
                      label: 'Steps',
                      value: fmtNumber(summary.wearableSteps),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HeroStat(
                      label: 'Sleep',
                      value: fmtMinutes(summary.asleepMinutes),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HeroStat(
                      label: 'SpO2',
                      value: fmtNumber(
                        summary.avgSpo2,
                        decimals: 1,
                        suffix: '%',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: confidenceColor.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${summary.confidence} coverage',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${summary.missingSignals.length} gaps',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Good morning';
    if (hour < 16) return 'Good afternoon';
    if (hour < 20) return 'Good evening';
    return 'Rest well';
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

class _HeroScore extends StatelessWidget {
  final int score;
  final Color color;

  const _HeroScore({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      height: 74,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 7,
            color: color,
            backgroundColor: Colors.white.withValues(alpha: 0.22),
            strokeCap: StrokeCap.round,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              Text(
                'REC',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
