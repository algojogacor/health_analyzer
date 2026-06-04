import 'package:flutter/material.dart';

import 'features/dashboard/dashboard_page.dart';

class HealthAnalyzerApp extends StatelessWidget {
  const HealthAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}
