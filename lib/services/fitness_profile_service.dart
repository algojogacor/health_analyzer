import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FitnessProfile {
  final int? maxHeartRate;
  final int? restingHeartRate;

  const FitnessProfile({this.maxHeartRate, this.restingHeartRate});

  bool get hasHeartRateZones => maxHeartRate != null && maxHeartRate! >= 120;
}

class FitnessProfileService {
  static const maxHeartRateKey = 'fitness_profile.max_heart_rate';
  static const restingHeartRateKey = 'fitness_profile.resting_heart_rate';

  final FlutterSecureStorage storage;

  const FitnessProfileService({required this.storage});

  Future<FitnessProfile> loadProfile() async {
    return FitnessProfile(
      maxHeartRate: _validHr(
        await _readInt(maxHeartRateKey),
        min: 120,
        max: 240,
      ),
      restingHeartRate: _validHr(
        await _readInt(restingHeartRateKey),
        min: 35,
        max: 120,
      ),
    );
  }

  Future<void> saveProfile(FitnessProfile profile) async {
    await Future.wait([
      _writeOptionalInt(maxHeartRateKey, profile.maxHeartRate),
      _writeOptionalInt(restingHeartRateKey, profile.restingHeartRate),
    ]);
  }

  Future<int?> _readInt(String key) async {
    final raw = await storage.read(key: key);
    return int.tryParse(raw ?? '');
  }

  int? _validHr(int? value, {required int min, required int max}) {
    if (value == null || value < min || value > max) return null;
    return value;
  }

  Future<void> _writeOptionalInt(String key, int? value) {
    if (value == null) return storage.delete(key: key);
    return storage.write(key: key, value: value.toString());
  }
}
