import '../database/database.dart';
import 'fitness_profile_service.dart';

class HeartRateZoneSummary {
  final int zone;
  final String label;
  final int minBpm;
  final int maxBpm;
  final int seconds;
  final double percent;

  const HeartRateZoneSummary({
    required this.zone,
    required this.label,
    required this.minBpm,
    required this.maxBpm,
    required this.seconds,
    required this.percent,
  });
}

class HeartRateZoneResult {
  final int maxHeartRate;
  final int totalSeconds;
  final List<HeartRateZoneSummary> zones;

  const HeartRateZoneResult({
    required this.maxHeartRate,
    required this.totalSeconds,
    required this.zones,
  });
}

class HeartRateZoneService {
  HeartRateZoneResult? analyze({
    required FitnessProfile profile,
    required List<HealthRecord> heartRateRecords,
  }) {
    final maxHr = profile.maxHeartRate;
    if (maxHr == null || heartRateRecords.length < 2) return null;

    final sorted = [...heartRateRecords]
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    final secondsByZone = List<int>.filled(5, 0);

    for (var i = 0; i < sorted.length; i++) {
      final current = sorted[i];
      final nextTime =
          i + 1 < sorted.length ? sorted[i + 1].dateFrom : current.dateTo;
      final seconds =
          nextTime.difference(current.dateFrom).inSeconds.clamp(0, 120).toInt();
      if (seconds <= 0) continue;
      final zoneIndex = _zoneIndex(current.value, maxHr);
      secondsByZone[zoneIndex] += seconds;
    }

    final total = secondsByZone.fold<int>(0, (sum, value) => sum + value);
    if (total <= 0) return null;

    return HeartRateZoneResult(
      maxHeartRate: maxHr,
      totalSeconds: total,
      zones: List.generate(5, (index) {
        final range = _rangeFor(index + 1, maxHr);
        final seconds = secondsByZone[index];
        return HeartRateZoneSummary(
          zone: index + 1,
          label: _labelFor(index + 1),
          minBpm: range.min,
          maxBpm: range.max,
          seconds: seconds,
          percent: seconds / total,
        );
      }),
    );
  }

  int _zoneIndex(double bpm, int maxHr) {
    final pct = bpm / maxHr;
    if (pct < 0.6) return 0;
    if (pct < 0.7) return 1;
    if (pct < 0.8) return 2;
    if (pct < 0.9) return 3;
    return 4;
  }

  ({int min, int max}) _rangeFor(int zone, int maxHr) {
    final ranges = switch (zone) {
      1 => (min: 0.50, max: 0.59),
      2 => (min: 0.60, max: 0.69),
      3 => (min: 0.70, max: 0.79),
      4 => (min: 0.80, max: 0.89),
      _ => (min: 0.90, max: 1.00),
    };
    return (
      min: (ranges.min * maxHr).round(),
      max: (ranges.max * maxHr).round(),
    );
  }

  String _labelFor(int zone) {
    return switch (zone) {
      1 => 'Easy',
      2 => 'Fat burn',
      3 => 'Aerobic',
      4 => 'Threshold',
      _ => 'Peak',
    };
  }
}
