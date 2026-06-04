import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../shared/widgets/info_panel.dart';

class CommunitySettingsPage extends ConsumerStatefulWidget {
  const CommunitySettingsPage({super.key});

  @override
  ConsumerState<CommunitySettingsPage> createState() =>
      _CommunitySettingsPageState();
}

class _CommunitySettingsPageState extends ConsumerState<CommunitySettingsPage> {
  final _baseUrlController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(communitySettingsProvider);
    settings.whenData((value) {
      if (_loaded) return;
      _loaded = true;
      _baseUrlController.text = value.baseUrl;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Community backend')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const InfoPanel(
            icon: Icons.public,
            title: 'Koyeb community layer',
            body:
                'This backend receives public/sanitized activity cards only. Raw health records and raw route points stay in the user Turso/local database.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Community base URL',
              hintText: 'https://your-app.koyeb.app',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Saving...' : 'Save community settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(communityServiceProvider)
        .saveSettings(_baseUrlController.text);
    ref.invalidate(communitySettingsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community backend settings saved')),
    );
  }
}
