import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/activity_recorder_service.dart';
import '../../services/moving_time_service.dart';
import '../../services/voice_coach_service.dart';
import 'activity_save_page.dart';
import 'widgets/recording_map_controls.dart';
import 'widgets/recording_stat_sheet.dart';
import 'widgets/route_map.dart';

class ActivityRecordingPage extends ConsumerStatefulWidget {
  final SportMode mode;

  const ActivityRecordingPage({super.key, required this.mode});

  @override
  ConsumerState<ActivityRecordingPage> createState() =>
      _ActivityRecordingPageState();
}

class _ActivityRecordingPageState extends ConsumerState<ActivityRecordingPage> {
  RouteMapStyle _style = RouteMapStyle.street;
  bool _busy = false;
  bool _followCurrentLocation = true;
  Timer? _autoRecenterTimer;
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activityRecorderProvider).resumeActiveLocationStream();
    });
  }

  @override
  void dispose() {
    _autoRecenterTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(activityRecorderSnapshotProvider);
    final targetRoute = ref.watch(routeTargetProvider).valueOrNull;
    final targetGeometry =
        targetRoute == null
            ? null
            : ref.read(savedRouteServiceProvider).geometryFor(targetRoute);
    final targetRoutePoints =
        targetGeometry?.points
            .map(
              (point) => RouteMapPoint(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
            )
            .toList(growable: false) ??
        const <RouteMapPoint>[];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: snapshot.when(
        data:
            (value) => _RecordingContent(
              mode: widget.mode,
              style: _style,
              mapController: _mapController,
              followCurrentLocation: _followCurrentLocation,
              busy: _busy,
              snapshot: value,
              targetRoutePoints: targetRoutePoints,
              onBack: () => Navigator.of(context).maybePop(),
              onStyleChanged: (style) => setState(() => _style = style),
              onRecenter: () {
                _autoRecenterTimer?.cancel();
                setState(() => _followCurrentLocation = true);
              },
              onUserMapInteraction: _handleUserMapInteraction,
              onPause: _pause,
              onResume: _resume,
              onLap: _lap,
              onStop: _showStopSheet,
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Recording unavailable: $error'),
            ),
      ),
    );
  }

  Future<void> _pause() async {
    if (_busy) return;
    setState(() => _busy = true);
    final snapshot = await ref.read(activityRecorderProvider).pause();
    unawaited(
      ref
          .read(voiceCoachServiceProvider)
          .announce(VoiceCoachEvent.pause, stats: snapshot.stats),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _resume() async {
    if (_busy) return;
    setState(() => _busy = true);
    final snapshot = await ref.read(activityRecorderProvider).resume();
    unawaited(
      ref
          .read(voiceCoachServiceProvider)
          .announce(VoiceCoachEvent.resume, stats: snapshot.stats),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _lap() async {
    if (_busy) return;
    final snapshot = await ref.read(activityRecorderProvider).addLapMarker();
    unawaited(
      ref
          .read(voiceCoachServiceProvider)
          .announce(VoiceCoachEvent.lap, stats: snapshot.stats),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lap marker added')));
  }

  void _handleUserMapInteraction() {
    _autoRecenterTimer?.cancel();
    if (_followCurrentLocation && mounted) {
      setState(() => _followCurrentLocation = false);
    }
    _autoRecenterTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() => _followCurrentLocation = true);
    });
  }

  Future<void> _showStopSheet() async {
    if (_busy) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Stop activity?',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Resume to keep recording, finish to review before saving, or discard this activity.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _finishForReview(sheetContext),
                    icon: const Icon(Icons.flag),
                    label: const Text('Finish'),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _discard(sheetContext),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Discard'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _finishForReview(BuildContext sheetContext) async {
    if (_busy) return;
    setState(() => _busy = true);
    final snapshot = await ref.read(activityRecorderProvider).finishForReview();
    unawaited(
      ref
          .read(voiceCoachServiceProvider)
          .announce(VoiceCoachEvent.finish, stats: snapshot.stats),
    );
    ref.invalidate(activityRecorderSnapshotProvider);
    ref.invalidate(activityHistoryProvider);

    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    final session = snapshot.session;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ActivitySavePage(sessionLocalId: session.localId),
        ),
      );
    } else {
      setState(() => _busy = false);
    }
  }

  Future<void> _discard(BuildContext sheetContext) async {
    if (_busy) return;
    setState(() => _busy = true);
    await ref.read(activityRecorderProvider).discard();
    ref.invalidate(activityRecorderSnapshotProvider);
    ref.invalidate(activityHistoryProvider);

    if (!mounted || !sheetContext.mounted) return;
    Navigator.of(sheetContext).pop();
    Navigator.of(context).pop();
  }
}

