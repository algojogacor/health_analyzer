import 'package:flutter/material.dart';

import '../../../services/activity_analysis_service.dart';
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
            Table(
              columnWidths: const {
                0: FixedColumnWidth(44),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
              },
              children: [
                _row(context, ['#', 'Distance', 'Time', 'Pace'], header: true),
                for (final split in splits)
                  _row(context, [
                    split.index.toString(),
                    '${(split.distanceMeters / 1000).toStringAsFixed(split.distanceMeters >= 1000 ? 1 : 2)} km',
                    fmtDuration(split.elapsedSeconds),
                    _pace(split),
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
