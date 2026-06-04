import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool tursoOk;
  final bool credentialsConfigured;
  final int unsyncedCount;
  final String status;

  const StatusCard({
    super.key,
    required this.tursoOk,
    required this.credentialsConfigured,
    required this.unsyncedCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const StatusRow(
              label: 'Health Connect',
              ok: true,
              okText: 'Ready',
              badText: 'No permission',
              icon: Icons.favorite,
            ),
            const SizedBox(height: 8),
            StatusRow(
              label: 'Turso',
              ok: tursoOk,
              okText: 'Connected',
              badText: 'Disconnected',
              icon: Icons.cloud,
            ),
            const SizedBox(height: 8),
            StatusRow(
              label: 'Credentials',
              ok: credentialsConfigured,
              okText: 'Configured',
              badText: 'Not set',
              icon: Icons.key,
            ),
            const SizedBox(height: 8),
            StatusRow(
              label: 'Sync Queue',
              ok: unsyncedCount == 0,
              okText: 'Synced',
              badText: '$unsyncedCount pending',
              icon: Icons.sync,
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final String label;
  final bool ok;
  final String okText;
  final String badText;
  final IconData icon;

  const StatusRow({
    super.key,
    required this.label,
    required this.ok,
    required this.okText,
    required this.badText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ok ? Colors.teal : Colors.orange),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color:
                ok
                    ? Colors.teal.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ok ? okText : badText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ok ? Colors.teal : Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
