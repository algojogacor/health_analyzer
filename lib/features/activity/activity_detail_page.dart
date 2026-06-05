import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:share_plus/share_plus.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_analysis_service.dart';
import '../../services/cadence_analysis_service.dart';
import '../../services/fitness_profile_service.dart';
import '../../services/geoid_correction_service.dart';
import '../../services/heart_rate_zone_service.dart';
import '../../services/lap_analysis_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../settings/fitness_profile_page.dart';
import 'widgets/activity_charts.dart';
import 'widgets/activity_metric_strip.dart';
import 'widgets/activity_splits_table.dart';
import 'widgets/route_crop_preview.dart';
import 'widgets/route_map.dart';

class ActivityDetailPage extends ConsumerWidget {
  final ActivitySession session;

  const ActivityDetailPage({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveSession = ref.watch(activitySessionProvider(session.localId));
    final points = ref.watch(activityPointsProvider(session.localId));
    final analysis = ref.watch(activityAnalysisProvider(session.localId));
    final heartRateRecords = ref.watch(
      activityHeartRateRecordsProvider(session.localId),
    );
    final aiSummary = ref.watch(activitySummaryProvider(session.localId));
    final personalRecords = ref.watch(
      activityPersonalRecordsProvider(session.localId),
    );
    final lapSummaries = ref.watch(
      activityLapSummariesProvider(session.localId),
    );
    final hrZones = ref.watch(activityHeartRateZonesProvider(session.localId));
    final cadenceAnalysis = ref.watch(
      activityCadenceAnalysisProvider(session.localId),
    );
    final fitnessProfile = ref.watch(fitnessProfileProvider);

    return liveSession.when(
      data: (freshSession) {
        final currentSession = freshSession ?? session;
        final title = currentSession.title ?? currentSession.sportName;
        return DefaultTabController(
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Map'),
                  Tab(text: 'Splits'),
                  Tab(text: 'Charts'),
                  Tab(text: 'AI'),
                  Tab(text: 'Privacy'),
                ],
              ),
            ),
            body: points.when(
              data:
                  (rows) => analysis.when(
                    data:
                        (activityAnalysis) => _ActivityDetailContent(
                          session: currentSession,
                          points: rows,
                          analysis: activityAnalysis,
                          heartRateRecords:
                              heartRateRecords.valueOrNull ?? const [],
                          aiSummary: aiSummary.valueOrNull,
                          personalRecords:
                              personalRecords.valueOrNull ?? const [],
                          lapSummaries: lapSummaries.valueOrNull ?? const [],
                          heartRateZones: hrZones.valueOrNull,
                          cadenceAnalysis: cadenceAnalysis.valueOrNull,
                          fitnessProfile: fitnessProfile.valueOrNull,
                          onSyncRouteDetailChanged: (enabled) async {
                            await ref
                                .read(databaseProvider)
                                .setActivityRouteDetailSync(
                                  currentSession.localId,
                                  enabled,
                                );
                            ref.invalidate(
                              activitySessionProvider(currentSession.localId),
                            );
                            ref.invalidate(activityHistoryProvider);
                            ref.invalidate(unsyncedCountProvider);
                          },
                          onEditPrivacy:
                              () => _showPrivacyEditSheet(
                                context,
                                ref,
                                currentSession,
                              ),
                          onSaveHiddenMeters: (hiddenMeters) async {
                            await ref
                                .read(databaseProvider)
                                .setActivityPrivacy(
                                  currentSession.localId,
                                  routeVisibility:
                                      currentSession.routeVisibility,
                                  hideStartEndMeters: hiddenMeters,
                                );
                            ref.invalidate(
                              activitySessionProvider(currentSession.localId),
                            );
                            ref.invalidate(activityHistoryProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Route crop privacy saved'),
                              ),
                            );
                          },
                          onSaveRoute:
                              () => _saveRoute(context, ref, currentSession),
                          onShareCard:
                              () => _shareCard(context, ref, currentSession),
                          onExportGpx:
                              () => _exportGpx(context, ref, currentSession),
                          onShareCommunity:
                              () =>
                                  _shareCommunity(context, ref, currentSession),
                          onGenerateAiSummary: () async {
                            final points = await ref.read(
                              activityPointsProvider(
                                currentSession.localId,
                              ).future,
                            );
                            final hr = await ref.read(
                              activityHeartRateRecordsProvider(
                                currentSession.localId,
                              ).future,
                            );
                            final cadence = await ref.read(
                              activityCadenceAnalysisProvider(
                                currentSession.localId,
                              ).future,
                            );
                            final draft = ref
                                .read(activityAiSummaryServiceProvider)
                                .generate(
                                  session: currentSession,
                                  points: points,
                                  heartRateRecords: hr,
                                  cadenceAnalysis: cadence,
                                );
                            await ref
                                .read(databaseProvider)
                                .upsertActivitySummary(
                                  ActivitySummariesCompanion.insert(
                                    sessionLocalId: currentSession.localId,
                                    jsonSummary: draft.jsonSummary,
                                    markdownSummary: draft.markdownSummary,
                                    generatedAt: DateTime.now(),
                                    model: const Value('local-tool'),
                                    confidence: const Value('structured'),
                                    generatedBy: const Value('local'),
                                    agentNotes: Value(draft.narrative),
                                  ),
                                );
                            ref.invalidate(
                              activitySummaryProvider(currentSession.localId),
                            );
                            ref.invalidate(unsyncedCountProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('AI activity summary generated'),
                              ),
                            );
                          },
                        ),
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => _ErrorPanel(error: error),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorPanel(error: error),
            ),
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: _ErrorPanel(error: error)),
    );
  }
}

