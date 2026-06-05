import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/training_goal_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class GoalSettingsPage extends ConsumerStatefulWidget {
  const GoalSettingsPage({super.key});

  @override
  ConsumerState<GoalSettingsPage> createState() => _GoalSettingsPageState();
}

class _GoalSettingsPageState extends ConsumerState<GoalSettingsPage> {
  final _stepsController = TextEditingController();
  final _activeDaysController = TextEditingController();
  final _activeMinutesController = TextEditingController();
  final _distanceController = TextEditingController();
  final _sleepHoursController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _stepsController.dispose();
    _activeDaysController.dispose();
    _activeMinutesController.dispose();
    _distanceController.dispose();
    _sleepHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(trainingGoalsProvider);
    goals.whenData(_hydrateOnce);

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly goal wizard')),
      body: goals.when(
        data:
            (_) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const InfoPanel(
                  icon: Icons.flag_outlined,
                  title: 'Personal targets',
                  body:
                      'These goals tune dashboard progress, training insights, and AI coach context. They are stored locally on this phone.',
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          AccentIconBox(
                            icon: Icons.directions_walk,
                            color: AppTheme.cyan,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Movement goals',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _GoalField(
                        controller: _stepsController,
                        label: 'Daily steps',
                        suffix: 'steps',
                        helperText: 'Used as 7-day weekly step target.',
                      ),
                      const SizedBox(height: 12),
                      _GoalField(
                        controller: _activeDaysController,
                        label: 'Active days per week',
                        suffix: 'days',
                        helperText: '1-7 days.',
                      ),
                      const SizedBox(height: 12),
                      _GoalField(
                        controller: _activeMinutesController,
                        label: 'Active minutes per week',
                        suffix: 'min',
                        helperText:
                            'Walking, running, cycling, or indoor mode.',
                      ),
                      const SizedBox(height: 12),
                      _GoalField(
                        controller: _distanceController,
                        label: 'Recorded distance per week',
                        suffix: 'km',
                        helperText: 'Set 0 if distance is not your focus.',
                        decimal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          AccentIconBox(
                            icon: Icons.bedtime_outlined,
                            color: AppTheme.violet,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Recovery target',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _GoalField(
                        controller: _sleepHoursController,
                        label: 'Sleep target',
                        suffix: 'hours',
                        helperText: 'Used to calculate sleep debt.',
                        decimal: true,
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
                  label: Text(_saving ? 'Saving...' : 'Save goals'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _saving ? null : _resetDefaults,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset recommended defaults'),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Goals unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  void _hydrateOnce(TrainingGoals goals) {
    if (_loaded) return;
    _loaded = true;
    _stepsController.text = goals.dailySteps.toString();
    _activeDaysController.text = goals.weeklyActiveDays.toString();
    _activeMinutesController.text = goals.weeklyActiveMinutes.toString();
    _distanceController.text = goals.weeklyDistanceKm.toStringAsFixed(1);
    _sleepHoursController.text = (goals.sleepTargetMinutes / 60)
        .toStringAsFixed(1);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final goals = TrainingGoals(
      dailySteps: _readInt(_stepsController.text, 10000),
      weeklyActiveDays: _readInt(_activeDaysController.text, 5),
      weeklyActiveMinutes: _readInt(_activeMinutesController.text, 150),
      weeklyDistanceKm: _readDouble(_distanceController.text, 20),
      sleepTargetMinutes:
          (_readDouble(_sleepHoursController.text, 8) * 60).round(),
    );
    await ref.read(trainingGoalServiceProvider).saveGoals(goals);
    ref.invalidate(trainingGoalsProvider);
    ref.invalidate(trainingInsightsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Training goals saved')));
  }

  Future<void> _resetDefaults() async {
    setState(() => _saving = true);
    await ref.read(trainingGoalServiceProvider).resetDefaults();
    _loaded = false;
    ref.invalidate(trainingGoalsProvider);
    ref.invalidate(trainingInsightsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Goals reset')));
  }

  int _readInt(String raw, int fallback) {
    return int.tryParse(raw.replaceAll(',', '').trim()) ?? fallback;
  }

  double _readDouble(String raw, double fallback) {
    return double.tryParse(raw.replaceAll(',', '.').trim()) ?? fallback;
  }
}

class _GoalField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;
  final String helperText;
  final bool decimal;

  const _GoalField({
    required this.controller,
    required this.label,
    required this.suffix,
    required this.helperText,
    this.decimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        helperText: helperText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
