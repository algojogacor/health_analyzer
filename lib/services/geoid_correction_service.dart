import 'dart:convert';
import 'dart:math' as math;

import '../database/database.dart';

class GeoidCorrectionResult {
  final double rawAltitudeMeters;
  final double correctedAltitudeMeters;
  final double geoidUndulationMeters;
  final String model;
  final String confidence;

  const GeoidCorrectionResult({
    required this.rawAltitudeMeters,
    required this.correctedAltitudeMeters,
    required this.geoidUndulationMeters,
    required this.model,
    required this.confidence,
  });

  Map<String, dynamic> toMetadata() {
    return {
      'raw_altitude_meters': rawAltitudeMeters,
      'corrected_altitude_meters': correctedAltitudeMeters,
      'geoid_undulation_meters': geoidUndulationMeters,
      'correction_model': model,
      'confidence': confidence,
      'note':
          'Lightweight local geoid approximation. Use DEM/full EGM grid for survey-grade elevation.',
    };
  }
}

class ElevationCorrectionSummary {
  final int pointCount;
  final int rawAltitudeCount;
  final int correctedAltitudeCount;
  final List<String> models;

  const ElevationCorrectionSummary({
    required this.pointCount,
    required this.rawAltitudeCount,
    required this.correctedAltitudeCount,
    required this.models,
  });

  bool get hasAltitude => rawAltitudeCount > 0 || correctedAltitudeCount > 0;
  bool get hasCorrection => correctedAltitudeCount > 0;

  String get status {
    if (pointCount == 0) return 'no_route_points';
    if (!hasAltitude) return 'altitude_sensor_not_found';
    if (hasCorrection) return 'corrected';
    return 'raw_altitude_only';
  }

  String get primaryModel => models.isEmpty ? 'none' : models.first;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'point_count': pointCount,
      'raw_altitude_points': rawAltitudeCount,
      'corrected_altitude_points': correctedAltitudeCount,
      'models': models,
      'sensor_policy':
          'Elevation is reported only when GPS altitude exists. Missing altitude remains unavailable and is not inferred.',
    };
  }
}

class GeoidCorrectionService {
  static const modelName = 'egm96-lite-harmonic-v1';
  static const confidence = 'coarse_mobile';

  const GeoidCorrectionService();

  GeoidCorrectionResult? correctAltitude({
    required double latitude,
    required double longitude,
    required double? rawAltitudeMeters,
  }) {
    if (rawAltitudeMeters == null || !rawAltitudeMeters.isFinite) return null;
    if (!_validCoordinate(latitude, longitude)) return null;

    final undulation = estimateGeoidUndulationMeters(latitude, longitude);
    final corrected = rawAltitudeMeters - undulation;
    if (!corrected.isFinite) return null;

    return GeoidCorrectionResult(
      rawAltitudeMeters: rawAltitudeMeters,
      correctedAltitudeMeters: corrected,
      geoidUndulationMeters: undulation,
      model: modelName,
      confidence: confidence,
    );
  }

  /// Lightweight geoid undulation approximation in meters.
  ///
  /// This is deliberately small enough for mobile recording and gives a stable
  /// local sea-level correction without shipping a multi-megabyte EGM grid.
  /// Full EGM96/EGM2008 grid or DEM tiles can replace this service later.
  double estimateGeoidUndulationMeters(double latitude, double longitude) {
    if (!_validCoordinate(latitude, longitude)) return 0;
    final lat = _rad(latitude);
    final lon = _rad(longitude);
    final undulation =
        -2.0 +
        24.0 * math.sin(lat) * math.sin(lat) -
        18.0 * math.cos(lat) * math.cos(lon + _rad(20)) +
        11.0 * math.sin(2 * lat) * math.sin(lon - _rad(40)) +
        7.0 * math.cos(3 * lat) * math.sin(2 * lon) -
        4.0 * math.sin(4 * lon) * math.cos(lat);
    return undulation.clamp(-110.0, 90.0).toDouble();
  }

  ElevationCorrectionSummary summarizePoints(List<ActivityPoint> points) {
    final models = <String>{};
    var raw = 0;
    var corrected = 0;
    for (final point in points) {
      if (point.altitudeMeters != null) raw++;
      if (point.altitudeCorrectedMeters != null) corrected++;
      final model = _metadataMap(point.metadata)['elevation'];
      if (model is Map) {
        final value = model['correction_model']?.toString().trim();
        if (value != null && value.isNotEmpty) models.add(value);
      }
    }
    return ElevationCorrectionSummary(
      pointCount: points.length,
      rawAltitudeCount: raw,
      correctedAltitudeCount: corrected,
      models: models.toList(growable: false)..sort(),
    );
  }

  Map<String, dynamic> gpxElevationMetadata() {
    return {
      'source': 'gpx_ele',
      'correction_model': 'gpx_ele_assumed_orthometric',
      'confidence': 'imported',
      'note':
          'GPX elevation is stored as corrected because GPX ele normally represents elevation above mean sea level.',
    };
  }

  bool _validCoordinate(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  double _rad(double degrees) => degrees * math.pi / 180;

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
