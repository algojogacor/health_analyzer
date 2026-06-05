import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TrainingGoals {
  final int dailySteps;
  final int weeklyActiveDays;
  final int weeklyActiveMinutes;
  final double weeklyDistanceKm;
  final int sleepTargetMinutes;

  const TrainingGoals({
    required this.dailySteps,
    required this.weeklyActiveDays,
    required this.weeklyActiveMinutes,
    required this.weeklyDistanceKm,
    required this.sleepTargetMinutes,
  });

  static const defaults = TrainingGoals(
    dailySteps: 10000,
    weeklyActiveDays: 5,
    weeklyActiveMinutes: 150,
    weeklyDistanceKm: 20,
    sleepTargetMinutes: 480,
  );

  int get weeklyStepTarget => dailySteps * 7;

  String get sleepTargetLabel {
    final hours = sleepTargetMinutes / 60;
    return '${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)} h';
  }
}

class TrainingGoalService {
  static const dailyStepsKey = 'training_goal.daily_steps';
  static const weeklyActiveDaysKey = 'training_goal.weekly_active_days';
  static const weeklyActiveMinutesKey = 'training_goal.weekly_active_minutes';
  static const weeklyDistanceKmKey = 'training_goal.weekly_distance_km';
  static const sleepTargetMinutesKey = 'training_goal.sleep_target_minutes';

  final FlutterSecureStorage storage;

  const TrainingGoalService({required this.storage});

  Future<TrainingGoals> loadGoals() async {
    final defaults = TrainingGoals.defaults;
    return TrainingGoals(
      dailySteps: _clampInt(
        await _readInt(dailyStepsKey),
        min: 1000,
        max: 50000,
        fallback: defaults.dailySteps,
      ),
      weeklyActiveDays: _clampInt(
        await _readInt(weeklyActiveDaysKey),
        min: 1,
        max: 7,
        fallback: defaults.weeklyActiveDays,
      ),
      weeklyActiveMinutes: _clampInt(
        await _readInt(weeklyActiveMinutesKey),
        min: 30,
        max: 1500,
        fallback: defaults.weeklyActiveMinutes,
      ),
      weeklyDistanceKm: _clampDouble(
        await _readDouble(weeklyDistanceKmKey),
        min: 0,
        max: 500,
        fallback: defaults.weeklyDistanceKm,
      ),
      sleepTargetMinutes: _clampInt(
        await _readInt(sleepTargetMinutesKey),
        min: 240,
        max: 720,
        fallback: defaults.sleepTargetMinutes,
      ),
    );
  }

  Future<void> saveGoals(TrainingGoals goals) async {
    await Future.wait([
      storage.write(key: dailyStepsKey, value: goals.dailySteps.toString()),
      storage.write(
        key: weeklyActiveDaysKey,
        value: goals.weeklyActiveDays.toString(),
      ),
      storage.write(
        key: weeklyActiveMinutesKey,
        value: goals.weeklyActiveMinutes.toString(),
      ),
      storage.write(
        key: weeklyDistanceKmKey,
        value: goals.weeklyDistanceKm.toStringAsFixed(1),
      ),
      storage.write(
        key: sleepTargetMinutesKey,
        value: goals.sleepTargetMinutes.toString(),
      ),
    ]);
  }

  Future<void> resetDefaults() => saveGoals(TrainingGoals.defaults);

  Future<int?> _readInt(String key) async {
    final raw = await storage.read(key: key);
    return int.tryParse(raw ?? '');
  }

  Future<double?> _readDouble(String key) async {
    final raw = await storage.read(key: key);
    return double.tryParse(raw ?? '');
  }

  int _clampInt(
    int? value, {
    required int min,
    required int max,
    required int fallback,
  }) {
    return (value ?? fallback).clamp(min, max).toInt();
  }

  double _clampDouble(
    double? value, {
    required double min,
    required double max,
    required double fallback,
  }) {
    return (value ?? fallback).clamp(min, max).toDouble();
  }
}
