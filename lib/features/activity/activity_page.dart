import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/animated_section.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import 'activity_history_list.dart';
import 'activity_detail_page.dart';
import 'activity_heatmap_page.dart';
import 'activity_map_preview.dart';
import 'activity_recorder_panel.dart';
import 'route_builder_page.dart';
import 'route_library_page.dart';
import 'saved_route_detail_page.dart';
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
        const AnimatedSection(
          index: 0,
          child: InfoPanel(
            icon: Icons.gps_fixed,
            title: 'GPS behavior',
            body:
                'GPS is only used while an activity is recording. Periodic sync reads Health Connect and never keeps GPS active all day.',
          ),
        ),
        const SizedBox(height: 16),
        if (snapshot?.isRecording == true && snapshot?.session != null) ...[
          AnimatedSection(
            index: 1,
            child: ActiveActivityBanner(
              session: snapshot!.session!,
              onOpenRecording: onOpenRecording,
              onStopReview: onStopReview,
            ),
          ),
          const SizedBox(height: 16),
        ],
        AnimatedSection(
          index: 2,
          child: ActivityMapPreview(
            selectedMode: selectedMode,
            snapshot: snapshot,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSection(
          index: 3,
          child: ActivityRecorderPanel(
            selectedMode: selectedMode,
            snapshot: snapshot,
            onModeChanged: onModeChanged,
            onStart: onStart,
            onOpenRecording: onOpenRecording,
          ),
        ),
        const SizedBox(height: 16),
        const AnimatedSection(index: 4, child: _RouteToolsPanel()),
        const SizedBox(height: 16),
        const AnimatedSection(index: 5, child: _SavedRoutesList()),
        const SizedBox(height: 16),
        const AnimatedSection(index: 6, child: ActivityHistoryList()),
      ],
    );
  }
}

class _RouteToolsPanel extends ConsumerStatefulWidget {
  const _RouteToolsPanel();

  @override
  ConsumerState<_RouteToolsPanel> createState() => _RouteToolsPanelState();
}

class _RouteToolsPanelState extends ConsumerState<_RouteToolsPanel> {
  bool _importing = false;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          const AccentIconBox(
            icon: Icons.file_upload_outlined,
            color: AppTheme.cyan,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Route tools',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Import GPX, review personal heatmap, and keep route data local by default.',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ActivityHeatmapPage(),
                      ),
                    ),
                icon: const Icon(Icons.local_fire_department_outlined),
                label: const Text('Heatmap'),
              ),
              FilledButton.icon(
                onPressed: _importing ? null : _importGpx,
                icon:
                    _importing
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.upload_file),
                label: Text(_importing ? 'Importing' : 'Import'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _importGpx() async {
    setState(() => _importing = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gpx'],
        allowMultiple: false,
      );
      final path = picked?.files.single.path;
      if (path == null) return;

      final result = await ref.read(gpxServiceProvider).importFromPath(path);
      ref.invalidate(activityHistoryProvider);
      ref.invalidate(unsyncedCountProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported ${result.pointCount} GPX points')),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ActivityDetailPage(session: result.session),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('GPX import failed: $error')));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
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
          return InfoPanel(
            icon: Icons.bookmark_border,
            title: 'Saved routes',
            body: 'Save a route from activity detail to reuse it later.',
            action: FilledButton.icon(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RouteBuilderPage()),
                  ),
              icon: Icon(Icons.add_road),
              label: Text('Build route'),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Saved routes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RouteLibraryPage(),
                        ),
                      ),
                  child: const Text('Open'),
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SavedRouteDetailPage(route: route),
              ),
            ),
        child: PremiumCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const AccentIconBox(icon: Icons.route, color: AppTheme.cyan),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(route.distanceMeters / 1000).toStringAsFixed(2)} km / ${route.pointCount} pts / ${fmtTime(route.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.muted),
            ],
          ),
        ),
      ),
    );
  }
}
