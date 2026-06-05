import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

class OfflineMapCatalogPack {
  final String id;
  final String name;
  final String layer;
  final String url;
  final String source;
  final String license;
  final String attribution;
  final int sizeBytes;
  final int minZoom;
  final int maxZoom;
  final LatLngBounds bounds;

  const OfflineMapCatalogPack({
    required this.id,
    required this.name,
    required this.layer,
    required this.url,
    required this.source,
    required this.license,
    required this.attribution,
    required this.sizeBytes,
    required this.minZoom,
    required this.maxZoom,
    required this.bounds,
  });

  factory OfflineMapCatalogPack.fromJson(Map<String, dynamic> json) {
    final bounds = json['bounds'] as Map<String, dynamic>? ?? const {};
    return OfflineMapCatalogPack(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Offline map pack',
      layer: json['layer']?.toString() ?? 'satellite',
      url: json['url']?.toString() ?? '',
      source: json['source']?.toString() ?? 'unknown',
      license: json['license']?.toString() ?? 'review required',
      attribution: json['attribution']?.toString() ?? '',
      sizeBytes: (json['size_bytes'] as num?)?.round() ?? 0,
      minZoom: (json['min_zoom'] as num?)?.round() ?? 0,
      maxZoom: (json['max_zoom'] as num?)?.round() ?? 0,
      bounds: LatLngBounds(
        LatLng(
          (bounds['south'] as num?)?.toDouble() ?? 0,
          (bounds['west'] as num?)?.toDouble() ?? 0,
        ),
        LatLng(
          (bounds['north'] as num?)?.toDouble() ?? 0,
          (bounds['east'] as num?)?.toDouble() ?? 0,
        ),
      ),
    );
  }

  bool get isUsable =>
      id.isNotEmpty && url.startsWith('https://') && minZoom <= maxZoom;
}

class OfflinePmTilesPack {
  final String path;
  final String name;
  final String style;
  final String attribution;
  final int minZoom;
  final int maxZoom;

  const OfflinePmTilesPack({
    required this.path,
    required this.name,
    required this.style,
    required this.attribution,
    required this.minZoom,
    required this.maxZoom,
  });
}

class OfflineMapService {
  final AppDatabase db;
  final Dio dio;

