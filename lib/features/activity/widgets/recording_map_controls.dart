import 'package:flutter/material.dart';

import 'route_map.dart';

class RecordingMapControls extends StatelessWidget {
  final String sportName;
  final bool requiresGps;
  final String? status;
  final String locationLabel;
  final double? accuracyMeters;
  final RouteMapStyle style;
  final ValueChanged<RouteMapStyle> onStyleChanged;
  final VoidCallback onRecenter;
  final VoidCallback onBack;

  const RecordingMapControls({
    super.key,
    required this.sportName,
    required this.requiresGps,
    required this.status,
    required this.locationLabel,
    required this.accuracyMeters,
    required this.style,
    required this.onStyleChanged,
    required this.onRecenter,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _RoundIconButton(
                  icon: Icons.keyboard_arrow_down,
                  tooltip: 'Minimize',
                  onPressed: onBack,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sportName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            RecordingStatusBadge(status: status),
                            if (requiresGps)
                              LocationQualityBadge(
                                label: locationLabel,
                                accuracyMeters: accuracyMeters,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (requiresGps) ...[
                  const SizedBox(width: 10),
                  _RoundIconButton(
                    icon: Icons.my_location,
                    tooltip: 'Recenter',
                    onPressed: onRecenter,
                  ),
                ],
              ],
            ),
            if (requiresGps) ...[
              const SizedBox(height: 10),
              _GlassPanel(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: SegmentedButton<RouteMapStyle>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: RouteMapStyle.street,
                      icon: Icon(Icons.map_outlined),
                      label: Text('Street'),
                    ),
                    ButtonSegment(
                      value: RouteMapStyle.satellite,
                      icon: Icon(Icons.satellite_alt_outlined),
                      label: Text('Satellite'),
                    ),
                  ],
                  selected: {style},
                  onSelectionChanged: (selection) {
                    onStyleChanged(selection.first);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class RecordingStatusBadge extends StatelessWidget {
  final String? status;

  const RecordingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final raw = status ?? 'recording';
    final isPaused = raw == 'paused';
    final color = isPaused ? Colors.orange.shade800 : Colors.green.shade700;
    final label = isPaused ? 'Paused' : _labelFor(raw);

    return _Badge(label: label, color: color);
  }

  String _labelFor(String value) {
    if (value == 'recording') return 'Recording';
    if (value == 'reviewing') return 'Reviewing';
    return value;
  }
}

class LocationQualityBadge extends StatelessWidget {
  final String label;
  final double? accuracyMeters;

  const LocationQualityBadge({
    super.key,
    required this.label,
    required this.accuracyMeters,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      'Exact' => Colors.green.shade700,
      'Good' => Colors.teal.shade700,
      'Weak' => Colors.orange.shade800,
      _ => Colors.grey.shade700,
    };
    final text =
        accuracyMeters == null
            ? label
            : '$label +/- ${accuracyMeters!.round()}m';
    return _Badge(label: text, color: color);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      elevation: 4,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      child: Padding(padding: padding, child: child),
    );
  }
}
