import 'package:flutter/material.dart';

import 'features/dashboard/dashboard_page.dart';
import 'shared/theme/app_theme.dart';

class HealthAnalyzerApp extends StatelessWidget {
  const HealthAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Analyzer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}
