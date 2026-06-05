import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
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
              (rows) => _ChallengePanel(
                rows: rows,
                onCreate:
                    () => _createChallengeDraft(context, ref, activityRows),
              ),
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('Challenges unavailable: $error'),
        ),
      ],
    );
  }

  Future<void> _createChallengeDraft(
    BuildContext context,
    WidgetRef ref,
    List<ActivitySession> activities,
  ) async {
    final totalDistance = activities
        .take(7)
        .fold<double>(0, (total, item) => total + item.distanceMeters);
    final targetKm = ((totalDistance / 1000).ceil() + 5).clamp(5, 100);
    await ref
        .read(communityServiceProvider)
        .createChallengeDraft(
          title: '$targetKm km this week',
          metric: 'distance_km',
          targetValue: targetKm.toDouble(),
        );
    ref.invalidate(challengeInvitesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Challenge draft saved locally')),
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
    return PremiumCard(
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
            style: const TextStyle(color: AppTheme.muted),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PremiumCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AccentIconBox(
              icon:
                  row.status == 'shared' ? Icons.public : Icons.drafts_outlined,
              color: row.status == 'shared' ? AppTheme.mint : AppTheme.amber,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.publicUrl ?? row.shareId ?? row.localId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.status,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengePanel extends StatelessWidget {
  final List<ChallengeInvite> rows;
  final VoidCallback onCreate;

  const _ChallengePanel({required this.rows, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.emoji_events_outlined,
                color: AppTheme.amber,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community-lite challenges',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Drafts are local-only until the Koyeb community gateway is enabled.',
                      style: TextStyle(color: AppTheme.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onCreate,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Create challenge draft',
              ),
            ],
          ),
          if (rows.isEmpty) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create local challenge draft'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            ...rows.map((row) => _ChallengeRow(row: row)),
          ],
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  final ChallengeInvite row;

  const _ChallengeRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.canvas,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.line),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${row.metric} / target ${row.targetValue.toStringAsFixed(0)} / ${row.status}',
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.muted),
            ],
          ),
        ),
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
