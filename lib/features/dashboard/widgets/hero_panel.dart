import 'package:flutter/material.dart';

import '../../../providers/health_provider.dart';
import '../../../shared/utils/formatters.dart';

class HeroPanel extends StatelessWidget {
  final HealthCoverageSummary summary;

  const HeroPanel({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final confidenceColor = switch (summary.confidence) {
      'Good' => Colors.green,
      'Partial' => Colors.orange,
      _ => Colors.red,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 172),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withValues(alpha: 0.28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'WELCOME!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Latest wearable data ${fmtTime(summary.latestWearableDataAt)}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: confidenceColor.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${summary.confidence} coverage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
