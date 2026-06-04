import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../services/activity_analysis_service.dart';

class ActivityCharts extends StatelessWidget {
  final List<ActivityChartSample> samples;

  const ActivityCharts({super.key, required this.samples});

  @override
  Widget build(BuildContext context) {
    final speed = samples
        .where((sample) => sample.speedMps != null && sample.speedMps! >= 0)
        .map(
          (sample) => ChartValue(sample.elapsedSeconds, sample.speedMps! * 3.6),
        )
        .toList(growable: false);
    final elevation = samples
        .where((sample) => sample.altitudeMeters != null)
        .map(
          (sample) => ChartValue(sample.elapsedSeconds, sample.altitudeMeters!),
        )
        .toList(growable: false);

    if (speed.length < 2 && elevation.length < 2) {
      return const SizedBox.shrink();
    }

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
                Icon(Icons.show_chart, color: Colors.cyan.shade700),
                const SizedBox(width: 10),
                Text(
                  'Charts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (speed.length >= 2) ...[
              const SizedBox(height: 16),
              _ChartBlock(
                title: 'Speed',
                suffix: 'km/h',
                color: Colors.teal,
                values: speed,
              ),
            ],
            if (elevation.length >= 2) ...[
              const SizedBox(height: 16),
              _ChartBlock(
                title: 'Elevation',
                suffix: 'm',
                color: Colors.blueGrey,
                values: elevation,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChartValue {
  final int x;
  final double y;

  const ChartValue(this.x, this.y);
}

class _ChartBlock extends StatelessWidget {
  final String title;
  final String suffix;
  final Color color;
  final List<ChartValue> values;

  const _ChartBlock({
    required this.title,
    required this.suffix,
    required this.color,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final minY = values.map((v) => v.y).reduce(math.min);
    final maxY = values.map((v) => v.y).reduce(math.max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const Spacer(),
            Text(
              '${minY.toStringAsFixed(0)}-${maxY.toStringAsFixed(0)} $suffix',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineChartPainter(values: values, color: color),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartValue> values;
  final Color color;

  const _LineChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minX = values.map((v) => v.x).reduce(math.min).toDouble();
    final maxX = values.map((v) => v.x).reduce(math.max).toDouble();
    final minY = values.map((v) => v.y).reduce(math.min);
    final maxY = values.map((v) => v.y).reduce(math.max);
    final xSpan = math.max(1, maxX - minX);
    final ySpan = math.max(1.0, maxY - minY);

    final gridPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Offset map(ChartValue value) {
      final x = ((value.x - minX) / xSpan) * size.width;
      final y = size.height - ((value.y - minY) / ySpan) * size.height;
      return Offset(x, y.clamp(0, size.height));
    }

    final path = Path()..moveTo(map(values.first).dx, map(values.first).dy);
    for (final value in values.skip(1)) {
      final point = map(value);
      path.lineTo(point.dx, point.dy);
    }

    final stroke =
        Paint()
          ..color = color
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}
