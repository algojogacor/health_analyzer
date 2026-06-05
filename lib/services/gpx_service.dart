import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import '../database/database.dart';
import '../models/sport_mode.dart';
import 'geoid_correction_service.dart';

class GpxTrackPoint {
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double? altitudeMeters;
  final double distanceFromPreviousMeters;
  final double? speedMps;

  const GpxTrackPoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.distanceFromPreviousMeters,
    this.altitudeMeters,
    this.speedMps,
  });
}

class ParsedGpxTrack {
  final String title;
  final String sportKey;
  final List<GpxTrackPoint> points;
  final DateTime startedAt;
  final DateTime endedAt;
  final double distanceMeters;
  final double ascentMeters;
  final double descentMeters;
  final double? avgSpeedMps;
  final double? maxSpeedMps;

  const ParsedGpxTrack({
    required this.title,
    required this.sportKey,
    required this.points,
    required this.startedAt,
    required this.endedAt,
    required this.distanceMeters,
    required this.ascentMeters,
    required this.descentMeters,
    required this.avgSpeedMps,
    required this.maxSpeedMps,
  });

  int get elapsedSeconds =>
      endedAt.difference(startedAt).inSeconds.clamp(0, 1 << 31).toInt();
}

class GpxImportResult {
  final ActivitySession session;
  final int pointCount;

  const GpxImportResult({required this.session, required this.pointCount});
}

class GpxService {
  final AppDatabase db;
  final _uuid = const Uuid();
  final _distance = const Distance();
  final _geoid = const GeoidCorrectionService();

  GpxService(this.db);

  Future<GpxImportResult> importFromPath(String path) async {
    final file = File(path);
    final raw = await file.readAsString();
    final parsed = parse(raw, fallbackTitle: _titleFromPath(path));
    if (parsed.points.length < 2) {
      throw StateError('GPX file must contain at least two track points');
    }

    final mode = sportModeByKey(parsed.sportKey);
    final localId = _uuid.v4();
    await db.transaction(() async {
      await db.insertActivitySession(
        ActivitySessionsCompanion.insert(
          localId: localId,
          title: Value(parsed.title),
          sportKey: mode.key,
          sportName: mode.name,
          category: mode.category,
          requiresGps: const Value(true),
          status: const Value('completed'),
          startedAt: parsed.startedAt,
          endedAt: Value(parsed.endedAt),
          elapsedSeconds: Value(parsed.elapsedSeconds),
          movingSeconds: Value(parsed.elapsedSeconds),
          stoppedSeconds: const Value(0),
          distanceMeters: Value(parsed.distanceMeters),
          ascentMeters: Value(parsed.ascentMeters),
          descentMeters: Value(parsed.descentMeters),
          avgSpeedMps: Value(parsed.avgSpeedMps),
          maxSpeedMps: Value(parsed.maxSpeedMps),
          source: const Value('gpx_import'),
          routeVisibility: const Value('private'),
          hideStartEndMeters: const Value(300),
          syncRouteDetail: const Value(false),
          writeHealthConnect: const Value(false),
          metadata: Value(
            '{"source":"gpx_import","imported_file":"${_jsonEscape(p.basename(path))}"}',
          ),
        ),
      );

      for (final point in parsed.points) {
        final elevationMetadata =
            point.altitudeMeters == null
                ? {
                  'status': 'altitude_sensor_not_found',
                  'note': 'This GPX point has no ele value.',
                }
                : _geoid.gpxElevationMetadata();
        await db.insertActivityPoint(
          ActivityPointsCompanion.insert(
            sessionLocalId: localId,
            timestamp: point.timestamp,
            latitude: point.latitude,
            longitude: point.longitude,
            altitudeMeters: Value(point.altitudeMeters),
            altitudeCorrectedMeters: Value(point.altitudeMeters),
            accuracyMeters: const Value(null),
            speedMps: Value(point.speedMps),
            bearingDegrees: const Value(null),
            distanceFromPrevMeters: Value(point.distanceFromPreviousMeters),
            moving: const Value(true),
            pointQuality: const Value('imported'),
            provider: const Value('gpx_import'),
            metadata: Value(jsonEncode({'elevation': elevationMetadata})),
          ),
        );
      }
    });

    final session = await db.getActivitySession(localId);
    if (session == null) {
      throw StateError('Imported GPX session could not be loaded');
    }
    return GpxImportResult(session: session, pointCount: parsed.points.length);
  }

