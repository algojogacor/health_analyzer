import 'package:flutter_test/flutter_test.dart';
import 'package:health_analyzer/database/database.dart';
import 'package:health_analyzer/services/cadence_analysis_service.dart';

void main() {
  test('calculates step cadence from overlapping Health Connect steps', () {
    final start = DateTime(2026, 6, 5, 7);
    final session = _session(
      sportKey: 'outdoor_running',
      sportName: 'Outdoor running',
      start: start,
      end: start.add(const Duration(minutes: 30)),
    );
    final records = [
      _steps(
        value: 900,
        from: start.add(const Duration(minutes: 5)),
        to: start.add(const Duration(minutes: 15)),
      ),
      _steps(
        value: 1200,
        from: start.add(const Duration(minutes: 15)),
        to: start.add(const Duration(minutes: 25)),
      ),
    ];

    final result = CadenceAnalysisService().analyze(
      session: session,
      stepRecords: records,
    );

    expect(result.available, isTrue);
    expect(result.totalSteps, 2100);
    expect(result.averageStepsPerMinute?.round(), 105);
    expect(result.maxStepsPerMinute?.round(), 120);
    expect(result.sources, contains('Mi Fitness'));
  });

  test('keeps cadence unavailable when step export is missing', () {
    final start = DateTime(2026, 6, 5, 7);
    final session = _session(
      sportKey: 'outdoor_running',
      sportName: 'Outdoor running',
      start: start,
      end: start.add(const Duration(minutes: 20)),
    );

    final result = CadenceAnalysisService().analyze(
      session: session,
      stepRecords: const [],
    );

    expect(result.applicable, isTrue);
    expect(result.available, isFalse);
    expect(result.status, contains('not found'));
  });
}

ActivitySession _session({
  required String sportKey,
  required String sportName,
  required DateTime start,
  required DateTime end,
}) {
  return ActivitySession(
    id: 1,
    localId: 'session-1',
    sportKey: sportKey,
    sportName: sportName,
    category: 'Outdoor Workouts',
    requiresGps: true,
    status: 'completed',
    startedAt: start,
    endedAt: end,
    elapsedSeconds: end.difference(start).inSeconds,
    movingSeconds: end.difference(start).inSeconds,
    stoppedSeconds: 0,
    distanceMeters: 5000,
    caloriesKcal: 0,
    ascentMeters: 0,
    descentMeters: 0,
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
}

HealthRecord _steps({
  required double value,
  required DateTime from,
  required DateTime to,
}) {
  return HealthRecord(
    id: value.round(),
    dataType: 'STEPS',
    value: value,
    unit: 'COUNT',
    dateFrom: from,
    dateTo: to,
    sourceName: 'Mi Fitness',
    sourceId: 'com.xiaomi.wearable',
    syncStatus: 'synced',
    createdAt: from,
  );
}