class _RecordingContent extends StatelessWidget {
  final SportMode mode;
  final RouteMapStyle style;
  final MapController mapController;
  final bool followCurrentLocation;
  final bool busy;
  final ActivityRecorderSnapshot snapshot;
  final List<RouteMapPoint> targetRoutePoints;
  final VoidCallback onBack;
  final ValueChanged<RouteMapStyle> onStyleChanged;
  final VoidCallback onRecenter;
  final VoidCallback onUserMapInteraction;
  final Future<void> Function() onPause;
  final Future<void> Function() onResume;
  final Future<void> Function() onLap;
  final Future<void> Function() onStop;

  const _RecordingContent({
    required this.mode,
    required this.style,
    required this.mapController,
    required this.followCurrentLocation,
    required this.busy,
    required this.snapshot,
    required this.targetRoutePoints,
    required this.onBack,
    required this.onStyleChanged,
    required this.onRecenter,
    required this.onUserMapInteraction,
    required this.onPause,
    required this.onResume,
    required this.onLap,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final points = snapshot.routePoints;
    final routePoints = _routePoints(points);
    final displayPoints =
        routePoints.isEmpty && targetRoutePoints.isNotEmpty
            ? targetRoutePoints
            : routePoints;

    return Stack(
      children: [
        Positioned.fill(
          child:
              mode.requiresGps
                  ? RouteMap(
                    controller: mapController,
                    points: displayPoints,
                    targetPoints:
                        routePoints.isEmpty ? const [] : targetRoutePoints,
                    style: style,
                    height: double.infinity,
                    showAccuracy: true,
                    followCurrentLocation: followCurrentLocation,
                    followZoom: routePoints.length <= 1 ? 17 : null,
                    onUserInteraction: onUserMapInteraction,
                    borderRadius: 0,
                    emptyLabel:
                        'Acquiring GPS. Keep location enabled and stay in an open area.',
                  )
                  : _IndoorRecordingHero(mode: mode, stats: stats),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: RecordingMapControls(
            sportName: mode.name,
            requiresGps: mode.requiresGps,
            status: snapshot.session?.status,
            locationLabel: snapshot.locationQualityLabel,
            accuracyMeters: snapshot.lastAccuracyMeters,
            style: style,
            onStyleChanged: onStyleChanged,
            onRecenter: () {
              if (routePoints.isNotEmpty) {
                mapController.move(routePoints.last.latLng, 17);
              }
              onRecenter();
            },
            onBack: onBack,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: RecordingStatSheet(
            snapshot: snapshot,
            busy: busy,
            onPause: onPause,
            onResume: onResume,
            onLap: onLap,
            onStop: onStop,
          ),
        ),
      ],
    );
  }

  List<RouteMapPoint> _routePoints(List<TrackPoint> points) {
    return points
        .map(
          (point) => RouteMapPoint(
            latitude: point.latitude,
            longitude: point.longitude,
            accuracyMeters: point.accuracyMeters,
          ),
        )
        .toList(growable: false);
  }
}

class _IndoorRecordingHero extends StatelessWidget {
  final SportMode mode;
  final MovingTimeResult? stats;

  const _IndoorRecordingHero({required this.mode, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fitness_center, size: 48, color: Colors.cyan.shade700),
          const SizedBox(height: 12),
          Text(
            mode.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text('Indoor mode', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 18),
          Text(
            '${((stats?.distanceMeters ?? 0) / 1000).toStringAsFixed(2)} km',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
