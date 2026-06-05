import 'package:flutter/material.dart';

import '../../models/sport_mode.dart';
import '../../services/activity_recorder_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/premium_card.dart';
import 'recorder_stat.dart';
import 'sport_picker_page.dart';

class ActivityRecorderPanel extends StatelessWidget {
  final SportMode selectedMode;
  final ActivityRecorderSnapshot? snapshot;
  final ValueChanged<SportMode> onModeChanged;
  final VoidCallback onStart;
  final VoidCallback onOpenRecording;

  const ActivityRecorderPanel({
    super.key,
    required this.selectedMode,
    required this.snapshot,
    required this.onModeChanged,
    required this.onStart,
    required this.onOpenRecording,
  });

  @override
  Widget build(BuildContext context) {
    final isRecording = snapshot?.isRecording ?? false;
    final stats = snapshot?.stats;
    final session = snapshot?.session;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AccentIconBox(
                icon: Icons.radio_button_checked,
                color: AppTheme.cyan,
                size: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Activity recorder',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatusPill(
                label: isRecording ? (session?.status ?? 'recording') : 'ready',
                color: isRecording ? AppTheme.mint : AppTheme.muted,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SportModeButton(
            mode: selectedMode,
            enabled: !isRecording,
            onPick: () async {
              final result = await Navigator.of(context).push<SportMode>(
                MaterialPageRoute(
                  builder: (_) => SportPickerPage(selectedMode: selectedMode),
                ),
              );
              if (result != null) onModeChanged(result);
            },
          ),
          const SizedBox(height: 14),
          _PreStartChecklist(mode: selectedMode, snapshot: snapshot),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: RecorderStat(
                  label: 'Distance',
                  value:
                      '${((stats?.distanceMeters ?? 0) / 1000).toStringAsFixed(2)} km',
                ),
              ),
              Expanded(
                child: RecorderStat(
                  label: 'Moving',
                  value: fmtDuration(stats?.movingSeconds ?? 0),
                ),
              ),
              Expanded(
                child: RecorderStat(
                  label: 'Points',
                  value: '${snapshot?.pointCount ?? 0}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _PrivacyInlineNote(),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isRecording ? onOpenRecording : onStart,
              icon: Icon(isRecording ? Icons.open_in_full : Icons.play_arrow),
              label: Text(isRecording ? 'Open recording' : 'Start activity'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == AppTheme.muted ? AppTheme.ink : color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SportModeButton extends StatelessWidget {
  final SportMode mode;
  final bool enabled;
  final VoidCallback onPick;

  const _SportModeButton({
    required this.mode,
    required this.enabled,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPick : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(
            mode.requiresGps ? Icons.explore_outlined : Icons.fitness_center,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sport mode'),
                Text(
                  mode.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (mode.defaultOnBand)
            _SmallPill(label: 'Band')
          else
            _SmallPill(label: mode.requiresGps ? 'GPS' : 'Indoor'),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _PreStartChecklist extends StatelessWidget {
  final SportMode mode;
  final ActivityRecorderSnapshot? snapshot;

  const _PreStartChecklist({required this.mode, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final accuracy = snapshot?.lastAccuracyMeters;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _ChecklistRow(
              icon: mode.requiresGps ? Icons.gps_fixed : Icons.gps_off,
              label:
                  mode.requiresGps
                      ? 'GPS confidence: ${accuracy == null ? 'checks after start' : '${accuracy.round()} m'}'
                      : 'GPS not required for this mode',
              ok: !mode.requiresGps || (accuracy != null && accuracy <= 50),
            ),
            _ChecklistRow(
              icon: Icons.privacy_tip_outlined,
              label: 'Route private by default; start/end hidden',
              ok: true,
            ),
            const _ChecklistRow(
              icon: Icons.sensors,
              label: 'Phone GPS + Health Connect context after save',
              ok: true,
            ),
            const _ChecklistRow(
              icon: Icons.battery_saver_outlined,
              label: 'Keep battery optimization relaxed for long sessions',
              ok: true,
            ),
            const _ChecklistRow(
              icon: Icons.volume_up_outlined,
              label: 'Voice cues available in Settings',
              ok: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool ok;

  const _ChecklistRow({
    required this.icon,
    required this.label,
    required this.ok,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ok ? AppTheme.mint : AppTheme.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.ink, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  final String label;

  const _SmallPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.cyan.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: AppTheme.ink,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _PrivacyInlineNote extends StatelessWidget {
  const _PrivacyInlineNote();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.privacy_tip_outlined, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Private by default. Start/end hidden at 300m; full route sync is opt-in.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
