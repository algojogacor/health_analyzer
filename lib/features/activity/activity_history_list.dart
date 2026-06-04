import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/utils/formatters.dart';
import 'activity_detail_page.dart';

class ActivityHistoryList extends ConsumerWidget {
  const ActivityHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(activityHistoryProvider);

    return history.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No saved activities yet.'),
            ),
          );
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Activity history',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('Saved local workout summaries'),
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
          (error, _) => Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Activity history unavailable: $error'),
            ),
          ),
    );
  }
}

class _ActivityHistoryTile extends StatelessWidget {
  final ActivitySession session;

  const _ActivityHistoryTile(this.session);

  @override
  Widget build(BuildContext context) {
    final distanceKm = session.distanceMeters / 1000;
    final title = session.title ?? session.sportName;
    final duration = fmtDuration(
      session.movingSeconds > 0
          ? session.movingSeconds
          : session.elapsedSeconds,
    );

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            session.status == 'completed'
                ? Colors.teal.withValues(alpha: 0.12)
                : Colors.orange.withValues(alpha: 0.12),
        foregroundColor:
            session.status == 'completed' ? Colors.teal : Colors.orange,
        child: Icon(session.requiresGps ? Icons.map : Icons.fitness_center),
      ),
      title: Text(title),
      subtitle: Text(
        '${session.sportName} - ${fmtTime(session.startedAt)} - $duration',
      ),
      trailing: Text('${distanceKm.toStringAsFixed(2)} km'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityDetailPage(session: session),
          ),
        );
      },
    );
  }
}
