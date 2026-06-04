import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

enum AiTier { free, paid }

class AiTierConfig {
  final AiTier tier;
  final int maxToolCallsPerMessage;
  final int? windowResetHours;
  final int? weeklyToolCallLimit;

  const AiTierConfig({
    required this.tier,
    required this.maxToolCallsPerMessage,
    required this.windowResetHours,
    required this.weeklyToolCallLimit,
  });

  static const free = AiTierConfig(
    tier: AiTier.free,
    maxToolCallsPerMessage: 6,
    windowResetHours: null,
    weeklyToolCallLimit: null,
  );

  static const paid = AiTierConfig(
    tier: AiTier.paid,
    maxToolCallsPerMessage: 24,
    windowResetHours: 7,
    weeklyToolCallLimit: null,
  );
}

class AiTierPolicy {
  static const userTierKey = 'user_tier';
  static const configVersionKey = 'ai_tier_config_version';
  static const currentConfigVersion = '2026-06-05.v1';

  final FlutterSecureStorage storage;

  const AiTierPolicy({required this.storage});

  Future<AiTierConfig> loadConfig() async {
    await storage.write(key: configVersionKey, value: currentConfigVersion);
    final raw = await storage.read(key: userTierKey) ?? 'free';
    return raw == 'paid' ? AiTierConfig.paid : AiTierConfig.free;
  }

  Future<void> setTierForTestingOrFuture(AiTier tier) async {
    await storage.write(key: userTierKey, value: tier.name);
  }
}

class AiUsageTracker {
  final AppDatabase db;
  final AiTierPolicy tierPolicy;
  final _uuid = const Uuid();

  AiUsageTracker({required this.db, required this.tierPolicy});

  Future<AiUsageWindow> resolveActiveWindow() async {
    final config = await tierPolicy.loadConfig();
    final tier = config.tier.name;
    final latest = await db.getLatestAiUsageWindowForTier(tier);
    final now = DateTime.now();
    if (latest != null) {
      final resetsAt = latest.resetsAt;
      if (resetsAt == null || resetsAt.isAfter(now)) {
        return latest;
      }
    }

    final windowId = _uuid.v4();
    final resetsAt =
        config.windowResetHours == null
            ? null
            : now.add(Duration(hours: config.windowResetHours!));
    await db.upsertAiUsageWindow(
      AiUsageWindowsCompanion.insert(
        windowId: windowId,
        tier: Value(tier),
        startedAt: now,
        resetsAt: Value(resetsAt),
        updatedAt: Value(now),
      ),
    );
    final created = await db.getAiUsageWindow(windowId);
    if (created == null) {
      throw StateError('AI usage window was not created');
    }
    return created;
  }

  Future<void> increment({
    required String usageWindowId,
    int toolCalls = 0,
    int inputTokens = 0,
    int outputTokens = 0,
    double estimatedCost = 0,
  }) async {
    final current = await db.getAiUsageWindow(usageWindowId);
    if (current == null) return;
    await db.upsertAiUsageWindow(
      AiUsageWindowsCompanion.insert(
        windowId: current.windowId,
        tier: Value(current.tier),
        startedAt: current.startedAt,
        resetsAt: Value(current.resetsAt),
        toolCallsUsed: Value(current.toolCallsUsed + toolCalls),
        inputTokens: Value(current.inputTokens + inputTokens),
        outputTokens: Value(current.outputTokens + outputTokens),
        estimatedCost: Value(current.estimatedCost + estimatedCost),
        createdAt: Value(current.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