Future<void> _saveRoute(
  BuildContext context,
  WidgetRef ref,
  ActivitySession session,
) async {
  try {
    await ref.read(savedRouteServiceProvider).saveFromActivity(session);
    ref.invalidate(savedRoutesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Route saved')));
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Save route failed: $error')));
  }
}

Future<void> _exportGpx(
  BuildContext context,
  WidgetRef ref,
  ActivitySession session,
) async {
  if (!session.requiresGps) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Indoor activity has no GPX route')),
    );
    return;
  }

  final shouldConfirm =
      !session.syncRouteDetail || session.routeVisibility != 'public';
  if (shouldConfirm) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Export route file?'),
            content: Text(
              'GPX export creates a route file that can be opened by other apps. '
              'Health Analyzer will apply your ${session.hideStartEndMeters.round()} m hidden start/end setting before sharing.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Export GPX'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
  }

  try {
    final file = await ref.read(gpxServiceProvider).exportSession(session);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: session.title ?? session.sportName,
        text:
            '${session.title ?? session.sportName} exported from Health Analyzer',
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('GPX export failed: $error')));
  }
}

Future<void> _shareCard(
  BuildContext context,
  WidgetRef ref,
  ActivitySession session,
) async {
  try {
    final points = await ref.read(
      activityPointsProvider(session.localId).future,
    );
    final file = await ref
        .read(activityShareCardServiceProvider)
        .generate(session, points);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: session.title ?? session.sportName,
        text:
            '${session.title ?? session.sportName} shared from Health Analyzer',
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share card failed: $error')));
  }
}

Future<void> _shareCommunity(
  BuildContext context,
  WidgetRef ref,
  ActivitySession session,
) async {
  try {
    final result = await ref
        .read(communityServiceProvider)
        .shareActivity(session);
    ref.invalidate(communitySharesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.publicUrl == null
              ? 'Share draft saved. Configure Koyeb URL to publish.'
              : 'Shared: ${result.publicUrl}',
        ),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Community share failed: $error')));
  }
}

class _ActivityDetailContent extends StatelessWidget {
  final ActivitySession session;
  final List<ActivityPoint> points;
  final ActivityAnalysis? analysis;
  final List<HealthRecord> heartRateRecords;
  final ActivitySummary? aiSummary;
  final List<PersonalRecord> personalRecords;
  final List<ActivityLapSummary> lapSummaries;
  final HeartRateZoneResult? heartRateZones;
  final CadenceAnalysis? cadenceAnalysis;
  final FitnessProfile? fitnessProfile;
  final ValueChanged<bool> onSyncRouteDetailChanged;
  final VoidCallback onEditPrivacy;
  final Future<void> Function(double hiddenMeters) onSaveHiddenMeters;
  final Future<void> Function() onSaveRoute;
  final Future<void> Function() onShareCard;
  final Future<void> Function() onExportGpx;
  final Future<void> Function() onShareCommunity;
  final Future<void> Function() onGenerateAiSummary;

