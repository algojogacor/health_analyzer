import 'dart:math' as math;

class CropRoutePoint {
  final double latitude;
  final double longitude;

  const CropRoutePoint({required this.latitude, required this.longitude});
}

class RouteCropState {
  final double hiddenMeters;
  final double totalDistanceMeters;
  final double minVisibleMeters;
  final List<double> cumulativeDistances;
  final List<CropRoutePoint> visiblePoints;
  final CropRoutePoint? startHandle;
  final CropRoutePoint? endHandle;

  const RouteCropState({
    required this.hiddenMeters,
    required this.totalDistanceMeters,
    required this.minVisibleMeters,
    required this.cumulativeDistances,
    required this.visiblePoints,
    required this.startHandle,
    required this.endHandle,
  });

  double get maxHiddenMeters =>
      math.max(0, (totalDistanceMeters - minVisibleMeters) / 2);
}

class RouteCropCalculator {
  static RouteCropState calculate(
    List<CropRoutePoint> points, {
    required double hiddenMeters,
  }) {
    final cumulative = _cumulativeDistances(points);
    final total = cumulative.isEmpty ? 0.0 : cumulative.last;
    final minVisible = total <= 0 ? 0.0 : math.min(200.0, total * 0.2);
    final maxHidden = math.max(0.0, (total - minVisible) / 2);
    final hidden = hiddenMeters.clamp(0.0, maxHidden).toDouble();
    final startDistance = hidden;
    final endDistance = math.max(startDistance, total - hidden);
    final startHandle = _pointAtDistance(points, cumulative, startDistance);
    final endHandle = _pointAtDistance(points, cumulative, endDistance);
    final visible = _visiblePoints(
      points,
      cumulative,
      startDistance,
      endDistance,
      startHandle,
      endHandle,
    );

    return RouteCropState(
      hiddenMeters: hidden,
      totalDistanceMeters: total,
      minVisibleMeters: minVisible,
      cumulativeDistances: cumulative,
      visiblePoints: visible,
      startHandle: startHandle,
      endHandle: endHandle,
    );
  }

  static double hiddenMetersFromDraggedStart(
    List<CropRoutePoint> points,
    CropRoutePoint draggedPoint,
  ) {
    final cumulative = _cumulativeDistances(points);
    final distance = _nearestDistance(points, cumulative, draggedPoint);
    return calculate(points, hiddenMeters: distance).hiddenMeters;
  }

  static double hiddenMetersFromDraggedEnd(
    List<CropRoutePoint> points,
    CropRoutePoint draggedPoint,
  ) {
    final cumulative = _cumulativeDistances(points);
    final total = cumulative.isEmpty ? 0.0 : cumulative.last;
    final distance = _nearestDistance(points, cumulative, draggedPoint);
    return calculate(points, hiddenMeters: total - distance).hiddenMeters;
  }

  static List<double> _cumulativeDistances(List<CropRoutePoint> points) {
    if (points.isEmpty) return const [];
    final cumulative = <double>[0];
    for (var i = 1; i < points.length; i++) {
      cumulative.add(
        cumulative.last + haversineMeters(points[i - 1], points[i]),
      );
    }
    return cumulative;
  }

  static List<CropRoutePoint> _visiblePoints(
    List<CropRoutePoint> points,
    List<double> cumulative,
    double startDistance,
    double endDistance,
    CropRoutePoint? startHandle,
    CropRoutePoint? endHandle,
  ) {
    if (points.length < 2 || startHandle == null || endHandle == null) {
      return points;
    }
    final visible = <CropRoutePoint>[startHandle];
    for (var i = 0; i < points.length; i++) {
      final distance = cumulative[i];
      if (distance > startDistance && distance < endDistance) {
        visible.add(points[i]);
      }
    }
    visible.add(endHandle);
    return visible;
  }

  static CropRoutePoint? _pointAtDistance(
    List<CropRoutePoint> points,
    List<double> cumulative,
    double distance,
  ) {
    if (points.isEmpty) return null;
    if (points.length == 1 || distance <= 0) return points.first;
    if (distance >= cumulative.last) return points.last;

    for (var i = 1; i < cumulative.length; i++) {
      if (cumulative[i] < distance) continue;
      final segmentStart = cumulative[i - 1];
      final segmentEnd = cumulative[i];
      final span = segmentEnd - segmentStart;
      final ratio = span <= 0 ? 0.0 : (distance - segmentStart) / span;
      return CropRoutePoint(
        latitude:
            points[i - 1].latitude +
            (points[i].latitude - points[i - 1].latitude) * ratio,
        longitude:
            points[i - 1].longitude +
            (points[i].longitude - points[i - 1].longitude) * ratio,
      );
    }
    return points.last;
  }

  static double _nearestDistance(
    List<CropRoutePoint> points,
    List<double> cumulative,
    CropRoutePoint target,
  ) {
    if (points.isEmpty) return 0;
    var bestIndex = 0;
    var bestDistance = double.infinity;
    for (var i = 0; i < points.length; i++) {
      final distance = haversineMeters(points[i], target);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = i;
      }
    }
    return cumulative[bestIndex];
  }

  static double haversineMeters(CropRoutePoint a, CropRoutePoint b) {
    const earthRadius = 6371000.0;
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  static double _degToRad(double degrees) => degrees * math.pi / 180;
}
