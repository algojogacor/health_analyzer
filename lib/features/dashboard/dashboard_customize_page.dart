import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';

class DashboardCustomizePage extends ConsumerStatefulWidget {
  const DashboardCustomizePage({super.key});

  @override
  ConsumerState<DashboardCustomizePage> createState() =>
      _DashboardCustomizePageState();
}

class _DashboardCustomizePageState
    extends ConsumerState<DashboardCustomizePage> {
  Set<String>? _visibleKeys;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(dashboardWidgetPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Customize dashboard')),
      body: preferences.when(
        data: (prefs) {
          _visibleKeys ??= Set<String>.from(prefs.visibleKeys);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Text(
                'Show widgets',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Hide widgets you do not need. Preferences are saved locally on this phone.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: dashboardWidgetDefinitions
                      .map(
                        (item) => SwitchListTile(
                          title: Text(item.label),
                          value: _visibleKeys!.contains(item.key),
                          onChanged: (enabled) {
                            setState(() {
                              if (enabled) {
                                _visibleKeys!.add(item.key);
                              } else {
                                _visibleKeys!.remove(item.key);
                              }
                            });
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon:
                    _saving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Saving' : 'Save dashboard'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Customize unavailable: $error'),
            ),
      ),
    );
  }

  Future<void> _save() async {
    final visible = _visibleKeys ?? <String>{};
    setState(() => _saving = true);
    try {
      await saveDashboardWidgetPreferences(visible);
      ref.invalidate(dashboardWidgetPreferencesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dashboard preferences saved')),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
