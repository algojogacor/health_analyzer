import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/premium_card.dart';
import 'activity_detail_page.dart';

class ActivityHistoryList extends ConsumerWidget {
  const ActivityHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(activityHistoryProvider);

    return history.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return PremiumCard(
            child: Row(
              children: [
                const AccentIconBox(
                  icon: Icons.route_outlined,
                  color: AppTheme.cyan,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No saved activities yet. Start one outdoor or indoor session to build your training log.',
                    style: TextStyle(
                      color: AppTheme.mutedText(context),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return PremiumCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Row(
                  children: [
                    const AccentIconBox(
                      icon: Icons.history,
                      color: AppTheme.violet,
                      size: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Activity history',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Saved local workout summaries',
                            style: TextStyle(
                              color: AppTheme.mutedText(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...sessions.map((session) => _ActivityHistoryTile(session)),
            ],
          ),
        );
      },
      loading:
          () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, _) =>
              PremiumCard(child: Text('Activity history unavailable: $error')),
    );
  }
}

class _ActivityHistoryTile extends StatelessWidget {
  final ActivitySession session;

  const _ActivityHistoryTile(this.session);

  @override
  Widget build(BuildContext context) {
    final distanceKm = session.distanceMeters / 1000;
    final muted = AppTheme.mutedText(context);
    final title = session.title ?? session.sportName;
    final duration = fmtDuration(
      session.movingSeconds > 0
          ? session.movingSeconds
          : session.elapsedSeconds,
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityDetailPage(session: session),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            AccentIconBox(
              icon: session.requiresGps ? Icons.map : Icons.fitness_center,
              color:
                  session.status == 'completed'
                      ? AppTheme.cyan
                      : AppTheme.amber,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.sportName} / ${fmtTime(session.startedAt)} / $duration',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${distanceKm.toStringAsFixed(2)} km',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
