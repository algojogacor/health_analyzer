import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import 'widgets/route_map.dart';

class ActivitySavePage extends ConsumerStatefulWidget {
  final String sessionLocalId;

  const ActivitySavePage({super.key, required this.sessionLocalId});

  @override
  ConsumerState<ActivitySavePage> createState() => _ActivitySavePageState();
}

class _ActivitySavePageState extends ConsumerState<ActivitySavePage> {
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  String? _initializedSessionId;
  String _routeVisibility = 'private';
  double _hideStartEndMeters = 300;
  bool _syncRouteDetail = false;
  bool _writeHealthConnect = true;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionValue = ref.watch(
      activitySessionProvider(widget.sessionLocalId),
    );
    final pointsValue = ref.watch(
      activityPointsProvider(widget.sessionLocalId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Save activity')),
      body: sessionValue.when(
        data: (session) {
          if (session == null) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Activity not found',
                body:
                    'This workout could not be loaded. It may have been discarded.',
              ),
            );
          }
          _initializeFromSession(session);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _Header(session: session),
              const SizedBox(height: 16),
              _TitleField(controller: _titleController),
              const SizedBox(height: 12),
              _TagsField(controller: _tagsController),
              const SizedBox(height: 16),
              _WorkoutNarrativePreview(
                text: ref
                    .read(workoutNarrativeServiceProvider)
                    .generate(session: session, heartRateRecords: const []),
              ),
              const SizedBox(height: 16),
              pointsValue.when(
                data:
                    (points) => _RoutePreview(
                      points: points,
                      syncRouteDetail: _syncRouteDetail,
                    ),
                loading:
                    () => const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (error, _) => InfoPanel(
                      icon: Icons.map_outlined,
                      title: 'Route preview unavailable',
                      body: error.toString(),
                    ),
              ),
              const SizedBox(height: 16),
              _PrivacyOptions(
                routeVisibility: _routeVisibility,
                hideStartEndMeters: _hideStartEndMeters,
                syncRouteDetail: _syncRouteDetail,
                writeHealthConnect: _writeHealthConnect,
                onRouteVisibilityChanged:
                    (value) => setState(() => _routeVisibility = value),
                onHideStartEndChanged:
                    (value) => setState(() => _hideStartEndMeters = value),
                onSyncRouteDetailChanged:
                    (value) => setState(() => _syncRouteDetail = value),
                onWriteHealthConnectChanged:
                    (value) => setState(() => _writeHealthConnect = value),
              ),
              const SizedBox(height: 20),
              _ActionButtons(
                saving: _saving,
                onSave: () => _save(session),
                onDiscard: () => _confirmDiscard(session),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Save flow unavailable',
                body: error.toString(),
              ),
            ),
      ),
    );
  }

  void _initializeFromSession(ActivitySession session) {
    if (_initializedSessionId == session.localId) return;
    _initializedSessionId = session.localId;
    _titleController.text = session.title ?? session.sportName;
    _tagsController.text = session.tags;
    _routeVisibility = session.routeVisibility;
    _hideStartEndMeters = session.hideStartEndMeters;
    _syncRouteDetail = session.syncRouteDetail;
    _writeHealthConnect = session.writeHealthConnect;
  }

  Future<void> _save(ActivitySession session) async {
    setState(() => _saving = true);
    try {
      final savedSnapshot = await ref
          .read(activityRecorderProvider)
          .saveCompleted(
            session.localId,
            ActivitySaveOptions(
              title: _titleController.text,
              tags: _tagsController.text,
              routeVisibility: _routeVisibility,
              hideStartEndMeters: _hideStartEndMeters,
              syncRouteDetail: _syncRouteDetail,
              writeHealthConnect: _writeHealthConnect,
            ),
          );
      await _generateSummary(session.localId);
      await ref
          .read(proactiveInsightServiceProvider)
          .maybeNotifyActivitySaved(session.localId);
      final savedSession =
          savedSnapshot.session ??
          await ref.read(databaseProvider).getActivitySession(session.localId);
      if (savedSession != null) {
        unawaited(
          ref.read(webhookServiceProvider).sendActivitySaved(savedSession),
        );
        final records = await ref
            .read(personalRecordServiceProvider)
            .recordsForSession(savedSession.localId);
        if (records.isNotEmpty) {
          unawaited(
            ref
                .read(webhookServiceProvider)
                .sendPersonalRecords(savedSession, records),
          );
        }
      }
      _invalidateActivityState(session.localId);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDiscard(ActivitySession session) async {
    final discard = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discard activity?',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This workout will be marked discarded and will not appear in activity history.',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.of(sheetContext).pop(false),
                          child: const Text('Keep editing'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                          ),
                          onPressed: () => Navigator.of(sheetContext).pop(true),
                          child: const Text('Discard'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
    if (discard != true) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(activityRecorderProvider)
          .discard(localId: session.localId);
      _invalidateActivityState(session.localId);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Discard failed: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _invalidateActivityState(String localId) {
    ref.invalidate(activityHistoryProvider);
    ref.invalidate(activityRecorderSnapshotProvider);
    ref.invalidate(activitySessionProvider(localId));
    ref.invalidate(activityPointsProvider(localId));
    ref.invalidate(unsyncedCountProvider);
  }

  Future<void> _generateSummary(String localId) async {
    final savedSession = await ref
        .read(databaseProvider)
        .getActivitySession(localId);
    if (savedSession == null) return;
    final points = await ref.read(databaseProvider).getActivityPoints(localId);
    final hr = await ref.read(activityHeartRateRecordsProvider(localId).future);
    final cadence = await ref.read(
      activityCadenceAnalysisProvider(localId).future,
    );
    final draft = ref
        .read(activityAiSummaryServiceProvider)
        .generate(
          session: savedSession,
          points: points,
          heartRateRecords: hr,
          cadenceAnalysis: cadence,
        );
    await ref
        .read(databaseProvider)
        .upsertActivitySummary(
          ActivitySummariesCompanion.insert(
            sessionLocalId: savedSession.localId,
            jsonSummary: draft.jsonSummary,
            markdownSummary: draft.markdownSummary,
            generatedAt: DateTime.now(),
            model: const Value('local-tool'),
            confidence: const Value('structured'),
            generatedBy: const Value('local'),
            agentNotes: Value(draft.narrative),
          ),
        );
  }
}

class _WorkoutNarrativePreview extends StatelessWidget {
  final String text;

  const _WorkoutNarrativePreview({required this.text});

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.auto_awesome_outlined,
      title: 'Workout narrative',
      body:
          '$text\n\nA richer narrative with available HR/cadence context will be saved locally after you save the activity.',
    );
  }
}

class _Header extends StatelessWidget {
  final ActivitySession session;

  const _Header({required this.session});

  @override
  Widget build(BuildContext context) {
    final distanceKm = session.distanceMeters / 1000;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  session.requiresGps ? Icons.map : Icons.fitness_center,
                  color: Colors.teal,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    session.sportName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _StatusPill(status: session.status),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 22,
              runSpacing: 12,
              children: [
                _SummaryMetric(
                  label: 'Distance',
                  value: '${distanceKm.toStringAsFixed(2)} km',
                ),
                _SummaryMetric(
                  label: 'Moving',
                  value: fmtDuration(session.movingSeconds),
                ),
                _SummaryMetric(
                  label: 'Elapsed',
                  value: fmtDuration(session.elapsedSeconds),
                ),
                _SummaryMetric(
                  label: 'Stopped',
                  value: fmtDuration(session.stoppedSeconds),
                ),
                _SummaryMetric(
                  label: 'Ascent',
                  value: '${session.ascentMeters.round()} m',
                ),
                _SummaryMetric(
                  label: 'Start',
                  value: fmtTime(session.startedAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Activity title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit_outlined),
      ),
    );
  }
}

class _TagsField extends StatelessWidget {
  final TextEditingController controller;

  const _TagsField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'morning run, hot weather, fasted',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.sell_outlined),
      ),
    );
  }
}

