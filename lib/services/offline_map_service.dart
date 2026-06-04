import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

enum OfflineMapLayerChoice { street, satellite, both }

class OfflineMapDownloadResult {
  final bool streetReady;
  final bool satelliteReady;
  final bool satelliteFailed;
  final String message;

  const OfflineMapDownloadResult({
    required this.streetReady,
    required this.satelliteReady,
    required this.satelliteFailed,
    required this.message,
  });
}

class OfflineMapService {
  static const streetStoreName = 'health_analyzer_street';
  static const satelliteStoreName = 'health_analyzer_satellite';
  static const streetUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const satelliteUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/'
      'World_Imagery/MapServer/tile/{z}/{y}/{x}';

  final AppDatabase db;
  final _uuid = const Uuid();

  OfflineMapService(this.db);

  static Future<void> initialise() async {
    try {
      await FMTCObjectBoxBackend().initialise();
      for (final storeName in [streetStoreName, satelliteStoreName]) {
        final store = FMTCStore(storeName);
        if (!await store.manage.ready) {
          await store.manage.create();
        }
      }
    } on RootUnavailable {
      rethrow;
    } catch (_) {
      // FMTC throws when already initialised; callers can still use it.
    }
  }

  static FMTCTileProvider tileProviderForStyle(String style) {
    final storeName =
        style == 'satellite' ? satelliteStoreName : streetStoreName;
    return FMTCTileProvider(
      stores: {storeName: BrowseStoreStrategy.readUpdateCreate},
      loadingStrategy: BrowseLoadingStrategy.cacheFirst,
    );
  }

  Future<List<OfflineMapRegion>> regions() {
    return db.select(db.offlineMapRegions).get();
  }

  Future<OfflineMapDownloadResult> downloadCurrentArea({
    required LatLng center,
    required double radiusKm,
    required OfflineMapLayerChoice layerChoice,
  }) async {
    await initialise();
    final bounds = _boundsForRadius(center, radiusKm);
    var streetReady = false;
    var satelliteReady = false;
    var satelliteFailed = false;

    if (layerChoice == OfflineMapLayerChoice.street ||
        layerChoice == OfflineMapLayerChoice.both) {
      streetReady = await _downloadLayer(
        name: 'Street ${radiusKm.toStringAsFixed(0)} km',
        style: 'street',
        storeName: streetStoreName,
        urlTemplate: streetUrl,
        bounds: bounds,
        minZoom: 12,
        maxZoom: 16,
      );
    }

    if (layerChoice == OfflineMapLayerChoice.satellite ||
        layerChoice == OfflineMapLayerChoice.both) {
      satelliteReady = await _downloadLayer(
        name: 'Satellite ${radiusKm.toStringAsFixed(0)} km',
        style: 'satellite',
        storeName: satelliteStoreName,
        urlTemplate: satelliteUrl,
        bounds: bounds,
        minZoom: 12,
        maxZoom: 17,
      );
      satelliteFailed = !satelliteReady;
    }

    return OfflineMapDownloadResult(
      streetReady: streetReady,
      satelliteReady: satelliteReady,
      satelliteFailed: satelliteFailed,
      message:
          satelliteFailed
              ? 'Satellite tiles unavailable. Street map can still be downloaded.'
              : 'Offline region download finished.',
    );
  }

  Future<void> deleteRegion(OfflineMapRegion region) async {
    await (db.update(db.offlineMapRegions)
      ..where((table) => table.id.equals(region.id))).write(
      OfflineMapRegionsCompanion(
        status: const Value('deleted'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> _downloadLayer({
    required String name,
    required String style,
    required String storeName,
    required String urlTemplate,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
  }) async {
    final localName = '$style-${_uuid.v4()}';
    await db
        .into(db.offlineMapRegions)
        .insert(
          OfflineMapRegionsCompanion.insert(
            name: name,
            bounds: jsonEncode({
              'north': bounds.north,
              'south': bounds.south,
              'east': bounds.east,
              'west': bounds.west,
            }),
            minZoom: minZoom,
            maxZoom: maxZoom,
            style: style,
            status: const Value('downloading'),
          ),
        );

    try {
      final store = FMTCStore(storeName);
      if (!await store.manage.ready) await store.manage.create();
      final region = RectangleRegion(bounds).toDownloadable(
        minZoom: minZoom,
        maxZoom: maxZoom,
        options: TileLayer(urlTemplate: urlTemplate),
      );
      final streams = store.download.startForeground(
        region: region,
        parallelThreads: 2,
        maxBufferLength: 60,
        skipExistingTiles: true,
        skipSeaTiles: false,
        rateLimit: 2,
        instanceId: localName,
      );
      DownloadProgress? last;
      await for (final progress in streams.downloadProgress) {
        last = progress;
      }
      final failed = last?.failedTilesCount ?? 0;
      final stats = await store.stats.all;
      await _updateLatestRegion(
        style: style,
        status: failed > 0 ? 'failed' : 'ready',
        storageBytes: (stats.size * 1024).round(),
      );
      return failed == 0;
    } catch (_) {
      await _updateLatestRegion(style: style, status: 'failed');
      return false;
    }
  }

  Future<void> _updateLatestRegion({
    required String style,
    required String status,
    int? storageBytes,
  }) async {
    final rows =
        await (db.select(db.offlineMapRegions)
              ..where((table) => table.style.equals(style))
              ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
              ..limit(1))
            .get();
    if (rows.isEmpty) return;
    await (db.update(db.offlineMapRegions)
      ..where((table) => table.id.equals(rows.first.id))).write(
      OfflineMapRegionsCompanion(
        status: Value(status),
        storageBytes:
            storageBytes == null ? const Value.absent() : Value(storageBytes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  LatLngBounds _boundsForRadius(LatLng center, double radiusKm) {
    final radiusMeters = radiusKm.clamp(1, 10) * 1000;
    const earthRadius = 6371000.0;
    final latDelta = (radiusMeters / earthRadius) * 180 / math.pi;
    final lonDelta =
        (radiusMeters /
            (earthRadius * math.cos(center.latitude * math.pi / 180))) *
        180 /
        math.pi;
    return LatLngBounds(
      LatLng(center.latitude - latDelta, center.longitude - lonDelta),
      LatLng(center.latitude + latDelta, center.longitude + lonDelta),
    );
  }
}
