import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class RouteBuildResult {
  final List<LatLng> points;
  final double distanceMeters;
  final String source;
  final String? warning;

  const RouteBuildResult({
    required this.points,
    required this.distanceMeters,
    required this.source,
    this.warning,
  });
}

class RouteBuilderService {
  final Dio _dio;
  final _distance = const Distance();

  RouteBuilderService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 12),
            ),
          );

  Future<RouteBuildResult> snapToRoad(
    List<LatLng> points, {
    required String sportKey,
  }) async {
    if (points.length < 2) {
      return RouteBuildResult(
        points: points,
        distanceMeters: _distanceMeters(points),
        source: 'manual',
        warning: 'Route needs at least two points before snap-to-road.',
      );
    }

    final profile = _profileFor(sportKey);
    final coordinates = points
        .map((point) => '${point.longitude},${point.latitude}')
        .join(';');
    final url =
        'https://router.project-osrm.org/route/v1/$profile/$coordinates';
    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'false',
        },
      );
      final routes = response.data['routes'];
      if (routes is! List || routes.isEmpty) {
        throw StateError('No OSRM route returned');
      }
      final route = routes.first as Map;
      final geometry = route['geometry'] as Map?;
      final coordinatesRaw = geometry?['coordinates'];
      if (coordinatesRaw is! List) {
        throw StateError('OSRM route has no geometry');
      }
      final snapped = <LatLng>[];
      for (final item in coordinatesRaw) {
        if (item is! List || item.length < 2) continue;
        final lon = (item[0] as num).toDouble();
        final lat = (item[1] as num).toDouble();
        snapped.add(LatLng(lat, lon));
      }
      if (snapped.length < 2) {
        throw StateError('OSRM route has too few points');
      }
      return RouteBuildResult(
        points: snapped,
        distanceMeters:
            (route['distance'] as num?)?.toDouble() ?? _distanceMeters(snapped),
        source: 'osrm_public',
      );
    } catch (error) {
      return RouteBuildResult(
        points: points,
        distanceMeters: _distanceMeters(points),
        source: 'manual',
        warning:
            'Snap-to-road unavailable. Manual route is kept. Error: $error',
      );
    }
  }

  double distanceMeters(List<LatLng> points) => _distanceMeters(points);

  double _distanceMeters(List<LatLng> points) {
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += _distance.as(LengthUnit.Meter, points[i - 1], points[i]);
    }
    return total;
  }

  String _profileFor(String sportKey) {
    final lower = sportKey.toLowerCase();
    if (lower.contains('cycling')) return 'bike';
    if (lower.contains('walking') || lower.contains('hiking')) return 'foot';
    return 'foot';
  }
}
