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
import 'route_builder_page.dart';
import 'route_library_page.dart';
import 'saved_route_detail_page.dart';
import 'sport_picker_page.dart';
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
        AnimatedSection(
          index: 0,
          child: _ActivityCommandPanel(
            selectedMode: selectedMode,
            snapshot: snapshot,
            onModeChanged: onModeChanged,
            onStart: onStart,
            onOpenRecording: onOpenRecording,
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
        const AnimatedSection(index: 3, child: _RouteToolsPanel()),
        const SizedBox(height: 16),
        const AnimatedSection(index: 4, child: _SavedRoutesList()),
        const SizedBox(height: 16),
        const AnimatedSection(index: 5, child: ActivityHistoryList()),
      ],
    );
  }
}

class _ActivityCommandPanel extends StatelessWidget {
  final SportMode selectedMode;
  final ActivityRecorderSnapshot? snapshot;
  final ValueChanged<SportMode> onModeChanged;
  final VoidCallback onStart;
  final VoidCallback onOpenRecording;

  const _ActivityCommandPanel({
    required this.selectedMode,
    required this.snapshot,
    required this.onModeChanged,
    required this.onStart,
    required this.onOpenRecording,
  });

  @override
  Widget build(BuildContext context) {
    final isRecording = snapshot?.isRecording ?? false;
    final status =
        isRecording ? snapshot?.session?.status ?? 'recording' : 'ready';
    final action = isRecording ? onOpenRecording : onStart;
    final accuracy = snapshot?.lastAccuracyMeters;
    final modeDetail =
        selectedMode.requiresGps
            ? 'Outdoor GPS route, live map, splits, and privacy review.'
            : 'Indoor session with workout summary and Health Connect context.';
    return PremiumCard(
      color: AppTheme.commandSurface(context),
      borderColor: AppTheme.commandSurface(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AccentIconBox(
                icon: Icons.radio_button_checked,
                color: AppTheme.accentDark,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activity cockpit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedMode.requiresGps
                          ? 'GPS wakes only during recording. Satellite/street map preview is available after route points arrive.'
                          : 'Indoor mode keeps route off and focuses on workout summary, privacy, and Health Connect context.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.76),
                        height: 1.36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _CommandPill(label: status),
            ],
          ),
          const SizedBox(height: 16),
          _ModeSelectorButton(
            mode: selectedMode,
            enabled: !isRecording,
            detail: modeDetail,
            onChanged: onModeChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CommandMetric(
                  label: selectedMode.requiresGps ? 'Location' : 'Sensor',
                  value:
                      selectedMode.requiresGps
                          ? accuracy == null
                              ? 'Checks on start'
                              : '+/- ${accuracy.round()} m'
                          : 'No GPS needed',
                  icon:
                      selectedMode.requiresGps
                          ? Icons.gps_fixed
                          : Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CommandMetric(
                  label: 'Privacy',
                  value: 'Private first',
                  icon: Icons.privacy_tip_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ExperienceChecklist(mode: selectedMode),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: action,
              icon: Icon(isRecording ? Icons.open_in_full : Icons.play_arrow),
              label: Text(isRecording ? 'Open recording' : 'Start activity'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelectorButton extends StatelessWidget {
  final SportMode mode;
  final bool enabled;
  final String detail;
  final ValueChanged<SportMode> onChanged;

  const _ModeSelectorButton({
    required this.mode,
    required this.enabled,
    required this.detail,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _pick(context) : null,
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                mode.requiresGps
                    ? Icons.explore_outlined
                    : Icons.fitness_center,
                color: AppTheme.accentDark,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                enabled ? 'Change' : 'Locked',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: enabled ? 0.90 : 0.50),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: enabled ? 0.90 : 0.50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final result = await Navigator.of(context).push<SportMode>(
      MaterialPageRoute(builder: (_) => SportPickerPage(selectedMode: mode)),
    );
    if (result != null) onChanged(result);
  }
}

class _ExperienceChecklist extends StatelessWidget {
  final SportMode mode;

  const _ExperienceChecklist({required this.mode});

  @override
  Widget build(BuildContext context) {
    final items = [
      mode.requiresGps ? 'GPS starts only on record' : 'Indoor mode',
      'Route private',
      'Voice cues optional',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.accentDark.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppTheme.accentDark.withValues(alpha: 0.20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: AppTheme.accentDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CommandMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CommandMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentDark, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandPill extends StatelessWidget {
  final String label;

  const _CommandPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentDark.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.accentDark.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.accentDark,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
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
    final muted = AppTheme.mutedText(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AccentIconBox(
                icon: Icons.file_upload_outlined,
                color: AppTheme.cyan,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route tools',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Import GPX, review personal heatmap, and keep route data local by default.',
                      style: TextStyle(color: muted, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ActivityHeatmapPage(),
                        ),
                      ),
                  icon: const Icon(Icons.local_fire_department_outlined),
                  label: const Text('Heatmap'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
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
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Route tools are offline-friendly. Public sharing only happens after you explicitly choose it.',
            style: TextStyle(color: muted, fontSize: 12, height: 1.3),
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
    final muted = AppTheme.mutedText(context);
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
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
