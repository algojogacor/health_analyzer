import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/webhook_settings_service.dart';
import '../../shared/widgets/info_panel.dart';

class WebhookSettingsPage extends ConsumerStatefulWidget {
  const WebhookSettingsPage({super.key});

  @override
  ConsumerState<WebhookSettingsPage> createState() =>
      _WebhookSettingsPageState();
}

class _WebhookSettingsPageState extends ConsumerState<WebhookSettingsPage> {
  final _urlController = TextEditingController();
  final _secretController = TextEditingController();
  WebhookSettings? _draft;
  String? _initializedUrl;
  bool _saving = false;
  bool _testing = false;

  @override
  void dispose() {
    _urlController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(webhookSettingsProvider);
    final settings = _draft ?? value.valueOrNull;
    if (settings != null && _initializedUrl != settings.url) {
      _initializedUrl = settings.url;
      _urlController.text = settings.url;
      _secretController.text = settings.secret;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Webhook outbound')),
      body: value.when(
        data: (_) => _body(settings!),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.webhook_outlined,
                title: 'Webhook settings unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  Widget _body(WebhookSettings settings) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        const InfoPanel(
          icon: Icons.webhook_outlined,
          title: 'Power-user automation',
          body:
              'Send sanitized events to your own endpoint, Telegram relay, n8n, Zapier, or VPS. Payloads exclude raw health records, raw GPS points, API keys, and Turso tokens.',
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enable webhook'),
                subtitle: const Text('Only sends events you select below'),
                value: settings.enabled,
                onChanged:
                    (value) => _update(settings.copyWith(enabled: value)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Webhook URL',
                    hintText: 'https://example.com/webhook',
                  ),
                  onChanged: (value) => _update(settings.copyWith(url: value)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _secretController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Optional shared secret',
                    helperText: 'Sent as X-Health-Analyzer-Secret',
                  ),
                  onChanged:
                      (value) => _update(settings.copyWith(secret: value)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Activity saved'),
                value: settings.activitySaved,
                onChanged:
                    (value) => _update(settings.copyWith(activitySaved: value)),
              ),
              SwitchListTile(
                title: const Text('Sync completed'),
                value: settings.syncCompleted,
                onChanged:
                    (value) => _update(settings.copyWith(syncCompleted: value)),
              ),
              SwitchListTile(
                title: const Text('Personal record'),
                value: settings.personalRecord,
                onChanged:
                    (value) =>
                        _update(settings.copyWith(personalRecord: value)),
              ),
              SwitchListTile(
                title: const Text('Readiness changed'),
                subtitle: const Text('Reserved for future baseline triggers'),
                value: settings.readinessChanged,
                onChanged:
                    (value) =>
                        _update(settings.copyWith(readinessChanged: value)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _saving ? null : () => _save(settings),
          icon:
              _saving
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.save_outlined),
          label: Text(_saving ? 'Saving' : 'Save webhook settings'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _testing ? null : () => _test(settings),
          icon:
              _testing
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.send_outlined),
          label: Text(_testing ? 'Testing' : 'Send test event'),
        ),
      ],
    );
  }

  void _update(WebhookSettings settings) {
    setState(() => _draft = settings);
  }

  Future<void> _save(WebhookSettings settings) async {
    setState(() => _saving = true);
    await ref.read(webhookSettingsServiceProvider).saveSettings(settings);
    ref.invalidate(webhookSettingsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Webhook settings saved')));
  }

  Future<void> _test(WebhookSettings settings) async {
    setState(() => _testing = true);
    await ref.read(webhookSettingsServiceProvider).saveSettings(settings);
    ref.invalidate(webhookSettingsProvider);
    try {
      await ref.read(webhookServiceProvider).sendTest();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Webhook test sent')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Webhook test failed: $error')));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }
}
