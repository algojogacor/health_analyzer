import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'ai_tier_service.dart';
import 'ai_tool_executor_service.dart';
import 'llm_service.dart';

class AiAgentResponse {
  final String content;
  final String mode;
  final int toolCallsUsed;
  final String? error;

  const AiAgentResponse({
    required this.content,
    required this.mode,
    required this.toolCallsUsed,
    this.error,
  });
}

class AiAgentService {
  static const allowedTools = {
    'get_daily_health_summary',
    'get_activity_detail',
    'get_training_load',
    'compare_workouts',
    'find_data_gaps',
    'generate_recovery_advice',
    'load_route_summary',
    'get_privacy_status',
    'get_pr_history',
    'get_best_efforts',
    'get_goal_progress',
    'get_hr_zone_summary',
    'get_vo2max_trend',
    'suggest_next_workout',
    'get_training_plan_status',
  };

  final LlmService llmService;
  final AiToolExecutorService tools;
  final AiTierPolicy tierPolicy;
  final AiUsageTracker usageTracker;
  final _uuid = const Uuid();

  AiAgentService({
    required this.llmService,
    required this.tools,
    required this.tierPolicy,
    required this.usageTracker,
  });

  Future<AiAgentResponse> respond({
    required String prompt,
    required String contextMode,
    ActivitySession? latestActivity,
    String? conversationId,
    String? conversationContext,
  }) async {
    final config = await tierPolicy.loadConfig();
    final usageWindow = await usageTracker.resolveActiveWindow();
    final resolvedConversationId = conversationId ?? _uuid.v4();
    final messageId = _uuid.v4();
    var toolCalls = 0;
    final cloudSettings = await llmService.loadSettings();

    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
            'You are Health Analyzer AI Coach. You must answer wellness and '
            'fitness questions only. Do not diagnose disease or prescribe. '
            'Use this JSON protocol only: either '
            '{"type":"tool_call","tool":"TOOL_NAME","input":{...}} or '
            '{"type":"final","content":"ANSWER"}. '
            'Allowed tools: ${allowedTools.join(', ')}. '
            'Never request raw route points unless the user explicitly asks and '
            'the tool privacy status allows it.',
      },
      {
        'role': 'user',
        'content': jsonEncode({
          'question': prompt,
          'context_mode': contextMode,
          'latest_activity_local_id': latestActivity?.localId,
          if (conversationContext != null &&
              conversationContext.trim().isNotEmpty)
            'conversation_memory': conversationContext.trim(),
          'tier': config.tier.name,
          'max_tool_calls': config.maxToolCallsPerMessage,
        }),
      },
    ];

    if (!cloudSettings.isConfigured) {
      final fallback = await localRulesResponse(
        prompt: prompt,
        contextMode: contextMode,
        latestActivity: latestActivity,
        conversationId: resolvedConversationId,
        messageId: messageId,
        usageWindowId: usageWindow.windowId,
        tier: config.tier.name,
      );
      return AiAgentResponse(
        content:
            'Cloud AI is not configured yet. I used local rules from your on-device summaries instead.\n\n$fallback',
        mode: 'local_rules',
        toolCallsUsed: 1,
      );
    }

    try {
      for (var i = 0; i < config.maxToolCallsPerMessage; i++) {
        final completion = await llmService.chatCompletion(
          messages: messages,
          settings: cloudSettings,
        );
        final raw = completion.content;
        if (completion.inputTokens > 0 || completion.outputTokens > 0) {
          await usageTracker.increment(
            usageWindowId: usageWindow.windowId,
            inputTokens: completion.inputTokens,
            outputTokens: completion.outputTokens,
          );
        }
        final parsed = _tryJson(raw);
        if (parsed == null) {
          return AiAgentResponse(
            content: raw,
            mode: 'online_llm',
            toolCallsUsed: toolCalls,
          );
        }

        if (parsed['type'] == 'final') {
          return AiAgentResponse(
            content: parsed['content']?.toString() ?? raw,
            mode: 'online_llm',
            toolCallsUsed: toolCalls,
          );
        }

        if (parsed['type'] != 'tool_call') {
          return AiAgentResponse(
            content: raw,
            mode: 'online_llm',
            toolCallsUsed: toolCalls,
          );
        }

        final toolName = parsed['tool']?.toString() ?? '';
        if (!allowedTools.contains(toolName)) {
          return AiAgentResponse(
            content: 'Tool "$toolName" is not allowed.',
            mode: 'online_llm',
            toolCallsUsed: toolCalls,
          );
        }

        final input = _toolInput(parsed['input']);
        final result = await tools.runTool(
          toolName,
          input,
          conversationId: resolvedConversationId,
          messageId: messageId,
          usageWindowId: usageWindow.windowId,
          tier: config.tier.name,
        );
        toolCalls++;
        await usageTracker.increment(
          usageWindowId: usageWindow.windowId,
          toolCalls: 1,
        );

        messages
          ..add({'role': 'assistant', 'content': raw})
          ..add({
            'role': 'user',
            'content': jsonEncode({
              'tool_result': result,
              'instruction':
                  'Use the tool result. Continue with final answer or another tool call.',
            }),
          });
      }

      return AiAgentResponse(
        content:
            'I reached the ${config.maxToolCallsPerMessage} tool-call limit for your free tier message. Ask a narrower follow-up if you want more detail.',
        mode: 'online_llm',
        toolCallsUsed: toolCalls,
      );
    } catch (error) {
      final fallback = await localRulesResponse(
        prompt: prompt,
        contextMode: contextMode,
        latestActivity: latestActivity,
        conversationId: resolvedConversationId,
        messageId: messageId,
        usageWindowId: usageWindow.windowId,
        tier: config.tier.name,
      );
      return AiAgentResponse(
        content: 'Cloud AI provider unavailable: $error\n\n$fallback',
        mode: 'local_rules',
        toolCallsUsed: toolCalls,
        error: error.toString(),
      );
    }
  }

  Future<String> localRulesResponse({
    required String prompt,
    required String contextMode,
    ActivitySession? latestActivity,
    String? conversationId,
    String? messageId,
    String? usageWindowId,
    String tier = 'free',
  }) async {
    final lower = prompt.toLowerCase();
    final toolName =
        lower.contains('privacy') && latestActivity != null
            ? 'get_privacy_status'
            : lower.contains('recovery') || lower.contains('pulih')
            ? 'generate_recovery_advice'
            : lower.contains('gap') || lower.contains('missing')
            ? 'find_data_gaps'
            : (contextMode == 'activity' || lower.contains('activity')) &&
                latestActivity != null
            ? 'get_activity_detail'
            : contextMode == 'gaps'
            ? 'find_data_gaps'
            : 'get_daily_health_summary';
    final input = <String, dynamic>{
      if (latestActivity != null) 'session_local_id': latestActivity.localId,
    };
    final result = await tools.runTool(
      toolName,
      input,
      conversationId: conversationId,
      messageId: messageId,
      usageWindowId: usageWindowId,
      tier: tier,
    );
    if (usageWindowId != null) {
      await usageTracker.increment(usageWindowId: usageWindowId, toolCalls: 1);
    }
    return '''
Local rules response:
- Tool: $toolName
- Result: ${jsonEncode(result)}

This is wellness guidance only, based on local summarized data.
''';
  }

  Map<String, dynamic>? _tryJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return null;
    }
    return null;
  }

  Map<String, dynamic> _toolInput(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }
}
