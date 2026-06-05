import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/map_tile_provider_service.dart';
import '../../services/offline_map_service.dart';
import '../../shared/widgets/info_panel.dart';

class MapSettingsPage extends ConsumerStatefulWidget {
  const MapSettingsPage({super.key});

  @override
  ConsumerState<MapSettingsPage> createState() => _MapSettingsPageState();
}

class _MapSettingsPageState extends ConsumerState<MapSettingsPage> {
  final _stadiaController = TextEditingController();
  final _mapTilerController = TextEditingController();
  final _customStreetController = TextEditingController();
  final _customSatelliteController = TextEditingController();
  OfflineMapLayerChoice _layerChoice = OfflineMapLayerChoice.street;
  MapTileSettings? _draftSettings;
  String? _initializedSignature;
  String? _downloadingPackId;
  double _packProgress = 0;
  double _radiusKm = 1;
  bool _savingTileSettings = false;
  bool _downloading = false;

  @override
  void dispose() {
    _stadiaController.dispose();
    _mapTilerController.dispose();
    _customStreetController.dispose();
    _customSatelliteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regions = ref.watch(offlineMapRegionsProvider);
    final tileSettingsValue = ref.watch(mapTileSettingsProvider);
    final communitySettings = ref.watch(communitySettingsProvider);
    final communityBaseUrl =
        communitySettings.valueOrNull?.baseUrl.trim() ?? '';
    final catalog =
        communityBaseUrl.isEmpty
            ? null
            : ref.watch(offlineMapCatalogProvider(communityBaseUrl));
    final tileSettings = _draftSettings ?? tileSettingsValue.valueOrNull;
    if (tileSettings != null) {
      _initializeTileSettings(tileSettings);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Map settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          const InfoPanel(
            icon: Icons.gps_fixed,
            title: 'GPS records offline; map tiles require internet',
            body:
                'Activity GPS points are recorded by the phone sensor and saved locally even without internet. Map backgrounds use online tiles until PMTiles offline packs are enabled.',
          ),
          const SizedBox(height: 16),
          if (tileSettings == null)
            const LinearProgressIndicator()
          else
            _TileProviderCard(
              settings: tileSettings,
              saving: _savingTileSettings,
              streetSource: ref
                  .read(mapTileProviderServiceProvider)
                  .streetSource(tileSettings),
              satelliteSource: ref
                  .read(mapTileProviderServiceProvider)
                  .satelliteSource(tileSettings),
              stadiaController: _stadiaController,
              mapTilerController: _mapTilerController,
              customStreetController: _customStreetController,
              customSatelliteController: _customSatelliteController,
              onChanged: _updateTileSettings,
              onSave: () => _saveTileSettings(tileSettings),
            ),
          const SizedBox(height: 16),
          const InfoPanel(
            icon: Icons.satellite_alt_outlined,
            title: 'Offline satellite strategy',
            body:
                'Satellite offline maps will use regional PMTiles packs with source and license metadata. Public bulk tile downloading is disabled to keep licensing and provider terms safe.',
          ),
          const SizedBox(height: 16),
          if (communityBaseUrl.isEmpty)
            const InfoPanel(
              icon: Icons.cloud_off_outlined,
              title: 'PMTiles catalog not configured',
              body:
                  'Set a Koyeb community base URL to view available satellite PMTiles packs. The catalog is metadata only; the app will never bulk-download public tiles.',
            )
          else
            _CatalogCard(
              catalog: catalog!,
              downloadingPackId: _downloadingPackId,
              progress: _packProgress,
              onDownloadPack: _downloadCatalogPack,
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
            'Offline map packs',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          regions.when(
            data:
                (rows) =>
                    rows.isEmpty
                        ? const Text('No offline map pack requests yet.')
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

  void _initializeTileSettings(MapTileSettings settings) {
    final signature = [
      settings.streetProvider.name,
      settings.satelliteProvider.name,
      settings.stadiaApiKey,
      settings.mapTilerApiKey,
      settings.customStreetUrl,
      settings.customSatelliteUrl,
    ].join('|');
    if (_initializedSignature == signature) return;
    _initializedSignature = signature;
    _stadiaController.text = settings.stadiaApiKey;
    _mapTilerController.text = settings.mapTilerApiKey;
    _customStreetController.text = settings.customStreetUrl;
    _customSatelliteController.text = settings.customSatelliteUrl;
  }

  void _updateTileSettings(MapTileSettings settings) {
    setState(() => _draftSettings = settings);
  }

  Future<void> _saveTileSettings(MapTileSettings settings) async {
    setState(() => _savingTileSettings = true);
    try {
      await ref.read(mapTileProviderServiceProvider).saveSettings(settings);
      ref.invalidate(mapTileSettingsProvider);
      if (!mounted) return;
      setState(() {
        _draftSettings = settings;
        _savingTileSettings = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Map tile providers saved')));
    } catch (error) {
      if (!mounted) return;
      setState(() => _savingTileSettings = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save map settings failed: $error')),
      );
    }
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
              ? 'Street maps remain available online. Offline PMTiles pack request saved.'
              : 'Offline satellite pack request cancelled.',
        ),
      ),
    );
  }

  Future<void> _delete(OfflineMapRegion region) async {
    await ref.read(offlineMapServiceProvider).deleteRegion(region);
    ref.invalidate(offlineMapRegionsProvider);
  }

  Future<void> _downloadCatalogPack(OfflineMapCatalogPack pack) async {
    setState(() {
      _downloadingPackId = pack.id;
      _packProgress = 0;
    });
    try {
      await ref
          .read(offlineMapServiceProvider)
          .downloadCatalogPack(
            pack,
            onProgress: (received, total) {
              if (!mounted || total <= 0) return;
              setState(() => _packProgress = received / total);
            },
          );
      ref.invalidate(offlineMapRegionsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pack.name} downloaded for offline maps')),
      );
    } catch (error) {
      ref.invalidate(offlineMapRegionsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PMTiles download failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _downloadingPackId = null;
          _packProgress = 0;
        });
      }
    }
  }
}

