import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../shared/utils/formatters.dart';

class ActiveActivityBanner extends StatelessWidget {
  final ActivitySession session;
  final VoidCallback onOpenRecording;
  final VoidCallback onStopReview;

  const ActiveActivityBanner({
    super.key,
    required this.session,
    required this.onOpenRecording,
    required this.onStopReview,
  });

  @override
  Widget build(BuildContext context) {
    final paused = session.status == 'paused';
    final color = paused ? Colors.orange.shade800 : Colors.green.shade700;
    final statusLabel = paused ? 'Paused' : 'Recording';

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  paused ? Icons.pause : Icons.radio_button_checked,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.sportName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$statusLabel since ${fmtTime(session.startedAt)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                FilledButton.icon(
                  onPressed: onOpenRecording,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                  style: FilledButton.styleFrom(backgroundColor: color),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: onStopReview,
                  child: const Text('Stop & Review'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
