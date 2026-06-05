import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:workmanager/workmanager.dart';

import '../../database/database.dart';
import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_sync_mapper.dart';
import '../../services/android_widget_service.dart';
import '../../services/background_service.dart';
import '../../services/training_goal_service.dart';
import '../../services/training_insights_service.dart';
import '../../services/turso_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/animated_section.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import '../ai/ai_page.dart';
import '../activity/activity_detail_page.dart';
import '../activity/activity_page.dart';
import '../activity/activity_recording_page.dart';
import '../activity/activity_save_page.dart';
import '../activity/widgets/active_activity_banner.dart';
import '../community/community_page.dart';
import '../health_detail/metric_detail_page.dart';
import '../insights/insights_page.dart';
import '../settings/settings_page.dart';
import '../settings/setup_dialog.dart';
import 'dashboard_customize_page.dart';
import 'widgets/hero_panel.dart';
import 'widgets/metric_grid.dart';
import 'widgets/quality_panel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _syncing = false;
  String _status = 'Ready';
  int _selectedIndex = 0;
  SportMode _selectedSportMode = sportModeByKey('walking');
  String? _lastWidgetSignature;

  @override
  Widget build(BuildContext context) {
    final credsConfigured = ref.watch(credentialsConfiguredProvider);
    final tursoStatus = ref.watch(tursoStatusProvider);
    final unsyncedCount = ref.watch(unsyncedCountProvider);
    final coverage = ref.watch(coverageSummaryProvider);
    final recorderSnapshot = ref.watch(activityRecorderSnapshotProvider);
    final dashboardPreferences = ref.watch(dashboardWidgetPreferencesProvider);
    final dashboardTrends = ref.watch(dashboardMetricTrendsProvider);
    final trainingInsights = ref.watch(trainingInsightsProvider);
    final trainingGoals = ref.watch(trainingGoalsProvider);
    final activityHistory = ref.watch(activityHistoryProvider);
    _maybeUpdateAndroidWidget(
      coverage.valueOrNull,
      trainingInsights.valueOrNull,
    );
    final preferences =
        dashboardPreferences.valueOrNull ??
        DashboardWidgetPreferences(
          visibleKeys:
              dashboardWidgetDefinitions.map((item) => item.key).toSet(),
        );
    final recentActivities = activityHistory.valueOrNull ?? const [];
    final recentActivity =
        recentActivities.isEmpty ? null : recentActivities.first;
    final title = switch (_selectedIndex) {
      0 => 'Dashboard',
      1 => 'Activity',
      2 => 'Insights',
      3 => 'AI Coach',
      4 => 'Community',
      _ => 'Settings',
    };
    final body = switch (_selectedIndex) {
      0 => _DashboardBody(
        coverage: coverage,
        activeSession: recorderSnapshot.valueOrNull?.session,
        preferences: preferences,
        trends: dashboardTrends.valueOrNull,
        goals: trainingGoals.valueOrNull ?? TrainingGoals.defaults,
        insightSummary: trainingInsights.valueOrNull,
        recentActivity: recentActivity,
        onMetricTap: _openMetricDetail,
        onCustomizeDashboard: _openDashboardCustomize,
        onRecentActivityTap:
            recentActivity == null
                ? null
                : () => _openActivityDetail(recentActivity),
        onOpenRecording:
            recorderSnapshot.valueOrNull?.isRecording == true
                ? () => _openActivityRecordingPage(
                  sportModeByKey(
                    recorderSnapshot.valueOrNull!.session!.sportKey,
                  ),
                )
                : null,
        onStopReview:
            recorderSnapshot.valueOrNull?.isRecording == true
                ? _stopAndReviewActiveActivity
                : null,
      ),
      1 => ActivityPage(
        selectedMode: _selectedSportMode,
        snapshot: recorderSnapshot.valueOrNull,
        onModeChanged: (mode) {
          setState(() => _selectedSportMode = mode);
        },
        onStart: () => _startAndOpenActivityRecording(_selectedSportMode),
        onOpenRecording:
            () => _openActivityRecordingPage(
              recorderSnapshot.valueOrNull?.session == null
                  ? _selectedSportMode
                  : sportModeByKey(
                    recorderSnapshot.valueOrNull!.session!.sportKey,
                  ),
            ),
        onStopReview: _stopAndReviewActiveActivity,
      ),
      2 => const InsightsPage(),
      3 => const AiPage(),
      4 => const CommunityPage(),
      _ => SettingsPage(
        tursoOk: tursoStatus.valueOrNull ?? false,
        credentialsConfigured: credsConfigured.valueOrNull ?? false,
        unsyncedCount: unsyncedCount.valueOrNull ?? 0,
        status: _status,
        syncing: _syncing,
        onCollect: _collectHealthData,
        onSync: _syncing ? null : _syncToTurso,
        onStartPeriodicSync: _startPeriodicSync,
        onSetupCredentials: () => showSetupDialog(context, ref),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(coverageSummaryProvider);
              ref.invalidate(unsyncedCountProvider);
              ref.invalidate(tursoStatusProvider);
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () => showSetupDialog(context, ref),
            icon: const Icon(Icons.more_vert),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: AppMotion.standard,
        switchInCurve: AppMotion.curve,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder:
            (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
        child: KeyedSubtree(key: ValueKey(_selectedIndex), child: body),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_filled),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.radio_button_checked),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI',
          ),
          NavigationDestination(icon: Icon(Icons.public), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _openMetricDetail(String metricKey) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => MetricDetailPage(spec: metricDetailSpecByKey(metricKey)),
      ),
    );
  }

  void _maybeUpdateAndroidWidget(
    HealthCoverageSummary? coverage,
    TrainingInsightSummary? insights,
  ) {
    if (coverage == null || insights == null) return;
    final now = DateTime.now();
    final steps =
        coverage.wearableSteps > 0
            ? coverage.wearableSteps
            : coverage.totalStepsIfMixed;
    final snapshot = AndroidWidgetSnapshot(
      steps: steps,
      readinessScore: insights.readinessScore,
      readinessLabel: insights.readinessLabel,
      updatedAt: now,
    );
    if (_lastWidgetSignature == snapshot.signature) return;
    _lastWidgetSignature = snapshot.signature;
    Future.microtask(() async {
      try {
        await ref.read(androidWidgetServiceProvider).updateHomeWidget(snapshot);
      } catch (_) {
        // Widget updates are best-effort and should never disturb the app.
      }
    });
  }

  void _openActivityDetail(ActivitySession session) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ActivityDetailPage(session: session)),
    );
  }

  void _openDashboardCustomize() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DashboardCustomizePage()));
  }

  void _collectHealthData() async {
    final startedAt = DateTime.now();
    setState(() => _status = 'Reading Health Connect...');
    final healthService = ref.read(healthServiceProvider);
    final db = ref.read(databaseProvider);

    // Request permission first
    final granted = await healthService.requestPermissions();
    if (!granted) {
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_collect',
          status: 'failed',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          message: const Value('Health Connect permission denied'),
        ),
      );
      setState(() => _status = 'Permission denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Health Connect permission required')),
        );
      }
      return;
    }

    // Fetch last 7 days of data (captures band sync history)
    final now = DateTime.now();
    final data = await healthService.fetchHealthData(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );

    // Save to local DB
    final records =
        data.map((point) {
          final value = point.value;
          double numericValue = 0.0;
          if (value is NumericHealthValue) {
            numericValue = value.numericValue.toDouble();
          }
          return HealthRecordsCompanion.insert(
            dataType: point.type.name,
            value: numericValue,
            unit: point.unit.name,
            dateFrom: point.dateFrom,
            dateTo: point.dateTo,
            sourceName: Value(point.sourceName),
            sourceId: Value(point.sourceId),
            syncStatus: const Value('pending'),
          );
        }).toList();

    if (records.isNotEmpty) {
      final inserted = await db.insertNewRecords(records);
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_collect',
          status: 'success',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          collectedCount: Value(data.length),
          insertedCount: Value(inserted),
          message: Value('Collected ${data.length}, inserted $inserted'),
        ),
      );
      ref.invalidate(unsyncedCountProvider);
      ref.invalidate(coverageSummaryProvider);
      setState(() => _status = 'Collected $inserted new health data points');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved ${records.length} records')),
        );
      }
    } else {
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_collect',
          status: 'success',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          collectedCount: Value(data.length),
          insertedCount: const Value(0),
          message: const Value('No Health Connect records found'),
        ),
      );
      ref.invalidate(coverageSummaryProvider);
      setState(() => _status = 'No new data found');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No health data found')));
      }
    }
  }

  void _syncToTurso() async {
    final startedAt = DateTime.now();
    setState(() => _syncing = true);
    _status = 'Syncing...';
    final db = ref.read(databaseProvider);

    final turso = await ref.read(tursoServiceProvider.future);
    if (turso == null) {
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_turso_sync',
          status: 'failed',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          message: const Value('No Turso credentials'),
        ),
      );
      setState(() {
        _syncing = false;
        _status = 'No Turso credentials';
      });
      return;
    }

    final unsynced = await db.getUnsyncedRecords();
    final pendingActivities = await db.getPendingActivitySessions();
    final pendingSummaries = await db.getPendingActivitySummaries();

    if (unsynced.isEmpty &&
        pendingActivities.isEmpty &&
        pendingSummaries.isEmpty) {
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_turso_sync',
          status: 'success',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          message: const Value('Nothing to sync'),
        ),
      );
      setState(() {
        _syncing = false;
        _status = 'Nothing to sync';
      });
      return;
    }

    final recordsJson =
        unsynced
            .map(
              (r) => {
                'data_type': r.dataType,
                'value': r.value, // double -> Turso float (JSON number)
                'unit': r.unit,
                'date_from': TursoService.formatToWib(r.dateFrom), // WIB +07:00
                'date_to': TursoService.formatToWib(r.dateTo), // WIB +07:00
                'source_name': r.sourceName ?? '',
                'source_id': r.sourceId ?? '',
              },
            )
            .toList();

    setState(
      () =>
          _status =
              'Pushing ${unsynced.length} records, ${pendingActivities.length} activities, ${pendingSummaries.length} summaries...',
    );

    final activitySessionsJson =
        pendingActivities.map(activitySessionToTurso).toList();
    final activityPointsJson = <Map<String, dynamic>>[];
    for (final activity in pendingActivities.where((a) => a.syncRouteDetail)) {
      final points = await db.getActivityPoints(activity.localId);
      activityPointsJson.addAll(points.map(activityPointToTurso));
    }
    final activitySummariesJson =
        pendingSummaries.map(activitySummaryToTurso).toList();

    final success =
        await turso.pushRecords(recordsJson) &&
        await turso.pushActivitySessions(activitySessionsJson) &&
        await turso.pushActivityPoints(activityPointsJson) &&
        await turso.pushActivitySummaries(activitySummariesJson);
    if (success) {
      await db.markAsSynced(unsynced.map((r) => r.id).toList());
      await db.markActivitySessionsSynced(
        pendingActivities.map((a) => a.localId).toList(),
      );
      await db.markActivitySummariesSynced(
        pendingSummaries.map((s) => s.sessionLocalId).toList(),
      );
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_turso_sync',
          status: 'success',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          syncedCount: Value(unsynced.length + pendingActivities.length),
          message: Value(
            'Synced ${unsynced.length} records and ${pendingActivities.length} activities',
          ),
        ),
      );
      ref.invalidate(unsyncedCountProvider);
      ref.invalidate(coverageSummaryProvider);
      await ref
          .read(proactiveInsightServiceProvider)
          .maybeNotifyAfterSync(
            insertedCount: 0,
            syncedCount: unsynced.length + pendingActivities.length,
            message:
                'Synced ${unsynced.length} records and ${pendingActivities.length} activities',
          );
      unawaited(
        ref
            .read(webhookServiceProvider)
            .sendSyncCompleted(
              insertedCount: 0,
              syncedCount:
                  unsynced.length +
                  pendingActivities.length +
                  pendingSummaries.length,
              message:
                  'Synced ${unsynced.length} records, ${pendingActivities.length} activities, ${pendingSummaries.length} summaries',
            ),
      );
      setState(
        () =>
            _status =
                'Synced ${unsynced.length} records and ${pendingActivities.length} activities',
      );
    } else {
      await db.insertSyncLog(
        SyncLogsCompanion.insert(
          operation: 'manual_turso_sync',
          status: 'failed',
          startedAt: startedAt,
          finishedAt: Value(DateTime.now()),
          message: Value(
            'Failed to sync ${unsynced.length} records and ${pendingActivities.length} activities',
          ),
        ),
      );
      ref.invalidate(coverageSummaryProvider);
      setState(() => _status = 'Sync failed');
    }

    setState(() => _syncing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Synced successfully' : 'Sync failed'),
        ),
      );
    }
  }

  Future<void> _startPeriodicSync() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Periodic background sync is available on Android.'),
        ),
      );
      return;
    }

    final healthService = ref.read(healthServiceProvider);
    final backgroundGranted = await healthService.requestBackgroundPermission();

    await Workmanager().registerPeriodicTask(
      healthPeriodicTask,
      healthPeriodicTask,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.update,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            backgroundGranted
                ? 'Background sync started (every 1h)'
                : 'Periodic sync started; enable Health Connect background access if prompted',
          ),
        ),
      );
    }
  }

  Future<void> _startAndOpenActivityRecording(SportMode mode) async {
    final started = await _startActivityRecording(mode);
    if (!started || !mounted) return;
    _openActivityRecordingPage(mode);
  }

  void _openActivityRecordingPage(SportMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ActivityRecordingPage(mode: mode)),
    );
  }

  Future<void> _stopAndReviewActiveActivity() async {
    try {
      final snapshot =
          await ref.read(activityRecorderProvider).finishForReview();
      ref.invalidate(activityRecorderSnapshotProvider);
      ref.invalidate(activityHistoryProvider);
      if (!mounted || snapshot.session == null) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) =>
                  ActivitySavePage(sessionLocalId: snapshot.session!.localId),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Stop failed: $error')));
    }
  }

  Future<bool> _startActivityRecording(SportMode mode) async {
    try {
      await ref.read(activityRecorderProvider).start(mode);
      setState(() => _status = 'Recording ${mode.name}');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Started ${mode.name}')));
      }
      return true;
    } catch (e) {
      setState(() => _status = 'Activity start failed');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Activity start failed: $e')));
      }
      return false;
    }
  }
}

