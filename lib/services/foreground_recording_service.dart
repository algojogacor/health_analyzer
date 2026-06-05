import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ForegroundRecordingService {
  static const _channel = MethodChannel('health_analyzer/recording_service');

  const ForegroundRecordingService();

  Future<void> start({
    required String sessionLocalId,
    required String sportName,
    required bool requiresGps,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    await _invoke('start', {
      'sessionLocalId': sessionLocalId,
      'sportName': sportName,
      'requiresGps': requiresGps,
    });
  }

  Future<void> update({
    required String sportName,
    required String status,
    required int elapsedSeconds,
    required int movingSeconds,
    required double distanceMeters,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    await _invoke('update', {
      'sportName': sportName,
      'status': status,
      'elapsedSeconds': elapsedSeconds,
      'movingSeconds': movingSeconds,
      'distanceMeters': distanceMeters,
    });
  }

  Future<void> stop() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    await _invoke('stop');
  }

  Future<void> _invoke(String method, [Map<String, Object?>? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on MissingPluginException {
      // Allows tests and non-Android development hosts to use recorder logic.
    }
  }
}
