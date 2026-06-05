import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/fitness_profile_service.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class FitnessProfilePage extends ConsumerStatefulWidget {
  const FitnessProfilePage({super.key});

  @override
  ConsumerState<FitnessProfilePage> createState() => _FitnessProfilePageState();
}

class _FitnessProfilePageState extends ConsumerState<FitnessProfilePage> {
  final _maxHrController = TextEditingController();
  final _restingHrController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _maxHrController.dispose();
    _restingHrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(fitnessProfileProvider);
    profile.whenData((value) {
      if (_loaded) return;
      _loaded = true;
      _maxHrController.text = value.maxHeartRate?.toString() ?? '';
      _restingHrController.text = value.restingHeartRate?.toString() ?? '';
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile and HR zones')),
      body: profile.when(
        data:
            (_) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const InfoPanel(
                  icon: Icons.monitor_heart_outlined,
                  title: 'Heart-rate zones',
                  body:
                      'Set your max heart rate so activity detail can calculate Zone 1-5 time distribution. This is fitness guidance, not medical advice.',
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _maxHrController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max heart rate',
                          suffixText: 'bpm',
                          helperText: 'Required for HR zones. Valid 120-240.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _restingHrController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Resting heart rate',
                          suffixText: 'bpm',
                          helperText:
                              'Optional baseline context. Valid 35-120.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                  label: Text(_saving ? 'Saving...' : 'Save profile'),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Profile unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = FitnessProfile(
      maxHeartRate: int.tryParse(_maxHrController.text.trim()),
      restingHeartRate: int.tryParse(_restingHrController.text.trim()),
    );
    await ref.read(fitnessProfileServiceProvider).saveProfile(profile);
    ref.invalidate(fitnessProfileProvider);
    ref.invalidate(activityHeartRateZonesProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fitness profile saved')));
  }
}
