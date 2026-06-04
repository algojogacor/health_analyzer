import 'dart:convert';

import '../database/database.dart';
import 'activity_analysis_service.dart';

class ActivityAiSummaryDraft {
  final String jsonSummary;
  final String markdownSummary;

  const ActivityAiSummaryDraft({
    required this.jsonSummary,
    required this.markdownSummary,
  });
}

class ActivityAiSummaryService {
  final ActivityAnalysisService analysisService;

  const ActivityAiSummaryService(this.analysisService);

  ActivityAiSummaryDraft generate({
    required ActivitySession session,
    required List<ActivityPoint> points,
    required List<HealthRecord> heartRateRecords,
  }) {
    final analysis = analysisService.analyze(session, points);
    final gpsQuality = analysis.gpsQuality;
    final metadata = _metadataMap(session.metadata);
    final autoPauseSegments =
        metadata['stopped_segments'] is List
            ? metadata['stopped_segments'] as List<dynamic>
            : const <dynamic>[];
    final healthContext = _healthContext(heartRateRecords);
    final dataGaps = _dataGaps(session, points, heartRateRecords);
    final pace = _paceText(session.distanceMeters, session.movingSeconds);

    final summary = <String, dynamic>{
      'sport': {
        'key': session.sportKey,
        'name': session.sportName,
        'category': session.category,
      },
      'date': {
        'started_at': session.startedAt.toIso8601String(),
        'ended_at': session.endedAt?.toIso8601String(),
      },
      'duration': {
        'elapsed_seconds': session.elapsedSeconds,
        'moving_seconds': session.movingSeconds,
        'stopped_seconds': session.stoppedSeconds,
      },
      'distance': {
        'meters': session.distanceMeters,
        'kilometers': session.distanceMeters / 1000,
      },
      'pace': {
        'text': pace,
        'avg_speed_mps': session.avgSpeedMps,
        'max_speed_mps': session.maxSpeedMps,
      },
      'ascent': {
        'ascent_meters': session.ascentMeters,
        'descent_meters': session.descentMeters,
      },
      'auto_pause_segments': autoPauseSegments,
      'gps_quality': {
        'good': gpsQuality.good,
        'usable': gpsQuality.usable,
        'low': gpsQuality.low,
        'unknown': gpsQuality.unknown,
        'total': gpsQuality.total,
      },
      'privacy_status': {
        'route_visibility': session.routeVisibility,
        'hide_start_end_meters': session.hideStartEndMeters,
        'sync_route_detail': session.syncRouteDetail,
        'raw_route_points_included': false,
      },
      'data_gaps': dataGaps,
      'health_context': healthContext,
    };

    return ActivityAiSummaryDraft(
      jsonSummary: jsonEncode(summary),
      markdownSummary: _markdown(session, summary, dataGaps, healthContext),
    );
  }

  Map<String, dynamic> _healthContext(List<HealthRecord> heartRateRecords) {
    if (heartRateRecords.isEmpty) {
      return {
        'heart_rate': {'available': false, 'record_count': 0},
      };
    }
    final values = heartRateRecords.map((record) => record.value).toList();
    final avg =
        values.fold<double>(0, (sum, value) => sum + value) / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    return {
      'heart_rate': {
        'available': true,
        'record_count': heartRateRecords.length,
        'avg_bpm': avg,
        'min_bpm': min,
        'max_bpm': max,
      },
    };
  }

  List<String> _dataGaps(
    ActivitySession session,
    List<ActivityPoint> points,
    List<HealthRecord> heartRateRecords,
  ) {
    final gaps = <String>[];
    if (session.requiresGps && points.length < 2) {
      gaps.add('gps_route_points_missing_or_too_short');
    }
    if (heartRateRecords.isEmpty) {
      gaps.add('heart_rate_overlap_missing');
    }
    if (session.caloriesKcal <= 0) {
      gaps.add('calories_missing');
    }
    if (!session.syncRouteDetail) {
      gaps.add('route_detail_local_only');
    }
    return gaps;
  }

  String _markdown(
    ActivitySession session,
    Map<String, dynamic> summary,
    List<String> dataGaps,
    Map<String, dynamic> healthContext,
  ) {
    final distance = (session.distanceMeters / 1000).toStringAsFixed(2);
    final hr = healthContext['heart_rate'] as Map<String, dynamic>;
    final hrLine =
        hr['available'] == true
            ? 'Heart rate: avg ${(hr['avg_bpm'] as double).round()} bpm, min ${(hr['min_bpm'] as double).round()}, max ${(hr['max_bpm'] as double).round()}.'
            : 'Heart rate: no overlapping records.';
    return '''
# Activity Summary

- Sport: ${session.sportName}
- Started: ${session.startedAt.toIso8601String()}
- Duration: moving ${session.movingSeconds}s, elapsed ${session.elapsedSeconds}s
- Distance: $distance km
- Pace: ${(summary['pace'] as Map<String, dynamic>)['text']}
- Elevation: +${session.ascentMeters.round()} m / -${session.descentMeters.round()} m
- Privacy: ${session.routeVisibility}, hide start/end ${session.hideStartEndMeters.round()} m, route detail sync ${session.syncRouteDetail}
- GPS quality: ${(summary['gps_quality'] as Map<String, dynamic>)['good']} good, ${(summary['gps_quality'] as Map<String, dynamic>)['usable']} usable, ${(summary['gps_quality'] as Map<String, dynamic>)['low']} low, ${(summary['gps_quality'] as Map<String, dynamic>)['unknown']} unknown
- $hrLine
- Data gaps: ${dataGaps.isEmpty ? 'none' : dataGaps.join(', ')}

Wellness/activity analysis only. Do not use this as medical diagnosis.
''';
  }

  String _paceText(double distanceMeters, int movingSeconds) {
    if (distanceMeters <= 0 || movingSeconds <= 0) return '--';
    final secondsPerKm = movingSeconds / (distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds /km';
  }

  Map<String, dynamic> _metadataMap(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return <String, dynamic>{};
    }
    return <String, dynamic>{};
  }
}
