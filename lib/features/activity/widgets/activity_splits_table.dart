import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../services/activity_analysis_service.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/formatters.dart';

class ActivitySplitsTable extends StatelessWidget {
  final List<ActivitySplit> splits;
  final double splitDistanceMeters;

  const ActivitySplitsTable({
    super.key,
    required this.splits,
    required this.splitDistanceMeters,
  });

  @override
  Widget build(BuildContext context) {
    if (splits.isEmpty) return const SizedBox.shrink();
    final label = splitDistanceMeters >= 5000 ? '5 km' : '1 km';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.splitscreen, color: Colors.teal.shade700),
                const SizedBox(width: 10),
                Text(
                  'Splits',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(label, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 12),
            _SplitPaceAscentChart(splits: splits),
            const SizedBox(height: 14),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(44),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
              },
              children: [
                _row(context, [
                  '#',
                  'Distance',
                  'Time',
                  'Pace',
                  'Ascent',
                ], header: true),
                for (final split in splits)
                  _row(context, [
                    split.index.toString(),
                    '${(split.distanceMeters / 1000).toStringAsFixed(split.distanceMeters >= 1000 ? 1 : 2)} km',
                    fmtDuration(split.elapsedSeconds),
                    _pace(split),
                    '+${split.ascentMeters.round()} m',
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _row(
    BuildContext context,
    List<String> cells, {
    bool header = false,
  }) {
    final style =
        header
            ? TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w800,
            )
            : const TextStyle(fontWeight: FontWeight.w700);
    return TableRow(
      children: cells
          .map(
            (cell) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(cell, style: style),
            ),
          )
          .toList(growable: false),
    );
  }

  String _pace(ActivitySplit split) {
    if (split.avgSpeedMps <= 0) return '--';
    final secondsPerKm = 1000 / split.avgSpeedMps;
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds /km';
  }
}

class _SplitPaceAscentChart extends StatelessWidget {
  final List<ActivitySplit> splits;

  const _SplitPaceAscentChart({required this.splits});

  @override
  Widget build(BuildContext context) {
    final usable = splits
        .where((split) => split.avgSpeedMps > 0 && split.movingSeconds > 0)
        .toList(growable: false);
    if (usable.length < 2) {
      return const SizedBox.shrink();
    }

    final paces = usable.map((split) => 1000 / split.avgSpeedMps).toList();
    final fastest = paces.reduce(math.min);
    final slowest = paces.reduce(math.max);
    final maxAscent = math.max(
      1.0,
      usable.map((split) => split.ascentMeters).reduce(math.max),
    );
    final avgPace =
        paces.fold<double>(0, (sum, pace) => sum + pace) / paces.length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkCanvas
                : AppTheme.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkLine
                  : AppTheme.line,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Pace by split',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                Text(
                  'avg ${_paceText(avgPace)}',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Bars show pace; cyan line shows ascent. Lower pace is faster.',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(
                painter: _SplitChartPainter(
                  splits: usable,
                  fastestPaceSeconds: fastest,
                  slowestPaceSeconds: slowest,
                  maxAscentMeters: maxAscent,
                  dark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _paceText(double secondsPerKm) {
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds /km';
  }
}

class _SplitChartPainter extends CustomPainter {
  final List<ActivitySplit> splits;
  final double fastestPaceSeconds;
  final double slowestPaceSeconds;
  final double maxAscentMeters;
  final bool dark;

  const _SplitChartPainter({
    required this.splits,
    required this.fastestPaceSeconds,
    required this.slowestPaceSeconds,
    required this.maxAscentMeters,
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (splits.isEmpty) return;
    final gridPaint =
        Paint()
          ..color = (dark ? AppTheme.darkLine : AppTheme.line)
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final span = math.max(1.0, slowestPaceSeconds - fastestPaceSeconds);
    final barWidth = math.max(8.0, size.width / (splits.length * 1.7));
    final spacing = size.width / splits.length;
    final ascentPoints = <Offset>[];
    for (var index = 0; index < splits.length; index++) {
      final split = splits[index];
      final pace = 1000 / split.avgSpeedMps;
      final normalized = ((pace - fastestPaceSeconds) / span).clamp(0.0, 1.0);
      final barHeight = size.height * (0.18 + normalized * 0.72);
      final left = index * spacing + (spacing - barWidth) / 2;
      final top = size.height - barHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(5),
      );
      final paint =
          Paint()
            ..color = Color.lerp(
              AppTheme.mint,
              AppTheme.coral,
              normalized,
            )!.withValues(alpha: 0.82);
      canvas.drawRRect(rect, paint);

      final ascentNorm = (split.ascentMeters / maxAscentMeters).clamp(0.0, 1.0);
      ascentPoints.add(
        Offset(left + barWidth / 2, size.height - ascentNorm * size.height),
      );
    }

    if (ascentPoints.length >= 2) {
      final path = Path()..moveTo(ascentPoints.first.dx, ascentPoints.first.dy);
      for (final point in ascentPoints.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      final linePaint =
          Paint()
            ..color = AppTheme.cyan
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplitChartPainter oldDelegate) {
    return oldDelegate.splits != splits ||
        oldDelegate.fastestPaceSeconds != fastestPaceSeconds ||
        oldDelegate.slowestPaceSeconds != slowestPaceSeconds ||
        oldDelegate.maxAscentMeters != maxAscentMeters ||
        oldDelegate.dark != dark;
  }
}
