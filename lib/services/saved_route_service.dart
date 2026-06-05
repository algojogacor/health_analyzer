import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'route_crop_service.dart';

class SavedRouteGeometry {
  final List<LatLng> points;
  final List<SavedRouteElevationSample> elevationSamples;
  final bool rawPointsIncluded;
  final String source;

  const SavedRouteGeometry({
    required this.points,
    this.elevationSamples = const [],
    required this.rawPointsIncluded,
    required this.source,
  });
}

class SavedRouteElevationSample {
  final double distanceMeters;
  final double altitudeMeters;

  const SavedRouteElevationSample({
    required this.distanceMeters,
    required this.altitudeMeters,
  });
}

class SavedRouteService {
  final AppDatabase db;
  final _uuid = const Uuid();
  final _distance = const Distance();

  SavedRouteService(this.db);

  Future<SavedRoute> saveFromActivity(ActivitySession session) async {
    final points = await db.getActivityPoints(session.localId);
    final routePoints = _privacyCroppedActivityPoints(session, points);
    final routeLatLng = routePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    final elevationProfile = _elevationProfile(routePoints);
    final routeId = _uuid.v4();
    final summary = <String, dynamic>{
      'source_session_local_id': session.localId,
      'sport': session.sportName,
      'distance_meters': session.distanceMeters,
      'ascent_meters': session.ascentMeters,
      'descent_meters': session.descentMeters,
      'point_count': points.length,
      'privacy': {
        'route_visibility': session.routeVisibility,
        'hide_start_end_meters': session.hideStartEndMeters,
      },
      'bounds': _boundsFromLatLng(routeLatLng),
      'points': _encodeActivityPoints(routePoints),
      'elevation_profile': elevationProfile
          .map(
            (sample) => {
              'distance_meters': double.parse(
                sample.distanceMeters.toStringAsFixed(1),
              ),
              'altitude_meters': double.parse(
                sample.altitudeMeters.toStringAsFixed(2),
              ),
            },
          )
          .toList(growable: false),
      'elevation': {
        'status':
            elevationProfile.length >= 2
                ? 'recorded_or_imported'
                : 'unavailable',
        'source': 'activity_points_altitude_corrected_first',
        'sample_count': elevationProfile.length,
      },
      'raw_points_included': true,
      'point_policy':
          'Local saved route points are privacy-cropped and are not synced as raw health data by default.',
    };

    await db.upsertSavedRoute(
      SavedRoutesCompanion.insert(
        localId: routeId,
        sourceSessionLocalId: Value(session.localId),
        name: session.title ?? '${session.sportName} route',
        sportKey: Value(session.sportKey),
        distanceMeters: Value(session.distanceMeters),
        ascentMeters: Value(session.ascentMeters),
        descentMeters: Value(session.descentMeters),
        pointCount: Value(points.length),
        routeVisibility: Value(session.routeVisibility),
        hideStartEndMeters: Value(session.hideStartEndMeters),
        summaryJson: Value(jsonEncode(summary)),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final saved = await db.getSavedRoute(routeId);
    if (saved == null) {
      throw StateError('Saved route could not be loaded after insert');
    }
    return saved;
  }

  Future<SavedRoute> savePlannedRoute({
    required String name,
    required String sportKey,
    required List<LatLng> points,
    String routeVisibility = 'private',
  }) async {
    if (points.length < 2) {
      throw StateError('A planned route needs at least two points');
    }
    final now = DateTime.now();
    final routeId = _uuid.v4();
    final distanceMeters = _distanceMeters(points);
    final summary = <String, dynamic>{
      'source': 'route_builder',
      'sport_key': sportKey,
      'bounds': _boundsFromLatLng(points),
      'points': _encodeLatLng(points),
      'raw_points_included': true,
      'point_policy':
          'Local planned route points stay on-device unless the user explicitly exports or shares them.',
      'elevation': {
        'status': 'unavailable',
        'reason':
            'Elevation preview needs DEM/PMTiles elevation source or recorded GPS altitude.',
      },
    };

    await db.upsertSavedRoute(
      SavedRoutesCompanion.insert(
        localId: routeId,
        sourceSessionLocalId: const Value(null),
        name: name.trim().isEmpty ? 'Planned route' : name.trim(),
        sportKey: Value(sportKey),
        distanceMeters: Value(distanceMeters),
        ascentMeters: const Value(0),
        descentMeters: const Value(0),
        pointCount: Value(points.length),
        routeVisibility: Value(routeVisibility),
        hideStartEndMeters: const Value(0),
        summaryJson: Value(jsonEncode(summary)),
        updatedAt: Value(now),
      ),
    );

    final saved = await db.getSavedRoute(routeId);
    if (saved == null) {
      throw StateError('Planned route could not be loaded after insert');
    }
    return saved;
  }

  SavedRouteGeometry geometryFor(SavedRoute route) {
    final raw = route.summaryJson;
    if (raw == null || raw.trim().isEmpty) {
      return const SavedRouteGeometry(
        points: [],
        rawPointsIncluded: false,
        source: 'unknown',
      );
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return const SavedRouteGeometry(
          points: [],
          rawPointsIncluded: false,
          source: 'unknown',
        );
      }
      final pointsRaw = decoded['points'];
      final points = <LatLng>[];
      if (pointsRaw is List) {
        for (final item in pointsRaw) {
          if (item is! Map) continue;
          final lat = _asDouble(item['lat']);
          final lon = _asDouble(item['lon'] ?? item['lng']);
          if (lat == null || lon == null) continue;
          points.add(LatLng(lat, lon));
        }
      }
      return SavedRouteGeometry(
        points: points,
        elevationSamples: _decodeElevationSamples(decoded),
        rawPointsIncluded: decoded['raw_points_included'] == true,
        source: decoded['source']?.toString() ?? 'saved_route',
      );
    } catch (_) {
      return const SavedRouteGeometry(
        points: [],
        rawPointsIncluded: false,
        source: 'unknown',
      );
    }
  }

  Future<File> exportRouteGpx(SavedRoute route) async {
    final geometry = geometryFor(route);
    if (geometry.points.length < 2) {
      throw StateError('Saved route needs at least two points to export GPX');
    }
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(dir.path, '${_safeFileName(route.name)}-route.gpx'),
    );
    await file.writeAsString(_buildRouteGpx(route, geometry));
    return file;
  }

