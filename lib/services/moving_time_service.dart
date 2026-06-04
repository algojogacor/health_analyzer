import 'dart:math' as math;

import '../models/sport_mode.dart';

class TrackPoint {
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double? altitudeMeters;
  final double? accuracyMeters;
  final double? speedMps;
  final double? bearingDegrees;
  final String? activityRecognition;

  const TrackPoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitudeMeters,
    this.accuracyMeters,
    this.speedMps,
    this.bearingDegrees,
    this.activityRecognition,
  });
}

class MovingSegment {
  final DateTime startedAt;
  final DateTime endedAt;
  final String reason;

  const MovingSegment({
    required this.startedAt,
    required this.endedAt,
    required this.reason,
  });

  int get durationSeconds => endedAt.difference(startedAt).inSeconds;
}

class MovingTimeResult {
  final int elapsedSeconds;
  final int movingSeconds;
  final int stoppedSeconds;
  final double distanceMeters;
  final double ascentMeters;
  final double descentMeters;
  final double? avgSpeedMps;
  final double? maxSpeedMps;
  final List<MovingSegment> stoppedSegments;

  const MovingTimeResult({
    required this.elapsedSeconds,
    required this.movingSeconds,
    required this.stoppedSeconds,
    required this.distanceMeters,
    required this.ascentMeters,
    required this.descentMeters,
    required this.avgSpeedMps,
    required this.maxSpeedMps,
    required this.stoppedSegments,
  });
}

class MovingTimeService {
  static const _gapInterpolateSeconds = 10;
  static const _gapPauseSeconds = 60;
  static const _dedupDistanceMeters = 3.0;
  static const _clusterRadiusMeters = 15.0;

  MovingTimeResult calculate(List<TrackPoint> rawPoints, SportMode sportMode) {
    final points = _deduplicate(_filterUsablePoints(rawPoints, sportMode));
    if (points.length < 2) {
      return const MovingTimeResult(
        elapsedSeconds: 0,
        movingSeconds: 0,
        stoppedSeconds: 0,
        distanceMeters: 0,
        ascentMeters: 0,
        descentMeters: 0,
        avgSpeedMps: null,
        maxSpeedMps: null,
        stoppedSegments: [],
      );
    }

    var movingSeconds = 0;
    var distanceMeters = 0.0;
    var ascentMeters = 0.0;
    var descentMeters = 0.0;
    var maxSpeedMps = 0.0;
    var isMoving = true;
    DateTime? stopStartedAt;
    final stoppedSegments = <MovingSegment>[];

    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final deltaSeconds =
          current.timestamp.difference(previous.timestamp).inSeconds;
      if (deltaSeconds <= 0) continue;

      if (previous.activityRecognition == 'MANUAL_PAUSED' ||
          current.activityRecognition == 'MANUAL_PAUSED') {
        continue;
      }

      final distance = haversineMeters(previous, current);

      if (deltaSeconds > _gapPauseSeconds) {
        stoppedSegments.add(
          MovingSegment(
            startedAt: previous.timestamp,
            endedAt: current.timestamp,
            reason: 'gps_gap',
          ),
        );
        isMoving = false;
        stopStartedAt = current.timestamp;
        continue;
      }

      final speed = _reliableSpeed(previous, current, distance, deltaSeconds);
      if (speed != null && speed > maxSpeedMps) maxSpeedMps = speed;
      final adjustedStopSpeed = _adjustedStopSpeed(sportMode, points, i);
      final clustered = _isClustered(points.take(i + 1).toList());
      final recognition = current.activityRecognition ?? '';
      final activityStill = recognition == 'STILL';
      final clearlyMoving = speed != null && speed >= sportMode.resumeSpeedMps;
      final clearlyStopped =
          (speed == null || speed <= adjustedStopSpeed) &&
          (clustered || activityStill);

      if (clearlyMoving || !clearlyStopped) {
        if (!isMoving && stopStartedAt != null) {
          final stoppedFor =
              current.timestamp.difference(stopStartedAt).inSeconds;
          if (stoppedFor >= sportMode.minStopSeconds) {
            stoppedSegments.add(
              MovingSegment(
                startedAt: stopStartedAt,
                endedAt: current.timestamp,
                reason: 'auto_pause',
              ),
            );
          } else {
            movingSeconds += stoppedFor;
          }
        }
        isMoving = true;
        stopStartedAt = null;
        movingSeconds += deltaSeconds;
        distanceMeters += distance;
        final altitudeDelta = _altitudeDelta(previous, current);
        if (altitudeDelta > 0) {
          ascentMeters += altitudeDelta;
        } else {
          descentMeters += altitudeDelta.abs();
        }
      } else if (isMoving) {
        isMoving = false;
        stopStartedAt = current.timestamp;
      }
    }

