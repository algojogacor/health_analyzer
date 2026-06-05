import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import 'activity_heatmap_page.dart';
import 'route_builder_page.dart';
import 'saved_route_detail_page.dart';

class RouteLibraryPage extends ConsumerWidget {
  const RouteLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(savedRoutesProvider);
    final target = ref.watch(routeTargetProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route library'),
        actions: [
          IconButton(
            tooltip: 'Activity heatmap',
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ActivityHeatmapPage(),
                  ),
                ),
            icon: const Icon(Icons.local_fire_department_outlined),
          ),
          IconButton(
            tooltip: 'Build route',
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RouteBuilderPage()),
                ),
            icon: const Icon(Icons.add_road),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          target.when(
            data:
                (route) => _TargetRoutePanel(
                  route: route,
                  onClear: () async {
                    await ref.read(routeTargetServiceProvider).clearTarget();
                    ref.invalidate(routeTargetProvider);
                  },
                ),
            loading: () => const LinearProgressIndicator(),
            error:
                (error, _) => InfoPanel(
                  icon: Icons.flag_outlined,
                  title: 'Target route unavailable',
                  body: error.toString(),
                ),
          ),
          const SizedBox(height: 16),
          routes.when(
            data: (rows) {
              if (rows.isEmpty) {
                return InfoPanel(
                  icon: Icons.route,
                  title: 'No saved routes yet',
                  body:
                      'Build a route from the map or save a route from Activity Detail.',
                  action: FilledButton.icon(
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RouteBuilderPage(),
                          ),
                        ),
                    icon: const Icon(Icons.add_road),
                    label: const Text('Build route'),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Saved routes',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RouteBuilderPage(),
                              ),
                            ),
                        icon: const Icon(Icons.add),
                        label: const Text('Build'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...rows.map((route) => _RouteTile(route: route)),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error:
                (error, _) => InfoPanel(
                  icon: Icons.error_outline,
                  title: 'Saved routes unavailable',
                  body: error.toString(),
                ),
          ),
        ],
      ),
    );
  }
}

class _TargetRoutePanel extends StatelessWidget {
  final SavedRoute? route;
  final Future<void> Function() onClear;

  const _TargetRoutePanel({required this.route, required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (route == null) {
      return const InfoPanel(
        icon: Icons.flag_outlined,
        title: 'No target route',
        body:
            'Set a saved route as target to keep a planned route visible from the Activity tab.',
      );
    }
    return PremiumCard(
      child: Row(
        children: [
          const AccentIconBox(icon: Icons.flag, color: AppTheme.violet),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target route',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  route!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear')),
        ],
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  final SavedRoute route;

  const _RouteTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SavedRouteDetailPage(route: route),
              ),
            ),
        child: PremiumCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const AccentIconBox(icon: Icons.route, color: AppTheme.cyan),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(route.distanceMeters / 1000).toStringAsFixed(2)} km / ${route.pointCount} pts / ${fmtTime(route.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
