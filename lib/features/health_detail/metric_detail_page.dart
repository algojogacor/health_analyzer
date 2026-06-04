import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
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
                else
                  _RecordList(spec: spec, records: rows),
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
                    '$primaryLabel, last 7 days',
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
