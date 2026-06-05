import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../services/moving_time_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/premium_card.dart';
import 'widgets/route_map.dart';

class ActivityMapPreview extends ConsumerStatefulWidget {
  final SportMode selectedMode;
  final ActivityRecorderSnapshot? snapshot;

  const ActivityMapPreview({
    super.key,
    required this.selectedMode,
    required this.snapshot,
  });

  @override
  ConsumerState<ActivityMapPreview> createState() => _ActivityMapPreviewState();
}

class _ActivityMapPreviewState extends ConsumerState<ActivityMapPreview> {
  RouteMapStyle _style = RouteMapStyle.street;

  @override
  Widget build(BuildContext context) {
    final session = widget.snapshot?.session;
    final usesGps = session?.requiresGps ?? widget.selectedMode.requiresGps;
    final isRecording = widget.snapshot?.isRecording ?? false;
    final points = widget.snapshot?.routePoints ?? const <TrackPoint>[];
    final hasPoints = points.isNotEmpty;
    final targetRoute = ref.watch(routeTargetProvider).valueOrNull;
    final targetGeometry =
        targetRoute == null
            ? null
            : ref.read(savedRouteServiceProvider).geometryFor(targetRoute);
    final targetPoints =
        targetGeometry?.points
            .map(
              (point) => RouteMapPoint(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
            )
            .toList(growable: false) ??
        const <RouteMapPoint>[];
    final accuracy = widget.snapshot?.lastAccuracyMeters;
    final qualityLabel =
        isRecording
            ? widget.snapshot?.locationQualityLabel ?? 'Searching'
            : 'Idle';

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.explore,
                color: AppTheme.cyan,
                size: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Live map preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _LocationBadge(label: qualityLabel, accuracy: accuracy),
            ],
          ),
          const SizedBox(height: 12),
          if (usesGps) ...[
            SegmentedButton<RouteMapStyle>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: RouteMapStyle.street,
                  icon: Icon(Icons.map_outlined),
                  label: Text('Street'),
                ),
                ButtonSegment(
                  value: RouteMapStyle.satellite,
                  icon: Icon(Icons.satellite_alt_outlined),
                  label: Text('Satellite'),
                ),
              ],
              selected: {_style},
              onSelectionChanged: (selection) {
                setState(() {
                  _style = selection.first;
                });
              },
            ),
            const SizedBox(height: 12),
          ],
          if (!usesGps)
            const _InlineNotice(
              icon: Icons.location_off_outlined,
              title: 'No GPS route for this mode',
              body:
                  'Indoor and strength-style modes save workout summary only. Pick an outdoor mode to record a route map.',
            )
          else if (!hasPoints &&
              targetRoute != null &&
              targetPoints.length >= 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RouteMap(
                  points: targetPoints,
                  style: _style,
                  height: 220,
                  interactive: false,
                  emptyLabel: 'Target route preview unavailable.',
                ),
                const SizedBox(height: 8),
                Text(
                  'Target route: ${targetRoute.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            )
          else if (!hasPoints)
            _InlineNotice(
              icon:
                  isRecording ? Icons.gps_not_fixed : Icons.gps_fixed_outlined,
              title:
                  isRecording
                      ? 'Waiting for GPS point'
                      : 'GPS ready when you start',
              body:
                  isRecording
                      ? 'Keep location enabled and wait until this preview shows your position.'
                      : 'Location is not active on this screen. Start an outdoor activity to open the recording map and acquire GPS.',
            )
          else
            RouteMap(
              points: points
                  .map(
                    (point) => RouteMapPoint(
                      latitude: point.latitude,
                      longitude: point.longitude,
                      accuracyMeters: point.accuracyMeters,
                    ),
                  )
                  .toList(growable: false),
              style: _style,
              height: 220,
              interactive: false,
              showAccuracy: true,
              emptyLabel: 'Waiting for GPS route.',
            ),
          if (usesGps) ...[
            const SizedBox(height: 10),
            Text(
              !isRecording
                  ? 'Location accuracy: idle until recording starts'
                  : accuracy == null
                  ? 'Location accuracy: searching'
                  : 'Location accuracy: +/- ${accuracy.round()} m',
              style: const TextStyle(
                color: AppTheme.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InlineNotice({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(color: AppTheme.muted, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationBadge extends StatelessWidget {
  final String label;
  final double? accuracy;

  const _LocationBadge({required this.label, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(label);
    final display =
        accuracy == null ? label : '$label +/- ${accuracy!.round()}m';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        display,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _colorFor(String label) {
    switch (label) {
      case 'Exact':
        return AppTheme.mint;
      case 'Good':
        return AppTheme.cyan;
      case 'Weak':
        return AppTheme.amber;
      case 'Idle':
        return AppTheme.muted;
      default:
        return AppTheme.muted;
    }
  }
}
