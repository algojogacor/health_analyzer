import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../models/sport_mode.dart';

/// Service untuk membaca data kesehatan dari Health Connect
class HealthService {
  final Health _health = Health();
  bool _configured = false;

  /// Data types yang relevan untuk Xiaomi Smart Band 9 Active lewat
  /// Mi Fitness -> Health Connect.
  ///
  /// Catatan: skor Stress di Mi Fitness bukan tipe standar Health Connect.
  /// Kita ambil HRV RMSSD kalau Mi Fitness mengekspornya, karena itu sinyal
  /// yang paling dekat untuk konteks stress/recovery.
  static const _dataTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_AWAKE_IN_BED,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_UNKNOWN,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.WORKOUT,
    HealthDataType.SPEED,
    HealthDataType.WEIGHT,
  ];

  List<HealthDataType> _availableTypes(List<HealthDataType> types) {
    return types.where(_health.isDataTypeAvailable).toList(growable: false);
  }

  Future<bool> _requestAuthorizationBestEffort(
    List<HealthDataType> types,
    List<HealthDataAccess> permissions,
  ) async {
    if (types.isEmpty) return false;
    try {
      return await _health.requestAuthorization(
        types,
        permissions: permissions,
      );
    } catch (error) {
      debugPrint('Health authorization batch failed: $error');
    }

    var grantedAny = false;
    for (var index = 0; index < types.length; index++) {
      try {
        final granted = await _health.requestAuthorization(
          [types[index]],
          permissions: [permissions[index]],
        );
        grantedAny = grantedAny || granted;
      } catch (error) {
        debugPrint('Health authorization skipped ${types[index].name}: $error');
      }
    }
    return grantedAny;
  }

  /// Inisialisasi Health Connect
  Future<void> initialize() async {
    if (_configured) return;
    await _health.configure();

    // Pastikan Health Connect tersedia di Android
    if (Platform.isAndroid) {
      final status = await _health.getHealthConnectSdkStatus();
      if (status != HealthConnectSdkStatus.sdkAvailable) {
        await _health.installHealthConnect();
      }
    }
    _configured = true;
  }

  /// Minta izin akses data
  Future<bool> requestPermissions() async {
    await initialize();
    final types = _availableTypes(_dataTypes);
    final permissions = List.filled(types.length, HealthDataAccess.READ);
    final foregroundGranted = await _requestAuthorizationBestEffort(
      types,
      permissions,
    );

    // Best-effort: diperlukan agar WorkManager bisa membaca Health Connect
    // saat app tidak sedang dibuka. Tidak semua versi Health Connect mendukung.
    await requestBackgroundPermission();

    return foregroundGranted;
  }

  /// Cek apakah izin baca sudah diberikan.
  ///
  /// Background task tidak bisa memunculkan dialog permission, jadi method ini
  /// dipakai untuk memastikan app pernah diberi akses saat berjalan di foreground.
  Future<bool> hasPermissions() async {
    await initialize();
    final types = _availableTypes(_dataTypes);
    if (types.isEmpty) return false;
    final permissions = List.filled(types.length, HealthDataAccess.READ);
    try {
      return await _health.hasPermissions(types, permissions: permissions) ??
          false;
    } catch (error) {
      debugPrint('Health permission check failed: $error');
      return false;
    }
  }

  /// Minta izin baca Health Connect di background jika tersedia di Android.
  ///
  /// Izin ini terpisah dari izin data biasa. Kalau tidak tersedia, foreground
  /// collect tetap bisa berjalan dan periodic task tetap akan sync antrean lokal.
  Future<bool> requestBackgroundPermission() async {
    await initialize();
    if (!Platform.isAndroid) return true;

    final available = await _health.isHealthDataInBackgroundAvailable();
    if (!available) return false;

    final authorized = await _health.isHealthDataInBackgroundAuthorized();
    if (authorized) return true;

    return _health.requestHealthDataInBackgroundAuthorization();
  }

  /// Cek izin background Health Connect untuk periodic collection.
  Future<bool> hasBackgroundPermission() async {
    await initialize();
    if (!Platform.isAndroid) return true;

    final available = await _health.isHealthDataInBackgroundAvailable();
    if (!available) return false;

    return _health.isHealthDataInBackgroundAuthorized();
  }

  Future<bool> requestWorkoutWritePermissions() async {
    await initialize();
    final types = _availableTypes([
      HealthDataType.WORKOUT,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.TOTAL_CALORIES_BURNED,
    ]);
    final permissions = List.filled(types.length, HealthDataAccess.WRITE);
    return _requestAuthorizationBestEffort(types, permissions);
  }

  Future<bool> writeWorkoutSummary({
    required SportMode sportMode,
    required DateTime start,
    required DateTime end,
    required double distanceMeters,
    required double caloriesKcal,
  }) async {
    await initialize();
    final granted = await requestWorkoutWritePermissions();
    if (!granted) return false;

    return _health.writeWorkoutData(
      activityType: _workoutTypeFor(sportMode),
      start: start,
      end: end,
      totalDistance: distanceMeters > 0 ? distanceMeters.round() : null,
      totalEnergyBurned: caloriesKcal > 0 ? caloriesKcal.round() : null,
      title: sportMode.name,
    );
  }

  HealthWorkoutActivityType _workoutTypeFor(SportMode sportMode) {
    return switch (sportMode.key) {
      'outdoor_running' ||
      'cross_country_running' => HealthWorkoutActivityType.RUNNING,
      'walking' => HealthWorkoutActivityType.WALKING,
      'hiking' || 'mountaineering' => HealthWorkoutActivityType.HIKING,
      'outdoor_cycling' => HealthWorkoutActivityType.BIKING,
      'indoor_cycling' => HealthWorkoutActivityType.BIKING_STATIONARY,
      'indoor_running' => HealthWorkoutActivityType.RUNNING_TREADMILL,
      'rope_jumping' => HealthWorkoutActivityType.JUMP_ROPE,
      'hiit' => HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
      'yoga' => HealthWorkoutActivityType.YOGA,
      'elliptical_machine' => HealthWorkoutActivityType.ELLIPTICAL,
      'rowing_machine' => HealthWorkoutActivityType.ROWING_MACHINE,
      'pilates' => HealthWorkoutActivityType.PILATES,
      'strength_training' => HealthWorkoutActivityType.STRENGTH_TRAINING,
      'stair_climbing' => HealthWorkoutActivityType.STAIR_CLIMBING,
      'weightlifting' => HealthWorkoutActivityType.WEIGHTLIFTING,
      'tennis' => HealthWorkoutActivityType.TENNIS,
      'basketball' => HealthWorkoutActivityType.BASKETBALL,
      'golf' => HealthWorkoutActivityType.GOLF,
      'football' => HealthWorkoutActivityType.SOCCER,
      'volleyball' => HealthWorkoutActivityType.VOLLEYBALL,
      'baseball' => HealthWorkoutActivityType.BASEBALL,
      'rugby' => HealthWorkoutActivityType.RUGBY,
      'table_tennis' => HealthWorkoutActivityType.TABLE_TENNIS,
      'badminton' => HealthWorkoutActivityType.BADMINTON,
      'cricket' => HealthWorkoutActivityType.CRICKET,
      'snowboarding' => HealthWorkoutActivityType.SNOWBOARDING,
      'skiing' => HealthWorkoutActivityType.SKIING,
      'outdoor_skating' => HealthWorkoutActivityType.SKATING,
      'ice_hockey' => HealthWorkoutActivityType.HOCKEY,
      'archery' => HealthWorkoutActivityType.ARCHERY,
      'frisbee' => HealthWorkoutActivityType.FRISBEE_DISC,
      _ => HealthWorkoutActivityType.OTHER,
    };
  }

  /// Ambil data kesehatan dalam rentang waktu tertentu
  Future<List<HealthDataPoint>> fetchHealthData({
    required DateTime start,
    required DateTime end,
    List<HealthDataType>? types,
  }) async {
    await initialize();

    final targetTypes = _availableTypes(types ?? _dataTypes);
    if (targetTypes.isEmpty) return const [];

    final rawData = <HealthDataPoint>[];
    for (final type in targetTypes) {
      try {
        rawData.addAll(
          await _health.getHealthDataFromTypes(
            startTime: start,
            endTime: end,
            types: [type],
          ),
        );
      } catch (error) {
        debugPrint('Health data skipped ${type.name}: $error');
      }
    }

    // Deduplicate
    return _health.removeDuplicates(rawData);
  }

  /// Format HealthDataPoint ke Map untuk dikirim ke Turso
  Map<String, dynamic> toTursoRecord(HealthDataPoint point) {
    final value = point.value;
    double numericValue = 0.0;

    if (value is NumericHealthValue) {
      numericValue = value.numericValue.toDouble();
    }

    return {
      'data_type': point.type.name,
      'value': numericValue,
      'unit': point.unit.name,
      'date_from': point.dateFrom.toUtc().toIso8601String(),
      'date_to': point.dateTo.toUtc().toIso8601String(),
      'source_name': point.sourceName,
      'source_id': point.sourceId,
      'uuid': point.uuid,
    };
  }
}
