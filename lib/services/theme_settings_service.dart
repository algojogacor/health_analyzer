import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeSettingsService {
  static const _themeModeKey = 'appearance.theme_mode';

  final FlutterSecureStorage storage;

  const ThemeSettingsService({required this.storage});

  Future<ThemeMode> loadThemeMode() async {
    final raw = await storage.read(key: _themeModeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return storage.write(key: _themeModeKey, value: value);
  }
}