  Future<File> exportSession(ActivitySession session) async {
    final points = await db.getActivityPoints(session.localId);
    if (points.length < 2) {
      throw StateError('Activity needs at least two GPS points to export GPX');
    }
    final dir = await getTemporaryDirectory();
    final safeTitle = _safeFileName(session.title ?? session.sportName);
    final file = File(
      p.join(
        dir.path,
        '$safeTitle-${session.startedAt.millisecondsSinceEpoch}.gpx',
      ),
    );
    await file.writeAsString(buildGpx(session, points));
    return file;
  }

  String buildGpx(ActivitySession session, List<ActivityPoint> points) {
    final exportPoints = _privacyCroppedPoints(session, points);
    final buffer =
        StringBuffer()
          ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
          ..writeln(
            '<gpx version="1.1" creator="Health Analyzer" xmlns="http://www.topografix.com/GPX/1/1">',
          )
          ..writeln('  <metadata>')
          ..writeln(
            '    <name>${_xmlEscape(session.title ?? session.sportName)}</name>',
          )
          ..writeln('    <time>${_iso(session.startedAt)}</time>')
          ..writeln('  </metadata>')
          ..writeln('  <trk>')
          ..writeln(
            '    <name>${_xmlEscape(session.title ?? session.sportName)}</name>',
          )
          ..writeln('    <type>${_xmlEscape(session.sportKey)}</type>')
          ..writeln('    <trkseg>');

    for (final point in exportPoints) {
      buffer.writeln(
        '      <trkpt lat="${point.latitude.toStringAsFixed(7)}" lon="${point.longitude.toStringAsFixed(7)}">',
      );
      final altitude = point.altitudeCorrectedMeters ?? point.altitudeMeters;
      if (altitude != null) {
        buffer.writeln('        <ele>${altitude.toStringAsFixed(2)}</ele>');
      }
      buffer.writeln('        <time>${_iso(point.timestamp)}</time>');
      buffer.writeln('      </trkpt>');
    }

    buffer
      ..writeln('    </trkseg>')
      ..writeln('  </trk>')
      ..writeln('</gpx>');
    return buffer.toString();
  }

