import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'premium_card.dart';

class InfoPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const InfoPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final titleColor = dark ? AppTheme.darkInk : AppTheme.ink;
    final bodyColor = dark ? AppTheme.darkMuted : AppTheme.muted;
    return PremiumCard(
      color: dark ? AppTheme.darkSurface : AppTheme.canvas,
      borderColor: dark ? AppTheme.darkLine : AppTheme.line,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccentIconBox(icon: icon, color: AppTheme.cyan, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(body, style: TextStyle(color: bodyColor, height: 1.35)),
                if (action != null) ...[const SizedBox(height: 10), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