    if (!isMoving && stopStartedAt != null) {
      final last = points.last.timestamp;
      final stoppedFor = last.difference(stopStartedAt).inSeconds;
      if (stoppedFor >= sportMode.minStopSeconds) {
        stoppedSegments.add(
          MovingSegment(
            startedAt: stopStartedAt,
            endedAt: last,
            reason: 'stopped_at_end',
          ),
        );
      }
    }

    final elapsedSeconds =
        points.last.timestamp.difference(points.first.timestamp).inSeconds;
    final stoppedSeconds = stoppedSegments.fold<int>(
      0,
      (total, segment) => total + segment.durationSeconds,
    );
    final safeMovingSeconds = math.max(
      0,
      math.min(movingSeconds, elapsedSeconds),
    );

    return MovingTimeResult(
      elapsedSeconds: elapsedSeconds,
      movingSeconds: safeMovingSeconds,
      stoppedSeconds: stoppedSeconds,
      distanceMeters: distanceMeters,
      ascentMeters: ascentMeters,
      descentMeters: descentMeters,
      avgSpeedMps:
          safeMovingSeconds > 0 ? distanceMeters / safeMovingSeconds : null,
      maxSpeedMps: maxSpeedMps == 0 ? null : maxSpeedMps,
      stoppedSegments: stoppedSegments,
    );
  }

  List<TrackPoint> _filterUsablePoints(
    List<TrackPoint> points,
    SportMode mode,
  ) {
    return points
        .where(
          (point) =>
              point.accuracyMeters == null ||
              point.accuracyMeters! <= mode.accuracyFilterMeters * 2,
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  List<TrackPoint> _deduplicate(List<TrackPoint> points) {
    if (points.isEmpty) return points;
    final result = <TrackPoint>[points.first];
    for (final point in points.skip(1)) {
      final deltaSeconds =
          point.timestamp.difference(result.last.timestamp).inSeconds;
      if (deltaSeconds >= _gapInterpolateSeconds ||
          haversineMeters(result.last, point) >= _dedupDistanceMeters) {
        result.add(point);
      }
    }
    return result;
  }

  double? _reliableSpeed(
    TrackPoint previous,
    TrackPoint current,
    double distanceMeters,
    int deltaSeconds,
  ) {
    if (deltaSeconds <= 0) return null;
    final calculated = distanceMeters / deltaSeconds;
    final gpsSpeed = current.speedMps;
    if (gpsSpeed == null || gpsSpeed <= 0) return calculated;
    final accuracy = current.accuracyMeters ?? 999;
    if (accuracy <= 20) return gpsSpeed;
    if (accuracy <= 50) return (gpsSpeed * 0.4) + (calculated * 0.6);
    return calculated;
  }

  double _adjustedStopSpeed(
    SportMode mode,
    List<TrackPoint> points,
    int index,
  ) {
    final start = math.max(1, index - 3);
    var gradientSum = 0.0;
    var count = 0;
    for (var i = start; i <= index; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final distance = haversineMeters(prev, curr);
      if (distance <= 0) continue;
      final altitudeDelta = _altitudeDelta(prev, curr);
      final gradient = (altitudeDelta / distance) * 100;
      if (gradient > 0) {
        gradientSum += gradient;
        count++;
      }
    }
    if (count == 0) return mode.stopSpeedMps;
    final avgGradient = gradientSum / count;
    if (avgGradient <= 5) return mode.stopSpeedMps;
    return mode.stopSpeedMps / (1 + avgGradient / 20);
  }

  double _altitudeDelta(TrackPoint previous, TrackPoint current) {
    final prevAlt = previous.altitudeMeters;
    final currAlt = current.altitudeMeters;
    if (prevAlt == null || currAlt == null) return 0;
    final prevAccuracy = previous.accuracyMeters ?? 0;
    final currAccuracy = current.accuracyMeters ?? 0;
    if (prevAccuracy > 50 || currAccuracy > 50) return 0;
    final delta = currAlt - prevAlt;
    return delta.abs() < 1.5 ? 0 : delta;
  }

  bool _isClustered(List<TrackPoint> points) {
    if (points.length < 10) return false;
    final recent = points.sublist(points.length - 10);
    final centerLat =
        recent.fold(0.0, (total, point) => total + point.latitude) /
        recent.length;
    final centerLon =
        recent.fold(0.0, (total, point) => total + point.longitude) /
        recent.length;
    final center = TrackPoint(
      timestamp: recent.last.timestamp,
      latitude: centerLat,
      longitude: centerLon,
    );
    final within =
        recent
            .where(
              (point) => haversineMeters(point, center) < _clusterRadiusMeters,
            )
            .length;
    return within >= 7;
  }

  static double haversineMeters(TrackPoint a, TrackPoint b) {
    const earthRadius = 6371000.0;
    final dLat = _radians(b.latitude - a.latitude);
    final dLon = _radians(b.longitude - a.longitude);
    final lat1 = _radians(a.latitude);
    final lat2 = _radians(b.latitude);
    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