  ParsedGpxTrack parse(String raw, {String fallbackTitle = 'Imported GPX'}) {
    final document = XmlDocument.parse(raw);
    final track = _firstElement(document.findAllElements('trk'));
    final title =
        _text(
          track == null ? null : _firstElement(track.findElements('name')),
        ) ??
        _text(_firstElement(document.findAllElements('name'))) ??
        fallbackTitle;
    final sportKey = _sportKeyFromType(
      _text(track == null ? null : _firstElement(track.findElements('type'))) ??
          _text(_firstElement(document.findAllElements('type'))) ??
          title,
    );

    final rawPoints =
        document
            .findAllElements('trkpt')
            .map((node) {
              final latitude = double.tryParse(node.getAttribute('lat') ?? '');
              final longitude = double.tryParse(node.getAttribute('lon') ?? '');
              if (latitude == null || longitude == null) return null;
              return (
                latitude: latitude,
                longitude: longitude,
                altitude: double.tryParse(
                  _text(_firstElement(node.findElements('ele'))) ?? '',
                ),
                timestamp: DateTime.tryParse(
                  _text(_firstElement(node.findElements('time'))) ?? '',
                ),
              );
            })
            .whereType<
              ({
                double latitude,
                double longitude,
                double? altitude,
                DateTime? timestamp,
              })
            >()
            .toList();

    if (rawPoints.isEmpty) {
      throw StateError('No GPX track points found');
    }

    final fallbackStart = DateTime.now();
    final points = <GpxTrackPoint>[];
    var distanceMeters = 0.0;
    var ascentMeters = 0.0;
    var descentMeters = 0.0;
    double? maxSpeedMps;

    for (var i = 0; i < rawPoints.length; i++) {
      final current = rawPoints[i];
      final previous = i == 0 ? null : rawPoints[i - 1];
      final timestamp =
          current.timestamp?.toLocal() ??
          fallbackStart.add(Duration(seconds: i));
      var distanceFromPrevious = 0.0;
      double? speedMps;

      if (previous != null) {
        distanceFromPrevious = _distance.as(
          LengthUnit.Meter,
          LatLng(previous.latitude, previous.longitude),
          LatLng(current.latitude, current.longitude),
        );
        distanceMeters += distanceFromPrevious;

        final previousAlt = previous.altitude;
        final altitude = current.altitude;
        if (previousAlt != null && altitude != null) {
          final diff = altitude - previousAlt;
          if (diff > 0) {
            ascentMeters += diff;
          } else {
            descentMeters += diff.abs();
          }
        }

        final previousTime =
            previous.timestamp?.toLocal() ??
            fallbackStart.add(Duration(seconds: i - 1));
        final seconds = timestamp.difference(previousTime).inSeconds;
        if (seconds > 0) {
          speedMps = distanceFromPrevious / seconds;
          maxSpeedMps =
              maxSpeedMps == null ? speedMps : math.max(maxSpeedMps, speedMps);
        }
      }

      points.add(
        GpxTrackPoint(
          timestamp: timestamp,
          latitude: current.latitude,
          longitude: current.longitude,
          altitudeMeters: current.altitude,
          distanceFromPreviousMeters: distanceFromPrevious,
          speedMps: speedMps,
        ),
      );
    }

    final startedAt = points.first.timestamp;
    final endedAt = points.last.timestamp;
    final elapsedSeconds = endedAt.difference(startedAt).inSeconds;
    final avgSpeedMps =
        elapsedSeconds <= 0 || distanceMeters <= 0
            ? null
            : distanceMeters / elapsedSeconds;

    return ParsedGpxTrack(
      title: title.trim().isEmpty ? fallbackTitle : title.trim(),
      sportKey: sportKey,
      points: points,
      startedAt: startedAt,
      endedAt: endedAt,
      distanceMeters: distanceMeters,
      ascentMeters: ascentMeters,
      descentMeters: descentMeters,
      avgSpeedMps: avgSpeedMps,
      maxSpeedMps: maxSpeedMps,
    );
  }

  List<ActivityPoint> _privacyCroppedPoints(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    if (points.length < 3 || session.hideStartEndMeters <= 0) return points;
    if (session.routeVisibility == 'public') return points;

    final total = points.fold<double>(
      0,
      (value, point) => value + point.distanceFromPrevMeters,
    );
    if (total <= 0) return points;

    final hidden = math.min(session.hideStartEndMeters, total * 0.4);
    var cumulative = 0.0;
    final cropped = <ActivityPoint>[];
    for (final point in points) {
      cumulative += point.distanceFromPrevMeters;
      if (cumulative >= hidden && cumulative <= total - hidden) {
        cropped.add(point);
      }
    }
    return cropped.length >= 2 ? cropped : points;
  }

  String _sportKeyFromType(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('walk')) return 'walking';
    if (lower.contains('hike')) return 'hiking';
    if (lower.contains('cycle') ||
        lower.contains('bike') ||
        lower.contains('cycling')) {
      return 'outdoor_cycling';
    }
    if (lower.contains('run')) return 'outdoor_running';
    return 'outdoor_running';
  }

  String _titleFromPath(String path) {
    final name = p.basenameWithoutExtension(path).replaceAll('_', ' ').trim();
    return name.isEmpty ? 'Imported GPX' : name;
  }

  String _safeFileName(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return cleaned.isEmpty ? 'health-analyzer-activity' : cleaned;
  }

  String? _text(XmlElement? element) {
    final value = element?.innerText.trim();
    return value == null || value.isEmpty ? null : value;
  }

  XmlElement? _firstElement(Iterable<XmlElement> elements) {
    final iterator = elements.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }

  String _iso(DateTime value) => value.toUtc().toIso8601String();

  String _xmlEscape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  String _jsonEscape(String value) =>
      value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
}
