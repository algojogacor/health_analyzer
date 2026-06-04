import 'package:flutter/material.dart';

import '../../../services/activity_recorder_service.dart';
import '../../../shared/utils/formatters.dart';

class RecordingStatSheet extends StatelessWidget {
  final ActivityRecorderSnapshot snapshot;
  final bool busy;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onLap;
  final VoidCallback onStop;

  const RecordingStatSheet({
    super.key,
    required this.snapshot,
    required this.busy,
    required this.onPause,
    required this.onResume,
    required this.onLap,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final isPaused = snapshot.session?.status == 'paused';
    final distanceKm = (stats?.distanceMeters ?? 0) / 1000;
    final avgSpeed = stats?.avgSpeedMps;
    final pace = _paceText(
      stats?.distanceMeters ?? 0,
      stats?.movingSeconds ?? 0,
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Material(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            '${distanceKm.toStringAsFixed(2)} km',
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${snapshot.pointCount} pts',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 58,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    _CompactStat(
                      label: 'Moving',
                      value: fmtDuration(stats?.movingSeconds ?? 0),
                    ),
                    _CompactStat(
                      label: 'Elapsed',
                      value: fmtDuration(stats?.elapsedSeconds ?? 0),
                    ),
                    _CompactStat(label: 'Pace', value: pace),
                    _CompactStat(
                      label: 'Speed',
                      value:
                          avgSpeed == null
                              ? '--'
                              : '${(avgSpeed * 3.6).toStringAsFixed(1)} km/h',
                    ),
                    _CompactStat(
                      label: 'Ascent',
                      value: '${(stats?.ascentMeters ?? 0).round()} m',
                    ),
                    _CompactStat(
                      label: 'Descent',
                      value: '${(stats?.descentMeters ?? 0).round()} m',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: busy ? null : onLap,
                        icon: const Icon(Icons.flag_outlined),
                        label: const Text('Lap'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            busy ? null : (isPaused ? onResume : onPause),
                        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(isPaused ? 'Resume' : 'Pause'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: busy ? null : onStop,
                        icon:
                            busy
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.stop),
                        label: Text(busy ? 'Working...' : 'Stop'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _paceText(double distanceMeters, int movingSeconds) {
    if (distanceMeters <= 0 || movingSeconds <= 0) return '--';
    final secondsPerKm = movingSeconds / (distanceMeters / 1000);
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).round().toString().padLeft(2, '0');
    return '$minutes:$seconds /km';
  }
}

class _CompactStat extends StatelessWidget {
  final String label;
  final String value;

  const _CompactStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
