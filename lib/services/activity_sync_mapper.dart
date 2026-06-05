import 'dart:convert';

import '../database/database.dart';
import 'turso_service.dart';

Map<String, dynamic> activitySessionToTurso(ActivitySession session) {
  return {
    'local_id': session.localId,
    'sport_key': session.sportKey,
    'sport_name': session.sportName,
    'category': session.category,
    'requires_gps': session.requiresGps ? 1 : 0,
    'status': session.status,
    'started_at': TursoService.formatToWib(session.startedAt),
    'ended_at':
        session.endedAt == null
            ? ''
            : TursoService.formatToWib(session.endedAt!),
    'elapsed_seconds': session.elapsedSeconds,
    'moving_seconds': session.movingSeconds,
    'stopped_seconds': session.stoppedSeconds,
    'distance_meters': session.distanceMeters,
    'calories_kcal': session.caloriesKcal,
    'ascent_meters': session.ascentMeters,
    'descent_meters': session.descentMeters,
    'avg_speed_mps': session.avgSpeedMps,
    'max_speed_mps': session.maxSpeedMps,
    'avg_heart_rate': session.avgHeartRate,
    'max_heart_rate': session.maxHeartRate,
    'source': session.source,
    'route_visibility': session.routeVisibility,
    'hide_start_end_meters': session.hideStartEndMeters,
    'sync_route_detail': session.syncRouteDetail ? 1 : 0,
    'write_health_connect': session.writeHealthConnect ? 1 : 0,
    'metadata': _activitySessionMetadata(session),
  };
}

Map<String, dynamic> activityPointToTurso(ActivityPoint point) {
  return {
    'session_local_id': point.sessionLocalId,
    'timestamp': TursoService.formatToWib(point.timestamp),
    'latitude': point.latitude,
    'longitude': point.longitude,
    'altitude_meters': point.altitudeMeters,
    'altitude_corrected_meters': point.altitudeCorrectedMeters,
    'accuracy_meters': point.accuracyMeters,
    'speed_mps': point.speedMps,
    'bearing_degrees': point.bearingDegrees,
    'distance_from_prev_meters': point.distanceFromPrevMeters,
    'moving': point.moving ? 1 : 0,
    'point_quality': point.pointQuality,
    'provider': point.provider ?? '',
    'metadata': point.metadata ?? '',
  };
}

Map<String, dynamic> activitySummaryToTurso(ActivitySummary summary) {
  return {
    'session_local_id': summary.sessionLocalId,
    'json_summary': summary.jsonSummary,
    'markdown_summary': summary.markdownSummary,
    'generated_at': TursoService.formatToWib(summary.generatedAt),
  };
}

String _activitySessionMetadata(ActivitySession session) {
  final metadata = <String, dynamic>{};
  final raw = session.metadata;
  if (raw != null && raw.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        metadata.addAll(decoded);
      } else if (decoded is Map) {
        metadata.addAll(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      metadata['raw_metadata'] = raw;
    }
  }

  metadata['title'] = session.title ?? session.sportName;
  metadata['tags'] = _tagsList(session.tags);
  metadata['manual_paused_seconds'] = session.manualPausedSeconds;
  return jsonEncode(metadata);
}

List<String> _tagsList(String raw) {
  return raw
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList(growable: false);
}
