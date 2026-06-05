import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';
import '../shared/theme/app_theme.dart';
import '../shared/utils/formatters.dart';

class ActivityShareCardService {
  const ActivityShareCardService();

  static const int _width = 1080;
  static const int _height = 1350;

  Future<File> generate(
    ActivitySession session,
    List<ActivityPoint> points,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(_width.toDouble(), _height.toDouble());
    final routePoints = _privacySafeRoute(session, points);

    _paintBackground(canvas, size, session.sportKey);
    _paintHeader(canvas, session);
    _paintRoutePanel(canvas, routePoints, session);
    _paintStats(canvas, session);
    _paintFooter(canvas, session, routePoints);

    final picture = recorder.endRecording();
    final image = await picture.toImage(_width, _height);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      throw StateError('Share card image could not be encoded.');
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        '${_safeFileName(session.title ?? session.sportName)}-${session.startedAt.millisecondsSinceEpoch}.png',
      ),
    );
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file;
  }

  List<ActivityPoint> _privacySafeRoute(
    ActivitySession session,
    List<ActivityPoint> points,
  ) {
    if (!session.requiresGps || points.length < 2) return const [];
    if (session.routeVisibility == 'public' && session.syncRouteDetail) {
      return _sample(points);
    }

    final total = points.fold<double>(
      0,
      (sum, point) => sum + point.distanceFromPrevMeters,
    );
    if (total <= 0) return const [];

    final minVisible = math.min(200.0, total * 0.2);
    final maxHiddenPerSide = math.max(0.0, (total - minVisible) / 2);
    final hidden = math.min(
      session.hideStartEndMeters <= 0 ? 300.0 : session.hideStartEndMeters,
      maxHiddenPerSide,
    );
    if (hidden <= 0) return _sample(points);

    var cumulative = 0.0;
    final cropped = <ActivityPoint>[];
    for (final point in points) {
      cumulative += point.distanceFromPrevMeters;
      if (cumulative >= hidden && cumulative <= total - hidden) {
        cropped.add(point);
      }
    }
    if (cropped.length < 2) return const [];
    return _sample(cropped);
  }

  List<ActivityPoint> _sample(List<ActivityPoint> points) {
    const maxPoints = 420;
    if (points.length <= maxPoints) return points;
    final step = points.length / maxPoints;
    return List.generate(maxPoints, (index) => points[(index * step).floor()]);
  }

  void _paintBackground(Canvas canvas, Size size, String sportKey) {
    final accent = _sportAccent(sportKey);
    final paint =
        Paint()
          ..shader = ui.Gradient.linear(
            Offset.zero,
            Offset(size.width, size.height),
            [
              AppTheme.ink,
              const Color(0xFF0E1518),
              accent.withValues(alpha: 0.72),
            ],
            [0, 0.58, 1],
          );
    canvas.drawRect(Offset.zero & size, paint);

    canvas.drawCircle(
      const Offset(980, 140),
      260,
      Paint()..color = accent.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      const Offset(80, 1180),
      300,
      Paint()..color = AppTheme.cyan.withValues(alpha: 0.12),
    );
  }

  void _paintHeader(Canvas canvas, ActivitySession session) {
    final title =
        session.title?.trim().isNotEmpty == true
            ? session.title!.trim()
            : session.sportName;
    _drawPill(
      canvas,
      const Rect.fromLTWH(72, 72, 280, 64),
      session.sportName.toUpperCase(),
      _sportAccent(session.sportKey),
    );
    _drawText(
      canvas,
      title,
      72,
      174,
      920,
      74,
      FontWeight.w900,
      Colors.white,
      maxLines: 2,
    );
    _drawText(
      canvas,
      _dateLabel(session.startedAt),
      76,
      330,
      760,
      30,
      FontWeight.w700,
      Colors.white.withValues(alpha: 0.72),
    );
  }

  void _paintRoutePanel(
    Canvas canvas,
    List<ActivityPoint> routePoints,
    ActivitySession session,
  ) {
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(72, 402, 936, 450),
      const Radius.circular(36),
    );
    canvas.drawRRect(
      rect,
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawMapGrid(canvas, rect.outerRect);

    if (routePoints.length < 2) {
      final label =
          session.requiresGps
              ? 'Route hidden by privacy settings'
              : 'Indoor workout';
      _drawText(
        canvas,
        label,
        118,
        588,
        844,
        42,
        FontWeight.w900,
        Colors.white.withValues(alpha: 0.88),
        align: TextAlign.center,
      );
      _drawText(
        canvas,
        session.requiresGps
            ? 'Stats are still shareable without raw GPS.'
            : 'No GPS route is attached to this activity.',
        150,
        642,
        780,
        27,
        FontWeight.w700,
        Colors.white.withValues(alpha: 0.56),
        align: TextAlign.center,
      );
      return;
    }

    final path = Path();
    final mapRect = const Rect.fromLTWH(118, 448, 844, 352);
    final projected = _project(routePoints, mapRect);
    for (var i = 0; i < projected.length; i++) {
      final point = projected[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 18,
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(mapRect.topLeft, mapRect.bottomRight, [
          AppTheme.cyan,
          AppTheme.mint,
          AppTheme.amber,
        ])
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 11,
    );

    _drawEndpoint(canvas, projected.first, AppTheme.mint, 'S');
    _drawEndpoint(canvas, projected.last, AppTheme.coral, 'F');
  }

  void _paintStats(Canvas canvas, ActivitySession session) {
    const top = 898.0;
    const left = 72.0;
    const gap = 22.0;
    const cardWidth = (_width - 144 - gap) / 2;
    const cardHeight = 140.0;

    final stats = [
      ('Distance', '${(session.distanceMeters / 1000).toStringAsFixed(2)} km'),
      ('Moving', fmtDuration(session.movingSeconds)),
      ('Pace', _paceLabel(session)),
      ('Ascent', '${session.ascentMeters.round()} m'),
      ('Calories', '${session.caloriesKcal.round()} kcal'),
      ('Elapsed', fmtDuration(session.elapsedSeconds)),
    ];

    for (var i = 0; i < stats.length; i++) {
      final row = i ~/ 2;
      final col = i % 2;
      final rect = Rect.fromLTWH(
        left + col * (cardWidth + gap),
        top + row * (cardHeight + gap),
        cardWidth,
        cardHeight,
      );
      _drawStatCard(canvas, rect, stats[i].$1, stats[i].$2);
    }
  }

  void _paintFooter(
    Canvas canvas,
    ActivitySession session,
    List<ActivityPoint> routePoints,
  ) {
    final privacyText =
        routePoints.isEmpty
            ? 'Private by default'
            : session.routeVisibility == 'public' && session.syncRouteDetail
            ? 'Public route'
            : 'Start/end hidden';
    _drawText(
      canvas,
      privacyText,
      72,
      1272,
      360,
      27,
      FontWeight.w800,
      Colors.white.withValues(alpha: 0.62),
    );
    _drawText(
      canvas,
      'Health Analyzer',
      610,
      1268,
      398,
      34,
      FontWeight.w900,
      Colors.white,
      align: TextAlign.right,
    );
  }

  void _drawStatCard(Canvas canvas, Rect rect, String label, String value) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(28));
    canvas.drawRRect(
      rrect,
      Paint()..color = Colors.white.withValues(alpha: 0.1),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      label,
      rect.left + 28,
      rect.top + 26,
      rect.width - 56,
      25,
      FontWeight.w800,
      Colors.white.withValues(alpha: 0.62),
    );
    _drawText(
      canvas,
      value,
      rect.left + 28,
      rect.top + 62,
      rect.width - 56,
      43,
      FontWeight.w900,
      Colors.white,
    );
  }

  void _drawMapGrid(Canvas canvas, Rect rect) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.07)
          ..strokeWidth = 1;
    for (var i = 1; i < 6; i++) {
      final x = rect.left + rect.width * i / 6;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), paint);
    }
    for (var i = 1; i < 4; i++) {
      final y = rect.top + rect.height * i / 4;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
    }
  }

  List<Offset> _project(List<ActivityPoint> points, Rect rect) {
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLon = points.first.longitude;
    var maxLon = points.first.longitude;
    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLon = math.min(minLon, point.longitude);
      maxLon = math.max(maxLon, point.longitude);
    }
    final latSpan = math.max(maxLat - minLat, 0.00001);
    final lonSpan = math.max(maxLon - minLon, 0.00001);
    final scale = math.min(rect.width / lonSpan, rect.height / latSpan);
    final usedWidth = lonSpan * scale;
    final usedHeight = latSpan * scale;
    final left = rect.left + (rect.width - usedWidth) / 2;
    final top = rect.top + (rect.height - usedHeight) / 2;
    return points
        .map((point) {
          final x = left + (point.longitude - minLon) * scale;
          final y = top + (maxLat - point.latitude) * scale;
          return Offset(x, y);
        })
        .toList(growable: false);
  }

  void _drawEndpoint(Canvas canvas, Offset center, Color color, String label) {
    canvas.drawCircle(center, 26, Paint()..color = Colors.black45);
    canvas.drawCircle(center, 21, Paint()..color = color);
    _drawText(
      canvas,
      label,
      center.dx - 18,
      center.dy - 16,
      36,
      20,
      FontWeight.w900,
      Colors.white,
      align: TextAlign.center,
    );
  }

  void _drawPill(Canvas canvas, Rect rect, String text, Color color) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(32));
    canvas.drawRRect(rrect, Paint()..color = color.withValues(alpha: 0.22));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawText(
      canvas,
      text,
      rect.left + 28,
      rect.top + 19,
      rect.width - 56,
      20,
      FontWeight.w900,
      Colors.white,
      align: TextAlign.center,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double width,
    double fontSize,
    FontWeight weight,
    Color color, {
    TextAlign align = TextAlign.left,
    int maxLines = 1,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          height: 1.08,
          letterSpacing: 0,
        ),
      ),
      maxLines: maxLines,
      ellipsis: '...',
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    painter.paint(canvas, Offset(x, y));
  }

  Color _sportAccent(String sportKey) {
    if (sportKey.contains('cycling') || sportKey.contains('bike')) {
      return AppTheme.mint;
    }
    if (sportKey.contains('walk') || sportKey.contains('hiking')) {
      return AppTheme.amber;
    }
    if (sportKey.contains('strength') || sportKey.contains('fitness')) {
      return AppTheme.violet;
    }
    return AppTheme.cyan;
  }

  String _paceLabel(ActivitySession session) {
    if (session.distanceMeters <= 0 || session.movingSeconds <= 0) return '--';
    final secondsPerKm =
        session.movingSeconds / (session.distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = secondsPerKm.round() % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }

  String _dateLabel(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year} / ${fmtTime(value)}';
  }

  String _safeFileName(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return cleaned.isEmpty ? 'health-analyzer-share-card' : cleaned;
  }
}
