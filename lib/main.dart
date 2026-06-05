import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'services/background_service.dart';
import 'services/local_notification_service.dart';
import 'services/offline_map_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }
  await OfflineMapService.initialise();
  if (!kIsWeb) {
    await LocalNotificationService().initialize();
  }

  runApp(const ProviderScope(child: HealthAnalyzerApp()));
}