class _CatalogCard extends StatelessWidget {
  final AsyncValue<List<OfflineMapCatalogPack>> catalog;
  final String? downloadingPackId;
  final double progress;
  final Future<void> Function(OfflineMapCatalogPack pack) onDownloadPack;

  const _CatalogCard({
    required this.catalog,
    required this.downloadingPackId,
    required this.progress,
    required this.onDownloadPack,
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
              'Available PMTiles packs',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Packs come from your configured Koyeb catalog. Check source and license before public/commercial use.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            catalog.when(
              data:
                  (packs) =>
                      packs.isEmpty
                          ? const Text('No PMTiles packs published yet.')
                          : Column(
                            children:
                                packs
                                    .map(
                                      (pack) => _CatalogPackTile(
                                        pack: pack,
                                        downloading:
                                            downloadingPackId == pack.id,
                                        progress: progress,
                                        onDownload: () => onDownloadPack(pack),
                                      ),
                                    )
                                    .toList(),
                          ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Catalog unavailable: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogPackTile extends StatelessWidget {
  final OfflineMapCatalogPack pack;
  final bool downloading;
  final double progress;
  final Future<void> Function() onDownload;

  const _CatalogPackTile({
    required this.pack,
    required this.downloading,
    required this.progress,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        pack.layer == 'satellite'
            ? Icons.satellite_alt_outlined
            : Icons.map_outlined,
      ),
      title: Text(pack.name),
      subtitle: Text(
        downloading
            ? 'Downloading ${(_safeProgress * 100).round()}%'
            : '${pack.layer} / ${_mb(pack.sizeBytes)} MB / ${pack.source} / ${pack.license}',
      ),
      trailing:
          downloading
              ? SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(value: _safeProgress),
              )
              : IconButton(
                onPressed: onDownload,
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Download PMTiles pack',
              ),
    );
  }

  double get _safeProgress => progress <= 0 ? 0.04 : progress.clamp(0.0, 1.0);

  String _mb(int bytes) => (bytes / 1024 / 1024).toStringAsFixed(1);
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
              'Prepare offline pack',
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
              label: Text(
                downloading ? 'Saving...' : 'Save offline pack request',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileProviderCard extends StatelessWidget {
  final MapTileSettings settings;
  final MapTileSource streetSource;
  final MapTileSource satelliteSource;
  final bool saving;
  final TextEditingController stadiaController;
  final TextEditingController mapTilerController;
  final TextEditingController customStreetController;
  final TextEditingController customSatelliteController;
  final ValueChanged<MapTileSettings> onChanged;
  final VoidCallback onSave;

  const _TileProviderCard({
    required this.settings,
    required this.streetSource,
    required this.satelliteSource,
    required this.saving,
    required this.stadiaController,
    required this.mapTilerController,
    required this.customStreetController,
    required this.customSatelliteController,
    required this.onChanged,
    required this.onSave,
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
            Row(
              children: [
                Icon(Icons.layers_outlined, color: Colors.cyan.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Online tile providers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Choose legal providers for map backgrounds. GPS recording still works offline without tiles.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<StreetMapProvider>(
              value: settings.streetProvider,
              decoration: const InputDecoration(
                labelText: 'Street map provider',
                border: OutlineInputBorder(),
              ),
              items:
                  StreetMapProvider.values
                      .map(
                        (provider) => DropdownMenuItem(
                          value: provider,
                          child: Text(_streetLabel(provider)),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) =>
                      value == null
                          ? null
                          : onChanged(settings.copyWith(streetProvider: value)),
            ),
            if (settings.streetProvider == StreetMapProvider.stadia) ...[
              const SizedBox(height: 12),
              TextField(
                controller: stadiaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Stadia Maps API key',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) =>
                        onChanged(settings.copyWith(stadiaApiKey: value)),
              ),
            ],
            if (settings.streetProvider == StreetMapProvider.custom) ...[
              const SizedBox(height: 12),
              TextField(
                controller: customStreetController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Custom street tile URL',
                  hintText: 'https://example.com/{z}/{x}/{y}.png',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) =>
                        onChanged(settings.copyWith(customStreetUrl: value)),
              ),
            ],
            const SizedBox(height: 12),
            _TileSourcePreview(label: 'Street source', source: streetSource),
            const SizedBox(height: 18),
            DropdownButtonFormField<SatelliteMapProvider>(
              value: settings.satelliteProvider,
              decoration: const InputDecoration(
                labelText: 'Satellite map provider',
                border: OutlineInputBorder(),
              ),
              items:
                  SatelliteMapProvider.values
                      .map(
                        (provider) => DropdownMenuItem(
                          value: provider,
                          child: Text(_satelliteLabel(provider)),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) =>
                      value == null
                          ? null
                          : onChanged(
                            settings.copyWith(satelliteProvider: value),
                          ),
            ),
            if (settings.satelliteProvider ==
                SatelliteMapProvider.maptiler) ...[
              const SizedBox(height: 12),
              TextField(
                controller: mapTilerController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'MapTiler API key',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) =>
                        onChanged(settings.copyWith(mapTilerApiKey: value)),
              ),
            ],
            if (settings.satelliteProvider == SatelliteMapProvider.custom) ...[
              const SizedBox(height: 12),
              TextField(
                controller: customSatelliteController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Custom satellite tile URL',
                  hintText: 'https://example.com/{z}/{x}/{y}.jpg',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) =>
                        onChanged(settings.copyWith(customSatelliteUrl: value)),
              ),
            ],
            const SizedBox(height: 12),
            _TileSourcePreview(
              label: 'Satellite source',
              source: satelliteSource,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: saving ? null : onSave,
              icon:
                  saving
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.save_outlined),
              label: Text(saving ? 'Saving...' : 'Save tile providers'),
            ),
          ],
        ),
      ),
    );
  }

  static String _streetLabel(StreetMapProvider provider) {
    return switch (provider) {
      StreetMapProvider.osm => 'OpenStreetMap',
      StreetMapProvider.stadia => 'Stadia Maps',
      StreetMapProvider.custom => 'Custom URL',
    };
  }

  static String _satelliteLabel(SatelliteMapProvider provider) {
    return switch (provider) {
      SatelliteMapProvider.eoxSentinel2 => 'EOX Sentinel-2 Cloudless',
      SatelliteMapProvider.esri => 'Esri World Imagery',
      SatelliteMapProvider.maptiler => 'MapTiler Satellite',
      SatelliteMapProvider.custom => 'Custom URL',
    };
  }
}

class _TileSourcePreview extends StatelessWidget {
  final String label;
  final MapTileSource source;

  const _TileSourcePreview({required this.label, required this.source});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              source.warning == null
                  ? Colors.grey.shade200
                  : Colors.orange.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              source.attribution,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if (source.warning != null) ...[
              const SizedBox(height: 6),
              Text(
                source.warning!,
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
