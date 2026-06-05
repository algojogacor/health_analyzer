import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class AiConversationMemory {
  final AiConversation conversation;
  final List<AiMessage> messages;

  const AiConversationMemory({
    required this.conversation,
    required this.messages,
  });

  String get contextForAgent {
    final lines = <String>[
      if ((conversation.summary ?? '').trim().isNotEmpty)
        'Conversation summary: ${conversation.summary!.trim()}',
      if (messages.isNotEmpty) 'Recent conversation:',
      ...messages.take(12).map((message) {
        final role = message.role == 'user' ? 'User' : 'Assistant';
        return '$role: ${message.content.trim()}';
      }),
    ];
    return lines.join('\n');
  }
}

class AiConversationService {
  final AppDatabase db;
  final _uuid = const Uuid();

  const AiConversationService(this.db);

  Future<AiConversationMemory> loadOrCreateActive({
    String contextMode = 'daily',
  }) async {
    final recent = await db.getRecentAiConversations(limit: 1);
    final existing = recent.isEmpty ? null : recent.first;
    final conversation =
        existing ?? await createConversation(contextMode: contextMode);
    final messages = await db.getAiMessagesForConversation(
      conversation.localId,
      limit: 80,
    );
    if (messages.isEmpty) {
      final welcome = await appendMessage(
        conversation.localId,
        role: 'assistant',
        content:
            'Hi, I can explain your health/activity summaries, data gaps, recovery, and privacy status.',
        mode: 'local_rules',
      );
      return AiConversationMemory(
        conversation:
            await db.getAiConversation(conversation.localId) ?? conversation,
        messages: [welcome],
      );
    }
    return AiConversationMemory(conversation: conversation, messages: messages);
  }

  Future<AiConversationMemory?> loadMemory(String conversationId) async {
    final conversation = await db.getAiConversation(conversationId);
    if (conversation == null) return null;
    final messages = await db.getAiMessagesForConversation(
      conversationId,
      limit: 80,
    );
    return AiConversationMemory(conversation: conversation, messages: messages);
  }

  Future<AiConversation> createConversation({
    required String contextMode,
    String? title,
  }) async {
    final now = DateTime.now();
    final localId = _uuid.v4();
    await db.upsertAiConversation(
      AiConversationsCompanion.insert(
        localId: localId,
        title: title ?? 'Health coach chat',
        contextMode: Value(contextMode),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final conversation = await db.getAiConversation(localId);
    if (conversation == null) {
      throw StateError('AI conversation was not created');
    }
    return conversation;
  }

  Future<AiMessage> appendMessage(
    String conversationId, {
    required String role,
    required String content,
    String? mode,
    int toolCallsUsed = 0,
    String? error,
  }) async {
    final now = DateTime.now();
    final messageId = _uuid.v4();
    await db.insertAiMessage(
      AiMessagesCompanion.insert(
        localId: messageId,
        conversationId: conversationId,
        role: role,
        content: content,
        mode: Value(mode),
        toolCallsUsed: Value(toolCallsUsed),
        error: Value(error),
        createdAt: now,
      ),
    );

    final conversation = await db.getAiConversation(conversationId);
    final nextCount = (conversation?.messageCount ?? 0) + 1;
    final nextTitle =
        conversation?.messageCount == 0 && role == 'user'
            ? _titleFromPrompt(content)
            : conversation?.title ?? 'Health coach chat';
    await db.upsertAiConversation(
      AiConversationsCompanion.insert(
        localId: conversationId,
        title: nextTitle,
        summary: Value(conversation?.summary),
        contextMode: Value(mode ?? conversation?.contextMode ?? 'daily'),
        messageCount: Value(nextCount),
        createdAt: conversation?.createdAt ?? now,
        updatedAt: now,
        compactedAt: Value(conversation?.compactedAt),
      ),
    );

    if (role == 'assistant' && nextCount >= 12 && nextCount % 6 == 0) {
      await compactConversation(conversationId);
    }

    final messages = await db.getAiMessagesForConversation(
      conversationId,
      limit: nextCount + 1,
    );
    return messages.lastWhere((message) => message.localId == messageId);
  }

  Future<AiConversation> compactConversation(String conversationId) async {
    final conversation = await db.getAiConversation(conversationId);
    if (conversation == null) {
      throw StateError('AI conversation not found');
    }
    final messages = await db.getAiMessagesForConversation(
      conversationId,
      limit: 30,
    );
    final userPrompts =
        messages
            .where((message) => message.role == 'user')
            .map((message) => message.content.trim())
            .where((content) => content.isNotEmpty)
            .take(5)
            .toList();
    final assistantHints =
        messages
            .where((message) => message.role == 'assistant')
            .map((message) => message.content.trim())
            .where((content) => content.isNotEmpty)
            .take(3)
            .toList();
    final summary =
        [
          if (conversation.summary != null && conversation.summary!.isNotEmpty)
            conversation.summary!,
          if (userPrompts.isNotEmpty) 'User focus: ${userPrompts.join(' | ')}',
          if (assistantHints.isNotEmpty)
            'Recent coach context: ${assistantHints.join(' | ')}',
        ].join('\n').trim();
    final now = DateTime.now();
    await db.upsertAiConversation(
      AiConversationsCompanion.insert(
        localId: conversation.localId,
        title: conversation.title,
        summary: Value(
          summary.length > 1200 ? summary.substring(0, 1200) : summary,
        ),
        contextMode: Value(conversation.contextMode),
        messageCount: Value(conversation.messageCount),
        createdAt: conversation.createdAt,
        updatedAt: now,
        compactedAt: Value(now),
      ),
    );
    return await db.getAiConversation(conversationId) ?? conversation;
  }

  String _titleFromPrompt(String prompt) {
    final cleaned = prompt.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleaned.isEmpty) return 'Health coach chat';
    return cleaned.length <= 42 ? cleaned : '${cleaned.substring(0, 39)}...';
  }
}
