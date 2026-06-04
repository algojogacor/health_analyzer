import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../models/sport_mode.dart';
import 'health_service.dart';
import 'moving_time_service.dart';

class ActivityRecorderSnapshot {
  final ActivitySession? session;
  final MovingTimeResult? stats;
  final int pointCount;
  final List<TrackPoint> routePoints;

  const ActivityRecorderSnapshot({
    required this.session,
    required this.stats,
    required this.pointCount,
    this.routePoints = const [],
  });

  bool get isRecording =>
      session?.status == 'recording' || session?.status == 'paused';

  TrackPoint? get lastPoint => routePoints.isEmpty ? null : routePoints.last;

  double? get lastAccuracyMeters => lastPoint?.accuracyMeters;

  String get locationQualityLabel {
    final accuracy = lastAccuracyMeters;
    if (accuracy == null) return 'Searching';
    if (accuracy <= 10) return 'Exact';
    if (accuracy <= 25) return 'Good';
    if (accuracy <= 50) return 'Weak';
    return 'Searching';
  }
}

class ActivitySaveOptions {
  final String title;
  final String routeVisibility;
  final double hideStartEndMeters;
  final bool syncRouteDetail;
  final bool writeHealthConnect;

  const ActivitySaveOptions({
    required this.title,
    required this.routeVisibility,
    required this.hideStartEndMeters,
    required this.syncRouteDetail,
    required this.writeHealthConnect,
  });
}

class ActivityPrivacyDefaults {
  final String routeVisibility;
  final double hideStartEndMeters;
  final bool syncRouteDetail;
  final bool writeHealthConnect;

  const ActivityPrivacyDefaults({
    this.routeVisibility = 'private',
    this.hideStartEndMeters = 300,
    this.syncRouteDetail = false,
    this.writeHealthConnect = true,
  });

  ActivityPrivacyDefaults copyWith({
    String? routeVisibility,
    double? hideStartEndMeters,
    bool? syncRouteDetail,
    bool? writeHealthConnect,
  }) {
    return ActivityPrivacyDefaults(
      routeVisibility: routeVisibility ?? this.routeVisibility,
      hideStartEndMeters: hideStartEndMeters ?? this.hideStartEndMeters,
      syncRouteDetail: syncRouteDetail ?? this.syncRouteDetail,
      writeHealthConnect: writeHealthConnect ?? this.writeHealthConnect,
    );
  }
}

class ActivityRecorderService {
  static const _routeVisibilityKey = 'activity.default.route_visibility';
  static const _hideStartEndMetersKey =
      'activity.default.hide_start_end_meters';
  static const _syncRouteDetailKey = 'activity.default.sync_route_detail';
  static const _writeHealthConnectKey = 'activity.default.write_health_connect';

  final AppDatabase db;
  final HealthService healthService;
  final FlutterSecureStorage storage;
  final _uuid = const Uuid();
  final _movingTime = MovingTimeService();

  StreamSubscription<Position>? _positionSub;
  SportMode? _activeMode;
  String? _activeLocalId;
  bool _manualPaused = false;
  final _points = <TrackPoint>[];
  final _controller = StreamController<ActivityRecorderSnapshot>.broadcast();

