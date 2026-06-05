import '../database/database.dart';

class ActivityLapSummary {
  final int index;
  final DateTime startedAt;
  final DateTime endedAt;
  final double distanceMeters;
  final int elapsedSeconds;
  final double ascentMeters;
  final double? avgHeartRate;

  const ActivityLapSummary({
    required this.index,
    required this.startedAt,
    required this.endedAt,
    required this.distanceMeters,
    required this.elapsedSeconds,
    required this.ascentMeters,
    required this.avgHeartRate,
  });

  double get avgSpeedMps =>
      elapsedSeconds <= 0 ? 0 : distanceMeters / elapsedSeconds;
}

class LapAnalysisService {
  List<ActivityLapSummary> analyze({
    required ActivitySession session,
    required List<ActivityPoint> points,
    required List<ActivityEvent> events,
    required List<HealthRecord> heartRateRecords,
  }) {
    final lapEvents =
        events
            .where((event) => event.eventType == 'manual_lap')
            .map((event) => event.timestamp)
            .where(
              (time) =>
                  !time.isBefore(session.startedAt) &&
                  !time.isAfter(session.endedAt ?? DateTime.now()),
            )
            .toList()
          ..sort();
    if (lapEvents.isEmpty) return const [];

    final boundaries = <DateTime>[
      session.startedAt,
      ...lapEvents,
      session.endedAt ??
          (points.isEmpty ? DateTime.now() : points.last.timestamp),
    ];
    final laps = <ActivityLapSummary>[];
    for (var i = 0; i < boundaries.length - 1; i++) {
      final start = boundaries[i];
      final end = boundaries[i + 1];
      if (!end.isAfter(start)) continue;
      final lapPoints = points
          .where(
            (point) =>
                !point.timestamp.isBefore(start) &&
                point.timestamp.isBefore(end),
          )
          .toList(growable: false);
      final distanceMeters = lapPoints.fold<double>(
        0,
        (total, point) => total + point.distanceFromPrevMeters,
      );
      final ascentMeters = _ascent(lapPoints);
      final hrRows = heartRateRecords.where(
        (record) =>
            !record.dateFrom.isBefore(start) && record.dateFrom.isBefore(end),
      );
      final hrCount = hrRows.length;
      final avgHr =
          hrCount == 0
              ? null
              : hrRows.fold<double>(0, (sum, record) => sum + record.value) /
                  hrCount;

      laps.add(
        ActivityLapSummary(
          index: laps.length + 1,
          startedAt: start,
          endedAt: end,
          distanceMeters: distanceMeters,
          elapsedSeconds: end.difference(start).inSeconds.clamp(0, 1 << 31),
          ascentMeters: ascentMeters,
          avgHeartRate: avgHr,
        ),
      );
    }
    return laps;
  }

  double _ascent(List<ActivityPoint> points) {
    if (points.length < 2) return 0;
    var ascent = 0.0;
    ActivityPoint? previous;
    for (final point in points) {
      if (previous != null) {
        final prevAlt =
            previous.altitudeCorrectedMeters ?? previous.altitudeMeters;
        final alt = point.altitudeCorrectedMeters ?? point.altitudeMeters;
        if (prevAlt != null && alt != null && alt > prevAlt) {
          ascent += alt - prevAlt;
        }
      }
      previous = point;
    }
    return ascent;
  }
}
