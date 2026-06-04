import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../settings/community_settings_page.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(communitySettingsProvider);
    final activities = ref.watch(activityHistoryProvider);
    final shares = ref.watch(communitySharesProvider);
    final challenges = ref.watch(challengeInvitesProvider);
    final activityRows = activities.valueOrNull ?? const <ActivitySession>[];
    final latestActivity = activityRows.isEmpty ? null : activityRows.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        settings.when(
          data:
              (value) => InfoPanel(
                icon: Icons.public,
                title:
                    value.isConfigured
                        ? 'Community backend connected'
                        : 'Community backend not configured',
                body:
                    value.isConfigured
                        ? value.baseUrl
                        : 'Set a Koyeb base URL to create public share links.',
                action: TextButton.icon(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CommunitySettingsPage(),
                        ),
                      ),
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ),
          loading: () => const LinearProgressIndicator(),
          error:
              (error, _) => InfoPanel(
                icon: Icons.error_outline,
                title: 'Community settings unavailable',
                body: error.toString(),
              ),
        ),
        const SizedBox(height: 16),
        settings.when(
          data:
              (value) => _CommunityInterestPanel(
                interested: value.interest,
                interestAt: value.interestAt,
              ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        if (latestActivity == null)
          const InfoPanel(
            icon: Icons.route,
            title: 'No activity to share yet',
            body:
                'Save an activity first, then create a sanitized public card.',
          )
        else
          _LatestShareCard(activity: latestActivity),
        const SizedBox(height: 16),
        _SectionTitle(
          title: 'Share history',
          action: IconButton(
            onPressed: () => ref.invalidate(communitySharesProvider),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh share history',
          ),
        ),
        shares.when(
          data:
              (rows) =>
                  rows.isEmpty
                      ? const Text('No public shares yet.')
                      : Column(
                        children:
                            rows.map((row) => _ShareRow(row: row)).toList(),
                      ),
          loading:
              () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          error: (error, _) => Text('Share history unavailable: $error'),
        ),
        const SizedBox(height: 16),
        _SectionTitle(title: 'Challenges'),
        challenges.when(
          data:
              (rows) =>
                  rows.isEmpty
                      ? const InfoPanel(
                        icon: Icons.emoji_events_outlined,
                        title: 'Challenges coming soon',
                        body:
                            'Friend challenge invites and leaderboards will use a future Turso community database. Nothing is sent today.',
                      )
                      : Column(
                        children:
                            rows
                                .map((row) => ListTile(title: Text(row.title)))
                                .toList(),
                      ),
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('Challenges unavailable: $error'),
        ),
      ],
    );
  }
}

class _CommunityInterestPanel extends ConsumerStatefulWidget {
  final bool interested;
  final DateTime? interestAt;

  const _CommunityInterestPanel({
    required this.interested,
    required this.interestAt,
  });

  @override
  ConsumerState<_CommunityInterestPanel> createState() =>
      _CommunityInterestPanelState();
}

class _CommunityInterestPanelState
    extends ConsumerState<_CommunityInterestPanel> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.emoji_events_outlined,
      title:
          widget.interested
              ? 'Community interest saved'
              : 'Community features coming soon',
      body:
          widget.interested
              ? 'Saved locally${widget.interestAt == null ? '' : ' at ${fmtTime(widget.interestAt!)}'}. No data was sent to a server.'
              : 'Challenges, leaderboard, and public profiles are planned. Tap below to save local-only interest.',
      action:
          widget.interested
              ? null
              : TextButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.notifications_active_outlined),
                label: Text(
                  _saving ? 'Saving...' : "Notify me / I'm interested",
                ),
              ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(communityServiceProvider).saveCommunityInterest();
    ref.invalidate(communitySettingsProvider);
    if (mounted) setState(() => _saving = false);
  }
}

class _LatestShareCard extends ConsumerStatefulWidget {
  final ActivitySession activity;

  const _LatestShareCard({required this.activity});

  @override
  ConsumerState<_LatestShareCard> createState() => _LatestShareCardState();
}

class _LatestShareCardState extends ConsumerState<_LatestShareCard> {
  bool _sharing = false;

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.title ?? activity.sportName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '${activity.sportName} / ${(activity.distanceMeters / 1000).toStringAsFixed(2)} km / ${fmtDuration(activity.movingSeconds)}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            const InfoPanel(
              icon: Icons.verified_user_outlined,
              title: 'Sanitized payload',
              body:
                  'Share includes public metrics only. Raw Health Connect records and raw GPS points are excluded.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _sharing ? null : _share,
              icon:
                  _sharing
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.ios_share),
              label: Text(_sharing ? 'Sharing...' : 'Share latest activity'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final result = await ref
          .read(communityServiceProvider)
          .shareActivity(widget.activity);
      ref.invalidate(communitySharesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.publicUrl == null
                ? 'Share draft saved. Configure Koyeb URL to publish.'
                : 'Public activity shared: ${result.publicUrl}',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Share failed: $error')));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }
}

class _ShareRow extends StatelessWidget {
  final CommunityShareRecord row;

  const _ShareRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          row.status == 'shared' ? Icons.public : Icons.drafts_outlined,
        ),
        title: Text(row.publicUrl ?? row.shareId ?? row.localId),
        subtitle: Text(row.status),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionTitle({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
