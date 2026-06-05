import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../../services/notification_settings_service.dart';
import '../../shared/widgets/info_panel.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: settings.when(
        data:
            (value) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                InfoPanel(
                  icon: Icons.notifications_active_outlined,
                  title: 'Proactive insight push',
                  body:
                      'Notifications are generated from local summaries only. Missing sensors are treated as unavailable, so the app will not invent HRV, stress, cadence, or SpO2 alerts.',
                  action: FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(localNotificationServiceProvider)
                          .initialize(requestPermission: true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification permission checked'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.verified_user_outlined),
                    label: const Text('Allow notifications'),
                  ),
                ),
                const SizedBox(height: 16),
                _ToggleTile(
                  title: 'Sync complete',
                  subtitle:
                      'Notify only when new records or activities are synced.',
                  value: value.syncComplete,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(syncComplete: enabled)),
                ),
                _ToggleTile(
                  title: 'Recovery advice',
                  subtitle:
                      'Sleep debt and recovery-first nudges from local rules.',
                  value: value.recovery,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(recovery: enabled)),
                ),
                _ToggleTile(
                  title: 'Personal records',
                  subtitle: 'Notify when a saved activity unlocks a PR.',
                  value: value.personalRecord,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(personalRecord: enabled)),
                ),
                _ToggleTile(
                  title: 'Streak reminder',
                  subtitle:
                      'A gentle late-day reminder when weekly activity is behind.',
                  value: value.streakReminder,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(streakReminder: enabled)),
                ),
                _ToggleTile(
                  title: 'Training plan today',
                  subtitle:
                      'Notify when a local training plan has workout today.',
                  value: value.trainingPlan,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(trainingPlan: enabled)),
                ),
                _ToggleTile(
                  title: 'Challenge updates',
                  subtitle:
                      'Reserved for Koyeb community challenge updates later.',
                  value: value.challengeUpdate,
                  onChanged:
                      (enabled) =>
                          _save(ref, value.copyWith(challengeUpdate: enabled)),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Notification settings unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  Future<void> _save(WidgetRef ref, HealthNotificationSettings settings) async {
    await ref.read(notificationSettingsServiceProvider).saveSettings(settings);
    ref.invalidate(notificationSettingsProvider);
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
