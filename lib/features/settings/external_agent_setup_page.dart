import 'package:flutter/material.dart';

import '../../shared/widgets/info_panel.dart';

class ExternalAgentSetupPage extends StatelessWidget {
  const ExternalAgentSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('External AI agent')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: const [
          InfoPanel(
            icon: Icons.developer_mode,
            title: 'Optional developer mode',
            body:
                'Termux, Telegram, ZeroClaw, and Hermes are optional add-ons for advanced users. The native app and Koyeb backend work without them.',
          ),
          SizedBox(height: 16),
          _SetupBlock(
            title: 'What to export',
            body:
                'Share the Health Analyzer skill folder, Turso URL/token owned by the user, and generated activity/daily summaries. Do not export raw route points unless route detail sharing is enabled.',
          ),
          SizedBox(height: 12),
          _SetupBlock(
            title: 'Setup files',
            body:
                'Read docs/EXTERNAL_AI_AGENT_SETUP.md and copy skills/health-analyzer-skill/agent.env.example. Fill the copy on Termux or VPS only; never commit secrets.',
          ),
          SizedBox(height: 12),
          _SetupBlock(
            title: 'Agent responsibilities',
            body:
                'The external agent may read Turso summaries, answer broader Telegram questions, and use its own model/provider configuration.',
          ),
          SizedBox(height: 12),
          _SetupBlock(
            title: 'Not provided by the app',
            body:
                'Telegram bot token, model API keys, ZeroClaw/Hermes install, provider selection, and long-running Termux process management.',
          ),
        ],
      ),
    );
  }
}

class _SetupBlock extends StatelessWidget {
  final String title;
  final String body;

  const _SetupBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
