import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/health_provider.dart';
import '../../shared/widgets/info_panel.dart';
import '../settings/ai_settings_page.dart';

class AiPage extends ConsumerStatefulWidget {
  const AiPage({super.key});

  @override
  ConsumerState<AiPage> createState() => _AiPageState();
}

class _AiPageState extends ConsumerState<AiPage> {
  final _inputController = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      role: 'assistant',
      content:
          'Hi, I can explain your health/activity summaries, data gaps, recovery, and privacy status.',
    ),
  ];
  String _contextMode = 'daily';
  bool _busy = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(deepSeekSettingsProvider);
    final coverage = ref.watch(coverageSummaryProvider);
    final activityHistory = ref.watch(activityHistoryProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        settings.when(
          data:
              (value) =>
                  value.isConfigured
                      ? _CoachCards(
                        recordCount: coverage.valueOrNull?.recordCount ?? 0,
                        confidence: coverage.valueOrNull?.confidence ?? '--',
                        model: value.model,
                      )
                      : InfoPanel(
                        icon: Icons.key_outlined,
                        title: 'DeepSeek is not configured',
                        body:
                            'Add your API key to enable AI chat. Local summaries and privacy tools are still available.',
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
        const SizedBox(height: 16),
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
          selected: {_contextMode},
          onSelectionChanged:
              _busy
                  ? null
                  : (value) => setState(() => _contextMode = value.first),
        ),
        const SizedBox(height: 16),
        ..._messages.map((message) => _MessageBubble(message: message)),
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
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed:
                  _busy
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
    setState(() {
      _busy = true;
      _messages.add(_ChatMessage(role: 'user', content: prompt));
      _inputController.clear();
    });

    try {
      final response = await ref
          .read(aiAgentServiceProvider)
          .respond(
            prompt: prompt,
            contextMode: _contextMode,
            latestActivity: activities.isEmpty ? null : activities.first,
          );
      setState(
        () => _messages.add(
          _ChatMessage(
            role: 'assistant',
            content:
                '${response.content}\n\nMode: ${response.mode}, tools: ${response.toolCallsUsed}',
          ),
        ),
      );
    } catch (error) {
      setState(
        () => _messages.add(
          _ChatMessage(role: 'assistant', content: 'AI unavailable: $error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _CoachCards extends StatelessWidget {
  final int recordCount;
  final String confidence;
  final String model;

  const _CoachCards({
    required this.recordCount,
    required this.confidence,
    required this.model,
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
          body: '$model ready',
          color: Colors.deepPurple,
        ),
        _CoachCard(
          icon: Icons.verified_user_outlined,
          title: 'Privacy Guard',
          body: 'Sanitized context',
          color: Colors.teal,
        ),
        _CoachCard(
          icon: Icons.fact_check_outlined,
          title: 'Data Quality',
          body: '$recordCount records',
          color: Colors.orange,
        ),
        _CoachCard(
          icon: Icons.favorite_border,
          title: 'Recovery',
          body: confidence,
          color: Colors.red,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(
              body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700),
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
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.cyan.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUser ? Colors.cyan.shade100 : Colors.grey.shade200,
          ),
        ),
        child: Text(message.content),
      ),
    );
  }
}

class _ChatMessage {
  final String role;
  final String content;

  const _ChatMessage({required this.role, required this.content});
}
