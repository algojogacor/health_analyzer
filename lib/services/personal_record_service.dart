import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class PersonalRecordService {
  final AppDatabase db;
  final _uuid = const Uuid();

  PersonalRecordService(this.db);

  Future<List<PersonalRecord>> rebuildAndLoadRecords({int limit = 30}) async {
    final sessions = await db.activitySessionsRecent(500).get();
    final completed = sessions
        .where((session) => session.status == 'completed')
        .where((session) => session.distanceMeters > 0)
        .toList(growable: false);
    final records = _calculate(completed);

    await db.transaction(() async {
      await db.clearPersonalRecords();
      for (final record in records) {
        await db.upsertPersonalRecord(record.toCompanion(_uuid.v4()));
      }
    });

    return db.getRecentPersonalRecords(limit: limit);
  }

  Future<List<PersonalRecord>> recordsForSession(String sessionLocalId) async {
    await rebuildAndLoadRecords();
    return db.getPersonalRecordsForSession(sessionLocalId);
  }

  List<_PersonalRecordDraft> _calculate(List<ActivitySession> sessions) {
    final bestByKey = <String, _PersonalRecordDraft>{};

    for (final session in sessions) {
      _consider(
        bestByKey,
        session,
        recordKey: 'longest_distance',
        label: 'Longest ${session.sportName}',
        metric: 'max_distance',
        value: session.distanceMeters,
        unit: 'meters',
        higherIsBetter: true,
      );

      final avgSpeed = session.avgSpeedMps;
      if (avgSpeed != null && avgSpeed > 0) {
        _consider(
          bestByKey,
          session,
          recordKey: 'best_avg_speed',
          label: 'Best average speed',
          metric: 'max_speed',
          value: avgSpeed,
          unit: 'mps',
          higherIsBetter: true,
        );
      }

      for (final target in _targetsForSport(session.sportKey)) {
        if (session.distanceMeters < target.distanceMeters ||
            session.movingSeconds <= 0) {
          continue;
        }
        final estimatedSeconds =
            session.movingSeconds *
            (target.distanceMeters / session.distanceMeters);
        _consider(
          bestByKey,
          session,
          recordKey: target.key,
          label: target.label,
          metric: 'fastest_time',
          value: estimatedSeconds,
          unit: 'seconds',
          higherIsBetter: false,
        );
      }
    }

    final records = bestByKey.values.toList(growable: false);
    records.sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
    return records;
  }

  void _consider(
    Map<String, _PersonalRecordDraft> bestByKey,
    ActivitySession session, {
    required String recordKey,
    required String label,
    required String metric,
    required double value,
    required String unit,
    required bool higherIsBetter,
  }) {
    final key = '${session.sportKey}:$recordKey';
    final existing = bestByKey[key];
    final better =
        existing == null ||
        (higherIsBetter ? value > existing.value : value < existing.value);
    if (!better) return;

    bestByKey[key] = _PersonalRecordDraft(
      sportKey: session.sportKey,
      recordKey: recordKey,
      label: label,
      metric: metric,
      value: value,
      unit: unit,
      sessionLocalId: session.localId,
      achievedAt: session.startedAt,
    );
  }

  List<_RecordTarget> _targetsForSport(String sportKey) {
    final lower = sportKey.toLowerCase();
    if (lower.contains('cycling')) {
      return const [
        _RecordTarget('fastest_5k', 'Fastest 5K', 5000),
        _RecordTarget('fastest_10k', 'Fastest 10K', 10000),
        _RecordTarget('fastest_20k', 'Fastest 20K', 20000),
        _RecordTarget('fastest_40k', 'Fastest 40K', 40000),
      ];
    }
    if (lower.contains('walking') ||
        lower.contains('hiking') ||
        lower.contains('mountaineering')) {
      return const [
        _RecordTarget('fastest_1k', 'Fastest 1K', 1000),
        _RecordTarget('fastest_5k', 'Fastest 5K', 5000),
        _RecordTarget('fastest_10k', 'Fastest 10K', 10000),
      ];
    }
    if (lower.contains('running')) {
      return const [
        _RecordTarget('fastest_1k', 'Fastest 1K', 1000),
        _RecordTarget('fastest_5k', 'Fastest 5K', 5000),
        _RecordTarget('fastest_10k', 'Fastest 10K', 10000),
        _RecordTarget('fastest_half', 'Fastest half marathon', 21097.5),
        _RecordTarget('fastest_marathon', 'Fastest marathon', 42195),
      ];
    }
    return const [];
  }
}

class _RecordTarget {
  final String key;
  final String label;
  final double distanceMeters;

  const _RecordTarget(this.key, this.label, this.distanceMeters);
}

class _PersonalRecordDraft {
  final String sportKey;
  final String recordKey;
  final String label;
  final String metric;
  final double value;
  final String unit;
  final String sessionLocalId;
  final DateTime achievedAt;

  const _PersonalRecordDraft({
    required this.sportKey,
    required this.recordKey,
    required this.label,
    required this.metric,
    required this.value,
    required this.unit,
    required this.sessionLocalId,
    required this.achievedAt,
  });

  PersonalRecordsCompanion toCompanion(String localId) {
    return PersonalRecordsCompanion.insert(
      localId: localId,
      sportKey: sportKey,
      recordKey: recordKey,
      label: label,
      metric: metric,
      value: value,
      unit: unit,
      sessionLocalId: sessionLocalId,
      achievedAt: achievedAt,
      updatedAt: Value(DateTime.now()),
    );
  }
}
