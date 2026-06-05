import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/health_provider.dart';
import '../../shared/widgets/info_panel.dart';

class DataExportPage extends ConsumerStatefulWidget {
  const DataExportPage({super.key});

  @override
  ConsumerState<DataExportPage> createState() => _DataExportPageState();
}

class _DataExportPageState extends ConsumerState<DataExportPage> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data export')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          const InfoPanel(
            icon: Icons.archive_outlined,
            title: 'Full local export',
            body:
                'Create a ZIP with local health records, activities, GPS points, GPX files, summaries, AI history, goals, and route data. API keys and Turso credentials are not included.',
          ),
          const SizedBox(height: 16),
          InfoPanel(
            icon: Icons.privacy_tip_outlined,
            title: 'Private file',
            body:
                'This ZIP can contain raw Health Connect records and exact GPS route points. Share it only with places you trust.',
            action: FilledButton.icon(
              onPressed: _exporting ? null : _export,
              icon:
                  _exporting
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.ios_share_outlined),
              label: Text(_exporting ? 'Exporting' : 'Create and share ZIP'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final result = await ref.read(dataExportServiceProvider).exportZip();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(result.file.path)],
          subject: 'Health Analyzer data export',
          text:
              'Health Analyzer export: ${result.healthRecordCount} health records, ${result.activityCount} activities, ${result.gpxCount} GPX files.',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Export ready: ${result.activityCount} activities / ${result.gpxCount} GPX',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
