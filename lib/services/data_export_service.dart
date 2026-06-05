import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';
import 'gpx_service.dart';

class DataExportResult {
  final File file;
  final int healthRecordCount;
  final int activityCount;
  final int gpxCount;

  const DataExportResult({
    required this.file,
    required this.healthRecordCount,
    required this.activityCount,
    required this.gpxCount,
  });
}

class DataExportService {
  final AppDatabase db;
  final GpxService gpxService;
  final JsonEncoder _encoder = const JsonEncoder.withIndent('  ');

  DataExportService(this.db, {GpxService? gpxService})
    : gpxService = gpxService ?? GpxService(db);

  Future<DataExportResult> exportZip() async {
    final archive = Archive();
    final now = DateTime.now();
    final healthRecords = await db.select(db.healthRecords).get();
    final syncLogs = await db.select(db.syncLogs).get();
    final sessions = await db.select(db.activitySessions).get();
    final points = await db.select(db.activityPoints).get();
    final events = await db.select(db.activityEvents).get();
    final summaries = await db.select(db.activitySummaries).get();
    final savedRoutes = await db.select(db.savedRoutes).get();
    final dailySummaries = await db.select(db.dailySummaries).get();
    final aiConversations = await db.select(db.aiConversations).get();
    final aiMessages = await db.select(db.aiMessages).get();
    final aiToolCalls = await db.select(db.aiToolCalls).get();
    final aiUsageWindows = await db.select(db.aiUsageWindows).get();
    final personalRecords = await db.select(db.personalRecords).get();
    final trainingPlans = await db.select(db.trainingPlans).get();
    final trainingPlanWorkouts = await db.select(db.trainingPlanWorkouts).get();
    final communityShares = await db.select(db.communityShareRecords).get();
    final challengeInvites = await db.select(db.challengeInvites).get();
    final offlineRegions = await db.select(db.offlineMapRegions).get();

    _addJson(archive, 'manifest.json', {
      'app': 'Health Analyzer',
      'exported_at': now.toIso8601String(),
      'privacy_note':
          'This export is user-initiated and may contain raw health records and raw GPS points. API keys and Turso credentials are not included.',
      'counts': {
        'health_records': healthRecords.length,
        'activity_sessions': sessions.length,
        'activity_points': points.length,
        'activity_summaries': summaries.length,
        'saved_routes': savedRoutes.length,
        'daily_summaries': dailySummaries.length,
        'ai_conversations': aiConversations.length,
        'training_plans': trainingPlans.length,
      },
    });

    _addRows(archive, 'health/health_records.json', healthRecords);
    _addRows(archive, 'health/sync_logs.json', syncLogs);
    _addRows(archive, 'activities/activity_sessions.json', sessions);
    _addRows(archive, 'activities/activity_points.json', points);
    _addRows(archive, 'activities/activity_events.json', events);
    _addRows(archive, 'activities/activity_summaries.json', summaries);
    _addRows(archive, 'routes/saved_routes.json', savedRoutes);
    _addRows(archive, 'summaries/daily_summaries.json', dailySummaries);
    _addRows(archive, 'ai/ai_conversations.json', aiConversations);
    _addRows(archive, 'ai/ai_messages.json', aiMessages);
    _addRows(archive, 'ai/ai_tool_calls.json', aiToolCalls);
    _addRows(archive, 'ai/ai_usage_windows.json', aiUsageWindows);
    _addRows(archive, 'training/personal_records.json', personalRecords);
    _addRows(archive, 'training/training_plans.json', trainingPlans);
    _addRows(
      archive,
      'training/training_plan_workouts.json',
      trainingPlanWorkouts,
    );
    _addRows(
      archive,
      'community/community_share_records.json',
      communityShares,
    );
    _addRows(archive, 'community/challenge_invites.json', challengeInvites);
    _addRows(archive, 'maps/offline_map_regions.json', offlineRegions);

    for (final summary in summaries) {
      final safe = _safeFileName(summary.sessionLocalId);
      archive.addFile(
        ArchiveFile.string(
          'summaries/activity/$safe.md',
          summary.markdownSummary,
        ),
      );
      archive.addFile(
        ArchiveFile.string(
          'summaries/activity/$safe.json',
          summary.jsonSummary,
        ),
      );
    }

    var gpxCount = 0;
    for (final session in sessions.where((row) => row.status == 'completed')) {
      final routePoints =
          points
              .where((point) => point.sessionLocalId == session.localId)
              .toList()
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      if (routePoints.length < 2) continue;
      final safe = _safeFileName(session.title ?? session.sportName);
      archive.addFile(
        ArchiveFile.string(
          'activities/gpx/$safe-${session.localId}.gpx',
          gpxService.buildGpx(session, routePoints),
        ),
      );
      gpxCount++;
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        'health-analyzer-export-${now.millisecondsSinceEpoch}.zip',
      ),
    );
    final bytes = ZipEncoder().encode(archive);
    await file.writeAsBytes(bytes, flush: true);

    return DataExportResult(
      file: file,
      healthRecordCount: healthRecords.length,
      activityCount: sessions.length,
      gpxCount: gpxCount,
    );
  }

  void _addRows(Archive archive, String path, List<dynamic> rows) {
    _addJson(archive, path, rows.map((row) => row.toJson()).toList());
  }

  void _addJson(Archive archive, String path, Object value) {
    archive.addFile(ArchiveFile.string(path, _encoder.convert(value)));
  }

  String _safeFileName(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return cleaned.isEmpty ? 'health-analyzer' : cleaned;
  }
}
