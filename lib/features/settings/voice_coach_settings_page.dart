import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/voice_coach_service.dart';
import '../../services/voice_coach_settings_service.dart';
import '../../shared/widgets/info_panel.dart';

class VoiceCoachSettingsPage extends ConsumerStatefulWidget {
  const VoiceCoachSettingsPage({super.key});

  @override
  ConsumerState<VoiceCoachSettingsPage> createState() =>
      _VoiceCoachSettingsPageState();
}

class _VoiceCoachSettingsPageState
    extends ConsumerState<VoiceCoachSettingsPage> {
  VoiceCoachSettings? _draft;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(voiceCoachSettingsProvider);
    final settings = _draft ?? value.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Voice coach')),
      body: value.when(
        data: (_) => _body(settings!),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.volume_off_outlined,
                title: 'Voice settings unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  Widget _body(VoiceCoachSettings settings) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        const InfoPanel(
          icon: Icons.record_voice_over_outlined,
          title: 'Offline Android TTS',
          body:
              'Voice coach uses the phone text-to-speech engine. It works without cloud AI and does not require smartwatch sensors. Missing HR/cadence simply means those cues are skipped. Android is asked to briefly duck workout audio while cues play.',
        ),
        const SizedBox(height: 16),
        Card(
          child: SwitchListTile(
            title: const Text('Enable voice coach'),
            subtitle: const Text('Announce selected recording events'),
            value: settings.enabled,
            onChanged: (value) => _update(settings.copyWith(enabled: value)),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language_outlined),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Language'),
                              Text(
                                settings.languageCode == 'id-ID'
                                    ? 'Bahasa Indonesia'
                                    : 'English',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'id-ID', label: Text('ID')),
                        ButtonSegment(value: 'en-US', label: Text('EN')),
                      ],
                      selected: {settings.languageCode},
                      onSelectionChanged:
                          (values) => _update(
                            settings.copyWith(languageCode: values.first),
                          ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.speed_outlined),
                title: const Text('Speech speed'),
                subtitle: Slider(
                  min: 0.25,
                  max: 0.85,
                  divisions: 12,
                  value: settings.speechRate,
                  label: settings.speechRate.toStringAsFixed(2),
                  onChanged:
                      (value) => _update(settings.copyWith(speechRate: value)),
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.music_note_outlined),
                title: const Text('Minimal audio interrupt'),
                subtitle: const Text(
                  'Briefly lower music volume while voice cues play',
                ),
                value: settings.minimalAudioInterrupt,
                onChanged:
                    (value) => _update(
                      settings.copyWith(minimalAudioInterrupt: value),
                    ),
              ),
              ListTile(
                leading: const Icon(Icons.volume_down_outlined),
                title: const Text('Cue volume'),
                subtitle: Slider(
                  min: 0.35,
                  max: 1,
                  divisions: 13,
                  value: settings.volume,
                  label: '${(settings.volume * 100).round()}%',
                  onChanged:
                      (value) => _update(settings.copyWith(volume: value)),
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
                title: const Text('Pause / resume'),
                value: settings.announcePauseResume,
                onChanged:
                    (value) =>
                        _update(settings.copyWith(announcePauseResume: value)),
              ),
              SwitchListTile(
                title: const Text('Lap markers'),
                value: settings.announceLap,
                onChanged:
                    (value) => _update(settings.copyWith(announceLap: value)),
              ),
              SwitchListTile(
                title: const Text('Finish summary'),
                value: settings.announceFinish,
                onChanged:
                    (value) =>
                        _update(settings.copyWith(announceFinish: value)),
              ),
              SwitchListTile(
                title: const Text('Milestones'),
                subtitle: const Text('Reserved for split/PR cues'),
                value: settings.announceMilestones,
                onChanged:
                    (value) =>
                        _update(settings.copyWith(announceMilestones: value)),
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
          label: Text(_saving ? 'Saving' : 'Save voice settings'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _testVoice(settings),
          icon: const Icon(Icons.volume_up_outlined),
          label: const Text('Test voice'),
        ),
      ],
    );
  }

  void _update(VoiceCoachSettings settings) {
    setState(() => _draft = settings);
  }

  Future<void> _save(VoiceCoachSettings settings) async {
    setState(() => _saving = true);
    await ref.read(voiceCoachSettingsServiceProvider).saveSettings(settings);
    ref.invalidate(voiceCoachSettingsProvider);
    if (!mounted) return;
    setState(() {
      _draft = settings;
      _saving = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Voice coach settings saved')));
  }

  Future<void> _testVoice(VoiceCoachSettings settings) async {
    await ref.read(voiceCoachSettingsServiceProvider).saveSettings(settings);
    ref.invalidate(voiceCoachSettingsProvider);
    await ref
        .read(voiceCoachServiceProvider)
        .announce(
          VoiceCoachEvent.milestone,
          customMessage:
              settings.languageCode == 'id-ID'
                  ? 'Voice coach aktif. Selamat berlatih.'
                  : 'Voice coach is active. Enjoy your workout.',
        );
  }
}
