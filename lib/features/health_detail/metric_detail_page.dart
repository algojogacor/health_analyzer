import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';

enum MetricAggregation { average, total }

class MetricDetailSpec {
  final String key;
  final String title;
  final Set<String> dataTypes;
  final String unitLabel;
  final IconData icon;
  final Color color;
  final MetricAggregation aggregation;

  const MetricDetailSpec({
    required this.key,
    required this.title,
    required this.dataTypes,
    required this.unitLabel,
    required this.icon,
    required this.color,
    required this.aggregation,
  });
}

final metricDetailSpecs = <String, MetricDetailSpec>{
  'steps': const MetricDetailSpec(
    key: 'steps',
    title: 'Steps',
    dataTypes: {'STEPS'},
    unitLabel: 'steps',
    icon: Icons.directions_walk,
    color: Colors.blue,
    aggregation: MetricAggregation.total,
  ),
  'calories': MetricDetailSpec(
    key: 'calories',
    title: 'Calories',
    dataTypes: const {'ACTIVE_ENERGY_BURNED', 'TOTAL_CALORIES_BURNED'},
    unitLabel: 'kcal',
    icon: Icons.local_fire_department,
    color: Colors.amber.shade700,
    aggregation: MetricAggregation.total,
  ),
  'sleep': const MetricDetailSpec(
    key: 'sleep',
    title: 'Sleep',
    dataTypes: {
      'SLEEP_ASLEEP',
      'SLEEP_DEEP',
      'SLEEP_LIGHT',
      'SLEEP_REM',
      'SLEEP_AWAKE',
      'SLEEP_SESSION',
    },
    unitLabel: 'min',
    icon: Icons.nightlight_round,
    color: Colors.deepPurple,
    aggregation: MetricAggregation.total,
  ),
  'heart_rate': const MetricDetailSpec(
    key: 'heart_rate',
    title: 'Heart rate',
    dataTypes: {'HEART_RATE', 'RESTING_HEART_RATE'},
    unitLabel: 'bpm',
    icon: Icons.favorite,
    color: Colors.red,
    aggregation: MetricAggregation.average,
  ),
  'blood_oxygen': const MetricDetailSpec(
    key: 'blood_oxygen',
    title: 'Blood oxygen',
    dataTypes: {'BLOOD_OXYGEN'},
    unitLabel: '%',
    icon: Icons.bloodtype,
    color: Colors.pink,
    aggregation: MetricAggregation.average,
  ),
  'hrv': const MetricDetailSpec(
    key: 'hrv',
    title: 'HRV',
    dataTypes: {'HEART_RATE_VARIABILITY_RMSSD'},
    unitLabel: 'ms',
    icon: Icons.monitor_heart,
    color: Colors.lightGreen,
    aggregation: MetricAggregation.average,
  ),
  'weight': const MetricDetailSpec(
    key: 'weight',
    title: 'Weight',
    dataTypes: {'WEIGHT'},
    unitLabel: 'kg',
    icon: Icons.scale,
    color: Colors.teal,
    aggregation: MetricAggregation.average,
  ),
};

MetricDetailSpec metricDetailSpecByKey(String key) {
  return metricDetailSpecs[key] ?? metricDetailSpecs['heart_rate']!;
}

class MetricDetailPage extends ConsumerWidget {
  final MetricDetailSpec spec;

  const MetricDetailPage({super.key, required this.spec});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthMetricRecordsProvider(spec.dataTypes));

    return Scaffold(
      appBar: AppBar(title: Text(spec.title)),
      body: records.when(
        data:
            (rows) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                _MetricSummaryCard(spec: spec, records: rows),
                const SizedBox(height: 16),
                if (rows.isEmpty)
                  const InfoPanel(
                    icon: Icons.info_outline,
                    title: 'No local records',
                    body:
                        'Collect Health Data first, then return here to inspect this metric.',
                  )
                else ...[
                  _MetricTrendPanel(spec: spec, records: rows),
                  const SizedBox(height: 16),
                  _MetricQualityPanel(spec: spec, records: rows),
                  const SizedBox(height: 16),
                  _RecordList(spec: spec, records: rows),
                ],
              ],
            ),
        loading:
            () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Metric data unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }
}

class _MetricSummaryCard extends StatelessWidget {
  final MetricDetailSpec spec;
  final List<HealthRecord> records;

