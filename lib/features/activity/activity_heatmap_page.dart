import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../providers/health_provider.dart';
import '../../services/activity_heatmap_service.dart';
import '../../services/map_tile_provider_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class ActivityHeatmapPage extends ConsumerWidget {
  const ActivityHeatmapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmap = ref.watch(activityHeatmapProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Activity heatmap')),
      body: heatmap.when(
        data:
            (summary) =>
                summary.available
                    ? _HeatmapContent(summary: summary)
                    : const Padding(
                      padding: EdgeInsets.all(20),
                      child: InfoPanel(
                        icon: Icons.local_fire_department_outlined,
                        title: 'Heatmap unavailable',
                        body:
                            'Record or import GPS activities first. Heatmap stays local on this device and does not upload raw routes.',
                      ),
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Heatmap unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }
}

class _HeatmapContent extends ConsumerStatefulWidget {
  final ActivityHeatmapSummary summary;

  const _HeatmapContent({required this.summary});

  @override
  ConsumerState<_HeatmapContent> createState() => _HeatmapContentState();
}

class _HeatmapContentState extends ConsumerState<_HeatmapContent> {
  RouteMapStyleChoice _style = RouteMapStyleChoice.street;

  @override
  Widget build(BuildContext context) {
    final settings =
        ref.watch(mapTileSettingsProvider).valueOrNull ??
        MapTileSettings.defaults;
    final source =
        _style == RouteMapStyleChoice.satellite
            ? ref.read(mapTileProviderServiceProvider).satelliteSource(settings)
            : ref.read(mapTileProviderServiceProvider).streetSource(settings);
    final bounds = widget.summary.bounds;
    final center = bounds?.center ?? const LatLng(0, 0);

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: _initialZoom(bounds),
            ),
            children: [
              TileLayer(
                urlTemplate: source.urlTemplate,
                userAgentPackageName: 'com.healthanalyzer.health_analyzer',
                maxNativeZoom: source.maxNativeZoom,
              ),
              CircleLayer(circles: _circles(context)),
              SimpleAttributionWidget(
                source: Text(
                  source.attribution,
                  style: const TextStyle(fontSize: 10),
                ),
                alignment: Alignment.bottomLeft,
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 16,
          child: _HeatmapHeader(
            summary: widget.summary,
            style: _style,
            warning: source.warning,
            onStyleChanged: (value) => setState(() => _style = value),
          ),
        ),
      ],
    );
  }

  List<CircleMarker> _circles(BuildContext context) {
    final maxCount = math.max(1, widget.summary.maxCount);
    return widget.summary.cells
        .map((cell) {
          final intensity = cell.count / maxCount;
          final radius = 24.0 + (intensity * 90.0);
          final color =
              Color.lerp(AppTheme.cyan, AppTheme.coral, intensity.clamp(0, 1))!;
          return CircleMarker(
            point: LatLng(cell.latitude, cell.longitude),
            radius: radius,
            useRadiusInMeter: true,
            color: color.withValues(alpha: 0.12 + (intensity * 0.28)),
            borderColor: color.withValues(alpha: 0.28 + (intensity * 0.48)),
            borderStrokeWidth: 1,
          );
        })
        .toList(growable: false);
  }

  double _initialZoom(LatLngBounds? bounds) {
    if (bounds == null) return 2;
    final latSpan = (bounds.north - bounds.south).abs();
    final lonSpan = (bounds.east - bounds.west).abs();
    final span = math.max(latSpan, lonSpan);
    if (span < 0.01) return 14;
    if (span < 0.05) return 12;
    if (span < 0.2) return 10;
    return 8;
  }
}

enum RouteMapStyleChoice { street, satellite }

class _HeatmapHeader extends StatelessWidget {
  final ActivityHeatmapSummary summary;
  final RouteMapStyleChoice style;
  final String? warning;
  final ValueChanged<RouteMapStyleChoice> onStyleChanged;

  const _HeatmapHeader({
    required this.summary,
    required this.style,
    required this.warning,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final muted = dark ? AppTheme.darkMuted : AppTheme.muted;
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.local_fire_department,
                color: AppTheme.coral,
                size: 34,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal heatmap',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${summary.activityCount} activities / ${summary.pointCount} route points / ${summary.cells.length} cells',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (warning != null) ...[
            const SizedBox(height: 8),
            Text(
              warning!,
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 12),
          SegmentedButton<RouteMapStyleChoice>(
            showSelectedIcon: false,
            selected: {style},
            segments: const [
              ButtonSegment(
                value: RouteMapStyleChoice.street,
                icon: Icon(Icons.map_outlined),
                label: Text('Street'),
              ),
              ButtonSegment(
                value: RouteMapStyleChoice.satellite,
                icon: Icon(Icons.satellite_alt_outlined),
                label: Text('Satellite'),
              ),
            ],
            onSelectionChanged: (value) => onStyleChanged(value.first),
          ),
          const SizedBox(height: 8),
          const Text(
            'Local only. Raw route points are not uploaded by this view.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
