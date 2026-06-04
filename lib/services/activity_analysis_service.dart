import '../database/database.dart';

class ActivityGpsQuality {
  final int good;
  final int usable;
  final int low;
  final int unknown;

  const ActivityGpsQuality({
    required this.good,
    required this.usable,
    required this.low,
    required this.unknown,
  });

  int get total => good + usable + low + unknown;
}

class ActivitySplit {
  final int index;
  final double distanceMeters;
  final int elapsedSeconds;
  final int movingSeconds;
  final double avgSpeedMps;
  final double ascentMeters;

  const ActivitySplit({
    required this.index,
    required this.distanceMeters,
    required this.elapsedSeconds,
    required this.movingSeconds,
    required this.avgSpeedMps,
    required this.ascentMeters,
  });
}

class ActivityChartSample {
  final int elapsedSeconds;
  final double? speedMps;
  final double? altitudeMeters;

  const ActivityChartSample({
    required this.elapsedSeconds,
    required this.speedMps,
    required this.altitudeMeters,
  });
}

class ActivityAnalysis {
  final ActivityGpsQuality gpsQuality;
  final List<ActivitySplit> splits;
  final List<ActivityChartSample> chartSamples;
  final double splitDistanceMeters;

  const ActivityAnalysis({
    required this.gpsQuality,
    required this.splits,
    required this.chartSamples,
    required this.splitDistanceMeters,
  });
}

class ActivityAnalysisService {
  ActivityAnalysis analyze(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    return ActivityAnalysis(
      gpsQuality: _quality(points),
      splits: _splits(session, points),
      chartSamples: _chartSamples(session, points),
      splitDistanceMeters: _splitDistanceMeters(session),
    );
  }

  ActivityGpsQuality _quality(List<ActivityPoint> points) {
    var good = 0;
    var usable = 0;
    var low = 0;
    var unknown = 0;
    for (final point in points) {
      switch (point.pointQuality) {
        case 'good':
          good++;
        case 'usable':
          usable++;
        case 'low':
          low++;
        default:
          unknown++;
      }
    }
    return ActivityGpsQuality(
      good: good,
      usable: usable,
      low: low,
      unknown: unknown,
    );
  }

  List<ActivitySplit> _splits(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    if (points.length < 2 || session.distanceMeters <= 0) return const [];

    final splitDistance = _splitDistanceMeters(session);
    final splits = <ActivitySplit>[];
    var splitStartTime = points.first.timestamp;
    var splitMovingSeconds = 0;
    var splitDistanceMeters = 0.0;
    var splitAscentMeters = 0.0;
    var nextBoundary = splitDistance;
    ActivityPoint? previous;

    for (final point in points) {
      if (previous != null) {
        final segmentDistance = point.distanceFromPrevMeters;
        splitDistanceMeters += segmentDistance;
        if (point.moving) {
          splitMovingSeconds +=
              point.timestamp
                  .difference(previous.timestamp)
                  .inSeconds
                  .clamp(0, 1 << 31)
                  .toInt();
        }
        final previousAlt =
            previous.altitudeCorrectedMeters ?? previous.altitudeMeters;
        final altitude = point.altitudeCorrectedMeters ?? point.altitudeMeters;
        if (previousAlt != null && altitude != null && altitude > previousAlt) {
          splitAscentMeters += altitude - previousAlt;
        }
      }

      while (splitDistanceMeters >= nextBoundary) {
        final elapsedSeconds =
            point.timestamp
                .difference(splitStartTime)
                .inSeconds
                .clamp(0, 1 << 31)
                .toInt();
        splits.add(
          ActivitySplit(
            index: splits.length + 1,
            distanceMeters: nextBoundary,
            elapsedSeconds: elapsedSeconds,
            movingSeconds: splitMovingSeconds,
            avgSpeedMps:
                splitMovingSeconds <= 0 ? 0 : nextBoundary / splitMovingSeconds,
            ascentMeters: splitAscentMeters,
          ),
        );
        splitStartTime = point.timestamp;
        splitMovingSeconds = 0;
        splitDistanceMeters -= nextBoundary;
        splitAscentMeters = 0;
        nextBoundary = splitDistance;
      }
      previous = point;
    }

    if (splitDistanceMeters > splitDistance * 0.2 && previous != null) {
      final elapsedSeconds =
          previous.timestamp
              .difference(splitStartTime)
              .inSeconds
              .clamp(0, 1 << 31)
              .toInt();
      splits.add(
        ActivitySplit(
          index: splits.length + 1,
          distanceMeters: splitDistanceMeters,
          elapsedSeconds: elapsedSeconds,
          movingSeconds: splitMovingSeconds,
          avgSpeedMps:
              splitMovingSeconds <= 0
                  ? 0
                  : splitDistanceMeters / splitMovingSeconds,
          ascentMeters: splitAscentMeters,
        ),
      );
    }

    return splits;
  }

  List<ActivityChartSample> _chartSamples(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    if (points.isEmpty) return const [];
    final start = points.first.timestamp;
    return points
        .map(
          (point) => ActivityChartSample(
            elapsedSeconds:
                point.timestamp
                    .difference(start)
                    .inSeconds
                    .clamp(0, 1 << 31)
                    .toInt(),
            speedMps: point.speedMps,
            altitudeMeters:
                point.altitudeCorrectedMeters ?? point.altitudeMeters,
          ),
        )
        .toList(growable: false);
  }

  double _splitDistanceMeters(ActivitySession session) {
    final value = '${session.sportKey} ${session.category}'.toLowerCase();
    if (value.contains('cycling') ||
        value.contains('bike') ||
        value.contains('cycle')) {
      return 5000;
    }
    return 1000;
  }
}