  ActivityRecorderService(
    this.db,
    this.healthService, {
    FlutterSecureStorage? storage,
  }) : storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           );

  Stream<ActivityRecorderSnapshot> get snapshots => _controller.stream;

  Future<ActivityRecorderSnapshot> loadActiveSession() async {
    final session = await db.activeActivitySession().getSingleOrNull();
    final points =
        session == null
            ? <ActivityPoint>[]
            : await db.activityPointsForSession(session.localId).get();
    _activeLocalId = session?.localId;
    _activeMode = session == null ? null : sportModeByKey(session.sportKey);
    _manualPaused =
        session != null &&
        session.status == 'paused' &&
        _metadataMap(session.metadata)['pause_reason'] == 'manual';
    _points
      ..clear()
      ..addAll(points.map(_trackPointFromDb));
    final snapshot = _snapshot(session);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> resumeActiveLocationStream() async {
    var session = await db.activeActivitySession().getSingleOrNull();
    if (session == null) return _snapshot(null);

    _activeLocalId = session.localId;
    _activeMode = sportModeByKey(session.sportKey);
    _manualPaused =
        session.status == 'paused' &&
        _metadataMap(session.metadata)['pause_reason'] == 'manual';

    final points = await db.activityPointsForSession(session.localId).get();
    _points
      ..clear()
      ..addAll(points.map(_trackPointFromDb));

    if (session.requiresGps && _positionSub == null) {
      await _ensureLocationPermission(_activeMode!);
      await _startLocationStream();
      session = await db.activeActivitySession().getSingleOrNull();
    }

    final snapshot = _snapshot(session);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityPrivacyDefaults> loadPrivacyDefaults() async {
    final routeVisibility =
        await storage.read(key: _routeVisibilityKey) ?? 'private';
    final hideStartEndMeters =
        double.tryParse(
          await storage.read(key: _hideStartEndMetersKey) ?? '',
        ) ??
        300;
    final syncRouteDetail =
        (await storage.read(key: _syncRouteDetailKey)) == 'true';
    final writeHealthConnect =
        (await storage.read(key: _writeHealthConnectKey)) != 'false';

    return ActivityPrivacyDefaults(
      routeVisibility: _validRouteVisibility(routeVisibility),
      hideStartEndMeters: hideStartEndMeters.clamp(0, 1000).toDouble(),
      syncRouteDetail: syncRouteDetail,
      writeHealthConnect: writeHealthConnect,
    );
  }

  Future<void> savePrivacyDefaults(ActivityPrivacyDefaults defaults) async {
    await Future.wait([
      storage.write(
        key: _routeVisibilityKey,
        value: _validRouteVisibility(defaults.routeVisibility),
      ),
      storage.write(
        key: _hideStartEndMetersKey,
        value: defaults.hideStartEndMeters.clamp(0, 1000).toStringAsFixed(0),
      ),
      storage.write(
        key: _syncRouteDetailKey,
        value: defaults.syncRouteDetail.toString(),
      ),
      storage.write(
        key: _writeHealthConnectKey,
        value: defaults.writeHealthConnect.toString(),
      ),
    ]);
  }

  Future<ActivityRecorderSnapshot> start(SportMode mode) async {
    await _ensureLocationPermission(mode);
    await stopLocationStreamOnly();

    final privacy = await loadPrivacyDefaults();
    final localId = _uuid.v4();
    final now = DateTime.now();
    await db.insertActivitySession(
      ActivitySessionsCompanion.insert(
        localId: localId,
        title: Value(mode.name),
        sportKey: mode.key,
        sportName: mode.name,
        category: mode.category,
        requiresGps: Value(mode.requiresGps),
        status: const Value('recording'),
        startedAt: now,
        routeVisibility: Value(privacy.routeVisibility),
        hideStartEndMeters: Value(privacy.hideStartEndMeters),
        syncRouteDetail: Value(privacy.syncRouteDetail),
        writeHealthConnect: Value(privacy.writeHealthConnect),
        metadata: Value(
          jsonEncode({
            'auto_pause': true,
            'stop_speed_mps': mode.stopSpeedMps,
            'resume_speed_mps': mode.resumeSpeedMps,
            'min_stop_seconds': mode.minStopSeconds,
            'privacy_default': privacy.routeVisibility,
          }),
        ),
      ),
    );
    _activeLocalId = localId;
    _activeMode = mode;
    _manualPaused = false;
    _points.clear();

    if (mode.requiresGps) {
      await _startLocationStream();
    }

    final session = await db.activeActivitySession().getSingleOrNull();
    await _insertEvent(localId, 'start');
    final snapshot = _snapshot(session);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> pause() async {
    final localId = _activeLocalId;
    if (localId == null) return _snapshot(null);

    _manualPaused = true;
    final session = await db.getActivitySession(localId);
    final metadata =
        _metadataMap(session?.metadata)
          ..['pause_reason'] = 'manual'
          ..['paused_started_at'] = DateTime.now().toIso8601String();

    await db.updateActivitySession(
      localId,
      ActivitySessionsCompanion(
        status: const Value('paused'),
        metadata: Value(jsonEncode(metadata)),
      ),
    );
    await _insertEvent(localId, 'manual_pause');
    final updated = await db.getActivitySession(localId);
    final snapshot = _snapshot(updated);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> resume() async {
    final localId = _activeLocalId;
    if (localId == null) return _snapshot(null);

    final session = await db.getActivitySession(localId);
    final metadata = _metadataMap(session?.metadata);
    final pausedStartedAt = _dateTimeFromMetadata(
      metadata['paused_started_at'],
    );
    final pausedSeconds =
        pausedStartedAt == null
            ? 0
            : DateTime.now()
                .difference(pausedStartedAt)
                .inSeconds
                .clamp(0, 1 << 31)
                .toInt();
    metadata
      ..remove('pause_reason')
      ..remove('paused_started_at');

    _manualPaused = false;
    await db.updateActivitySession(
      localId,
      ActivitySessionsCompanion(
        status: const Value('recording'),
        manualPausedSeconds: Value(
          (session?.manualPausedSeconds ?? 0) + pausedSeconds,
        ),
        metadata: Value(jsonEncode(metadata)),
      ),
    );
    await _insertEvent(localId, 'manual_resume');
    final updated = await db.getActivitySession(localId);
    final snapshot = _snapshot(updated);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> addLapMarker() async {
    final localId = _activeLocalId;
    final mode = _activeMode;
    if (localId == null || mode == null) return _snapshot(null);

    final session = await db.getActivitySession(localId);
    final stats = _calculateStats(mode, session?.manualPausedSeconds ?? 0);
    await _insertEvent(
      localId,
      'manual_lap',
      metadata: {
        'elapsed_seconds': stats.elapsedSeconds,
        'moving_seconds': stats.movingSeconds,
        'distance_meters': stats.distanceMeters,
        'point_count': _points.length,
      },
    );
    final snapshot = _snapshot(session);
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> finishForReview() async {
    await stopLocationStreamOnly();
    final localId = _activeLocalId;
    if (localId == null) {
      return const ActivityRecorderSnapshot(
        session: null,
        stats: null,
        pointCount: 0,
      );
    }

    final mode = _activeMode ?? sportModeByKey('free_activities');
    var session = await db.getActivitySession(localId);
    final metadata = _metadataMap(session?.metadata);
    var manualPausedSeconds = session?.manualPausedSeconds ?? 0;
    final pausedStartedAt = _dateTimeFromMetadata(
      metadata['paused_started_at'],
    );
    if (_manualPaused && pausedStartedAt != null) {
      manualPausedSeconds +=
          DateTime.now()
              .difference(pausedStartedAt)
              .inSeconds
              .clamp(0, 1 << 31)
              .toInt();
      metadata
        ..remove('pause_reason')
        ..remove('paused_started_at');
    }
    final stats = _calculateStats(mode, manualPausedSeconds);
    final now = DateTime.now();
    await db.updateActivitySession(
      localId,
      ActivitySessionsCompanion(
        status: const Value('reviewing'),
        endedAt: Value(now),
        elapsedSeconds: Value(stats.elapsedSeconds),
        movingSeconds: Value(stats.movingSeconds),
        stoppedSeconds: Value(stats.stoppedSeconds),
        distanceMeters: Value(stats.distanceMeters),
        ascentMeters: Value(stats.ascentMeters),
        descentMeters: Value(stats.descentMeters),
        avgSpeedMps: Value(stats.avgSpeedMps),
        maxSpeedMps: Value(stats.maxSpeedMps),
        manualPausedSeconds: Value(manualPausedSeconds),
        metadata: Value(
          jsonEncode(
            metadata..addAll({
              'stopped_segments':
                  stats.stoppedSegments
                      .map(
                        (segment) => {
                          'start': segment.startedAt.toIso8601String(),
                          'end': segment.endedAt.toIso8601String(),
                          'reason': segment.reason,
                        },
                      )
                      .toList(),
            }),
          ),
        ),
      ),
    );
    session = await db.getActivitySession(localId);
    await _insertEvent(localId, 'finish_review');
    _activeLocalId = null;
    _activeMode = null;
    _manualPaused = false;
    final snapshot = ActivityRecorderSnapshot(
      session: session,
      stats: stats,
      pointCount: _points.length,
      routePoints: List.unmodifiable(_points),
    );
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> saveCompleted(
    String localId,
    ActivitySaveOptions options,
  ) async {
    final existing = await db.getActivitySession(localId);
    if (existing == null) {
      return const ActivityRecorderSnapshot(
        session: null,
        stats: null,
        pointCount: 0,
      );
    }

    final mode = sportModeByKey(existing.sportKey);
    final points = await db.getActivityPoints(localId);
    _points
      ..clear()
      ..addAll(points.map(_trackPointFromDb));
    final stats = _calculateStats(mode, existing.manualPausedSeconds);
    final endedAt = existing.endedAt ?? DateTime.now();

    await db.updateActivitySession(
      localId,
      ActivitySessionsCompanion(
        title: Value(
          options.title.trim().isEmpty
              ? existing.sportName
              : options.title.trim(),
        ),
        status: const Value('completed'),
        endedAt: Value(endedAt),
        elapsedSeconds: Value(stats.elapsedSeconds),
        movingSeconds: Value(stats.movingSeconds),
        stoppedSeconds: Value(stats.stoppedSeconds),
        distanceMeters: Value(stats.distanceMeters),
        ascentMeters: Value(stats.ascentMeters),
        descentMeters: Value(stats.descentMeters),
        avgSpeedMps: Value(stats.avgSpeedMps),
        maxSpeedMps: Value(stats.maxSpeedMps),
        routeVisibility: Value(options.routeVisibility),
        hideStartEndMeters: Value(options.hideStartEndMeters),
        syncRouteDetail: Value(options.syncRouteDetail),
        writeHealthConnect: Value(options.writeHealthConnect),
        syncStatus: const Value('pending'),
      ),
    );

    final session = await db.getActivitySession(localId);
    if (session != null && session.writeHealthConnect) {
      await healthService.writeWorkoutSummary(
        sportMode: mode,
        start: session.startedAt,
        end: session.endedAt ?? endedAt,
        distanceMeters: stats.distanceMeters,
        caloriesKcal: session.caloriesKcal,
      );
    }
    await _insertEvent(localId, 'save_completed');
    final snapshot = ActivityRecorderSnapshot(
      session: session,
      stats: stats,
      pointCount: _points.length,
      routePoints: List.unmodifiable(_points),
    );
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> discard({String? localId}) async {
    await stopLocationStreamOnly();
    final targetLocalId = localId ?? _activeLocalId;
    if (targetLocalId == null) {
      return const ActivityRecorderSnapshot(
        session: null,
        stats: null,
        pointCount: 0,
      );
    }

    final existing = await db.getActivitySession(targetLocalId);
    final mode =
        _activeMode ??
        (existing == null
            ? sportModeByKey('free_activities')
            : sportModeByKey(existing.sportKey));
    if (existing != null && _activeLocalId == null) {
      final points = await db.getActivityPoints(targetLocalId);
      _points
        ..clear()
        ..addAll(points.map(_trackPointFromDb));
    }
    final stats = _calculateStats(mode, existing?.manualPausedSeconds ?? 0);
    await db.updateActivitySession(
      targetLocalId,
      ActivitySessionsCompanion(
        status: const Value('discarded'),
        endedAt: Value(DateTime.now()),
        elapsedSeconds: Value(stats.elapsedSeconds),
        movingSeconds: Value(stats.movingSeconds),
        stoppedSeconds: Value(stats.stoppedSeconds),
        distanceMeters: Value(stats.distanceMeters),
        ascentMeters: Value(stats.ascentMeters),
        descentMeters: Value(stats.descentMeters),
        avgSpeedMps: Value(stats.avgSpeedMps),
        maxSpeedMps: Value(stats.maxSpeedMps),
      ),
    );
    await _insertEvent(targetLocalId, 'discard');
    _activeLocalId = null;
    _activeMode = null;
    _manualPaused = false;
    final session = await db.getActivitySession(targetLocalId);
    final snapshot = ActivityRecorderSnapshot(
      session: session,
      stats: stats,
      pointCount: _points.length,
      routePoints: List.unmodifiable(_points),
    );
    _controller.add(snapshot);
    return snapshot;
  }

  Future<ActivityRecorderSnapshot> stop() => finishForReview();

  Future<void> stopLocationStreamOnly() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  Future<void> dispose() async {
    await stopLocationStreamOnly();
    await _controller.close();
  }

  Future<void> _startLocationStream() async {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );
    _positionSub = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(_handlePosition);
  }

  Future<void> _handlePosition(Position position) async {
    final localId = _activeLocalId;
    final mode = _activeMode;
    if (localId == null || mode == null) return;

    final point = TrackPoint(
      timestamp: position.timestamp,
      latitude: position.latitude,
      longitude: position.longitude,
      altitudeMeters: position.altitude,
      accuracyMeters: position.accuracy,
      speedMps: position.speed,
      bearingDegrees: position.heading,
      activityRecognition: _manualPaused ? 'MANUAL_PAUSED' : null,
    );
    final distanceFromPrev =
        _points.isEmpty
            ? 0.0
            : MovingTimeService.haversineMeters(_points.last, point);
    _points.add(point);
    final currentSession = await db.getActivitySession(localId);
    final stats = _calculateStats(
      mode,
      currentSession?.manualPausedSeconds ?? 0,
    );
    final shouldBePaused =
        stats.stoppedSegments.isNotEmpty &&
        stats.stoppedSegments.last.endedAt == point.timestamp;
    final status = _manualPaused || shouldBePaused ? 'paused' : 'recording';

    await db.insertActivityPoint(
      ActivityPointsCompanion.insert(
        sessionLocalId: localId,
        timestamp: point.timestamp,
        latitude: point.latitude,
        longitude: point.longitude,
        altitudeMeters: Value(point.altitudeMeters),
        accuracyMeters: Value(point.accuracyMeters),
        speedMps: Value(point.speedMps),
        bearingDegrees: Value(point.bearingDegrees),
        distanceFromPrevMeters: Value(distanceFromPrev),
        moving: Value(status == 'recording'),
        pointQuality: Value(_pointQuality(point, mode)),
        provider: const Value('fused'),
        metadata:
            _manualPaused
                ? Value(jsonEncode({'activity_recognition': 'MANUAL_PAUSED'}))
                : const Value.absent(),
      ),
    );
    await db.updateActivitySession(
      localId,
      ActivitySessionsCompanion(
        status: Value(status),
        elapsedSeconds: Value(stats.elapsedSeconds),
        movingSeconds: Value(stats.movingSeconds),
        stoppedSeconds: Value(stats.stoppedSeconds),
        distanceMeters: Value(stats.distanceMeters),
        ascentMeters: Value(stats.ascentMeters),
        descentMeters: Value(stats.descentMeters),
        avgSpeedMps: Value(stats.avgSpeedMps),
        maxSpeedMps: Value(stats.maxSpeedMps),
      ),
    );
    final session = await db.activeActivitySession().getSingleOrNull();
    _controller.add(
      ActivityRecorderSnapshot(
        session: session,
        stats: stats,
        pointCount: _points.length,
        routePoints: List.unmodifiable(_points),
      ),
    );
  }

  Future<void> _ensureLocationPermission(SportMode mode) async {
    if (!mode.requiresGps) return;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw StateError('Location service is disabled');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission denied');
    }
  }

  ActivityRecorderSnapshot _snapshot(ActivitySession? session) {
    final mode = _activeMode;
    final stats =
        mode == null
            ? null
            : _calculateStats(mode, session?.manualPausedSeconds ?? 0);
    return ActivityRecorderSnapshot(
      session: session,
      stats: stats,
      pointCount: _points.length,
      routePoints: List.unmodifiable(_points),
    );
  }

  TrackPoint _trackPointFromDb(ActivityPoint point) {
    final metadata = _metadataMap(point.metadata);
    return TrackPoint(
      timestamp: point.timestamp,
      latitude: point.latitude,
      longitude: point.longitude,
      altitudeMeters: point.altitudeMeters,
      accuracyMeters: point.accuracyMeters,
      speedMps: point.speedMps,
      bearingDegrees: point.bearingDegrees,
      activityRecognition: metadata['activity_recognition']?.toString(),
    );
  }

  String _pointQuality(TrackPoint point, SportMode mode) {
    final accuracy = point.accuracyMeters;
    if (accuracy == null) return 'unknown';
    if (accuracy <= mode.accuracyFilterMeters / 2) return 'good';
    if (accuracy <= mode.accuracyFilterMeters) return 'usable';
    return 'low';
  }

  MovingTimeResult _calculateStats(SportMode mode, int manualPausedSeconds) {
    final raw = _movingTime.calculate(_points, mode);
    if (manualPausedSeconds <= 0) return raw;
    return MovingTimeResult(
      elapsedSeconds: raw.elapsedSeconds,
      movingSeconds: raw.movingSeconds,
      stoppedSeconds: raw.stoppedSeconds + manualPausedSeconds,
      distanceMeters: raw.distanceMeters,
      ascentMeters: raw.ascentMeters,
      descentMeters: raw.descentMeters,
      avgSpeedMps: raw.avgSpeedMps,
      maxSpeedMps: raw.maxSpeedMps,
      stoppedSegments: raw.stoppedSegments,
    );
  }

  Future<void> _insertEvent(
    String localId,
    String eventType, {
    Map<String, dynamic>? metadata,
  }) {
    return db.insertActivityEvent(
      ActivityEventsCompanion.insert(
        sessionLocalId: localId,
        eventType: eventType,
        timestamp: DateTime.now(),
        metadata:
            metadata == null
                ? const Value.absent()
                : Value(jsonEncode(metadata)),
      ),
    );
  }

  Map<String, dynamic> _metadataMap(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return <String, dynamic>{};
    }
    return <String, dynamic>{};
  }

  DateTime? _dateTimeFromMetadata(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _validRouteVisibility(String value) {
    return switch (value) {
      'followers' || 'public' || 'private' => value,
      _ => 'private',
    };
  }
}
