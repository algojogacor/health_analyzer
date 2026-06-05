import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../database/database.dart';

class ActivityHeatmapCell {
  final double latitude;
  final double longitude;
  final int count;

  const ActivityHeatmapCell({
    required this.latitude,
    required this.longitude,
    required this.count,
  });
}

class ActivityHeatmapSummary {
  final List<ActivityHeatmapCell> cells;
  final int activityCount;
  final int pointCount;
  final DateTime? newestActivityAt;
  final DateTime? oldestActivityAt;

  const ActivityHeatmapSummary({
    required this.cells,
    required this.activityCount,
    required this.pointCount,
    required this.newestActivityAt,
    required this.oldestActivityAt,
  });

  bool get available => cells.isNotEmpty;

  int get maxCount {
    if (cells.isEmpty) return 0;
    return cells.map((cell) => cell.count).reduce(math.max);
  }

  LatLngBounds? get bounds {
    if (cells.isEmpty) return null;
    return LatLngBounds.fromPoints(
      cells.map((cell) => LatLng(cell.latitude, cell.longitude)).toList(),
    );
  }
}

class ActivityHeatmapService {
  final AppDatabase db;

  const ActivityHeatmapService(this.db);

  Future<ActivityHeatmapSummary> build({
    int maxActivities = 100,
    int maxPointsPerActivity = 1600,
    double precision = 0.001,
  }) async {
    final sessions =
        await (db.select(db.activitySessions)
              ..where((table) => table.status.equals('completed'))
              ..where((table) => table.requiresGps.equals(true))
              ..where((table) => table.distanceMeters.isBiggerThanValue(0))
              ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
              ..limit(maxActivities))
            .get();

    final buckets = <String, _HeatmapBucket>{};
    var pointCount = 0;

    for (final session in sessions) {
      final points = await db.getActivityPoints(session.localId);
      if (points.length < 2) continue;
      final sampled = _sample(points, maxPointsPerActivity);
      for (final point in sampled) {
        if (!_validPoint(point)) continue;
        final lat = _snap(point.latitude, precision);
        final lon = _snap(point.longitude, precision);
        final key = '$lat:$lon';
        buckets.update(
          key,
          (bucket) => bucket.increment(),
          ifAbsent: () => _HeatmapBucket(latitude: lat, longitude: lon),
        );
        pointCount++;
      }
    }

    final cells = buckets.values
      .map(
        (bucket) => ActivityHeatmapCell(
          latitude: bucket.latitude,
          longitude: bucket.longitude,
          count: bucket.count,
        ),
      )
      .toList(growable: false)..sort((a, b) => b.count.compareTo(a.count));

    return ActivityHeatmapSummary(
      cells: cells.take(1200).toList(growable: false),
      activityCount: sessions.length,
      pointCount: pointCount,
      newestActivityAt: sessions.isEmpty ? null : sessions.first.startedAt,
      oldestActivityAt: sessions.isEmpty ? null : sessions.last.startedAt,
    );
  }

  List<ActivityPoint> _sample(List<ActivityPoint> points, int maxPoints) {
    if (points.length <= maxPoints) return points;
    final step = (points.length / maxPoints).ceil();
    return [
      for (var index = 0; index < points.length; index += step) points[index],
    ];
  }

  double _snap(double value, double precision) {
    return (value / precision).roundToDouble() * precision;
  }

  bool _validPoint(ActivityPoint point) {
    return point.latitude.isFinite &&
        point.longitude.isFinite &&
        point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180 &&
        point.pointQuality != 'low';
  }
}

class _HeatmapBucket {
  final double latitude;
  final double longitude;
  final int count;

  const _HeatmapBucket({
    required this.latitude,
    required this.longitude,
    this.count = 1,
  });

  _HeatmapBucket increment() {
    return _HeatmapBucket(
      latitude: latitude,
      longitude: longitude,
      count: count + 1,
    );
  }
}
