import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/deepseek_service.dart';
import '../../shared/widgets/info_panel.dart';

class AiSettingsPage extends ConsumerStatefulWidget {
  const AiSettingsPage({super.key});

  @override
  ConsumerState<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends ConsumerState<AiSettingsPage> {
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(deepSeekSettingsProvider);
    settings.whenData((value) {
      if (_loaded) return;
      _loaded = true;
      _apiKeyController.text = value.apiKey;
      _modelController.text = value.model;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('AI settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const InfoPanel(
            icon: Icons.privacy_tip_outlined,
            title: 'AI privacy guard',
            body:
                'Native AI uses summaries by default. Raw GPS is not sent unless route detail sharing is enabled for that activity.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _apiKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'DeepSeek API key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'DeepSeek model',
              helperText: 'Default: ${DeepSeekService.defaultModel}',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
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
            label: Text(_saving ? 'Saving...' : 'Save AI settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(deepSeekServiceProvider)
        .saveSettings(
          apiKey: _apiKeyController.text,
          model: _modelController.text,
        );
    ref.invalidate(deepSeekSettingsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('AI settings saved')));
  }
}
