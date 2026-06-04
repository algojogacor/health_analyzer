import 'package:flutter/material.dart';

import '../dashboard/widgets/actions_card.dart';
import '../dashboard/widgets/status_card.dart';
import 'ai_settings_page.dart';
import 'community_settings_page.dart';
import 'external_agent_setup_page.dart';
import 'map_settings_page.dart';
import 'privacy_settings_page.dart';

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
            leading: const Icon(Icons.auto_awesome_outlined),
            title: const Text('AI settings'),
            subtitle: const Text('DeepSeek key, model, and privacy guard'),
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
