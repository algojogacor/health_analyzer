import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/llm_service.dart';
import '../../shared/widgets/info_panel.dart';

class AiSettingsPage extends ConsumerStatefulWidget {
  const AiSettingsPage({super.key});

  @override
  ConsumerState<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends ConsumerState<AiSettingsPage> {
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();
  String _providerId = LlmProviderPreset.deepseek.id;
  bool _loaded = false;
  bool _saving = false;
  bool _showApiKey = false;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(llmSettingsProvider);
    settings.whenData((value) {
      if (_loaded) return;
      _loaded = true;
      _providerId = value.providerId;
      _baseUrlController.text = value.baseUrl;
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
                'Cloud AI receives summarized context by default. Raw GPS is never sent unless route detail sharing is enabled for that activity.',
          ),
          const SizedBox(height: 12),
          const InfoPanel(
            icon: Icons.hub_outlined,
            title: 'Bring your own model',
            body:
                'Use the default preset or any OpenAI-compatible provider. Include /v1 in the base URL when your provider requires it.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _providerId,
            decoration: const InputDecoration(
              labelText: 'Provider preset',
              border: OutlineInputBorder(),
            ),
            items:
                LlmProviderPreset.all
                    .map(
                      (preset) => DropdownMenuItem(
                        value: preset.id,
                        child: Text(preset.label),
                      ),
                    )
                    .toList(),
            onChanged: _saving ? null : _applyPreset,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _baseUrlController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              helperText: 'Final request path: <base URL>/chat/completions',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'Model name',
              helperText: 'Example: deepseek-chat, gpt-4.1-mini, llama model',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _apiKeyController,
            obscureText: !_showApiKey,
            decoration: InputDecoration(
              labelText: 'API key',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _showApiKey = !_showApiKey),
                icon: Icon(
                  _showApiKey
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                tooltip: _showApiKey ? 'Hide key' : 'Show key',
              ),
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
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _saving ? null : _clearCloudKey,
            icon: const Icon(Icons.offline_bolt_outlined),
            label: const Text('Use local rules only'),
          ),
        ],
      ),
    );
  }

  void _applyPreset(String? providerId) {
    if (providerId == null) return;
    final preset = LlmProviderPreset.byId(providerId);
    setState(() {
      _providerId = preset.id;
      _baseUrlController.text = preset.defaultBaseUrl;
      _modelController.text = preset.defaultModel;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(llmServiceProvider)
        .saveSettings(
          providerId: _providerId,
          baseUrl: _baseUrlController.text,
          apiKey: _apiKeyController.text,
          model: _modelController.text,
        );
    ref.invalidate(llmSettingsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('AI settings saved')));
  }

  Future<void> _clearCloudKey() async {
    _apiKeyController.clear();
    await _save();
  }
}
