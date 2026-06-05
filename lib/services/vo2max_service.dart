import '../database/database.dart';
import 'fitness_profile_service.dart';

class Vo2MaxSample {
  final String sessionLocalId;
  final DateTime date;
  final String sportName;
  final double estimate;
  final double avgHeartRate;
  final double paceSecondsPerKm;
  final String confidence;

  const Vo2MaxSample({
    required this.sessionLocalId,
    required this.date,
    required this.sportName,
    required this.estimate,
    required this.avgHeartRate,
    required this.paceSecondsPerKm,
    required this.confidence,
  });
}

class Vo2MaxSummary {
  final bool available;
  final String status;
  final String sensorStatus;
  final Vo2MaxSample? latest;
  final double? trendDelta;
  final List<Vo2MaxSample> samples;

  const Vo2MaxSummary({
    required this.available,
    required this.status,
    required this.sensorStatus,
    required this.latest,
    required this.trendDelta,
    required this.samples,
  });
}

class Vo2MaxService {
  final AppDatabase db;
  final FitnessProfileService fitnessProfileService;

  const Vo2MaxService({required this.db, required this.fitnessProfileService});

  Future<Vo2MaxSummary> estimate() async {
    final profile = await fitnessProfileService.loadProfile();
    final maxHr = profile.maxHeartRate;
    if (maxHr == null) {
      return const Vo2MaxSummary(
        available: false,
        status: 'Max HR profile is required for VO2max trend estimate.',
        sensorStatus: 'max_hr_not_configured',
        latest: null,
        trendDelta: null,
        samples: [],
      );
    }

    final sessions = (await db.activitySessionsRecent(120).get())
        .where(_eligibleSession)
        .toList(growable: false);
    final samples = <Vo2MaxSample>[];
    for (final session in sessions) {
      final end = session.endedAt ?? session.startedAt;
      final hrRecords = (await db.getRecordsBetween(session.startedAt, end))
          .where((record) => record.dataType == 'HEART_RATE')
          .toList(growable: false);
      if (hrRecords.length < 3) continue;
      final avgHr =
          hrRecords.fold<double>(0, (sum, record) => sum + record.value) /
          hrRecords.length;
      if (avgHr <= 0 || avgHr >= maxHr) continue;

      final speedMps = session.distanceMeters / session.movingSeconds;
      final speedMetersPerMinute = speedMps * 60;
      final oxygenCost = 3.5 + (0.2 * speedMetersPerMinute);
      final estimate = (oxygenCost * (maxHr / avgHr)).clamp(15, 85).toDouble();
      samples.add(
        Vo2MaxSample(
          sessionLocalId: session.localId,
          date: session.startedAt,
          sportName: session.sportName,
          estimate: estimate,
          avgHeartRate: avgHr,
          paceSecondsPerKm: 1000 / speedMps,
          confidence: hrRecords.length >= 12 ? 'medium' : 'low',
        ),
      );
    }

    samples.sort((a, b) => b.date.compareTo(a.date));
    if (samples.isEmpty) {
      return const Vo2MaxSummary(
        available: false,
        status:
            'Need a completed run with overlapping heart-rate records. If your band does not sync HR for workouts, this metric stays unavailable.',
        sensorStatus: 'heart_rate_overlap_not_found',
        latest: null,
        trendDelta: null,
        samples: [],
      );
    }

    final latest = samples.first;
    final trendDelta =
        samples.length >= 3
            ? latest.estimate -
                (samples
                        .skip(1)
                        .take(3)
                        .fold<double>(
                          0,
                          (sum, sample) => sum + sample.estimate,
                        ) /
                    samples.skip(1).take(3).length)
            : null;
    return Vo2MaxSummary(
      available: true,
      status: 'Trend estimate only. Not a clinical or lab VO2max result.',
      sensorStatus: 'heart_rate_overlap_found',
      latest: latest,
      trendDelta: trendDelta,
      samples: samples.take(8).toList(growable: false),
    );
  }

  bool _eligibleSession(ActivitySession session) {
    final sport = session.sportKey.toLowerCase();
    return session.status == 'completed' &&
        sport.contains('running') &&
        session.distanceMeters >= 1000 &&
        session.movingSeconds >= 300;
  }
}
