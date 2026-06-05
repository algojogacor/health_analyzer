import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingProfile {
  final String displayName;
  final String unitSystem;
  final double? bodyWeightKg;

  const OnboardingProfile({
    required this.displayName,
    required this.unitSystem,
    this.bodyWeightKg,
  });
}

class OnboardingService {
  static const completedKey = 'onboarding.completed.v1';
  static const completedAtKey = 'onboarding.completed_at';
  static const displayNameKey = 'user_profile.display_name';
  static const unitSystemKey = 'user_profile.unit_system';
  static const bodyWeightKgKey = 'user_profile.body_weight_kg';
  static const favoriteSportsKey = 'sport_picker.favorites';

  final FlutterSecureStorage storage;

  const OnboardingService({required this.storage});

  Future<bool> isCompleted() async {
    return (await storage.read(key: completedKey)) == 'true';
  }

  Future<OnboardingProfile> loadProfile() async {
    final displayName = await storage.read(key: displayNameKey) ?? '';
    final unit = await storage.read(key: unitSystemKey) ?? 'metric';
    final weight = double.tryParse(
      await storage.read(key: bodyWeightKgKey) ?? '',
    );
    return OnboardingProfile(
      displayName: displayName,
      unitSystem: unit == 'imperial' ? 'imperial' : 'metric',
      bodyWeightKg: weight == null || weight <= 0 ? null : weight,
    );
  }

  Future<void> saveProfile(OnboardingProfile profile) async {
    await Future.wait([
      storage.write(key: displayNameKey, value: profile.displayName.trim()),
      storage.write(key: unitSystemKey, value: profile.unitSystem),
      profile.bodyWeightKg == null
          ? storage.delete(key: bodyWeightKgKey)
          : storage.write(
            key: bodyWeightKgKey,
            value: profile.bodyWeightKg!.toStringAsFixed(1),
          ),
    ]);
  }

  Future<void> saveFavoriteSports(Set<String> sportKeys) {
    return storage.write(key: favoriteSportsKey, value: sportKeys.join(','));
  }

  Future<void> complete() async {
    final now = DateTime.now().toIso8601String();
    await Future.wait([
      storage.write(key: completedKey, value: 'true'),
      storage.write(key: completedAtKey, value: now),
    ]);
  }
}
