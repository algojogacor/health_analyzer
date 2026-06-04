import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import 'activity_history_list.dart';
import 'activity_map_preview.dart';
import 'activity_recorder_panel.dart';
import 'widgets/active_activity_banner.dart';

class ActivityPage extends StatelessWidget {
  final SportMode selectedMode;
  final ActivityRecorderSnapshot? snapshot;
  final ValueChanged<SportMode> onModeChanged;
  final VoidCallback onStart;
  final VoidCallback onOpenRecording;
  final VoidCallback onStopReview;

  const ActivityPage({
    super.key,
    required this.selectedMode,
    required this.snapshot,
    required this.onModeChanged,
    required this.onStart,
    required this.onOpenRecording,
    required this.onStopReview,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const InfoPanel(
          icon: Icons.gps_fixed,
          title: 'GPS behavior',
          body:
              'GPS is only used while an activity is recording. Periodic sync reads Health Connect and never keeps GPS active all day.',
        ),
        const SizedBox(height: 16),
        if (snapshot?.isRecording == true && snapshot?.session != null) ...[
          ActiveActivityBanner(
            session: snapshot!.session!,
            onOpenRecording: onOpenRecording,
            onStopReview: onStopReview,
          ),
          const SizedBox(height: 16),
        ],
        ActivityMapPreview(selectedMode: selectedMode, snapshot: snapshot),
        const SizedBox(height: 16),
        ActivityRecorderPanel(
          selectedMode: selectedMode,
          snapshot: snapshot,
          onModeChanged: onModeChanged,
          onStart: onStart,
          onOpenRecording: onOpenRecording,
        ),
        const SizedBox(height: 16),
        const _SavedRoutesList(),
        const SizedBox(height: 16),
        const ActivityHistoryList(),
      ],
    );
  }
}

class _SavedRoutesList extends ConsumerWidget {
  const _SavedRoutesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(savedRoutesProvider);
    return routes.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const InfoPanel(
            icon: Icons.bookmark_border,
            title: 'Saved routes',
            body: 'Save a route from activity detail to reuse it later.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved routes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            ...rows.take(3).map((route) => _SavedRouteTile(route: route)),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error:
          (error, _) => InfoPanel(
            icon: Icons.error_outline,
            title: 'Saved routes unavailable',
            body: error.toString(),
          ),
    );
  }
}

class _SavedRouteTile extends StatelessWidget {
  final SavedRoute route;

  const _SavedRouteTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.route),
        title: Text(route.name),
        subtitle: Text(
          '${(route.distanceMeters / 1000).toStringAsFixed(2)} km / ${route.pointCount} pts / ${fmtTime(route.createdAt)}',
        ),
      ),
    );
  }
}
