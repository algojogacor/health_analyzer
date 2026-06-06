import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../shared/widgets/info_panel.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: value.when(
        data:
            (mode) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                const InfoPanel(
                  icon: Icons.contrast_outlined,
                  title: 'Theme mode',
                  body:
                      'Health Analyzer follows your phone by default, with JalaJO light and dark palettes available anytime.',
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color mode',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.system,
                                icon: Icon(Icons.phone_android_outlined),
                                label: Text('System'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                icon: Icon(Icons.light_mode_outlined),
                                label: Text('Light'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                icon: Icon(Icons.dark_mode_outlined),
                                label: Text('Dark'),
                              ),
                            ],
                            selected: {mode},
                            onSelectionChanged:
                                (selection) => _save(ref, selection.first),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Appearance unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  Future<void> _save(WidgetRef ref, ThemeMode mode) async {
    await ref.read(themeSettingsServiceProvider).saveThemeMode(mode);
    ref.invalidate(themeModeProvider);
  }
}
