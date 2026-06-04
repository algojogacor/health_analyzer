import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../providers/health_provider.dart';
import '../../services/turso_service.dart';

Future<void> showSetupDialog(BuildContext context, WidgetRef ref) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final creds = await TursoService.loadCredentials(storage);

  final dbController = TextEditingController(text: creds?.dbName ?? '');
  final tokenController = TextEditingController(text: creds?.authToken ?? '');

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: const Text('Turso Setup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dbController,
                decoration: const InputDecoration(
                  labelText: 'Database Name',
                  hintText: 'your-db-name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(
                  labelText: 'Auth Token',
                  hintText: 'turso auth token',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final service = TursoService(
                  dbName: dbController.text.trim(),
                  authToken: tokenController.text.trim(),
                  storage: storage,
                );
                await service.saveCredentials(
                  dbName: dbController.text.trim(),
                  authToken: tokenController.text.trim(),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                ref.invalidate(tursoServiceProvider);
                ref.invalidate(credentialsConfiguredProvider);
                ref.invalidate(tursoStatusProvider);
              },
              child: const Text('Save'),
            ),
          ],
        ),
  );
}
