import '../database/database.dart';

class CadenceSample {
  final int elapsedSeconds;
  final double stepsPerMinute;
  final int steps;
  final DateTime startedAt;
  final DateTime endedAt;

  const CadenceSample({
    required this.elapsedSeconds,
    required this.stepsPerMinute,
    required this.steps,
    required this.startedAt,
    required this.endedAt,
  });
}

class CadenceAnalysis {
  final bool applicable;
  final String status;
  final double? averageStepsPerMinute;
  final double? maxStepsPerMinute;
  final int totalSteps;
  final List<CadenceSample> samples;
  final List<String> sources;

  const CadenceAnalysis({
    required this.applicable,
    required this.status,
    required this.averageStepsPerMinute,
    required this.maxStepsPerMinute,
    required this.totalSteps,
    required this.samples,
    required this.sources,
  });

  bool get available => samples.isNotEmpty && averageStepsPerMinute != null;
}

class CadenceAnalysisService {
  CadenceAnalysis analyze({
    required ActivitySession session,
    required List<HealthRecord> stepRecords,
  }) {
    if (!_isStepBasedSport(session)) {
      return const CadenceAnalysis(
        applicable: false,
        status:
            'Cadence is currently calculated only for run, walk, hike, and mountaineering activities.',
        averageStepsPerMinute: null,
        maxStepsPerMinute: null,
        totalSteps: 0,
        samples: [],
        sources: [],
      );
    }

    final endedAt = session.endedAt ?? DateTime.now();
    if (!endedAt.isAfter(session.startedAt)) {
      return const CadenceAnalysis(
        applicable: true,
        status: 'Activity duration is too short for cadence analysis.',
        averageStepsPerMinute: null,
        maxStepsPerMinute: null,
        totalSteps: 0,
        samples: [],
        sources: [],
      );
    }

    final samples = <CadenceSample>[];
    final sources = <String>{};
    var totalSteps = 0;
    var weightedCadence = 0.0;
    var weightedMinutes = 0.0;
    double? maxCadence;

    for (final record in stepRecords) {
      if (record.value <= 0) continue;
      final overlapStart =
          record.dateFrom.isAfter(session.startedAt)
              ? record.dateFrom
              : session.startedAt;
      final overlapEnd =
          record.dateTo.isBefore(endedAt) ? record.dateTo : endedAt;
      if (!overlapEnd.isAfter(overlapStart)) continue;

      final recordSeconds = record.dateTo.difference(record.dateFrom).inSeconds;
      final overlapSeconds = overlapEnd.difference(overlapStart).inSeconds;
      if (recordSeconds <= 0 || overlapSeconds <= 0) continue;

      final overlapRatio = (overlapSeconds / recordSeconds).clamp(0.0, 1.0);
      final steps = (record.value * overlapRatio).round();
      if (steps <= 0) continue;

      final minutes = overlapSeconds / 60.0;
      final cadence = steps / minutes;
      if (cadence <= 0 || cadence.isNaN || cadence.isInfinite) continue;

      final source = (record.sourceName ?? record.sourceId ?? '').trim();
      if (source.isNotEmpty) sources.add(source);
      totalSteps += steps;
      weightedCadence += cadence * minutes;
      weightedMinutes += minutes;
      maxCadence =
          maxCadence == null || cadence > maxCadence ? cadence : maxCadence;
      samples.add(
        CadenceSample(
          elapsedSeconds:
              overlapStart
                  .difference(session.startedAt)
                  .inSeconds
                  .clamp(0, 1 << 31)
                  .toInt(),
          stepsPerMinute: cadence,
          steps: steps,
          startedAt: overlapStart,
          endedAt: overlapEnd,
        ),
      );
    }

    samples.sort((a, b) => a.startedAt.compareTo(b.startedAt));
    if (samples.isEmpty || weightedMinutes <= 0) {
      return const CadenceAnalysis(
        applicable: true,
        status:
            'Step cadence sensor/export not found for this activity timerange.',
        averageStepsPerMinute: null,
        maxStepsPerMinute: null,
        totalSteps: 0,
        samples: [],
        sources: [],
      );
    }

    return CadenceAnalysis(
      applicable: true,
      status: 'Step cadence calculated from overlapping Health Connect steps.',
      averageStepsPerMinute: weightedCadence / weightedMinutes,
      maxStepsPerMinute: maxCadence,
      totalSteps: totalSteps,
      samples: samples,
      sources: sources.toList(growable: false)..sort(),
    );
  }

  bool _isStepBasedSport(ActivitySession session) {
    final value =
        '${session.sportKey} ${session.sportName} ${session.category}'
            .toLowerCase();
    return value.contains('running') ||
        value.contains('walking') ||
        value.contains('hiking') ||
        value.contains('mountaineering') ||
        value.contains('treadmill') ||
        value.contains('rope') ||
        value.contains('skating');
  }
}
