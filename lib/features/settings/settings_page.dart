import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/premium_card.dart';
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
        _SettingsTile(
          icon: Icons.contrast_outlined,
          title: 'Appearance',
          subtitle: 'System, light, or dark mode',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppearanceSettingsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.lock_outline,
          title: 'Privacy defaults',
          subtitle: 'Route visibility, hidden radius, and sync',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrivacySettingsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.flag_outlined,
          title: 'Weekly goals',
          subtitle: 'Steps, active days, minutes, distance',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GoalSettingsPage()));
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.event_note_outlined,
          title: 'Training plan',
          subtitle: '5K, 10K, and half-marathon templates',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TrainingPlanPage()));
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.monitor_heart_outlined,
          title: 'Profile and HR zones',
          subtitle: 'Max HR, resting HR, zone calculation',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FitnessProfilePage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.auto_awesome_outlined,
          title: 'AI settings',
          subtitle: 'Provider, base URL, model, API key',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AiSettingsPage()));
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Notifications',
          subtitle: 'Sync, recovery, PR, streak, training plan',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NotificationSettingsPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.record_voice_over_outlined,
          title: 'Voice coach',
          subtitle: 'Offline TTS cues for recording events',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VoiceCoachSettingsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.public,
          title: 'Community backend',
          subtitle: 'Koyeb URL for share cards and challenges',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CommunitySettingsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.developer_mode,
          title: 'External AI agent',
          subtitle: 'Optional Termux, Telegram, ZeroClaw setup',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExternalAgentSetupPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.archive_outlined,
          title: 'Data export',
          subtitle: 'ZIP with JSON, GPX, and summaries',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const DataExportPage()));
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.webhook_outlined,
          title: 'Webhook outbound',
          subtitle: 'Send sanitized events to your own URL',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WebhookSettingsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.map_outlined,
          title: 'Map and offline',
          subtitle: 'GPS offline behavior and map downloads',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const MapSettingsPage()));
          },
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Turso Credentials',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Set your Turso database URL and auth token',
                style: TextStyle(color: AppTheme.mutedText(context)),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onSetupCredentials,
                icon: const Icon(Icons.settings),
                label: const Text('Setup Credentials'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            AccentIconBox(
              icon: icon,
              color: AppTheme.accent(context),
              size: 38,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.text(context),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.mutedText(context),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right, color: AppTheme.mutedText(context)),
          ],
        ),
      ),
    );
  }
}
