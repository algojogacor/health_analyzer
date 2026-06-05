import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/saved_route_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import 'widgets/route_map.dart';

class SavedRouteDetailPage extends ConsumerWidget {
  final SavedRoute route;

  const SavedRouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveRoute = ref.watch(savedRouteProvider(route.localId));
    return liveRoute.when(
      data: (value) => _SavedRouteDetailScaffold(route: value ?? route),
      loading:
          () => Scaffold(
            appBar: AppBar(title: Text(route.name)),
            body: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, _) => Scaffold(
            appBar: AppBar(title: Text(route.name)),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: InfoPanel(
                icon: Icons.error_outline,
                title: 'Route unavailable',
                body: error.toString(),
              ),
            ),
          ),
    );
  }
}

class _SavedRouteDetailScaffold extends ConsumerWidget {
  final SavedRoute route;

  const _SavedRouteDetailScaffold({required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geometry = ref.read(savedRouteServiceProvider).geometryFor(route);
    final points = geometry.points
        .map(
          (point) => RouteMapPoint(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        )
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(title: Text(route.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          RouteMap(
            points: points,
            height: 320,
            style: RouteMapStyle.street,
            emptyLabel:
                'No local route geometry was saved for this route. Save or build a route again to enable preview.',
          ),
          const SizedBox(height: 16),
          _RouteStats(route: route, geometrySource: geometry.source),
          const SizedBox(height: 16),
          _ElevationPreview(
            route: route,
            geometry: geometry,
            hasGeometry: points.length >= 2,
          ),
          const SizedBox(height: 16),
          _Actions(route: route, hasGeometry: points.length >= 2),
        ],
      ),
    );
  }
}

class _RouteStats extends StatelessWidget {
  final SavedRoute route;
  final String geometrySource;

  const _RouteStats({required this.route, required this.geometrySource});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(icon: Icons.route, color: AppTheme.cyan),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '$geometrySource / ${route.routeVisibility}',
                      style: TextStyle(color: AppTheme.mutedText(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Distance',
                  value:
                      '${(route.distanceMeters / 1000).toStringAsFixed(2)} km',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(label: 'Points', value: '${route.pointCount}'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'Saved',
                  value: fmtTime(route.createdAt),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ElevationPreview extends StatelessWidget {
  final SavedRoute route;
  final SavedRouteGeometry geometry;
  final bool hasGeometry;

  const _ElevationPreview({
    required this.route,
    required this.geometry,
    required this.hasGeometry,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasGeometry) {
      return const InfoPanel(
        icon: Icons.terrain_outlined,
        title: 'Elevation unavailable',
        body:
            'This saved route has no local geometry, so elevation preview cannot be calculated.',
      );
    }
    final samples = geometry.elevationSamples;
    if (samples.length < 2) {
      return const InfoPanel(
        icon: Icons.terrain_outlined,
        title: 'Elevation preview not ready',
        body:
            'Route geometry is available, but elevation needs recorded GPS altitude, imported GPX ele values, or a future DEM/PMTiles elevation source. The route still works for planning and GPX export.',
      );
    }
    final minAlt = samples
        .map((sample) => sample.altitudeMeters)
        .reduce(math.min);
    final maxAlt = samples
        .map((sample) => sample.altitudeMeters)
        .reduce(math.max);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(icon: Icons.terrain, color: AppTheme.mint),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Elevation profile',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${samples.length} samples',
                style: TextStyle(
                  color: AppTheme.mutedText(context),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _ElevationProfilePainter(
                samples: samples,
                lineColor: AppTheme.mint,
                fillColor: AppTheme.mint.withValues(alpha: 0.16),
                gridColor: AppTheme.border(context),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Ascent',
                  value: '${route.ascentMeters.round()} m',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'Descent',
                  value: '${route.descentMeters.round()} m',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'Range',
                  value: '${minAlt.round()}-${maxAlt.round()} m',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ElevationProfilePainter extends CustomPainter {
  final List<SavedRouteElevationSample> samples;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  const _ElevationProfilePainter({
    required this.samples,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2 || size.width <= 0 || size.height <= 0) return;
    final minDistance = samples.first.distanceMeters;
    final maxDistance =
        samples.last.distanceMeters <= minDistance
            ? minDistance + 1
            : samples.last.distanceMeters;
    final minAltitude = samples
        .map((sample) => sample.altitudeMeters)
        .reduce(math.min);
    final maxAltitude = samples
        .map((sample) => sample.altitudeMeters)
        .reduce(math.max);
    final altitudeSpan = math.max(8.0, maxAltitude - minAltitude);
    const padding = EdgeInsets.fromLTRB(6, 8, 6, 18);
    final chart = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    final gridPaint =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    Offset project(SavedRouteElevationSample sample) {
      final xRatio =
          (sample.distanceMeters - minDistance) / (maxDistance - minDistance);
      final yRatio = (sample.altitudeMeters - minAltitude) / altitudeSpan;
      return Offset(
        chart.left + xRatio.clamp(0.0, 1.0) * chart.width,
        chart.bottom - yRatio.clamp(0.0, 1.0) * chart.height,
      );
    }

    final path =
        Path()..moveTo(project(samples.first).dx, project(samples.first).dy);
    for (final sample in samples.skip(1)) {
      final point = project(sample);
      path.lineTo(point.dx, point.dy);
    }

    final fillPath =
        Path.from(path)
          ..lineTo(chart.right, chart.bottom)
          ..lineTo(chart.left, chart.bottom)
          ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ElevationProfilePainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.gridColor != gridColor;
  }
}

class _Actions extends ConsumerStatefulWidget {
  final SavedRoute route;
  final bool hasGeometry;

  const _Actions({required this.route, required this.hasGeometry});

  @override
  ConsumerState<_Actions> createState() => _ActionsState();
}

class _ActionsState extends ConsumerState<_Actions> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: _busy ? null : _setTarget,
            icon: const Icon(Icons.flag),
            label: const Text('Set as target route'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _busy || !widget.hasGeometry ? null : _exportGpx,
            icon: const Icon(Icons.ios_share),
            label: const Text('Export GPX'),
          ),
        ],
      ),
    );
  }

  Future<void> _setTarget() async {
    setState(() => _busy = true);
    try {
      await ref.read(routeTargetServiceProvider).setTarget(widget.route);
      ref.invalidate(routeTargetProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.route.name} set as target route')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportGpx() async {
    setState(() => _busy = true);
    try {
      final file = await ref
          .read(savedRouteServiceProvider)
          .exportRouteGpx(widget.route);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/gpx+xml')],
          text: 'Route GPX from Health Analyzer',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Route export failed: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.softSurface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.mutedText(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
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
