import '../database/database.dart';
import 'cadence_analysis_service.dart';

class WorkoutNarrativeService {
  const WorkoutNarrativeService();

  String generate({
    required ActivitySession session,
    required List<HealthRecord> heartRateRecords,
    CadenceAnalysis? cadence,
  }) {
    final parts = <String>[];
    final distanceKm = session.distanceMeters / 1000;
    final sport = session.sportName;
    final title = session.title?.trim();
    final headline = title == null || title.isEmpty ? sport : title;

    parts.add(headline);

    if (distanceKm >= 0.1) {
      parts.add('${distanceKm.toStringAsFixed(2)} km');
    }
    if (session.movingSeconds > 0) {
      parts.add('moving ${_duration(session.movingSeconds)}');
    }
    final pace = _pace(session.distanceMeters, session.movingSeconds);
    if (pace != null) parts.add(pace);
    if (session.ascentMeters >= 10) {
      parts.add('+${session.ascentMeters.round()} m ascent');
    }
    final avgHr = _avgHeartRate(heartRateRecords);
    if (avgHr != null) parts.add('avg HR ${avgHr.round()} bpm');
    if (cadence?.available == true) {
      parts.add('cadence ${cadence!.averageStepsPerMinute!.round()} spm');
    }

    final sentence = parts.join(' / ');
    final close = _closing(session, heartRateRecords, cadence);
    return '$sentence. $close';
  }

  String _closing(
    ActivitySession session,
    List<HealthRecord> heartRateRecords,
    CadenceAnalysis? cadence,
  ) {
    final gaps = <String>[
      if (session.requiresGps && session.distanceMeters <= 0) 'route',
      if (heartRateRecords.isEmpty) 'heart-rate',
      if (cadence != null && cadence.applicable && !cadence.available)
        'cadence',
    ];
    if (gaps.isEmpty) {
      return 'Clean local summary, ready for private review or a sanitized share card.';
    }
    return 'Some context is unavailable (${gaps.join(', ')}), so the summary keeps those signals out instead of guessing.';
  }

  double? _avgHeartRate(List<HealthRecord> records) {
    if (records.isEmpty) return null;
    return records.fold<double>(0, (sum, record) => sum + record.value) /
        records.length;
  }

  String? _pace(double distanceMeters, int movingSeconds) {
    if (distanceMeters <= 0 || movingSeconds <= 0) return null;
    final secondsPerKm = movingSeconds / (distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds/km';
  }

  String _duration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
