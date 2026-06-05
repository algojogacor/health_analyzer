import 'dart:io';

import 'package:flutter/services.dart';

class AndroidWidgetSnapshot {
  final int steps;
  final int readinessScore;
  final String readinessLabel;
  final DateTime updatedAt;

  const AndroidWidgetSnapshot({
    required this.steps,
    required this.readinessScore,
    required this.readinessLabel,
    required this.updatedAt,
  });

  String get signature =>
      '$steps|$readinessScore|$readinessLabel|${updatedAt.hour}:${updatedAt.minute}';
}

class AndroidWidgetService {
  static const _channel = MethodChannel('health_analyzer/widget');

  const AndroidWidgetService();

  Future<void> updateHomeWidget(AndroidWidgetSnapshot snapshot) async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('updateHomeWidget', {
      'steps': snapshot.steps,
      'readinessScore': snapshot.readinessScore,
      'readinessLabel': snapshot.readinessLabel,
      'updatedAt': _updatedLabel(snapshot.updatedAt),
    });
  }

  String _updatedLabel(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return 'Updated ${two(value.hour)}:${two(value.minute)}';
  }
}
