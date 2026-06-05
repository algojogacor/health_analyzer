import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VoiceCoachSettings {
  final bool enabled;
  final String languageCode;
  final double speechRate;
  final bool announcePauseResume;
  final bool announceLap;
  final bool announceFinish;
  final bool announceMilestones;
  final bool minimalAudioInterrupt;
  final double volume;

  const VoiceCoachSettings({
    this.enabled = false,
    this.languageCode = 'id-ID',
    this.speechRate = 0.45,
    this.announcePauseResume = true,
    this.announceLap = true,
    this.announceFinish = true,
    this.announceMilestones = true,
    this.minimalAudioInterrupt = true,
    this.volume = 0.88,
  });

  VoiceCoachSettings copyWith({
    bool? enabled,
    String? languageCode,
    double? speechRate,
    bool? announcePauseResume,
    bool? announceLap,
    bool? announceFinish,
    bool? announceMilestones,
    bool? minimalAudioInterrupt,
    double? volume,
  }) {
    return VoiceCoachSettings(
      enabled: enabled ?? this.enabled,
      languageCode: languageCode ?? this.languageCode,
      speechRate: speechRate ?? this.speechRate,
      announcePauseResume: announcePauseResume ?? this.announcePauseResume,
      announceLap: announceLap ?? this.announceLap,
      announceFinish: announceFinish ?? this.announceFinish,
      announceMilestones: announceMilestones ?? this.announceMilestones,
      minimalAudioInterrupt:
          minimalAudioInterrupt ?? this.minimalAudioInterrupt,
      volume: volume ?? this.volume,
    );
  }
}

class VoiceCoachSettingsService {
  static const _enabledKey = 'voice_coach.enabled';
  static const _languageKey = 'voice_coach.language';
  static const _rateKey = 'voice_coach.rate';
  static const _pauseResumeKey = 'voice_coach.pause_resume';
  static const _lapKey = 'voice_coach.lap';
  static const _finishKey = 'voice_coach.finish';
  static const _milestonesKey = 'voice_coach.milestones';
  static const _minimalAudioInterruptKey =
      'voice_coach.minimal_audio_interrupt';
  static const _volumeKey = 'voice_coach.volume';

  final FlutterSecureStorage storage;

  const VoiceCoachSettingsService({required this.storage});

  Future<VoiceCoachSettings> loadSettings() async {
    final enabled = (await storage.read(key: _enabledKey)) == 'true';
    final language = await storage.read(key: _languageKey) ?? 'id-ID';
    final rate =
        double.tryParse(await storage.read(key: _rateKey) ?? '') ?? 0.45;
    final volume =
        double.tryParse(await storage.read(key: _volumeKey) ?? '') ?? 0.88;
    return VoiceCoachSettings(
      enabled: enabled,
      languageCode: language == 'en-US' ? 'en-US' : 'id-ID',
      speechRate: rate.clamp(0.25, 0.85).toDouble(),
      announcePauseResume:
          (await storage.read(key: _pauseResumeKey)) != 'false',
      announceLap: (await storage.read(key: _lapKey)) != 'false',
      announceFinish: (await storage.read(key: _finishKey)) != 'false',
      announceMilestones: (await storage.read(key: _milestonesKey)) != 'false',
      minimalAudioInterrupt:
          (await storage.read(key: _minimalAudioInterruptKey)) != 'false',
      volume: volume.clamp(0.35, 1.0).toDouble(),
    );
  }

  Future<void> saveSettings(VoiceCoachSettings settings) async {
    await Future.wait([
      storage.write(key: _enabledKey, value: settings.enabled.toString()),
      storage.write(key: _languageKey, value: settings.languageCode),
      storage.write(
        key: _rateKey,
        value: settings.speechRate.clamp(0.25, 0.85).toStringAsFixed(2),
      ),
      storage.write(
        key: _pauseResumeKey,
        value: settings.announcePauseResume.toString(),
      ),
      storage.write(key: _lapKey, value: settings.announceLap.toString()),
      storage.write(key: _finishKey, value: settings.announceFinish.toString()),
      storage.write(
        key: _milestonesKey,
        value: settings.announceMilestones.toString(),
      ),
      storage.write(
        key: _minimalAudioInterruptKey,
        value: settings.minimalAudioInterrupt.toString(),
      ),
      storage.write(
        key: _volumeKey,
        value: settings.volume.clamp(0.35, 1.0).toStringAsFixed(2),
      ),
    ]);
  }
}
