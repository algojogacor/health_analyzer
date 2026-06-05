import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/formatters.dart';
import '../../../shared/widgets/premium_card.dart';

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
    final color = paused ? AppTheme.amber : AppTheme.mint;
    final statusLabel = paused ? 'Paused' : 'Recording';

    return PremiumCard(
      color: color.withValues(alpha: 0.08),
      borderColor: color.withValues(alpha: 0.24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;
          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
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
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final openButton = FilledButton.icon(
            onPressed: onOpenRecording,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open'),
            style: FilledButton.styleFrom(backgroundColor: color),
          );
          final reviewButton = OutlinedButton(
            onPressed: onStopReview,
            child: const Text('Review'),
          );
          final actions = Row(
            mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (compact) Expanded(child: openButton) else openButton,
              const SizedBox(width: 8),
              if (compact) Expanded(child: reviewButton) else reviewButton,
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [content, const SizedBox(height: 12), actions],
            );
          }

          return Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 12),
              SizedBox(width: 220, child: actions),
            ],
          );
        },
      ),
    );
  }
}
