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
                        : _CloudSetupCard(
                          onPressed:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AiSettingsPage(),
                                ),
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

class _CloudSetupCard extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloudSetupCard({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: AppTheme.commandSurface(context),
      borderColor: AppTheme.commandSurface(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccentIconBox(
            icon: Icons.key_outlined,
            color: AppTheme.electric,
            size: 42,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cloud AI is not configured',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your own OpenAI-compatible key for chat. Local summaries, data quality checks, and privacy guard stay available.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accent(context),
                    foregroundColor:
                        AppTheme.isDark(context)
                            ? AppTheme.darkCanvas
                            : Colors.white,
                  ),
                  icon: const Icon(Icons.settings),
                  label: const Text('Configure AI'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    final accent = AppTheme.accent(context);
    return PremiumCard(
      color: AppTheme.commandSurface(context),
      borderColor: AppTheme.commandSurface(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AccentIconBox(icon: Icons.auto_awesome, color: accent, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI coach ready',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$provider / $model',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'It reads summarized health context first, keeps raw route private by default, and falls back to local rules when cloud AI is unavailable.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.38,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _CoachSignalRow(
            icon: Icons.fact_check_outlined,
            label: 'Data quality',
            value: '$recordCount records / $confidence',
          ),
          const SizedBox(height: 8),
          _CoachSignalRow(
            icon: Icons.favorite_border,
            label: 'Recovery',
            value:
                insights == null
                    ? 'Waiting for baseline'
                    : '${insights!.readinessScore} / ${insights!.readinessLabel}',
          ),
          const SizedBox(height: 8),
          const _CoachSignalRow(
            icon: Icons.verified_user_outlined,
            label: 'Privacy',
            value: 'Sanitized context',
          ),
        ],
      ),
    );
  }
}

class _CoachSignalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CoachSignalRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentDark, size: 19),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
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
          const Text(
            'Ask with context',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<String>(
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
              onSelectionChanged:
                  busy ? null : (value) => onChanged(value.first),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PromptButton(
                label: 'What should I do today?',
                onTap:
                    () => onPrompt(
                      'Based on my current data, what should I do today?',
                      'daily',
                    ),
              ),
              const SizedBox(height: 8),
              _PromptButton(
                label: 'Explain my data gaps',
                onTap:
                    () => onPrompt(
                      'Explain my data gaps and what I should fix first.',
                      'gaps',
                    ),
              ),
              const SizedBox(height: 8),
              _PromptButton(
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

class _PromptButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PromptButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.softSurface(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border(context)),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, size: 17, color: AppTheme.accent(context)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.text(context),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
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
            ? AppTheme.accent(context).withValues(alpha: dark ? 0.22 : 0.10)
            : AppTheme.card(context);
    final border =
        isUser
            ? AppTheme.accent(context).withValues(alpha: dark ? 0.44 : 0.24)
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