class _RoutePreview extends StatelessWidget {
  final List<ActivityPoint> points;
  final bool syncRouteDetail;

  const _RoutePreview({required this.points, required this.syncRouteDetail});

  @override
  Widget build(BuildContext context) {
    final route = points
        .map(
          (point) => RouteMapPoint(
            latitude: point.latitude,
            longitude: point.longitude,
            accuracyMeters: point.accuracyMeters,
          ),
        )
        .toList(growable: false);

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
                Icon(Icons.route, color: Colors.cyan.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Route preview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text('${points.length} pts'),
              ],
            ),
            const SizedBox(height: 12),
            RouteMap(
              points: route,
              style: RouteMapStyle.satellite,
              height: 240,
              showAccuracy: true,
              emptyLabel:
                  'No GPS points for this workout. You can still save the summary.',
            ),
            const SizedBox(height: 10),
            Text(
              syncRouteDetail
                  ? 'Route detail will be synced to Turso when you run sync.'
                  : 'Only the workout summary will sync. Route detail stays local.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyOptions extends StatelessWidget {
  final String routeVisibility;
  final double hideStartEndMeters;
  final bool syncRouteDetail;
  final bool writeHealthConnect;
  final ValueChanged<String> onRouteVisibilityChanged;
  final ValueChanged<double> onHideStartEndChanged;
  final ValueChanged<bool> onSyncRouteDetailChanged;
  final ValueChanged<bool> onWriteHealthConnectChanged;

  const _PrivacyOptions({
    required this.routeVisibility,
    required this.hideStartEndMeters,
    required this.syncRouteDetail,
    required this.writeHealthConnect,
    required this.onRouteVisibilityChanged,
    required this.onHideStartEndChanged,
    required this.onSyncRouteDetailChanged,
    required this.onWriteHealthConnectChanged,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy and sync',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: routeVisibility,
              decoration: const InputDecoration(
                labelText: 'Route visibility',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'private', child: Text('Private')),
                DropdownMenuItem(value: 'followers', child: Text('Followers')),
                DropdownMenuItem(value: 'public', child: Text('Public')),
              ],
              onChanged: (value) {
                if (value != null) onRouteVisibilityChanged(value);
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Hide start/end: ${hideStartEndMeters.round()} m',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Slider(
              value: hideStartEndMeters.clamp(0, 1000).toDouble(),
              min: 0,
              max: 1000,
              divisions: 20,
              label: '${hideStartEndMeters.round()} m',
              onChanged: onHideStartEndChanged,
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sync route detail to Turso'),
              subtitle: const Text(
                'Off keeps latitude/longitude points local; summary still syncs.',
              ),
              value: syncRouteDetail,
              onChanged: onSyncRouteDetailChanged,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Write workout to Health Connect'),
              subtitle: const Text(
                'Saved only after you tap Save, never during review.',
              ),
              value: writeHealthConnect,
              onChanged: onWriteHealthConnectChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const _ActionButtons({
    required this.saving,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: saving ? null : onDiscard,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Discard'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: saving ? null : onSave,
            icon:
                saving
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.check),
            label: Text(saving ? 'Saving' : 'Save'),
          ),
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status,
          style: TextStyle(
            color: Colors.orange.shade800,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
