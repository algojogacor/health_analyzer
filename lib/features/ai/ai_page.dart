import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../services/training_insights_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/animated_section.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';
import '../settings/ai_settings_page.dart';

class AiPage extends ConsumerStatefulWidget {
  const AiPage({super.key});

  @override
  ConsumerState<AiPage> createState() => _AiPageState();
}

class _AiPageState extends ConsumerState<AiPage> {
  final _inputController = TextEditingController();
  final _messages = <_ChatMessage>[];
  String? _conversationId;
  String _contextMode = 'daily';
  bool _loadingHistory = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadConversation);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    try {
      final memory = await ref
          .read(aiConversationServiceProvider)
          .loadOrCreateActive(contextMode: _contextMode);
      if (!mounted) return;
      setState(() {
        _conversationId = memory.conversation.localId;
        _contextMode = memory.conversation.contextMode;
        _messages
          ..clear()
          ..addAll(
            memory.messages.map(
              (message) =>
                  _ChatMessage(role: message.role, content: message.content),
            ),
          );
        _loadingHistory = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..add(
            _ChatMessage(
              role: 'assistant',
              content: 'AI conversation history unavailable: $error',
            ),
          );
        _loadingHistory = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(llmSettingsProvider);
    final coverage = ref.watch(coverageSummaryProvider);
    final activityHistory = ref.watch(activityHistoryProvider);
    final insights = ref.watch(trainingInsightsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        AnimatedSection(
          index: 0,
          child: settings.when(
            data:
                (value) =>
                    value.isConfigured
                        ? _CoachCards(
                          recordCount: coverage.valueOrNull?.recordCount ?? 0,
                          confidence: coverage.valueOrNull?.confidence ?? '--',
                          provider: value.providerLabel,
                          model: value.model,
                          insights: insights.valueOrNull,
                        )
                        : InfoPanel(
                          icon: Icons.key_outlined,
                          title: 'Cloud AI is not configured',
                          body:
                              'Add your own OpenAI-compatible key to enable cloud chat. Local summaries and privacy tools are still available.',
                          action: TextButton.icon(
                            onPressed:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AiSettingsPage(),
                                  ),
                                ),
                            icon: const Icon(Icons.settings),
                            label: const Text('Configure'),
                          ),
                        ),
            loading: () => const LinearProgressIndicator(),
            error:
                (error, _) => InfoPanel(
                  icon: Icons.error_outline,
                  title: 'AI settings unavailable',
                  body: error.toString(),
                ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSection(
          index: 1,
          child: _ContextPicker(
            selected: _contextMode,
            busy: _busy || _loadingHistory,
            onChanged: (value) => setState(() => _contextMode = value),
            onPrompt: _usePrompt,
          ),
        ),
        const SizedBox(height: 16),
        if (_loadingHistory) const LinearProgressIndicator(),
        if (!_loadingHistory && _messages.isEmpty) ...[
          AnimatedSection(index: 2, child: const _CoachWelcome()),
          const SizedBox(height: 12),
        ],
        ..._messages.asMap().entries.map(
          (entry) => AnimatedSection(
            index: entry.key + 2,
            child: _MessageBubble(message: entry.value),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ask your health coach',
                  hintText: 'Example: review my recovery today',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed:
                  _busy || _loadingHistory
                      ? null
                      : () => _send(
                        activityHistory.valueOrNull ??
                            const <ActivitySession>[],
                      ),
              child:
                  _busy
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _send(List<ActivitySession> activities) async {
    final prompt = _inputController.text.trim();
    if (prompt.isEmpty) return;
    final conversationId = _conversationId;
    if (conversationId == null) return;
    setState(() {
      _busy = true;
      _messages.add(_ChatMessage(role: 'user', content: prompt));
      _inputController.clear();
    });

    try {
      await ref
          .read(aiConversationServiceProvider)
          .appendMessage(
            conversationId,
            role: 'user',
            content: prompt,
            mode: _contextMode,
          );
      final response = await ref
          .read(aiAgentServiceProvider)
          .respond(
            prompt: prompt,
            contextMode: _contextMode,
            latestActivity: activities.isEmpty ? null : activities.first,
            conversationId: conversationId,
            conversationContext: _conversationContext(),
          );
      final assistantContent =
          '${response.content}\n\nMode: ${response.mode}, tools: ${response.toolCallsUsed}';
      await ref
          .read(aiConversationServiceProvider)
          .appendMessage(
            conversationId,
            role: 'assistant',
            content: assistantContent,
            mode: response.mode,
            toolCallsUsed: response.toolCallsUsed,
            error: response.error,
          );
      setState(
        () => _messages.add(
          _ChatMessage(role: 'assistant', content: assistantContent),
        ),
      );
    } catch (error) {
      await ref
          .read(aiConversationServiceProvider)
          .appendMessage(
            conversationId,
            role: 'assistant',
            content: 'AI unavailable: $error',
            mode: 'error',
            error: error.toString(),
          );
      setState(
        () => _messages.add(
          _ChatMessage(role: 'assistant', content: 'AI unavailable: $error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _usePrompt(String prompt, String mode) {
    if (_busy) return;
    setState(() {
      _contextMode = mode;
      _inputController.text = prompt;
    });
  }

  String _conversationContext() {
    return _messages
        .take(12)
        .map((message) {
          final role = message.role == 'user' ? 'User' : 'Assistant';
          return '$role: ${message.content}';
        })
        .join('\n');
  }
}

class _CoachCards extends StatelessWidget {
  final int recordCount;
  final String confidence;
  final String provider;
  final String model;
  final TrainingInsightSummary? insights;

  const _CoachCards({
    required this.recordCount,
    required this.confidence,
    required this.provider,
    required this.model,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      children: [
        _CoachCard(
          icon: Icons.auto_awesome,
          title: 'AI Summary',
          body: '$provider / $model',
          color: AppTheme.violet,
        ),
        _CoachCard(
          icon: Icons.verified_user_outlined,
          title: 'Privacy Guard',
          body: 'Sanitized context',
          color: AppTheme.cyan,
        ),
        _CoachCard(
          icon: Icons.fact_check_outlined,
          title: 'Data Quality',
          body: '$recordCount records',
          color: AppTheme.amber,
        ),
        _CoachCard(
          icon: Icons.favorite_border,
          title: 'Recovery',
          body:
              insights == null
                  ? confidence
                  : '${insights!.readinessScore} / ${insights!.readinessLabel}',
          color: AppTheme.coral,
        ),
      ],
    );
  }
}

class _CoachCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const _CoachCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccentIconBox(icon: icon, color: color, size: 34),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(
            body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppTheme.mutedText(context)),
          ),
        ],
      ),
    );
  }
}

class _CoachWelcome extends StatelessWidget {
  const _CoachWelcome();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: AppTheme.softSurface(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccentIconBox(
            icon: Icons.psychology_outlined,
            color: AppTheme.violet,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hi, I can explain your health summaries, workout trends, data gaps, and privacy status. I use local rules first, then cloud AI only when configured.',
              style: TextStyle(
                color: AppTheme.text(context),
                height: 1.42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextPicker extends StatelessWidget {
  final String selected;
  final bool busy;
  final ValueChanged<String> onChanged;
  final void Function(String prompt, String mode) onPrompt;

  const _ContextPicker({
    required this.selected,
    required this.busy,
    required this.onChanged,
    required this.onPrompt,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: 'daily',
                icon: Icon(Icons.today_outlined),
                label: Text('Daily'),
              ),
              ButtonSegment(
                value: 'activity',
                icon: Icon(Icons.route),
                label: Text('Latest'),
              ),
              ButtonSegment(
                value: 'gaps',
                icon: Icon(Icons.fact_check_outlined),
                label: Text('Gaps'),
              ),
            ],
            selected: {selected},
            onSelectionChanged: busy ? null : (value) => onChanged(value.first),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PromptChip(
                label: 'What should I do today?',
                onTap:
                    () => onPrompt(
                      'Based on my current data, what should I do today?',
                      'daily',
                    ),
              ),
              _PromptChip(
                label: 'Explain my data gaps',
                onTap:
                    () => onPrompt(
                      'Explain my data gaps and what I should fix first.',
                      'gaps',
                    ),
              ),
              _PromptChip(
                label: 'Review latest workout',
                onTap:
                    () => onPrompt(
                      'Review my latest workout and give practical next steps.',
                      'activity',
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PromptChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: const Icon(Icons.auto_awesome, size: 16),
      label: Text(label),
      backgroundColor: AppTheme.softSurface(context),
      side: BorderSide(color: AppTheme.border(context)),
      labelStyle: TextStyle(
        color: AppTheme.text(context),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final dark = AppTheme.isDark(context);
    final background =
        isUser
            ? AppTheme.cyan.withValues(alpha: dark ? 0.22 : 0.10)
            : AppTheme.card(context);
    final border =
        isUser
            ? AppTheme.cyan.withValues(alpha: dark ? 0.44 : 0.24)
            : AppTheme.border(context);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: AppTheme.text(context), height: 1.38),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String role;
  final String content;

  const _ChatMessage({required this.role, required this.content});
}