  const _ActivityDetailContent({
    required this.session,
    required this.points,
    required this.analysis,
    required this.heartRateRecords,
    required this.aiSummary,
    required this.personalRecords,
    required this.lapSummaries,
    required this.heartRateZones,
    required this.cadenceAnalysis,
    required this.fitnessProfile,
    required this.onSyncRouteDetailChanged,
    required this.onEditPrivacy,
    required this.onSaveHiddenMeters,
    required this.onSaveRoute,
    required this.onShareCard,
    required this.onExportGpx,
    required this.onShareCommunity,
    required this.onGenerateAiSummary,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics(context);
    final elevationSummary = const GeoidCorrectionService().summarizePoints(
      points,
    );
    final gpsQuality =
        analysis?.gpsQuality ??
        const ActivityGpsQuality(good: 0, usable: 0, low: 0, unknown: 0);

    return TabBarView(
      children: [
        _PaddedList(
          children: [
            _Header(session: session),
            if (session.tags.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              _ActivityTagsPanel(tags: session.tags),
            ],
            const SizedBox(height: 14),
            ActivityMetricStrip(metrics: metrics),
            if (session.requiresGps) ...[
              const SizedBox(height: 14),
              _ElevationCorrectionPanel(summary: elevationSummary),
            ],
            if (personalRecords.isNotEmpty) ...[
              const SizedBox(height: 14),
              _PersonalRecordsPanel(records: personalRecords),
            ],
            const SizedBox(height: 14),
            _RouteActionsPanel(
              session: session,
              onSaveRoute: onSaveRoute,
              onShareCard: onShareCard,
              onExportGpx: onExportGpx,
              onShareCommunity: onShareCommunity,
            ),
            if (!session.requiresGps) ...[
              const SizedBox(height: 14),
              const InfoPanel(
                icon: Icons.fitness_center,
                title: 'Indoor activity',
                body:
                    'This workout has no GPS route. Summary metrics are still saved locally and can be synced.',
              ),
            ],
          ],
        ),
        _PaddedList(
          children: [
            if (session.requiresGps) _RouteHero(points: points),
            if (!session.requiresGps)
              const InfoPanel(
                icon: Icons.fitness_center,
                title: 'Indoor activity',
                body: 'No route map is available for this sport mode.',
              ),
            const SizedBox(height: 14),
            _GpsQualityPanel(points: points, quality: gpsQuality),
            const SizedBox(height: 14),
            _ElevationCorrectionPanel(summary: elevationSummary),
          ],
        ),
        _PaddedList(
          children: [
            if (lapSummaries.isNotEmpty) ...[
              _ManualLapsPanel(laps: lapSummaries),
              const SizedBox(height: 14),
            ],
            if (session.requiresGps &&
                session.distanceMeters > 1000 &&
                (analysis?.splits.isNotEmpty ?? false))
              ActivitySplitsTable(
                splits: analysis!.splits,
                splitDistanceMeters: analysis!.splitDistanceMeters,
              )
            else
              const InfoPanel(
                icon: Icons.table_rows_outlined,
                title: 'Splits unavailable',
                body:
                    'Splits appear after a GPS activity has enough distance and route points.',
              ),
          ],
        ),
        _PaddedList(
          children: [
            if (heartRateRecords.isNotEmpty)
              _HeartRateOverlapChart(records: heartRateRecords)
            else
              const InfoPanel(
                icon: Icons.favorite_border,
                title: 'Heart-rate chart unavailable',
                body:
                    'No Health Connect heart-rate records overlap this activity.',
              ),
            const SizedBox(height: 14),
            if (heartRateZones != null)
              _HeartRateZonesPanel(result: heartRateZones!)
            else
              _HeartRateZonesUnavailable(
                hasHeartRateRecords: heartRateRecords.length >= 2,
                profile: fitnessProfile,
              ),
            const SizedBox(height: 14),
            _CadencePanel(result: cadenceAnalysis),
            if ((analysis?.chartSamples.length ?? 0) >= 2) ...[
              const SizedBox(height: 14),
              ActivityCharts(samples: analysis!.chartSamples),
            ],
          ],
        ),
        _PaddedList(
          children: [
            _AiSummaryPanel(
              summary: aiSummary,
              onGenerate: onGenerateAiSummary,
            ),
          ],
        ),
        _PaddedList(
          children: [
            _RoutePrivacyTab(
              session: session,
              points: points,
              onSyncRouteDetailChanged: onSyncRouteDetailChanged,
              onEditPrivacy: onEditPrivacy,
              onSaveHiddenMeters: onSaveHiddenMeters,
            ),
          ],
        ),
      ],
    );
  }

  List<ActivityMetric> _metrics(BuildContext context) {
    final pace = _paceText(session.distanceMeters, session.movingSeconds);
    final speed =
        session.avgSpeedMps == null
            ? '--'
            : '${(session.avgSpeedMps! * 3.6).toStringAsFixed(1)} km/h';
    final quality = analysis?.gpsQuality;
    final qualityText =
        quality == null
            ? 'unknown'
            : '${quality.good}/${quality.usable}/${quality.low}/${quality.unknown}';

    final metrics = [
      ActivityMetric(
        label: 'Distance',
        value: '${(session.distanceMeters / 1000).toStringAsFixed(2)} km',
        icon: Icons.straighten,
        color: Colors.teal.shade700,
      ),
      ActivityMetric(
        label: 'Moving',
        value: fmtDuration(session.movingSeconds),
        icon: Icons.timer_outlined,
        color: Colors.cyan.shade700,
      ),
      ActivityMetric(
        label: 'Elapsed',
        value: fmtDuration(session.elapsedSeconds),
        icon: Icons.schedule,
        color: Colors.indigo.shade600,
      ),
      ActivityMetric(
        label: session.distanceMeters > 0 ? 'Pace' : 'Speed',
        value: session.distanceMeters > 0 ? pace : speed,
        icon: Icons.speed,
        color: Colors.deepOrange.shade600,
      ),
      ActivityMetric(
        label: 'Ascent / descent',
        value:
            '${session.ascentMeters.round()} / ${session.descentMeters.round()} m',
        icon: Icons.terrain,
        color: Colors.green.shade700,
      ),
      ActivityMetric(
        label: 'Calories',
        value:
            session.caloriesKcal <= 0
                ? '--'
                : '${session.caloriesKcal.round()} kcal',
        icon: Icons.local_fire_department_outlined,
        color: Colors.red.shade600,
      ),
      ActivityMetric(
        label: 'GPS quality',
        value: qualityText,
        icon: Icons.gps_fixed,
        color: Colors.blueGrey.shade700,
      ),
      ActivityMetric(
        label: 'Sync',
        value: session.syncStatus,
        icon:
            session.syncStatus == 'synced'
                ? Icons.cloud_done_outlined
                : Icons.cloud_upload_outlined,
        color:
            session.syncStatus == 'synced'
                ? Colors.green.shade700
                : Colors.orange.shade800,
      ),
    ];
    if (cadenceAnalysis?.available == true) {
      metrics.insert(
        4,
        ActivityMetric(
          label: 'Cadence',
          value: '${cadenceAnalysis!.averageStepsPerMinute!.round()} spm',
          icon: Icons.directions_run_outlined,
          color: Colors.purple.shade600,
        ),
      );
    }
    return metrics;
  }

  String _paceText(double distanceMeters, int movingSeconds) {
    if (distanceMeters <= 0 || movingSeconds <= 0) return '--';
    final secondsPerKm = movingSeconds / (distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds /km';
  }
}

class _PersonalRecordsPanel extends StatelessWidget {
  final List<PersonalRecord> records;

  const _PersonalRecordsPanel({required this.records});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber.shade800),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Personal records',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: records
                  .map(
                    (record) => Chip(
                      avatar: const Icon(Icons.bolt, size: 16),
                      label: Text('${record.label}: ${_recordValue(record)}'),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  String _recordValue(PersonalRecord record) {
    return switch (record.unit) {
      'seconds' => fmtDuration(record.value.round()),
      'meters' => '${(record.value / 1000).toStringAsFixed(2)} km',
      'mps' => '${(record.value * 3.6).toStringAsFixed(1)} km/h',
      _ => record.value.toStringAsFixed(1),
    };
  }
}

class _ManualLapsPanel extends StatelessWidget {
  final List<ActivityLapSummary> laps;

  const _ManualLapsPanel({required this.laps});

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Icon(Icons.flag, color: Colors.indigo.shade600),
                const SizedBox(width: 10),
                Text(
                  'Manual laps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text('${laps.length} laps'),
              ],
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(38),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
              },
              children: [
                _lapRow(['#', 'Dist', 'Time', 'Pace', 'HR'], header: true),
                for (final lap in laps)
                  _lapRow([
                    '${lap.index}',
                    '${(lap.distanceMeters / 1000).toStringAsFixed(2)} km',
                    fmtDuration(lap.elapsedSeconds),
                    _pace(lap.avgSpeedMps),
                    lap.avgHeartRate == null
                        ? '--'
                        : '${lap.avgHeartRate!.round()}',
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _lapRow(List<String> cells, {bool header = false}) {
    final style =
        header
            ? const TextStyle(
              color: AppTheme.muted,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            )
            : const TextStyle(fontWeight: FontWeight.w700, fontSize: 13);
    return TableRow(
      children: cells
          .map(
            (cell) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(cell, style: style),
            ),
          )
          .toList(growable: false),
    );
  }

  String _pace(double speedMps) {
    if (speedMps <= 0) return '--';
    final secondsPerKm = 1000 / speedMps;
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ActivityTagsPanel extends StatelessWidget {
  final String tags;

  const _ActivityTagsPanel({required this.tags});

  @override
  Widget build(BuildContext context) {
    final rows = tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false);
    if (rows.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppTheme.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sell_outlined, color: AppTheme.cyan),
                const SizedBox(width: 8),
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  rows
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          side: const BorderSide(color: AppTheme.line),
                          backgroundColor: AppTheme.canvas,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartRateZonesPanel extends StatelessWidget {
  final HeartRateZoneResult result;

  const _HeartRateZonesPanel({required this.result});

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.red.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Heart-rate zones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text('Max ${result.maxHeartRate} bpm'),
              ],
            ),
            const SizedBox(height: 12),
            ...result.zones.map((zone) => _ZoneRow(zone: zone)),
          ],
        ),
      ),
    );
  }
}