  List<ActivityPoint> _privacyCroppedActivityPoints(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    if (points.isEmpty) return const [];
    final raw = points
        .map(
          (point) => CropRoutePoint(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        )
        .toList(growable: false);
    if (session.routeVisibility == 'public' ||
        session.hideStartEndMeters <= 0 ||
        raw.length < 3) {
      return points;
    }
    final cropped =
        RouteCropCalculator.calculate(
          raw,
          hiddenMeters: session.hideStartEndMeters,
        ).visiblePoints;
    final visibleKeys =
        cropped
            .map(
              (point) =>
                  '${point.latitude.toStringAsFixed(7)},'
                  '${point.longitude.toStringAsFixed(7)}',
            )
            .toSet();
    final selected = points
        .where(
          (point) => visibleKeys.contains(
            '${point.latitude.toStringAsFixed(7)},'
            '${point.longitude.toStringAsFixed(7)}',
          ),
        )
        .toList(growable: false);
    return selected.length >= 2 ? selected : points;
  }

  double _distanceMeters(List<LatLng> points) {
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += _distance.as(LengthUnit.Meter, points[i - 1], points[i]);
    }
    return total;
  }

  List<Map<String, double>> _encodeLatLng(List<LatLng> points) {
    return points
        .map(
          (point) => {
            'lat': double.parse(point.latitude.toStringAsFixed(7)),
            'lon': double.parse(point.longitude.toStringAsFixed(7)),
          },
        )
        .toList(growable: false);
  }

