import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'services/background_service.dart';
import 'services/offline_map_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi WorkManager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await OfflineMapService.initialise();

  runApp(const ProviderScope(child: HealthAnalyzerApp()));
}