  const _MetricSummaryCard({required this.spec, required this.records});

  @override
  Widget build(BuildContext context) {
    final values = records.map((record) => record.value).toList();
    final total = values.fold(0.0, (sum, value) => sum + value);
    final avg = values.isEmpty ? null : total / values.length;
    final min = values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
    final max = values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);
    final primary = spec.aggregation == MetricAggregation.total ? total : avg;
    final primaryLabel =
        spec.aggregation == MetricAggregation.total ? 'Total' : 'Average';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(spec.icon, color: spec.color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$primaryLabel, last 30 days',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _formatMetricValue(primary, spec),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _SummaryChip(label: 'Records', value: '${records.length}'),
                _SummaryChip(
                  label: 'Min',
                  value: _formatMetricValue(min, spec),
                ),
                _SummaryChip(
                  label: 'Max',
                  value: _formatMetricValue(max, spec),
                ),
                _SummaryChip(
                  label: 'Latest',
                  value:
                      records.isEmpty ? '--' : fmtTime(records.first.dateFrom),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _DailyMetricPoint {
  final DateTime day;
  final double? value;
  final int count;

  const _DailyMetricPoint({
    required this.day,
    required this.value,
    required this.count,
  });
}

class _MetricTrendPanel extends StatelessWidget {
  final MetricDetailSpec spec;
  final List<HealthRecord> records;

  const _MetricTrendPanel({required this.spec, required this.records});

  @override
  Widget build(BuildContext context) {
    final series = _buildDailySeries(spec, records);
    final values = series.where((point) => point.value != null).toList();
    final latest = values.isEmpty ? null : values.last.value;
    final previous = values.length < 2 ? null : values[values.length - 2].value;
    final delta = latest == null || previous == null ? null : latest - previous;
    final chartWidth = math.max(
      MediaQuery.of(context).size.width - 40,
      series.length * 30.0,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkLine
                  : AppTheme.line,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: spec.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '30-day trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _TrendBadge(delta: delta, spec: spec),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Horizontal pan is enabled for dense history. Values are daily ${spec.aggregation == MetricAggregation.total ? 'totals' : 'averages'}.',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                height: 210,
                child: CustomPaint(
                  painter: _MetricTrendPainter(
                    series: series,
                    spec: spec,
                    foreground:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkInk
                            : AppTheme.ink,
                    muted:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkMuted
                            : AppTheme.muted,
                    line:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkLine
                            : AppTheme.line,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final double? delta;
  final MetricDetailSpec spec;

  const _TrendBadge({required this.delta, required this.spec});

  @override
  Widget build(BuildContext context) {
    final value = delta == null ? '--' : _formatMetricValue(delta!.abs(), spec);
    final positive = delta != null && delta! >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (positive ? AppTheme.mint : AppTheme.amber).withValues(
          alpha: 0.14,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        delta == null ? 'No trend' : '${positive ? '+' : '-'}$value',
        style: TextStyle(
          color: positive ? AppTheme.mint : AppTheme.amber,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MetricTrendPainter extends CustomPainter {
  final List<_DailyMetricPoint> series;
  final MetricDetailSpec spec;
  final Color foreground;
  final Color muted;
  final Color line;

  const _MetricTrendPainter({
    required this.series,
    required this.spec,
    required this.foreground,
    required this.muted,
    required this.line,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;
    final chart = Rect.fromLTWH(0, 10, size.width, size.height - 42);
    final values = series.map((point) => point.value ?? 0).toList();
    final maxValue = values.fold<double>(0, math.max);
    final scaleMax = maxValue <= 0 ? 1.0 : maxValue * 1.12;
    final step = chart.width / series.length;

    final gridPaint =
        Paint()
          ..color = line
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    if (spec.aggregation == MetricAggregation.total) {
      final barPaint = Paint()..color = spec.color.withValues(alpha: 0.78);
      final emptyPaint = Paint()..color = line.withValues(alpha: 0.55);
      for (var i = 0; i < series.length; i++) {
        final value = series[i].value;
        final x = chart.left + i * step + step * 0.18;
        final barWidth = math.max(7.0, step * 0.58);
        final height = value == null ? 5.0 : chart.height * value / scaleMax;
        final rect = Rect.fromLTWH(x, chart.bottom - height, barWidth, height);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          value == null ? emptyPaint : barPaint,
        );
      }
    } else {
      final path = Path();
      var started = false;
      for (var i = 0; i < series.length; i++) {
        final value = series[i].value;
        if (value == null) continue;
        final x = chart.left + i * step + step / 2;
        final y = chart.bottom - chart.height * value / scaleMax;
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = spec.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      final pointPaint = Paint()..color = spec.color;
      for (var i = 0; i < series.length; i++) {
        final value = series[i].value;
        if (value == null) continue;
        final x = chart.left + i * step + step / 2;
        final y = chart.bottom - chart.height * value / scaleMax;
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }
    }

    final textStyle = TextStyle(
      color: muted,
      fontSize: 10,
      fontWeight: FontWeight.w700,
    );
    for (var i = 0; i < series.length; i += 6) {
      _drawLabel(
        canvas,
        '${series[i].day.day}',
        Offset(chart.left + i * step + step / 2 - 10, chart.bottom + 12),
        textStyle,
      );
    }
    _drawLabel(
      canvas,
      _formatMetricValue(scaleMax, spec),
      Offset(chart.left + 2, chart.top),
      textStyle.copyWith(color: foreground.withValues(alpha: 0.58)),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _MetricTrendPainter oldDelegate) {
    return oldDelegate.series != series || oldDelegate.spec != spec;
  }
}

class _MetricQualityPanel extends StatelessWidget {
  final MetricDetailSpec spec;
  final List<HealthRecord> records;

  const _MetricQualityPanel({required this.spec, required this.records});

  @override
  Widget build(BuildContext context) {
    final series = _buildDailySeries(spec, records);
    final daysWithData = series.where((point) => point.value != null).length;
    final sources = <String, int>{};
    final types = <String>{};
    for (final record in records) {
      final source =
          record.sourceName?.trim().isNotEmpty == true
              ? record.sourceName!.trim()
              : 'Unknown source';
      sources[source] = (sources[source] ?? 0) + 1;
      types.add(record.dataType);
    }
    final topSources =
        sources.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return InfoPanel(
      icon: Icons.fact_check_outlined,
      title: 'Data quality',
      body:
          '$daysWithData of 30 days have ${spec.title.toLowerCase()} data. '
          'Types: ${types.take(4).join(', ')}. '
          'Top source: ${topSources.isEmpty ? 'none' : '${topSources.first.key} (${topSources.first.value})'}. '
          'If your wearable does not export a sensor, this page keeps it unavailable rather than estimating it.',
    );
  }
}

class _RecordList extends StatelessWidget {
  final MetricDetailSpec spec;
  final List<HealthRecord> records;

  const _RecordList({required this.spec, required this.records});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Recent records',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('${records.length} local rows'),
          ),
          const Divider(height: 1),
          ...records.take(80).map((record) {
            return ListTile(
              title: Text(_formatMetricValue(record.value, spec)),
              subtitle: Text(
                '${record.dataType} - ${record.sourceName ?? 'Unknown source'}',
              ),
              trailing: Text(fmtTime(record.dateFrom)),
            );
          }),
        ],
      ),
    );
  }
}

String _formatMetricValue(double? value, MetricDetailSpec spec) {
  if (value == null) return '--';
  final decimals = spec.unitLabel == '%' || spec.unitLabel == 'kg' ? 1 : 0;
  return fmtNumber(value, decimals: decimals, suffix: spec.unitLabel);
}

List<_DailyMetricPoint> _buildDailySeries(
  MetricDetailSpec spec,
  List<HealthRecord> records,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 29));
  return List.generate(30, (index) {
    final day = start.add(Duration(days: index));
    final next = day.add(const Duration(days: 1));
    final rows =
        records
            .where(
              (record) =>
                  !record.dateFrom.isBefore(day) &&
                  record.dateFrom.isBefore(next),
            )
            .toList();
    if (rows.isEmpty) {
      return _DailyMetricPoint(day: day, value: null, count: 0);
    }
    final total = rows.fold<double>(0, (sum, record) => sum + record.value);
    final value =
        spec.aggregation == MetricAggregation.total
            ? total
            : total / rows.length;
    return _DailyMetricPoint(day: day, value: value, count: rows.length);
  });
}
