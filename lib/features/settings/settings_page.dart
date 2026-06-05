import 'package:flutter/material.dart';

import '../dashboard/widgets/actions_card.dart';
import '../dashboard/widgets/status_card.dart';
import 'appearance_settings_page.dart';
import 'ai_settings_page.dart';
import 'community_settings_page.dart';
import 'data_export_page.dart';
import 'external_agent_setup_page.dart';
import 'fitness_profile_page.dart';
import 'goal_settings_page.dart';
import 'map_settings_page.dart';
import 'notification_settings_page.dart';
import 'privacy_settings_page.dart';
import 'training_plan_page.dart';
import 'voice_coach_settings_page.dart';
import 'webhook_settings_page.dart';

class SettingsPage extends StatelessWidget {
  final bool tursoOk;
  final bool credentialsConfigured;
  final int unsyncedCount;
  final String status;
  final bool syncing;
  final VoidCallback onCollect;
  final VoidCallback? onSync;
  final VoidCallback onStartPeriodicSync;
  final VoidCallback onSetupCredentials;

  const SettingsPage({
    super.key,
    required this.tursoOk,
    required this.credentialsConfigured,
    required this.unsyncedCount,
    required this.status,
    required this.syncing,
    required this.onCollect,
    required this.onSync,
    required this.onStartPeriodicSync,
    required this.onSetupCredentials,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        StatusCard(
          tursoOk: tursoOk,
          credentialsConfigured: credentialsConfigured,
          unsyncedCount: unsyncedCount,
          status: status,
        ),
        const SizedBox(height: 16),
        ActionsCard(
          unsyncedCount: unsyncedCount,
          syncing: syncing,
          onCollect: onCollect,
          onSync: onSync,
          onStartPeriodicSync: onStartPeriodicSync,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.contrast_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('System, light, or dark mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AppearanceSettingsPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy defaults'),
            subtitle: const Text('Route visibility, hidden radius, and sync'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacySettingsPage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Weekly goals'),
            subtitle: const Text('Steps, active days, minutes, distance'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GoalSettingsPage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_note_outlined),
            title: const Text('Training plan'),
            subtitle: const Text('5K, 10K, and half-marathon templates'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TrainingPlanPage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.monitor_heart_outlined),
            title: const Text('Profile and HR zones'),
            subtitle: const Text('Max HR, resting HR, zone calculation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FitnessProfilePage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: const Text('AI settings'),
            subtitle: const Text('Provider, base URL, model, API key'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AiSettingsPage()));
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Sync, recovery, PR, streak, training plan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.record_voice_over_outlined),
            title: const Text('Voice coach'),
            subtitle: const Text('Offline TTS cues for recording events'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VoiceCoachSettingsPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Community backend'),
            subtitle: const Text('Koyeb URL for share cards and challenges'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CommunitySettingsPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.developer_mode),
            title: const Text('External AI agent'),
            subtitle: const Text('Optional Termux, Telegram, ZeroClaw setup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExternalAgentSetupPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('Data export'),
            subtitle: const Text('ZIP with JSON, GPX, and summaries'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const DataExportPage()));
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.webhook_outlined),
            title: const Text('Webhook outbound'),
            subtitle: const Text('Send sanitized events to your own URL'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WebhookSettingsPage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Map and offline'),
            subtitle: const Text('GPS offline behavior and map downloads'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MapSettingsPage()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Turso Credentials',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Set your Turso database URL and auth token',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onSetupCredentials,
                  icon: const Icon(Icons.settings),
                  label: const Text('Setup Credentials'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
