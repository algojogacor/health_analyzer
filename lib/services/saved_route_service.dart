import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class SavedRouteService {
  final AppDatabase db;
  final _uuid = const Uuid();

  SavedRouteService(this.db);

  Future<SavedRoute> saveFromActivity(ActivitySession session) async {
    final points = await db.getActivityPoints(session.localId);
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
      'bounds': _bounds(points),
      'raw_points_included': false,
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

  Map<String, dynamic>? _bounds(List<ActivityPoint> points) {
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
}
