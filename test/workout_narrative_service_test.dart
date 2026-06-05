import 'package:flutter_test/flutter_test.dart';
import 'package:health_analyzer/database/database.dart';
import 'package:health_analyzer/services/workout_narrative_service.dart';

void main() {
  test('generates local narrative without inventing missing sensors', () {
    final start = DateTime(2026, 6, 5, 6);
    final session = ActivitySession(
      id: 1,
      localId: 'session-1',
      title: 'Morning run',
      sportKey: 'outdoor_running',
      sportName: 'Outdoor running',
      category: 'Outdoor Workouts',
      requiresGps: true,
      status: 'completed',
      startedAt: start,
      endedAt: start.add(const Duration(minutes: 30)),
      elapsedSeconds: 1800,
      movingSeconds: 1740,
      stoppedSeconds: 60,
      distanceMeters: 5000,
      caloriesKcal: 0,
      ascentMeters: 22,
      descentMeters: 18,
      manualPausedSeconds: 0,
      tags: '',
      source: 'phone_gps',
      routeVisibility: 'private',
      hideStartEndMeters: 300,
      syncRouteDetail: false,
      writeHealthConnect: true,
      syncStatus: 'pending',
      createdAt: start,
    );

    final narrative = const WorkoutNarrativeService().generate(
      session: session,
      heartRateRecords: const [],
    );

    expect(narrative, contains('Morning run'));
    expect(narrative, contains('5.00 km'));
    expect(narrative, contains('heart-rate'));
    expect(narrative, isNot(contains('avg HR')));
  });
}