  List<Map<String, double>> _encodeActivityPoints(List<ActivityPoint> points) {
    return points
        .map((point) {
          final altitude =
              point.altitudeCorrectedMeters ?? point.altitudeMeters;
          return {
            'lat': double.parse(point.latitude.toStringAsFixed(7)),
            'lon': double.parse(point.longitude.toStringAsFixed(7)),
            if (altitude != null)
              'ele': double.parse(altitude.toStringAsFixed(2)),
          };
        })
        .toList(growable: false);
  }

  List<SavedRouteElevationSample> _elevationProfile(
    List<ActivityPoint> points,
  ) {
    final samples = <SavedRouteElevationSample>[];
    var cumulative = 0.0;
    LatLng? previous;
    for (final point in points) {
      final current = LatLng(point.latitude, point.longitude);
      if (previous != null) {
        cumulative += _distance.as(LengthUnit.Meter, previous, current);
      }
      previous = current;
      final altitude = point.altitudeCorrectedMeters ?? point.altitudeMeters;
      if (altitude == null || !altitude.isFinite) continue;
      samples.add(
        SavedRouteElevationSample(
          distanceMeters: cumulative,
          altitudeMeters: altitude,
        ),
      );
    }
    return samples;
  }

  List<SavedRouteElevationSample> _decodeElevationSamples(Map decoded) {
    final explicit = decoded['elevation_profile'];
    if (explicit is List) {
      final samples = explicit
          .whereType<Map>()
          .map((item) {
            final distance = _asDouble(item['distance_meters']);
            final altitude = _asDouble(item['altitude_meters']);
            if (distance == null || altitude == null) return null;
            return SavedRouteElevationSample(
              distanceMeters: distance,
              altitudeMeters: altitude,
            );
          })
          .whereType<SavedRouteElevationSample>()
          .toList(growable: false);
      if (samples.length >= 2) return samples;
    }

    final pointsRaw = decoded['points'];
    if (pointsRaw is! List) return const [];
    final samples = <SavedRouteElevationSample>[];
    var cumulative = 0.0;
    LatLng? previous;
    for (final item in pointsRaw) {
      if (item is! Map) continue;
      final lat = _asDouble(item['lat']);
      final lon = _asDouble(item['lon'] ?? item['lng']);
      final altitude = _asDouble(item['ele'] ?? item['altitude_meters']);
      if (lat == null || lon == null) continue;
      final current = LatLng(lat, lon);
      if (previous != null) {
        cumulative += _distance.as(LengthUnit.Meter, previous, current);
      }
      previous = current;
      if (altitude == null) continue;
      samples.add(
        SavedRouteElevationSample(
          distanceMeters: cumulative,
          altitudeMeters: altitude,
        ),
      );
    }
    return samples.length >= 2 ? samples : const [];
  }

  Map<String, dynamic>? _boundsFromLatLng(List<LatLng> points) {
    if (points.isEmpty) return null;
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLon = points.first.longitude;
    var maxLon = points.first.longitude;
    for (final point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }
    return {
      'min_lat': minLat,
      'max_lat': maxLat,
      'min_lon': minLon,
      'max_lon': maxLon,
    };
  }

  String _buildRouteGpx(SavedRoute route, SavedRouteGeometry geometry) {
    final points = geometry.points;
    final buffer =
        StringBuffer()
          ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
          ..writeln(
            '<gpx version="1.1" creator="Health Analyzer" xmlns="http://www.topografix.com/GPX/1/1">',
          )
          ..writeln('  <rte>')
          ..writeln('    <name>${_xmlEscape(route.name)}</name>');
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      buffer.writeln(
        '    <rtept lat="${point.latitude.toStringAsFixed(7)}" lon="${point.longitude.toStringAsFixed(7)}">',
      );
      if (i < geometry.elevationSamples.length) {
        buffer.writeln(
          '      <ele>${geometry.elevationSamples[i].altitudeMeters.toStringAsFixed(2)}</ele>',
        );
      }
      buffer.writeln('    </rtept>');
    }
    buffer
      ..writeln('  </rte>')
      ..writeln('</gpx>');
    return buffer.toString();
  }

  String _safeFileName(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return cleaned.isEmpty ? 'health-analyzer-route' : cleaned;
  }

  String _xmlEscape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
