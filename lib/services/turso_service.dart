import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk push/pull data ke Turso (libSQL cloud)
class TursoService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static String _buildBaseUrl(String dbName) {
    String url = dbName.trim();
    if (url.startsWith('libsql://')) {
      url = 'https://${url.substring(9)}';
    } else if (url.startsWith('http://')) {
      url = 'https://${url.substring(7)}';
    } else if (!url.startsWith('https://')) {
      if (url.contains('.turso.io')) {
        url = 'https://$url';
      } else {
        url = 'https://$url.turso.io';
      }
    }
    return url;
  }

  static String formatToWib(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final wib = utc.add(const Duration(hours: 7));
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${wib.year}-${twoDigits(wib.month)}-${twoDigits(wib.day)}T${twoDigits(wib.hour)}:${twoDigits(wib.minute)}:${twoDigits(wib.second)}+07:00";
  }

  TursoService({
    required String dbName,
    required String authToken,
    Dio? dio,
    FlutterSecureStorage? storage,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: _buildBaseUrl(dbName),
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 15),
               headers: {
                 'Authorization': 'Bearer $authToken',
                 'Content-Type': 'application/json',
               },
             ),
           ),
       _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           );

  /// Push batch health records ke Turso (batched, max 20 per request)
  ///
  /// Turso/Hrana HTTP API spec:
  ///   - integer: {"type": "integer", "value": "decimal-string"}
  ///   - float: {"type": "float", "value": json-number}
  ///   - text: {"type": "text", "value": "string"}
  Future<bool> pushRecords(List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return true;

    const batchSize = 20;
    final totalBatches = (records.length / batchSize).ceil();

    for (var batchIdx = 0; batchIdx < totalBatches; batchIdx++) {
      final start = batchIdx * batchSize;
      final end = (start + batchSize).clamp(0, records.length);
      final batch = records.sublist(start, end);

      final statements =
          batch.map((r) {
            final cols = r.keys.join(', ');
            final placeholders = r.keys.map((_) => '?').join(', ');
            final args =
                r.values.map((v) {
                  if (v is int) {
                    // integer: value must be a decimal string
                    return {'type': 'integer', 'value': v.toString()};
                  } else if (v is double) {
                    // float: value must be an actual JSON number (f64), NOT a string
                    return {'type': 'float', 'value': v};
                  } else {
                    // text / null -> stringify
                    return {'type': 'text', 'value': v?.toString() ?? ''};
                  }
                }).toList();

            return {
              'type': 'execute',
              'stmt': {
                'sql':
                    'INSERT OR REPLACE INTO health_records ($cols) VALUES ($placeholders)',
                'args': args,
              },
            };
          }).toList();

      try {
        final response = await _dio.post(
          '/v2/pipeline',
          data: {'requests': statements},
        );

        if (response.statusCode != 200) {
          developer.log(
            'HTTP ${response.statusCode} on batch $batchIdx',
            name: 'TursoService.pushRecords',
          );
          return false;
        }

        // Check per-statement errors returned in the response body
        final results = response.data['results'] as List<dynamic>?;
        if (results != null) {
          for (var res in results) {
            if (res['type'] == 'error') {
              developer.log(
                'Statement error on batch $batchIdx: ${res['error']}',
                name: 'TursoService.pushRecords',
              );
              return false;
            }
          }
        }
      } on DioException catch (e) {
        developer.log(
          'Push error on batch $batchIdx: ${e.message}',
          name: 'TursoService.pushRecords',
          error: e,
        );
        if (e.response != null) {
          developer.log(
            'Response body: ${e.response?.data}',
            name: 'TursoService.pushRecords',
          );
        }
        return false;
      }
    }

    return true;
  }

  Future<bool> pushActivitySessions(List<Map<String, dynamic>> sessions) {
    return _pushRows('activity_sessions', sessions);
  }

  Future<bool> pushActivityPoints(List<Map<String, dynamic>> points) {
    return _pushRows('activity_points', points);
  }

  Future<bool> pushActivitySummaries(List<Map<String, dynamic>> summaries) {
    return _pushRows('activity_summaries', summaries);
  }

  Future<bool> _pushRows(
    String tableName,
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) return true;

    const batchSize = 20;
    final totalBatches = (rows.length / batchSize).ceil();

    for (var batchIdx = 0; batchIdx < totalBatches; batchIdx++) {
      final start = batchIdx * batchSize;
      final end = (start + batchSize).clamp(0, rows.length);
      final batch = rows.sublist(start, end);
      final statements =
          batch.map((r) {
            final cols = r.keys.join(', ');
            final placeholders = r.keys.map((_) => '?').join(', ');
            final args = r.values.map(_toTursoArg).toList();
            return {
              'type': 'execute',
              'stmt': {
                'sql':
                    'INSERT OR REPLACE INTO $tableName ($cols) VALUES ($placeholders)',
                'args': args,
              },
            };
          }).toList();

      try {
        final response = await _dio.post(
          '/v2/pipeline',
          data: {'requests': statements},
        );
        if (response.statusCode != 200) return false;
        final results = response.data['results'] as List<dynamic>?;
        if (results != null) {
          for (final res in results) {
            if (res['type'] == 'error') {
              developer.log(
                '$tableName error: ${res['error']}',
                name: 'TursoService.pushRows',
              );
              return false;
            }
          }
        }
      } on DioException catch (e) {
        developer.log(
          '$tableName push error: ${e.message}',
          name: 'TursoService.pushRows',
          error: e,
        );
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> _toTursoArg(dynamic value) {
    if (value is int) {
      return {'type': 'integer', 'value': value.toString()};
    }
    if (value is double) {
      return {'type': 'float', 'value': value};
    }
    return {'type': 'text', 'value': value?.toString() ?? ''};
  }

  /// Pull latest health data dari Turso
  Future<List<Map<String, dynamic>>> pullRecords({
    int limit = 100,
    String? since,
  }) async {
    try {
      final sql =
          since != null
              ? {
                'sql': '''
            SELECT * FROM health_records
            WHERE date_from > ?
            ORDER BY date_from DESC
            LIMIT ?''',
                'args': [
                  {'type': 'text', 'value': since},
                  {'type': 'integer', 'value': limit.toString()},
                ],
              }
              : {
                'sql': '''
            SELECT * FROM health_records
            WHERE synced_at IS NULL
            ORDER BY date_from DESC
            LIMIT ?''',
                'args': [
                  {'type': 'integer', 'value': limit.toString()},
                ],
              };

      final response = await _dio.post(
        '/v2/pipeline',
        data: {
          'requests': [
            {'type': 'execute', 'stmt': sql},
          ],
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final results =
            response.data['results']?[0]?['response']?['result']?['rows']
                as List<dynamic>? ??
            [];
        return results.cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      developer.log(
        'Pull error: ${e.message}',
        name: 'TursoService.pullRecords',
        error: e,
      );
      return [];
    }
  }

  /// Save Turso credentials securely
  Future<void> saveCredentials({
    required String dbName,
    required String authToken,
  }) async {
    await _storage.write(key: 'turso_db_name', value: dbName);
    await _storage.write(key: 'turso_auth_token', value: authToken);
  }

  /// Load Turso credentials
  static Future<({String dbName, String authToken})?> loadCredentials(
    FlutterSecureStorage storage,
  ) async {
    final dbName = await storage.read(key: 'turso_db_name');
    final authToken = await storage.read(key: 'turso_auth_token');
    if (dbName == null || authToken == null) return null;
    return (dbName: dbName, authToken: authToken);
  }

  /// Check if Turso is reachable and initialize tables
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.post(
        '/v2/pipeline',
        data: {
          'requests': [
            {
              'type': 'execute',
              'stmt': {'sql': 'SELECT 1'},
            },
            {
              'type': 'execute',
              'stmt': {
                'sql': '''
                  CREATE TABLE IF NOT EXISTS health_records (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    data_type TEXT NOT NULL,
                    value REAL NOT NULL,
                    unit TEXT NOT NULL,
                    date_from TEXT NOT NULL,
                    date_to TEXT NOT NULL,
                    source_name TEXT,
                    source_id TEXT,
                    created_at TEXT DEFAULT CURRENT_TIMESTAMP
                  )
                ''',
              },
            },
            {
              'type': 'execute',
              'stmt': {
                'sql': '''
                  CREATE TABLE IF NOT EXISTS activity_sessions (
                    local_id TEXT PRIMARY KEY,
                    sport_key TEXT NOT NULL,
                    sport_name TEXT NOT NULL,
                    category TEXT NOT NULL,
                    requires_gps INTEGER NOT NULL DEFAULT 0,
                    status TEXT NOT NULL,
                    started_at TEXT NOT NULL,
                    ended_at TEXT,
                    elapsed_seconds INTEGER NOT NULL DEFAULT 0,
                    moving_seconds INTEGER NOT NULL DEFAULT 0,
                    stopped_seconds INTEGER NOT NULL DEFAULT 0,
                    distance_meters REAL NOT NULL DEFAULT 0,
                    calories_kcal REAL NOT NULL DEFAULT 0,
                    ascent_meters REAL NOT NULL DEFAULT 0,
                    descent_meters REAL NOT NULL DEFAULT 0,
                    avg_speed_mps REAL,
                    max_speed_mps REAL,
                    avg_heart_rate REAL,
                    max_heart_rate REAL,
                    source TEXT NOT NULL DEFAULT 'phone_gps',
                    route_visibility TEXT NOT NULL DEFAULT 'private',
                    hide_start_end_meters REAL NOT NULL DEFAULT 300,
                    sync_route_detail INTEGER NOT NULL DEFAULT 0,
                    write_health_connect INTEGER NOT NULL DEFAULT 1,
                    metadata TEXT,
                    created_at TEXT DEFAULT CURRENT_TIMESTAMP
                  )
                ''',
              },
            },
            {
              'type': 'execute',
              'stmt': {
                'sql': '''
                  CREATE TABLE IF NOT EXISTS activity_points (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    session_local_id TEXT NOT NULL,
                    timestamp TEXT NOT NULL,
                    latitude REAL NOT NULL,
                    longitude REAL NOT NULL,
                    altitude_meters REAL,
                    altitude_corrected_meters REAL,
                    accuracy_meters REAL,
                    speed_mps REAL,
                    bearing_degrees REAL,
                    distance_from_prev_meters REAL NOT NULL DEFAULT 0,
                    moving INTEGER NOT NULL DEFAULT 1,
                    point_quality TEXT NOT NULL DEFAULT 'unknown',
                    provider TEXT,
                    metadata TEXT,
                    created_at TEXT DEFAULT CURRENT_TIMESTAMP
                  )
                ''',
              },
            },
            {
              'type': 'execute',
              'stmt': {
                'sql': '''
                  CREATE TABLE IF NOT EXISTS activity_summaries (
                    session_local_id TEXT PRIMARY KEY,
                    json_summary TEXT NOT NULL,
                    markdown_summary TEXT NOT NULL,
                    generated_at TEXT NOT NULL,
                    created_at TEXT DEFAULT CURRENT_TIMESTAMP
                  )
                ''',
              },
            },
          ],
        },
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          for (var res in results) {
            if (res['type'] == 'error') {
              developer.log(
                'Init error: ${res['error']}',
                name: 'TursoService.healthCheck',
              );
              return false;
            }
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      developer.log(
        'Health check error: $e',
        name: 'TursoService.healthCheck',
        error: e,
      );
      return false;
    }
  }
}
