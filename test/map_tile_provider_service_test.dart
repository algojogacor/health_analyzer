import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_analyzer/services/map_tile_provider_service.dart';

void main() {
  const service = MapTileProviderService(storage: FlutterSecureStorage());

  test('uses OpenStreetMap by default', () {
    final source = service.streetSource(MapTileSettings.defaults);

    expect(source.urlTemplate, contains('openstreetmap'));
    expect(source.warning, isNull);
  });

  test('uses EOX Sentinel-2 cloudless as default satellite source', () {
    final source = service.satelliteSource(MapTileSettings.defaults);

    expect(source.urlTemplate, contains('s2cloudless-2017_3857'));
    expect(source.attribution, contains('CC BY 4.0'));
    expect(source.warning, isNull);
  });

  test('falls back to OSM when Stadia API key is missing', () {
    final source = service.streetSource(
      const MapTileSettings(streetProvider: StreetMapProvider.stadia),
    );

    expect(source.urlTemplate, contains('openstreetmap'));
    expect(source.warning, contains('Stadia API key missing'));
  });

  test('falls back to Esri when MapTiler API key is missing', () {
    final source = service.satelliteSource(
      const MapTileSettings(satelliteProvider: SatelliteMapProvider.maptiler),
    );

    expect(source.urlTemplate, contains('World_Imagery'));
    expect(source.warning, contains('MapTiler API key missing'));
  });

  test('accepts valid custom HTTPS tile templates only', () {
    final valid = service.streetSource(
      const MapTileSettings(
        streetProvider: StreetMapProvider.custom,
        customStreetUrl: 'https://tiles.example.com/{z}/{x}/{y}.png',
      ),
    );
    final invalid = service.streetSource(
      const MapTileSettings(
        streetProvider: StreetMapProvider.custom,
        customStreetUrl: 'http://tiles.example.com/{z}/{x}/{y}.png',
      ),
    );

    expect(valid.urlTemplate, contains('tiles.example.com'));
    expect(valid.warning, isNull);
    expect(invalid.urlTemplate, contains('openstreetmap'));
    expect(invalid.warning, contains('Custom street tile URL invalid'));
  });
}
