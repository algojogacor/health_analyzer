import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../database/database.dart';
import '../../../providers/health_provider.dart';
import '../../../services/map_tile_provider_service.dart';
import '../../../services/route_crop_service.dart';
import '../../../shared/widgets/info_panel.dart';

class RouteCropPreview extends ConsumerStatefulWidget {
  final List<ActivityPoint> points;
  final double initialHiddenMeters;
  final ValueChanged<double> onHiddenMetersChanged;

  const RouteCropPreview({
    super.key,
    required this.points,
    required this.initialHiddenMeters,
    required this.onHiddenMetersChanged,
  });

  @override
  ConsumerState<RouteCropPreview> createState() => _RouteCropPreviewState();
}

class _RouteCropPreviewState extends ConsumerState<RouteCropPreview> {
  late double _hiddenMeters;

  List<CropRoutePoint> get _cropPoints => widget.points
      .map(
        (point) => CropRoutePoint(
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      )
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _hiddenMeters = widget.initialHiddenMeters;
  }

  @override
  void didUpdateWidget(covariant RouteCropPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialHiddenMeters != widget.initialHiddenMeters) {
      _hiddenMeters = widget.initialHiddenMeters;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.length < 2) {
      return const InfoPanel(
        icon: Icons.route,
        title: 'Route crop unavailable',
        body:
            'At least two GPS points are needed to preview hidden route ends.',
      );
    }

    final cropPoints = _cropPoints;
    final state = RouteCropCalculator.calculate(
      cropPoints,
      hiddenMeters: _hiddenMeters,
    );
    final original = cropPoints.map(_latLng).toList(growable: false);
    final visible = state.visiblePoints.map(_latLng).toList(growable: false);
    final center = LatLngBounds.fromPoints(original).center;
    final settings =
        ref.watch(mapTileSettingsProvider).valueOrNull ??
        MapTileSettings.defaults;
    final tileSource = ref
        .read(mapTileProviderServiceProvider)
        .streetSource(settings);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.content_cut, color: Colors.teal.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Route privacy preview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text('${state.hiddenMeters.round()} m'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Keep at least ${state.minVisibleMeters.round()} m visible.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 260,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: _initialZoom(original),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: tileSource.urlTemplate,
                      userAgentPackageName:
                          'com.healthanalyzer.health_analyzer',
                      maxNativeZoom: tileSource.maxNativeZoom,
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: original,
                          color: Colors.grey.withValues(alpha: 0.35),
                          strokeWidth: 5,
                        ),
                        Polyline(
                          points: visible,
                          color: Colors.teal,
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                    if (state.startHandle != null && state.endHandle != null)
                      DragMarkers(
                        markers: [
                          DragMarker(
                            point: _latLng(state.startHandle!),
                            size: const Size(40, 40),
                            builder:
                                (_, _, _) => const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.green,
                                  size: 34,
                                ),
                            onDragUpdate:
                                (_, latLng) => _setHidden(
                                  RouteCropCalculator.hiddenMetersFromDraggedStart(
                                    cropPoints,
                                    CropRoutePoint(
                                      latitude: latLng.latitude,
                                      longitude: latLng.longitude,
                                    ),
                                  ),
                                ),
                          ),
                          DragMarker(
                            point: _latLng(state.endHandle!),
                            size: const Size(40, 40),
                            builder:
                                (_, _, _) => const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.red,
                                  size: 34,
                                ),
                            onDragUpdate:
                                (_, latLng) => _setHidden(
                                  RouteCropCalculator.hiddenMetersFromDraggedEnd(
                                    cropPoints,
                                    CropRoutePoint(
                                      latitude: latLng.latitude,
                                      longitude: latLng.longitude,
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    SimpleAttributionWidget(
                      source: Text(
                        tileSource.attribution,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (tileSource.warning != null) ...[
              const SizedBox(height: 8),
              Text(
                tileSource.warning!,
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Slider(
              value: state.hiddenMeters.clamp(0, state.maxHiddenMeters),
              min: 0,
              max: state.maxHiddenMeters <= 0 ? 1 : state.maxHiddenMeters,
              divisions: state.maxHiddenMeters < 20 ? null : 20,
              label: '${state.hiddenMeters.round()} m',
              onChanged: _setHidden,
            ),
          ],
        ),
      ),
    );
  }

  void _setHidden(double value) {
    final next =
        RouteCropCalculator.calculate(
          _cropPoints,
          hiddenMeters: value,
        ).hiddenMeters;
    setState(() => _hiddenMeters = next);
    widget.onHiddenMetersChanged(next);
  }

  LatLng _latLng(CropRoutePoint point) =>
      LatLng(point.latitude, point.longitude);

  double _initialZoom(List<LatLng> route) {
    final bounds = LatLngBounds.fromPoints(route);
    final latSpan = (bounds.north - bounds.south).abs();
    final lonSpan = (bounds.east - bounds.west).abs();
    final span = latSpan > lonSpan ? latSpan : lonSpan;
    if (span < 0.002) return 16;
    if (span < 0.01) return 14;
    if (span < 0.05) return 12;
    return 10;
  }
}
