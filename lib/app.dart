import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/dashboard/dashboard_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'providers/health_provider.dart';
import 'shared/theme/app_theme.dart';

class HealthAnalyzerApp extends ConsumerWidget {
  const HealthAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).valueOrNull;
    final onboarding = ref.watch(onboardingCompletedProvider);
    return MaterialApp(
      title: 'Health Analyzer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode ?? ThemeMode.system,
      home: onboarding.when(
        data:
            (done) =>
                done
                    ? const HomePage()
                    : OnboardingPage(
                      onComplete:
                          () => ref.invalidate(onboardingCompletedProvider),
                    ),
        loading: () => const _StartupSplash(),
        error: (_, _) => const HomePage(),
      ),
    );
  }
}

class _StartupSplash extends StatelessWidget {
  const _StartupSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
