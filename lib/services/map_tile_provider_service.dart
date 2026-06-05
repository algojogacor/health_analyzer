import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StreetMapProvider { osm, stadia, custom }

enum SatelliteMapProvider { eoxSentinel2, esri, maptiler, custom }

class MapTileSource {
  final String urlTemplate;
  final String attribution;
  final int maxNativeZoom;
  final String? warning;

  const MapTileSource({
    required this.urlTemplate,
    required this.attribution,
    this.maxNativeZoom = 19,
    this.warning,
  });
}

class MapTileSettings {
  final StreetMapProvider streetProvider;
  final SatelliteMapProvider satelliteProvider;
  final String stadiaApiKey;
  final String mapTilerApiKey;
  final String customStreetUrl;
  final String customSatelliteUrl;

  const MapTileSettings({
    this.streetProvider = StreetMapProvider.osm,
    this.satelliteProvider = SatelliteMapProvider.eoxSentinel2,
    this.stadiaApiKey = '',
    this.mapTilerApiKey = '',
    this.customStreetUrl = '',
    this.customSatelliteUrl = '',
  });

  static const defaults = MapTileSettings();

  MapTileSettings copyWith({
    StreetMapProvider? streetProvider,
    SatelliteMapProvider? satelliteProvider,
    String? stadiaApiKey,
    String? mapTilerApiKey,
    String? customStreetUrl,
    String? customSatelliteUrl,
  }) {
    return MapTileSettings(
      streetProvider: streetProvider ?? this.streetProvider,
      satelliteProvider: satelliteProvider ?? this.satelliteProvider,
      stadiaApiKey: stadiaApiKey ?? this.stadiaApiKey,
      mapTilerApiKey: mapTilerApiKey ?? this.mapTilerApiKey,
      customStreetUrl: customStreetUrl ?? this.customStreetUrl,
      customSatelliteUrl: customSatelliteUrl ?? this.customSatelliteUrl,
    );
  }
}

class MapTileProviderService {
  static const _streetProviderKey = 'map.street_provider';
  static const _satelliteProviderKey = 'map.satellite_provider';
  static const _stadiaApiKeyKey = 'map.stadia_api_key';
  static const _mapTilerApiKeyKey = 'map.maptiler_api_key';
  static const _customStreetUrlKey = 'map.custom_street_url';
  static const _customSatelliteUrlKey = 'map.custom_satellite_url';

  final FlutterSecureStorage storage;

  const MapTileProviderService({required this.storage});

  Future<MapTileSettings> loadSettings() async {
    return MapTileSettings(
      streetProvider: _streetProvider(
        await storage.read(key: _streetProviderKey),
      ),
      satelliteProvider: _satelliteProvider(
        await storage.read(key: _satelliteProviderKey),
      ),
      stadiaApiKey: await storage.read(key: _stadiaApiKeyKey) ?? '',
      mapTilerApiKey: await storage.read(key: _mapTilerApiKeyKey) ?? '',
      customStreetUrl: await storage.read(key: _customStreetUrlKey) ?? '',
      customSatelliteUrl: await storage.read(key: _customSatelliteUrlKey) ?? '',
    );
  }

  Future<void> saveSettings(MapTileSettings settings) async {
    await Future.wait([
      storage.write(
        key: _streetProviderKey,
        value: settings.streetProvider.name,
      ),
      storage.write(
        key: _satelliteProviderKey,
        value: settings.satelliteProvider.name,
      ),
      storage.write(key: _stadiaApiKeyKey, value: settings.stadiaApiKey.trim()),
      storage.write(
        key: _mapTilerApiKeyKey,
        value: settings.mapTilerApiKey.trim(),
      ),
      storage.write(
        key: _customStreetUrlKey,
        value: settings.customStreetUrl.trim(),
      ),
      storage.write(
        key: _customSatelliteUrlKey,
        value: settings.customSatelliteUrl.trim(),
      ),
    ]);
  }

  MapTileSource streetSource(MapTileSettings settings) {
    switch (settings.streetProvider) {
      case StreetMapProvider.stadia:
        final key = settings.stadiaApiKey.trim();
        if (key.isEmpty) {
          return _osmSource(
            'Stadia API key missing. Using OpenStreetMap fallback.',
          );
        }
        return MapTileSource(
          urlTemplate:
              'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=$key',
          attribution: 'Stadia Maps / OpenMapTiles / OpenStreetMap',
        );
      case StreetMapProvider.custom:
        final url = settings.customStreetUrl.trim();
        if (_validTemplate(url)) {
          return MapTileSource(
            urlTemplate: url,
            attribution: 'Custom street tiles',
          );
        }
        return _osmSource('Custom street tile URL invalid. Using OSM.');
      case StreetMapProvider.osm:
        return _osmSource();
    }
  }

  MapTileSource satelliteSource(MapTileSettings settings) {
    switch (settings.satelliteProvider) {
      case SatelliteMapProvider.eoxSentinel2:
        return const MapTileSource(
          urlTemplate:
              'https://tiles.maps.eox.at/wmts/1.0.0/s2cloudless-2017_3857/default/GoogleMapsCompatible/{z}/{y}/{x}.jpg',
          attribution:
              'Sentinel-2 cloudless 2017 by EOX IT Services GmbH / Contains modified Copernicus Sentinel data 2017 / CC BY 4.0',
          maxNativeZoom: 17,
        );
      case SatelliteMapProvider.maptiler:
        final key = settings.mapTilerApiKey.trim();
        if (key.isEmpty) {
          return _esriSource('MapTiler API key missing. Using Esri fallback.');
        }
        return MapTileSource(
          urlTemplate:
              'https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=$key',
          attribution: 'MapTiler Satellite',
          maxNativeZoom: 20,
        );
      case SatelliteMapProvider.custom:
        final url = settings.customSatelliteUrl.trim();
        if (_validTemplate(url)) {
          return MapTileSource(
            urlTemplate: url,
            attribution: 'Custom satellite tiles',
            maxNativeZoom: 20,
          );
        }
        return _esriSource('Custom satellite tile URL invalid. Using Esri.');
      case SatelliteMapProvider.esri:
        return _esriSource();
    }
  }

  MapTileSource _osmSource([String? warning]) {
    return MapTileSource(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: 'OpenStreetMap contributors',
      warning: warning,
    );
  }

  MapTileSource _esriSource([String? warning]) {
    return MapTileSource(
      urlTemplate:
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      attribution: 'Esri World Imagery',
      warning: warning,
    );
  }

  bool _validTemplate(String url) {
    final lower = url.toLowerCase();
    return lower.startsWith('https://') &&
        url.contains('{z}') &&
        url.contains('{x}') &&
        url.contains('{y}');
  }

  StreetMapProvider _streetProvider(String? value) {
    return StreetMapProvider.values.firstWhere(
      (provider) => provider.name == value,
      orElse: () => StreetMapProvider.osm,
    );
  }

  SatelliteMapProvider _satelliteProvider(String? value) {
    return SatelliteMapProvider.values.firstWhere(
      (provider) => provider.name == value,
      orElse: () => SatelliteMapProvider.esri,
    );
  }
}
