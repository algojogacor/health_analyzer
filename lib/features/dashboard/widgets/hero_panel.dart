import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/formatters.dart';
import '../../../shared/widgets/premium_card.dart';

class HeroPanel extends StatelessWidget {
  final HealthCoverageSummary summary;

  const HeroPanel({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final recovery = _recoveryScore(summary).round();
    final confidenceColor = AppTheme.accent(context);

    return PremiumCard(
      padding: EdgeInsets.zero,
      color: AppTheme.commandSurface(context),
      borderColor: AppTheme.commandSurface(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: AppTheme.accent(context).withValues(alpha: 0.18),
                  accent: AppTheme.accentHover(context).withValues(alpha: 0.16),
                ),
              ),
            ),
            Positioned(
              top: -60,
              right: -36,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentHover(
                      context,
                    ).withValues(alpha: 0.18),
                    width: 20,
                  ),
                ),
              ),
            ),
            Padding(
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
                                color: AppTheme.onCommand(context),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Latest wearable data ${fmtTime(summary.latestWearableDataAt)} / ${summary.confidence} coverage',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 15,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          '${summary.missingSignals.length} gaps',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

class _HeroPatternPainter extends CustomPainter {
  final Color color;
  final Color accent;

  const _HeroPatternPainter({required this.color, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint =
        Paint()
          ..color = color
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;
    final accentPaint =
        Paint()
          ..color = accent
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.22 + i * 0.11);
      final path =
          Path()
            ..moveTo(size.width * 0.42, y)
            ..cubicTo(
              size.width * 0.56,
              y - 18,
              size.width * 0.72,
              y + 18,
              size.width * 1.04,
              y - 6,
            );
      canvas.drawPath(path, linePaint);
    }

    final route =
        Path()
          ..moveTo(size.width * 0.08, size.height * 0.82)
          ..cubicTo(
            size.width * 0.24,
            size.height * 0.72,
            size.width * 0.34,
            size.height * 0.92,
            size.width * 0.52,
            size.height * 0.78,
          )
          ..cubicTo(
            size.width * 0.65,
            size.height * 0.68,
            size.width * 0.76,
            size.height * 0.76,
            size.width * 0.92,
            size.height * 0.62,
          );
    canvas.drawPath(route, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _HeroPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.accent != accent;
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
