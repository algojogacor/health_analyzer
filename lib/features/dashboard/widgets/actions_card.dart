import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  final int unsyncedCount;
  final bool syncing;
  final VoidCallback onCollect;
  final VoidCallback? onSync;
  final VoidCallback onStartPeriodicSync;

  const ActionsCard({
    super.key,
    required this.unsyncedCount,
    required this.syncing,
    required this.onCollect,
    required this.onSync,
    required this.onStartPeriodicSync,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Collect Health Data'),
            subtitle: const Text('Read from Health Connect & save locally'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onCollect,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Sync to Turso'),
            subtitle: Text('Push $unsyncedCount pending records'),
            trailing:
                syncing
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.chevron_right),
            onTap: onSync,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Start Periodic Sync'),
            subtitle: const Text('Run background sync every hour'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onStartPeriodicSync,
          ),
        ],
      ),
    );
  }
}
