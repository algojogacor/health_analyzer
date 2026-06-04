import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../shared/utils/formatters.dart';
import '../../../shared/widgets/info_panel.dart';

class QualityPanel extends StatelessWidget {
  final HealthCoverageSummary summary;

  const QualityPanel({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final latestLog = summary.latestLog;
    final missing =
        summary.missingSignals.isEmpty
            ? 'No critical missing signal'
            : summary.missingSignals.join(', ');
    final notes =
        summary.qualityNotes.isEmpty
            ? 'No obvious data quality issue detected.'
            : summary.qualityNotes.join(' ');

    return InfoPanel(
      icon: Icons.verified_user,
      title: 'Coverage quality: ${summary.confidence}',
      body:
          'Records today: ${summary.recordCount}\n'
          'Latest record: ${fmtTime(summary.latestRecordAt)}\n'
          'Latest job: ${latestLog == null ? '--' : '${latestLog.operation} ${latestLog.status} at ${fmtTime(latestLog.finishedAt ?? latestLog.startedAt)}'}\n'
          'Missing: $missing\n'
          '$notes',
    );
  }
}
