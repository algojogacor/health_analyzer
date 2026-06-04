import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../services/offline_map_service.dart';

enum RouteMapStyle { street, satellite }

class RouteMapPoint {
  final double latitude;
  final double longitude;
  final double? accuracyMeters;

  const RouteMapPoint({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
  });

  LatLng get latLng => LatLng(latitude, longitude);
}

class RouteMap extends StatefulWidget {
  final List<RouteMapPoint> points;
  final RouteMapStyle style;
  final double height;
  final bool interactive;
  final bool showAccuracy;
  final String? emptyLabel;
  final MapController? controller;
  final bool followCurrentLocation;
  final double? followZoom;
  final double borderRadius;

  const RouteMap({
    super.key,
    required this.points,
    this.style = RouteMapStyle.street,
    this.height = 260,
    this.interactive = true,
    this.showAccuracy = false,
    this.emptyLabel,
    this.controller,
    this.followCurrentLocation = false,
    this.followZoom,
    this.borderRadius = 8,
  });

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  static final _transparentTile = MemoryImage(
    Uint8List.fromList([
      137,
      80,
      78,
      71,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      13,
      73,
      72,
      68,
      82,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      8,
      6,
      0,
      0,
      0,
      31,
      21,
      196,
      137,
      0,
      0,
      0,
      10,
      73,
      68,
      65,
      84,
      120,
      156,
      99,
      0,
      1,
      0,
      0,
      5,
      0,
      1,
      13,
      10,
      45,
      180,
      0,
      0,
      0,
      0,
      73,
      69,
      78,
      68,
      174,
      66,
      96,
      130,
    ]),
  );

  late final MapController _internalController;
  bool _mapUnavailable = false;

  MapController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = MapController();
    _recenterAfterBuild();
  }

  @override
  void didUpdateWidget(covariant RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.followCurrentLocation &&
        widget.points.isNotEmpty &&
        (oldWidget.points.length != widget.points.length ||
            oldWidget.points.last.latitude != widget.points.last.latitude ||
            oldWidget.points.last.longitude != widget.points.last.longitude ||
            oldWidget.followCurrentLocation != widget.followCurrentLocation)) {
      _recenterAfterBuild();
    }
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  void _recenterAfterBuild() {
    if (!widget.followCurrentLocation || widget.points.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.points.isEmpty) return;
      final route = widget.points
          .map((point) => point.latLng)
          .toList(growable: false);
      _controller.move(
        widget.points.last.latLng,
        widget.followZoom ?? _initialZoom(route),
        id: 'follow-current-location',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return _EmptyRouteMap(
        height: widget.height,
        label: widget.emptyLabel,
        borderRadius: widget.borderRadius,
      );
    }

    final route = widget.points
        .map((point) => point.latLng)
        .toList(growable: false);
    final center = _centerFor(route);
    final zoom = _initialZoom(route);
    final last = widget.points.last;

    final map = FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        interactionOptions: InteractionOptions(
          flags:
              widget.interactive
                  ? InteractiveFlag.pinchZoom | InteractiveFlag.drag
                  : InteractiveFlag.none,
        ),
      ),
      children: [
        _tileLayer(),
        if (widget.showAccuracy && last.accuracyMeters != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: last.latLng,
                radius: last.accuracyMeters!.clamp(8, 200).toDouble(),
                useRadiusInMeter: true,
                color: Colors.cyan.withValues(alpha: 0.14),
                borderColor: Colors.cyan.withValues(alpha: 0.55),
                borderStrokeWidth: 1.5,
              ),
            ],
          ),
        if (route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                color:
                    widget.style == RouteMapStyle.satellite
                        ? Colors.cyanAccent
                        : Colors.teal,
                strokeWidth: 5,
              ),
            ],
          ),
        MarkerLayer(markers: _markers(route)),
        SimpleAttributionWidget(
          source: Text(
            widget.style == RouteMapStyle.satellite
                ? 'Esri World Imagery'
                : 'OpenStreetMap contributors',
            style: const TextStyle(fontSize: 10),
          ),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.86),
          alignment: Alignment.bottomLeft,
        ),
      ],
    );

    final mapWithFallback = Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: Colors.grey.shade100)),
        Positioned.fill(child: map),
        if (_mapUnavailable)
          Positioned(
            left: 12,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  'Map unavailable',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child:
          widget.height.isInfinite
              ? SizedBox.expand(child: mapWithFallback)
              : SizedBox(height: widget.height, child: mapWithFallback),
    );
  }

  TileLayer _tileLayer() {
    switch (widget.style) {
      case RouteMapStyle.satellite:
        return TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/'
              'World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.healthanalyzer.health_analyzer',
          tileProvider: OfflineMapService.tileProviderForStyle('satellite'),
          maxNativeZoom: 19,
          errorImage: _transparentTile,
          errorTileCallback: _handleTileError,
        );
      case RouteMapStyle.street:
        return TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.healthanalyzer.health_analyzer',
          tileProvider: OfflineMapService.tileProviderForStyle('street'),
          maxNativeZoom: 19,
          errorImage: _transparentTile,
          errorTileCallback: _handleTileError,
        );
    }
  }

  void _handleTileError(Object tile, Object error, StackTrace? stackTrace) {
    if (_mapUnavailable || !mounted) return;
    setState(() => _mapUnavailable = true);
  }

  List<Marker> _markers(List<LatLng> route) {
    if (route.length == 1) {
      return [
        Marker(
          point: route.first,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.cyan, size: 28),
        ),
      ];
    }

    return [
      Marker(
        point: route.first,
        width: 36,
        height: 36,
        child: const Icon(Icons.play_circle_fill, color: Colors.green),
      ),
      Marker(
        point: route.last,
        width: 36,
        height: 36,
        child: const Icon(Icons.stop_circle, color: Colors.red),
      ),
      Marker(
        point: route.last,
        width: 40,
        height: 40,
        child: const Icon(Icons.navigation, color: Colors.cyan, size: 26),
      ),
    ];
  }

  LatLng _centerFor(List<LatLng> route) {
    if (route.length == 1) return route.first;
    return LatLngBounds.fromPoints(route).center;
  }

  double _initialZoom(List<LatLng> route) {
    if (route.length == 1) return 17;
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

class _EmptyRouteMap extends StatelessWidget {
  final double height;
  final String? label;
  final double borderRadius;

  const _EmptyRouteMap({
    required this.height,
    required this.label,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, color: Colors.grey.shade500),
          const SizedBox(height: 8),
          Text(
            label ?? 'Route map will appear after GPS points are recorded.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );

    return height.isInfinite
        ? SizedBox.expand(child: content)
        : SizedBox(height: height, child: content);
  }
}
