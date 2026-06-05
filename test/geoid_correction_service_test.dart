import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_analyzer/database/database.dart';
import 'package:health_analyzer/services/geoid_correction_service.dart';

void main() {
  test('corrects finite GPS altitude and records model metadata', () {
    const service = GeoidCorrectionService();

    final result = service.correctAltitude(
      latitude: -7.2575,
      longitude: 112.7521,
      rawAltitudeMeters: 44,
    );

    expect(result, isNotNull);
    expect(result!.model, GeoidCorrectionService.modelName);
    expect(result.correctedAltitudeMeters, isNot(equals(44)));
    expect(result.toMetadata()['correction_model'], result.model);
  });

  test(
    'keeps correction unavailable for missing altitude or bad coordinate',
    () {
      const service = GeoidCorrectionService();

      expect(
        service.correctAltitude(
          latitude: -7.2575,
          longitude: 112.7521,
          rawAltitudeMeters: null,
        ),
        isNull,
      );
      expect(
        service.correctAltitude(
          latitude: 999,
          longitude: 112.7521,
          rawAltitudeMeters: 20,
        ),
        isNull,
      );
    },
  );

  test('summarizes corrected, raw-only, and missing altitude points', () {
    const service = GeoidCorrectionService();
    final now = DateTime(2026, 6, 5, 8);
    final summary = service.summarizePoints([
      _point(
        now,
        altitude: 10,
        correctedAltitude: 6,
        metadata: {
          'elevation': {'correction_model': GeoidCorrectionService.modelName},
        },
      ),
      _point(now.add(const Duration(seconds: 1)), altitude: 11),
      _point(now.add(const Duration(seconds: 2))),
    ]);

    expect(summary.status, 'corrected');
    expect(summary.rawAltitudeCount, 2);
    expect(summary.correctedAltitudeCount, 1);
    expect(summary.models, contains(GeoidCorrectionService.modelName));
  });
}

ActivityPoint _point(
  DateTime timestamp, {
  double? altitude,
  double? correctedAltitude,
  Map<String, dynamic>? metadata,
}) {
  return ActivityPoint(
    id: 1,
    sessionLocalId: 'session',
    timestamp: timestamp,
    latitude: -7,
    longitude: 112,
    altitudeMeters: altitude,
    altitudeCorrectedMeters: correctedAltitude,
    accuracyMeters: 5,
    speedMps: 1,
    bearingDegrees: null,
    distanceFromPrevMeters: 0,
    moving: true,
    pointQuality: 'good',
    provider: 'test',
    metadata: metadata == null ? null : jsonEncode(metadata),
    createdAt: timestamp,
  );
}
