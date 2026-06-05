import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/map_tile_provider_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import 'saved_route_detail_page.dart';

class RouteBuilderPage extends ConsumerStatefulWidget {
  const RouteBuilderPage({super.key});

  @override
  ConsumerState<RouteBuilderPage> createState() => _RouteBuilderPageState();
}

class _RouteBuilderPageState extends ConsumerState<RouteBuilderPage> {
  final _mapController = MapController();
  final _nameController = TextEditingController();
  final _points = <LatLng>[];
  late SportMode _mode;
  bool _busy = false;
  String? _warning;
  double _distanceMeters = 0;

  @override
  void initState() {
    super.initState();
    _mode = sportModes.firstWhere(
      (mode) => mode.key == 'outdoor_running',
      orElse: () => sportModes.firstWhere((mode) => mode.requiresGps),
    );
    _nameController.text = 'Planned ${_mode.name}';
  }

  @override
  void dispose() {
    _mapController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpsModes = sportModes
        .where((mode) => mode.requiresGps)
        .toList(growable: false);
    final mapSettings =
        ref.watch(mapTileSettingsProvider).valueOrNull ??
        MapTileSettings.defaults;
    final tileSource = ref
        .read(mapTileProviderServiceProvider)
        .streetSource(mapSettings);
    final notice = _warning ?? tileSource.warning;
    return Scaffold(
      appBar: AppBar(title: const Text('Build route')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(0, 0),
              initialZoom: 2,
              onTap: (_, point) => _addPoint(point),
            ),
            children: [
              TileLayer(
                urlTemplate: tileSource.urlTemplate,
                userAgentPackageName: 'com.healthanalyzer.health_analyzer',
                maxNativeZoom: tileSource.maxNativeZoom,
              ),
              if (_points.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _points,
                      color: AppTheme.cyan,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              MarkerLayer(markers: _markers()),
              SimpleAttributionWidget(
                source: Text(
                  tileSource.attribution,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 14,
            child: PremiumCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const AccentIconBox(
                        icon: Icons.add_road,
                        color: AppTheme.cyan,
                        size: 34,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Route name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _mode.key,
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Sport',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              gpsModes
                                  .map(
                                    (mode) => DropdownMenuItem(
                                      value: mode.key,
                                      child: Text(mode.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _mode = gpsModes.firstWhere(
                                (mode) => mode.key == value,
                              );
                              _nameController.text = 'Planned ${_mode.name}';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      _MetricPill(
                        label:
                            '${(_distanceMeters / 1000).toStringAsFixed(2)} km',
                        icon: Icons.straighten,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (notice != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InfoPanel(
                        icon: Icons.info_outline,
                        title: 'Route notice',
                        body: notice,
                      ),
                    ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _useCurrentLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Use my location'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy || _points.isEmpty ? null : _undoPoint,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            _busy || _points.length < 2 ? null : _snapToRoad,
                        icon: const Icon(Icons.alt_route),
                        label: const Text('Snap'),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            _busy || _points.isEmpty ? null : _clearRoute,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                      ),
                      FilledButton.icon(
                        onPressed:
                            _busy || _points.length < 2 ? null : _saveRoute,
                        icon:
                            _busy
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.bookmark_add),
                        label: Text(_busy ? 'Saving' : 'Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: _BuilderHint(),
          ),
        ],
      ),
    );
  }

  void _addPoint(LatLng point) {
    setState(() {
      _points.add(point);
      _warning = null;
      _recalculateDistance();
    });
  }

  void _undoPoint() {
    setState(() {
      if (_points.isNotEmpty) _points.removeLast();
      _recalculateDistance();
    });
  }

  void _clearRoute() {
    setState(() {
      _points.clear();
      _distanceMeters = 0;
      _warning = null;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _busy = true);
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        setState(() => _warning = 'Location service is disabled.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _warning =
              'Location permission is unavailable. You can still pan the map and tap points manually.';
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      final point = LatLng(position.latitude, position.longitude);
      _mapController.move(point, 15);
    } catch (error) {
      setState(() => _warning = 'Current location unavailable: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _snapToRoad() async {
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(routeBuilderServiceProvider)
          .snapToRoad(_points, sportKey: _mode.key);
      setState(() {
        _points
          ..clear()
          ..addAll(result.points);
        _distanceMeters = result.distanceMeters;
        _warning = result.warning;
      });
      if (_points.isNotEmpty) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(_points),
            padding: const EdgeInsets.all(48),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveRoute() async {
    setState(() => _busy = true);
    try {
      final route = await ref
          .read(savedRouteServiceProvider)
          .savePlannedRoute(
            name: _nameController.text,
            sportKey: _mode.key,
            points: _points,
          );
      ref.invalidate(savedRoutesProvider);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SavedRouteDetailPage(route: route)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save route failed: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _recalculateDistance() {
    _distanceMeters = ref
        .read(routeBuilderServiceProvider)
        .distanceMeters(_points);
  }

  List<Marker> _markers() {
    return _points
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final point = entry.value;
          final isFirst = index == 0;
          final isLast = index == _points.length - 1;
          return Marker(
            point: point,
            width: 38,
            height: 38,
            child: Icon(
              isFirst
                  ? Icons.play_circle_fill
                  : isLast
                  ? Icons.stop_circle
                  : Icons.radio_button_checked,
              color:
                  isFirst
                      ? AppTheme.mint
                      : isLast
                      ? AppTheme.coral
                      : AppTheme.cyan,
            ),
          );
        })
        .toList(growable: false);
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetricPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.softSurface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppTheme.cyan),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _BuilderHint extends StatelessWidget {
  const _BuilderHint();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Tap the map to draw. Snap uses public OSRM when available; manual route stays local if snap fails.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.mutedText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