class _ZoneRow extends StatelessWidget {
  final HeartRateZoneSummary zone;

  const _ZoneRow({required this.zone});

  @override
  Widget build(BuildContext context) {
    final color = switch (zone.zone) {
      1 => AppTheme.mint,
      2 => AppTheme.cyan,
      3 => AppTheme.amber,
      4 => Colors.deepOrange,
      _ => AppTheme.coral,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Z${zone.zone} ${zone.label}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '${fmtDuration(zone.seconds)} / ${(zone.percent * 100).round()}%',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(height: 9, color: AppTheme.line),
                FractionallySizedBox(
                  widthFactor: zone.percent.clamp(0, 1).toDouble(),
                  child: Container(height: 9, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${zone.minBpm}-${zone.maxBpm} bpm',
            style: const TextStyle(color: AppTheme.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _HeartRateZonesUnavailable extends StatelessWidget {
  final bool hasHeartRateRecords;
  final FitnessProfile? profile;

  const _HeartRateZonesUnavailable({
    required this.hasHeartRateRecords,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final hasMaxHr = profile?.hasHeartRateZones == true;
    return InfoPanel(
      icon: Icons.monitor_heart_outlined,
      title: 'Heart-rate zones unavailable',
      body:
          !hasHeartRateRecords
              ? 'Need at least two overlapping heart-rate records for this activity.'
              : hasMaxHr
              ? 'Heart-rate records are too sparse to estimate time in zones.'
              : 'Set your max heart rate to unlock Zone 1-5 distribution.',
      action:
          hasMaxHr
              ? null
              : TextButton.icon(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FitnessProfilePage(),
                      ),
                    ),
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Set max HR'),
              ),
    );
  }
}

class _CadencePanel extends StatelessWidget {
  final CadenceAnalysis? result;

  const _CadencePanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final value = result;
    if (value == null) {
      return const InfoPanel(
        icon: Icons.directions_run_outlined,
        title: 'Cadence unavailable',
        body: 'Cadence analysis is still loading or this activity is missing.',
      );
    }
    if (!value.available) {
      return InfoPanel(
        icon: Icons.directions_run_outlined,
        title:
            value.applicable ? 'Cadence unavailable' : 'Cadence not applicable',
        body:
            '${value.status} Missing cadence will stay unavailable; the app will not infer it from unsupported sensors.',
      );
    }

    final avg = value.averageStepsPerMinute!.round();
    final max = value.maxStepsPerMinute?.round();
    final sources =
        value.sources.isEmpty ? 'Health Connect' : value.sources.join(', ');

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
            Row(
              children: [
                Icon(
                  Icons.directions_run_outlined,
                  color: Colors.purple.shade600,
                ),
                const SizedBox(width: 10),
                Text(
                  'Cadence',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  '$avg spm',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              max == null
                  ? '${value.totalSteps} overlapping steps from $sources.'
                  : 'Max $max spm / ${value.totalSteps} overlapping steps from $sources.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            _CadenceBars(samples: value.samples),
          ],
        ),
      ),
    );
  }
}

class _CadenceBars extends StatelessWidget {
  final List<CadenceSample> samples;

  const _CadenceBars({required this.samples});

  @override
  Widget build(BuildContext context) {
    final maxValue = samples.fold<double>(
      0,
      (max, sample) =>
          sample.stepsPerMinute > max ? sample.stepsPerMinute : max,
    );
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: samples
            .take(24)
            .map((sample) {
              final normalized =
                  maxValue <= 0
                      ? 0.08
                      : (sample.stepsPerMinute / maxValue).clamp(0.08, 1.0);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: normalized.toDouble(),
                            alignment: Alignment.bottomCenter,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.purple.shade400,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sample.stepsPerMinute.round().toString(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ActivitySession session;

  const _Header({required this.session});

  @override
  Widget build(BuildContext context) {
    final title = session.title ?? session.sportName;
    return Row(
      children: [
        Icon(
          session.requiresGps ? Icons.map : Icons.fitness_center,
          color: Colors.teal.shade700,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                '${session.sportName} / ${fmtTime(session.startedAt)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaddedList extends StatelessWidget {
  final List<Widget> children;

  const _PaddedList({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: children,
    );
  }
}

class _RouteActionsPanel extends StatelessWidget {
  final ActivitySession session;
  final Future<void> Function() onSaveRoute;
  final Future<void> Function() onShareCard;
  final Future<void> Function() onExportGpx;
  final Future<void> Function() onShareCommunity;

  const _RouteActionsPanel({
    required this.session,
    required this.onSaveRoute,
    required this.onShareCard,
    required this.onExportGpx,
    required this.onShareCommunity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.route, color: Colors.teal.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Route tools',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              session.syncRouteDetail
                  ? 'Route detail sharing is enabled for this activity.'
                  : 'Route detail is local-only. Public shares use summary metrics.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: session.requiresGps ? onSaveRoute : null,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Save route'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: session.requiresGps ? onExportGpx : null,
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('GPX'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onShareCard,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Share card'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onShareCommunity,
                    icon: const Icon(Icons.public),
                    label: const Text('Community'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteHero extends StatefulWidget {
  final List<ActivityPoint> points;

  const _RouteHero({required this.points});

  @override
  State<_RouteHero> createState() => _RouteHeroState();
}

class _RouteHeroState extends State<_RouteHero> {
  RouteMapStyle _style = RouteMapStyle.street;

  @override
  Widget build(BuildContext context) {
    final route = widget.points
        .map(
          (point) => RouteMapPoint(
            latitude: point.latitude,
            longitude: point.longitude,
            accuracyMeters: point.accuracyMeters,
          ),
        )
        .toList(growable: false);

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: RouteMap(
              points: route,
              style: _style,
              height: double.infinity,
              showAccuracy: true,
              borderRadius: 8,
              emptyLabel:
                  'Route points are not available yet for this GPS activity.',
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Row(
              children: [
                Material(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Text(
                      '${widget.points.length} GPS pts',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  child: SegmentedButton<RouteMapStyle>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: RouteMapStyle.street,
                        icon: Icon(Icons.map_outlined),
                      ),
                      ButtonSegment(
                        value: RouteMapStyle.satellite,
                        icon: Icon(Icons.satellite_alt_outlined),
                      ),
                    ],
                    selected: {_style},
                    onSelectionChanged: (selection) {
                      setState(() => _style = selection.first);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncAndPrivacyPanel extends StatelessWidget {
  final ActivitySession session;
  final ValueChanged<bool> onSyncRouteDetailChanged;
  final VoidCallback onEditPrivacy;

  const _SyncAndPrivacyPanel({
    required this.session,
    required this.onSyncRouteDetailChanged,
    required this.onEditPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    final synced = session.syncStatus == 'synced';
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  synced
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_upload_outlined,
                  color:
                      synced ? Colors.green.shade700 : Colors.orange.shade800,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    synced ? 'Synced' : 'Pending sync',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Text(session.syncStatus),
              ],
            ),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sync route detail'),
              subtitle: Text(
                session.syncRouteDetail
                    ? 'GPS points will be included in Turso sync.'
                    : 'Only summary syncs; latitude/longitude stay local.',
              ),
              value: session.syncRouteDetail,
              onChanged: onSyncRouteDetailChanged,
            ),
            Row(
              children: [
                Expanded(
                  child: _PrivacyChip(
                    label: 'Visibility',
                    value: session.routeVisibility,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PrivacyChip(
                    label: 'Hide start/end',
                    value: '${session.hideStartEndMeters.round()} m',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onEditPrivacy,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit privacy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePrivacyTab extends StatefulWidget {
  final ActivitySession session;
  final List<ActivityPoint> points;
  final ValueChanged<bool> onSyncRouteDetailChanged;
  final VoidCallback onEditPrivacy;
  final Future<void> Function(double hiddenMeters) onSaveHiddenMeters;

  const _RoutePrivacyTab({
    required this.session,
    required this.points,
    required this.onSyncRouteDetailChanged,
    required this.onEditPrivacy,
    required this.onSaveHiddenMeters,
  });

  @override
  State<_RoutePrivacyTab> createState() => _RoutePrivacyTabState();
}

class _RoutePrivacyTabState extends State<_RoutePrivacyTab> {
  late double _pendingHiddenMeters;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _pendingHiddenMeters = widget.session.hideStartEndMeters;
  }

  @override
  void didUpdateWidget(covariant _RoutePrivacyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.localId != widget.session.localId ||
        oldWidget.session.hideStartEndMeters !=
            widget.session.hideStartEndMeters) {
      _pendingHiddenMeters = widget.session.hideStartEndMeters;
    }
  }

  @override
  Widget build(BuildContext context) {
    final changed =
        (_pendingHiddenMeters - widget.session.hideStartEndMeters).abs() >= 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.session.requiresGps) ...[
          RouteCropPreview(
            points: widget.points,
            initialHiddenMeters: widget.session.hideStartEndMeters,
            onHiddenMetersChanged:
                (value) => setState(() => _pendingHiddenMeters = value),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _saving || !changed ? null : _save,
            icon:
                _saving
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Saving...' : 'Save route crop'),
          ),
          const SizedBox(height: 14),
        ],
        _SyncAndPrivacyPanel(
          session: widget.session,
          onSyncRouteDetailChanged: widget.onSyncRouteDetailChanged,
          onEditPrivacy: widget.onEditPrivacy,
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.onSaveHiddenMeters(_pendingHiddenMeters);
    if (mounted) setState(() => _saving = false);
  }
}

class _HeartRateOverlapChart extends StatelessWidget {
  final List<HealthRecord> records;

  const _HeartRateOverlapChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final values = records
        .map((record) => _HrPoint(record.dateFrom, record.value))
        .toList(growable: false);
    final avg =
        values.isEmpty
            ? 0
            : values.fold<double>(0, (sum, point) => sum + point.value) /
                values.length;
    final min = values
        .map((point) => point.value)
        .reduce((a, b) => a < b ? a : b);
    final max = values
        .map((point) => point.value)
        .reduce((a, b) => a > b ? a : b);

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
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Heart rate during activity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text('${records.length} records'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Avg ${avg.round()} bpm / min ${min.round()} / max ${max.round()}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomPaint(painter: _HrChartPainter(values)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HrPoint {
  final DateTime time;
  final double value;

  const _HrPoint(this.time, this.value);
}

class _HrChartPainter extends CustomPainter {
  final List<_HrPoint> values;

  const _HrChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final start = values.first.time;
    final minX = 0.0;
    final maxX = values.last.time
        .difference(start)
        .inSeconds
        .toDouble()
        .clamp(1, 1 << 31);
    final minY = values.map((v) => v.value).reduce((a, b) => a < b ? a : b);
    final maxY = values.map((v) => v.value).reduce((a, b) => a > b ? a : b);
    final ySpan = (maxY - minY).abs() < 1 ? 1.0 : maxY - minY;

    final gridPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Offset map(_HrPoint value) {
      final x =
          ((value.time.difference(start).inSeconds - minX) / maxX) * size.width;
      final y = size.height - ((value.value - minY) / ySpan) * size.height;
      return Offset(x, y.clamp(0, size.height));
    }

    final path = Path()..moveTo(map(values.first).dx, map(values.first).dy);
    for (final value in values.skip(1)) {
      final point = map(value);
      path.lineTo(point.dx, point.dy);
    }
    final paint =
        Paint()
          ..color = Colors.red.shade600
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HrChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _AiSummaryPanel extends StatelessWidget {
  final ActivitySummary? summary;
  final Future<void> Function() onGenerate;

  const _AiSummaryPanel({required this.summary, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final existing = summary;
    final narrative = existing?.agentNotes?.trim();
    return InfoPanel(
      icon: Icons.auto_awesome_outlined,
      title:
          existing == null
              ? 'AI summary not yet generated'
              : 'AI summary generated',
      body:
          existing == null
              ? 'Generate a compact wellness/activity summary for ZeroClaw without exposing raw route points unless route detail sync is enabled.'
              : [
                if (narrative != null && narrative.isNotEmpty)
                  'Workout narrative: $narrative',
                existing.markdownSummary,
              ].join('\n\n'),
      action: TextButton.icon(
        onPressed: onGenerate,
        icon: const Icon(Icons.auto_awesome),
        label: Text(existing == null ? 'Generate' : 'Regenerate'),
      ),
    );
  }
}

class _PrivacyEditResult {
  final String routeVisibility;
  final double hideStartEndMeters;

  const _PrivacyEditResult({
    required this.routeVisibility,
    required this.hideStartEndMeters,
  });
}

Future<void> _showPrivacyEditSheet(
  BuildContext context,
  WidgetRef ref,
  ActivitySession session,
) async {
  final result = await showModalBottomSheet<_PrivacyEditResult>(
    context: context,
    showDragHandle: true,
    builder:
        (sheetContext) => _PrivacyEditSheet(
          routeVisibility: session.routeVisibility,
          hideStartEndMeters: session.hideStartEndMeters,
        ),
  );
  if (result == null) return;

  await ref
      .read(databaseProvider)
      .setActivityPrivacy(
        session.localId,
        routeVisibility: result.routeVisibility,
        hideStartEndMeters: result.hideStartEndMeters,
      );
  ref.invalidate(activitySessionProvider(session.localId));
  ref.invalidate(activityHistoryProvider);
}

class _PrivacyEditSheet extends StatefulWidget {
  final String routeVisibility;
  final double hideStartEndMeters;

  const _PrivacyEditSheet({
    required this.routeVisibility,
    required this.hideStartEndMeters,
  });

  @override
  State<_PrivacyEditSheet> createState() => _PrivacyEditSheetState();
}

class _PrivacyEditSheetState extends State<_PrivacyEditSheet> {
  late String _routeVisibility;
  late double _hideStartEndMeters;

  @override
  void initState() {
    super.initState();
    _routeVisibility = widget.routeVisibility;
    _hideStartEndMeters = widget.hideStartEndMeters;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit privacy',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _routeVisibility,
              decoration: const InputDecoration(
                labelText: 'Route visibility',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'private', child: Text('Private')),
                DropdownMenuItem(value: 'followers', child: Text('Followers')),
                DropdownMenuItem(value: 'public', child: Text('Public')),
              ],
              onChanged:
                  (value) =>
                      setState(() => _routeVisibility = value ?? 'private'),
            ),
            const SizedBox(height: 16),
            Text(
              'Hide start/end: ${_hideStartEndMeters.round()} m',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Slider(
              value: _hideStartEndMeters.clamp(0, 1000).toDouble(),
              min: 0,
              max: 1000,
              divisions: 20,
              label: '${_hideStartEndMeters.round()} m',
              onChanged: (value) => setState(() => _hideStartEndMeters = value),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop(
                  _PrivacyEditResult(
                    routeVisibility: _routeVisibility,
                    hideStartEndMeters: _hideStartEndMeters,
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save privacy'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  final String label;
  final String value;

  const _PrivacyChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class _GpsQualityPanel extends StatelessWidget {
  final List<ActivityPoint> points;
  final ActivityGpsQuality quality;

  const _GpsQualityPanel({required this.points, required this.quality});

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.route,
      title: 'GPS quality: ${points.length} points',
      body:
          points.isEmpty
              ? 'No route points were recorded for this activity.'
              : 'good ${quality.good}, usable ${quality.usable}, low ${quality.low}, unknown ${quality.unknown}.',
    );
  }
}

class _ElevationCorrectionPanel extends StatelessWidget {
  final ElevationCorrectionSummary summary;

  const _ElevationCorrectionPanel({required this.summary});

  @override
  Widget build(BuildContext context) {
    final (icon, title, body) = switch (summary.status) {
      'no_route_points' => (
        Icons.terrain_outlined,
        'Elevation unavailable',
        'No GPS route points are available for this activity.',
      ),
      'altitude_sensor_not_found' => (
        Icons.sensors_off_outlined,
        'Altitude sensor not found',
        'GPS points were recorded, but no valid altitude was exported by the phone or source device.',
      ),
      'corrected' => (
        Icons.terrain,
        'Elevation corrected',
        '${summary.correctedAltitudeCount}/${summary.pointCount} points have corrected altitude. Model: ${summary.primaryModel}.',
      ),
      _ => (
        Icons.terrain_outlined,
        'Raw altitude only',
        '${summary.rawAltitudeCount}/${summary.pointCount} points have altitude, but geoid correction metadata is missing.',
      ),
    };
    return InfoPanel(icon: icon, title: title, body: body);
  }
}

class _ErrorPanel extends StatelessWidget {
  final Object error;

  const _ErrorPanel({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InfoPanel(
        icon: Icons.error_outline,
        title: 'Activity detail unavailable',
        body: error.toString(),
      ),
    );
  }
}