class _DashboardBody extends StatelessWidget {
  final AsyncValue<HealthCoverageSummary> coverage;
  final ActivitySession? activeSession;
  final DashboardWidgetPreferences preferences;
  final DashboardMetricTrends? trends;
  final TrainingGoals goals;
  final TrainingInsightSummary? insightSummary;
  final ActivitySession? recentActivity;
  final ValueChanged<String> onMetricTap;
  final VoidCallback onCustomizeDashboard;
  final VoidCallback? onRecentActivityTap;
  final VoidCallback? onOpenRecording;
  final VoidCallback? onStopReview;

  const _DashboardBody({
    required this.coverage,
    required this.activeSession,
    required this.preferences,
    required this.trends,
    required this.goals,
    required this.insightSummary,
    required this.recentActivity,
    required this.onMetricTap,
    required this.onCustomizeDashboard,
    required this.onRecentActivityTap,
    required this.onOpenRecording,
    required this.onStopReview,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        if ((activeSession?.status == 'recording' ||
                activeSession?.status == 'paused') &&
            onOpenRecording != null &&
            onStopReview != null) ...[
          ActiveActivityBanner(
            session: activeSession!,
            onOpenRecording: onOpenRecording!,
            onStopReview: onStopReview!,
          ),
          const SizedBox(height: 16),
        ],
        coverage.when(
          data:
              (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSection(index: 0, child: HeroPanel(summary: summary)),
                  if (insightSummary != null) ...[
                    const SizedBox(height: 16),
                    AnimatedSection(
                      index: 1,
                      child: _InsightSnapshotCard(
                        summary: insightSummary!,
                        goals: goals,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  AnimatedSection(
                    index: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Widgets',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: onCustomizeDashboard,
                          icon: const Icon(Icons.tune),
                          label: const Text('Customize'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSection(
                    index: 3,
                    child: MetricGrid(
                      summary: summary,
                      preferences: preferences,
                      goals: goals,
                      trends: trends,
                      onMetricTap: onMetricTap,
                    ),
                  ),
                  if (preferences.isVisible('recent_activity') &&
                      recentActivity != null) ...[
                    const SizedBox(height: 16),
                    AnimatedSection(
                      index: 4,
                      child: _RecentActivityCard(
                        session: recentActivity!,
                        onTap: onRecentActivityTap,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  AnimatedSection(
                    index: 5,
                    child: QualityPanel(summary: summary),
                  ),
                ],
              ),
          loading:
              () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
          error:
              (error, _) => InfoPanel(
                icon: Icons.error_outline,
                title: 'Dashboard data unavailable',
                body: error.toString(),
              ),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final ActivitySession session;
  final VoidCallback? onTap;

  const _RecentActivityCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = session.title ?? session.sportName;
    final distanceKm = session.distanceMeters / 1000;
    final duration =
        session.movingSeconds > 0
            ? session.movingSeconds
            : session.elapsedSeconds;
    final date =
        '${session.startedAt.day.toString().padLeft(2, '0')}/'
        '${session.startedAt.month.toString().padLeft(2, '0')}/'
        '${session.startedAt.year}';

    return PremiumCard(
      onTap: onTap,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.ink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                session.requiresGps ? Icons.map : Icons.fitness_center,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent activity',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.sportName} / $date ${fmtTime(session.startedAt)} / ${fmtDuration(duration)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${distanceKm.toStringAsFixed(2)} km',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Icon(Icons.chevron_right, color: AppTheme.muted),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightSnapshotCard extends StatelessWidget {
  final TrainingInsightSummary summary;
  final TrainingGoals goals;

  const _InsightSnapshotCard({required this.summary, required this.goals});

  @override
  Widget build(BuildContext context) {
    final color = switch (summary.readinessScore) {
      >= 82 => AppTheme.mint,
      >= 64 => AppTheme.cyan,
      >= 45 => AppTheme.amber,
      _ => AppTheme.coral,
    };

    return PremiumCard(
      color: AppTheme.ink,
      borderColor: AppTheme.ink,
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: summary.readinessScore / 100,
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: Colors.white.withValues(alpha: 0.14),
                  strokeCap: StrokeCap.round,
                ),
                Text(
                  '${summary.readinessScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.readinessLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.activeDays}/${goals.weeklyActiveDays} active days / ${fmtDuration(summary.weeklyMovingSeconds)} load',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.insights_outlined, color: Colors.white),
        ],
      ),
    );
  }
}