  OfflineMapService(this.db, {Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  static Future<void> initialise() async {}

  Future<List<OfflineMapRegion>> regions() {
    return db.select(db.offlineMapRegions).get();
  }

  Future<List<OfflineMapCatalogPack>> fetchCatalog(String baseUrl) async {
    if (baseUrl.trim().isEmpty) return const [];
    final response = await dio.get<Map<String, dynamic>>(
      '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/maps/catalog',
    );
    final packs = response.data?['packs'];
    if (packs is! List) return const [];
    return packs
        .whereType<Map<String, dynamic>>()
        .map(OfflineMapCatalogPack.fromJson)
        .where((pack) => pack.isUsable)
        .toList(growable: false);
  }

  Future<void> saveCatalogPackRequest(OfflineMapCatalogPack pack) async {
    await db
        .into(db.offlineMapRegions)
        .insert(
          OfflineMapRegionsCompanion.insert(
            name: pack.name,
            bounds: jsonEncode({
              'north': pack.bounds.north,
              'south': pack.bounds.south,
              'east': pack.bounds.east,
              'west': pack.bounds.west,
              'source': pack.source,
              'license': pack.license,
              'attribution': pack.attribution,
              'url': pack.url,
              'pack_id': pack.id,
            }),
            minZoom: pack.minZoom,
            maxZoom: pack.maxZoom,
            style: pack.layer,
            storageBytes: Value(pack.sizeBytes),
            status: const Value('catalog_pmtiles'),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<OfflineMapRegion> downloadCatalogPack(
    OfflineMapCatalogPack pack, {
    void Function(int received, int total)? onProgress,
  }) async {
    if (!pack.isUsable) {
      throw StateError(
        'PMTiles pack is missing a valid HTTPS URL or zoom range',
      );
    }
    final file = await _packFile(pack);
    final rowId = await db
        .into(db.offlineMapRegions)
        .insert(
          OfflineMapRegionsCompanion.insert(
            name: pack.name,
            bounds: jsonEncode({
              'north': pack.bounds.north,
              'south': pack.bounds.south,
              'east': pack.bounds.east,
              'west': pack.bounds.west,
              'source': pack.source,
              'license': pack.license,
              'attribution': pack.attribution,
              'url': pack.url,
              'pack_id': pack.id,
              'local_path': file.path,
            }),
            minZoom: pack.minZoom,
            maxZoom: pack.maxZoom,
            style: pack.layer,
            storageBytes: Value(pack.sizeBytes),
            status: const Value('downloading_pmtiles'),
            updatedAt: Value(DateTime.now()),
          ),
        );

    try {
      await dio.download(
        pack.url,
        file.path,
        deleteOnError: true,
        onReceiveProgress: onProgress,
      );
      final actualBytes = await file.length();
      await (db.update(db.offlineMapRegions)
        ..where((table) => table.id.equals(rowId))).write(
        OfflineMapRegionsCompanion(
          storageBytes: Value(actualBytes),
          status: const Value('ready_pmtiles'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (error) {
      await (db.update(db.offlineMapRegions)
        ..where((table) => table.id.equals(rowId))).write(
        OfflineMapRegionsCompanion(
          status: const Value('failed_pmtiles'),
          updatedAt: Value(DateTime.now()),
        ),
      );
      rethrow;
    }

    return (db.select(db.offlineMapRegions)
      ..where((table) => table.id.equals(rowId))).getSingle();
  }

  Future<OfflineMapDownloadResult> downloadCurrentArea({
    required LatLng center,
    required double radiusKm,
    required OfflineMapLayerChoice layerChoice,
  }) async {
    final bounds = _boundsForRadius(center, radiusKm);
    var streetReady = false;
    var satelliteReady = false;
    var satelliteFailed = false;

    if (layerChoice == OfflineMapLayerChoice.street ||
        layerChoice == OfflineMapLayerChoice.both) {
      streetReady = await _registerPlannedLayer(
        name: 'Street ${radiusKm.toStringAsFixed(0)} km',
        style: 'street',
        bounds: bounds,
        minZoom: 12,
        maxZoom: 16,
      );
    }

    if (layerChoice == OfflineMapLayerChoice.satellite ||
        layerChoice == OfflineMapLayerChoice.both) {
      satelliteReady = await _registerPlannedLayer(
        name: 'Satellite ${radiusKm.toStringAsFixed(0)} km',
        style: 'satellite',
        bounds: bounds,
        minZoom: 12,
        maxZoom: 17,
      );
      satelliteFailed = true;
    }

    return OfflineMapDownloadResult(
      streetReady: streetReady,
      satelliteReady: satelliteReady,
      satelliteFailed: satelliteFailed,
      message:
          satelliteFailed
              ? 'Satellite offline packs are waiting for PMTiles support. Street online maps still work.'
              : 'Offline region metadata saved. PMTiles download will be enabled in the next map phase.',
    );
  }

  Future<void> deleteRegion(OfflineMapRegion region) async {
    final localPath = localPathFor(region);
    if (localPath != null) {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await (db.update(db.offlineMapRegions)
      ..where((table) => table.id.equals(region.id))).write(
      OfflineMapRegionsCompanion(
        status: const Value('deleted'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  static OfflinePmTilesPack? selectReadyPmTilesPack({
    required LatLng center,
    required String style,
    required List<OfflineMapRegion> regions,
  }) {
    for (final region in regions) {
      if (region.status != 'ready_pmtiles') continue;
      if (region.style != style) continue;
      final metadata = _decodeMetadata(region.bounds);
      final path = metadata['local_path']?.toString();
      if (path == null || path.trim().isEmpty) continue;
      if (!File(path).existsSync()) continue;
      final north = _asDouble(metadata['north']);
      final south = _asDouble(metadata['south']);
      final east = _asDouble(metadata['east']);
      final west = _asDouble(metadata['west']);
      if (north == null || south == null || east == null || west == null) {
        continue;
      }
      final inside =
          center.latitude >= south &&
          center.latitude <= north &&
          center.longitude >= west &&
          center.longitude <= east;
      if (!inside) continue;
      return OfflinePmTilesPack(
        path: path,
        name: region.name,
        style: region.style,
        attribution:
            metadata['attribution']?.toString().trim().isEmpty == false
                ? metadata['attribution'].toString()
                : 'Offline PMTiles',
        minZoom: region.minZoom,
        maxZoom: region.maxZoom,
      );
    }
    return null;
  }

  static String? localPathFor(OfflineMapRegion region) {
    final metadata = _decodeMetadata(region.bounds);
    final path = metadata['local_path']?.toString();
    return path == null || path.trim().isEmpty ? null : path;
  }

  Future<bool> _registerPlannedLayer({
    required String name,
    required String style,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
  }) async {
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
            status: const Value('planned_pmtiles'),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return false;
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

  Future<File> _packFile(OfflineMapCatalogPack pack) async {
    final dir = await getApplicationSupportDirectory();
    final mapDir = Directory(p.join(dir.path, 'offline_maps'));
    if (!await mapDir.exists()) {
      await mapDir.create(recursive: true);
    }
    return File(p.join(mapDir.path, '${_safeFileName(pack.id)}.pmtiles'));
  }

  String _safeFileName(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return cleaned.isEmpty ? 'offline-map-pack' : cleaned;
  }

  static Map<String, dynamic> _decodeMetadata(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return const {};
    }
    return const {};
  }

  static double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
