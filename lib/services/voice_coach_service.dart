import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'moving_time_service.dart';
import 'voice_coach_settings_service.dart';

enum VoiceCoachEvent { pause, resume, lap, finish, milestone }

class VoiceCoachService {
  final VoiceCoachSettingsService settingsService;
  final FlutterTts _tts;

  VoiceCoachService({required this.settingsService, FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  Future<void> announce(
    VoiceCoachEvent event, {
    MovingTimeResult? stats,
    int? lapIndex,
    String? customMessage,
  }) async {
    final settings = await settingsService.loadSettings();
    if (!settings.enabled || !_eventEnabled(settings, event)) return;
    final message = customMessage ?? _message(event, stats, lapIndex, settings);
    if (message.trim().isEmpty) return;

    try {
      await _tts.setLanguage(settings.languageCode);
      await _tts.setSpeechRate(settings.speechRate);
      await _tts.setQueueMode(0);
      await _tts.awaitSpeakCompletion(false);
      if (settings.minimalAudioInterrupt) {
        await _tts.setAudioAttributesForNavigation();
      }
      await _tts.setVolume(settings.volume);
      await _tts.setPitch(1.0);
      await _tts.speak(message, focus: settings.minimalAudioInterrupt);
    } catch (error) {
      debugPrint('Voice coach unavailable: $error');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('Voice coach stop failed: $error');
    }
  }

  bool _eventEnabled(VoiceCoachSettings settings, VoiceCoachEvent event) {
    return switch (event) {
      VoiceCoachEvent.pause ||
      VoiceCoachEvent.resume => settings.announcePauseResume,
      VoiceCoachEvent.lap => settings.announceLap,
      VoiceCoachEvent.finish => settings.announceFinish,
      VoiceCoachEvent.milestone => settings.announceMilestones,
    };
  }

  String _message(
    VoiceCoachEvent event,
    MovingTimeResult? stats,
    int? lapIndex,
    VoiceCoachSettings settings,
  ) {
    final id = settings.languageCode == 'id-ID';
    final distance = _distance(stats?.distanceMeters ?? 0);
    final pace = _pace(stats?.distanceMeters ?? 0, stats?.movingSeconds ?? 0);
    return switch (event) {
      VoiceCoachEvent.pause =>
        id
            ? 'Aktivitas dijeda. Jarak $distance.'
            : 'Activity paused. Distance $distance.',
      VoiceCoachEvent.resume =>
        id ? 'Aktivitas dilanjutkan.' : 'Activity resumed.',
      VoiceCoachEvent.lap =>
        id
            ? 'Lap ${lapIndex ?? ''} ditandai. Jarak $distance, pace $pace.'
            : 'Lap ${lapIndex ?? ''} marked. Distance $distance, pace $pace.',
      VoiceCoachEvent.finish =>
        id
            ? 'Aktivitas selesai. Jarak $distance, pace rata-rata $pace.'
            : 'Activity finished. Distance $distance, average pace $pace.',
      VoiceCoachEvent.milestone =>
        id
            ? 'Milestone tercapai. Jarak $distance.'
            : 'Milestone reached. Distance $distance.',
    };
  }

  String _distance(double meters) {
    if (meters < 1000) return '${meters.round()} meter';
    return '${(meters / 1000).toStringAsFixed(2)} kilometer';
  }

  String _pace(double distanceMeters, int movingSeconds) {
    if (distanceMeters <= 0 || movingSeconds <= 0) return '--';
    final secondsPerKm = movingSeconds / (distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds per kilometer';
  }
}
