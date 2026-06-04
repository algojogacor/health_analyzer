import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/offline_map_service.dart';
import '../../shared/widgets/info_panel.dart';

class MapSettingsPage extends ConsumerStatefulWidget {
  const MapSettingsPage({super.key});

  @override
  ConsumerState<MapSettingsPage> createState() => _MapSettingsPageState();
}

class _MapSettingsPageState extends ConsumerState<MapSettingsPage> {
  OfflineMapLayerChoice _layerChoice = OfflineMapLayerChoice.street;
  double _radiusKm = 1;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    final regions = ref.watch(offlineMapRegionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          const InfoPanel(
            icon: Icons.gps_fixed,
            title: 'GPS records offline; map tiles require internet',
            body:
                'Activity GPS points are recorded by the phone sensor and saved locally even without internet. Downloaded regions make map backgrounds available offline.',
          ),
          const SizedBox(height: 16),
          const InfoPanel(
            icon: Icons.warning_amber_outlined,
            title: 'Public tile warning',
            body:
                'Street and satellite downloads use public tile services in v1. Keep regions small to avoid rate limits or blocked downloads.',
          ),
          const SizedBox(height: 16),
          _DownloadCard(
            layerChoice: _layerChoice,
            radiusKm: _radiusKm,
            downloading: _downloading,
            onLayerChanged: (value) => setState(() => _layerChoice = value),
            onRadiusChanged: (value) => setState(() => _radiusKm = value),
            onDownload: _download,
          ),
          const SizedBox(height: 16),
          Text(
            'Offline regions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          regions.when(
            data:
                (rows) =>
                    rows.isEmpty
                        ? const Text('No offline regions yet.')
                        : Column(
                          children:
                              rows
                                  .map(
                                    (region) => _RegionTile(
                                      region: region,
                                      onDelete: () => _delete(region),
                                    ),
                                  )
                                  .toList(),
                        ),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Offline regions unavailable: $error'),
          ),
        ],
      ),
    );
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final result = await ref
          .read(offlineMapServiceProvider)
          .downloadCurrentArea(
            center: LatLng(position.latitude, position.longitude),
            radiusKm: _radiusKm,
            layerChoice: _layerChoice,
          );
      ref.invalidate(offlineMapRegionsProvider);
      if (!mounted) return;
      if (result.satelliteFailed) {
        await _showSatelliteFailedDialog();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $error')));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _showSatelliteFailedDialog() async {
    final action = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Satellite tiles unavailable'),
            content: const Text(
              'Satellite tiles unavailable. Street map can still be downloaded.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop('cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop('street_only'),
                child: const Text('Continue street only'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop('retry'),
                child: const Text('Retry satellite'),
              ),
            ],
          ),
    );
    if (action == 'retry') {
      setState(() => _layerChoice = OfflineMapLayerChoice.satellite);
      await _download();
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          action == 'street_only'
              ? 'Continuing with street map only.'
              : 'Satellite download cancelled.',
        ),
      ),
    );
  }

  Future<void> _delete(OfflineMapRegion region) async {
    await ref.read(offlineMapServiceProvider).deleteRegion(region);
    ref.invalidate(offlineMapRegionsProvider);
  }
}

class _DownloadCard extends StatelessWidget {
  final OfflineMapLayerChoice layerChoice;
  final double radiusKm;
  final bool downloading;
  final ValueChanged<OfflineMapLayerChoice> onLayerChanged;
  final ValueChanged<double> onRadiusChanged;
  final VoidCallback onDownload;

  const _DownloadCard({
    required this.layerChoice,
    required this.radiusKm,
    required this.downloading,
    required this.onLayerChanged,
    required this.onRadiusChanged,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download region',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            SegmentedButton<OfflineMapLayerChoice>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: OfflineMapLayerChoice.street,
                  label: Text('Street'),
                  icon: Icon(Icons.map_outlined),
                ),
                ButtonSegment(
                  value: OfflineMapLayerChoice.satellite,
                  label: Text('Satellite'),
                  icon: Icon(Icons.satellite_alt_outlined),
                ),
                ButtonSegment(
                  value: OfflineMapLayerChoice.both,
                  label: Text('Both'),
                  icon: Icon(Icons.layers_outlined),
                ),
              ],
              selected: {layerChoice},
              onSelectionChanged: (value) => onLayerChanged(value.first),
            ),
            const SizedBox(height: 16),
            Text(
              'Radius: ${radiusKm.round()} km',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Slider(
              value: radiusKm,
              min: 1,
              max: 10,
              divisions: 2,
              label: '${radiusKm.round()} km',
              onChanged: onRadiusChanged,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: downloading ? null : onDownload,
              icon:
                  downloading
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.download_outlined),
              label: Text(downloading ? 'Downloading...' : 'Download'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionTile extends StatelessWidget {
  final OfflineMapRegion region;
  final VoidCallback onDelete;

  const _RegionTile({required this.region, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          region.style == 'satellite'
              ? Icons.satellite_alt_outlined
              : Icons.map_outlined,
        ),
        title: Text(region.name),
        subtitle: Text(
          '${region.style} / ${region.status} / ${(region.storageBytes / 1024 / 1024).toStringAsFixed(1)} MB',
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete metadata',
        ),
      ),
    );
  }
}
