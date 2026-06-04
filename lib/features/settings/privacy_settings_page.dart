import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../shared/widgets/info_panel.dart';

class PrivacySettingsPage extends ConsumerStatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  ConsumerState<PrivacySettingsPage> createState() =>
      _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends ConsumerState<PrivacySettingsPage> {
  String? _initializedKey;
  String _routeVisibility = 'private';
  double _hideStartEndMeters = 300;
  bool _syncRouteDetail = false;
  bool _writeHealthConnect = true;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final defaultsValue = ref.watch(activityPrivacyDefaultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy settings')),
      body: defaultsValue.when(
        data: (defaults) {
          _initialize(defaults);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const InfoPanel(
                icon: Icons.lock_outline,
                title: 'Route privacy defaults',
                body:
                    'These values are applied when a new activity starts. You can still change them before saving each workout.',
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _routeVisibility,
                        decoration: const InputDecoration(
                          labelText: 'Default route visibility',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'private',
                            child: Text('Private'),
                          ),
                          DropdownMenuItem(
                            value: 'followers',
                            child: Text('Followers'),
                          ),
                          DropdownMenuItem(
                            value: 'public',
                            child: Text('Public'),
                          ),
                        ],
                        onChanged:
                            (value) => setState(
                              () => _routeVisibility = value ?? 'private',
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Hide start/end: ${_hideStartEndMeters.round()} m',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Slider(
                        value: _hideStartEndMeters.clamp(0, 1000).toDouble(),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        label: '${_hideStartEndMeters.round()} m',
                        onChanged:
                            (value) =>
                                setState(() => _hideStartEndMeters = value),
                      ),
                      const SizedBox(height: 4),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sync route detail by default'),
                        subtitle: const Text(
                          'Off keeps GPS coordinates local unless enabled per activity.',
                        ),
                        value: _syncRouteDetail,
                        onChanged:
                            (value) => setState(() => _syncRouteDetail = value),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Write workouts to Health Connect'),
                        subtitle: const Text(
                          'Activity summaries are written only after Save.',
                        ),
                        value: _writeHealthConnect,
                        onChanged:
                            (value) =>
                                setState(() => _writeHealthConnect = value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                label: Text(_saving ? 'Saving' : 'Save defaults'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Privacy settings unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  void _initialize(ActivityPrivacyDefaults defaults) {
    final key =
        '${defaults.routeVisibility}-${defaults.hideStartEndMeters}-'
        '${defaults.syncRouteDetail}-${defaults.writeHealthConnect}';
    if (_initializedKey == key) return;
    _initializedKey = key;
    _routeVisibility = defaults.routeVisibility;
    _hideStartEndMeters = defaults.hideStartEndMeters;
    _syncRouteDetail = defaults.syncRouteDetail;
    _writeHealthConnect = defaults.writeHealthConnect;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(activityRecorderProvider)
          .savePrivacyDefaults(
            ActivityPrivacyDefaults(
              routeVisibility: _routeVisibility,
              hideStartEndMeters: _hideStartEndMeters,
              syncRouteDetail: _syncRouteDetail,
              writeHealthConnect: _writeHealthConnect,
            ),
          );
      ref.invalidate(activityPrivacyDefaultsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Privacy defaults saved')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
