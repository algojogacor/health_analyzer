import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppTheme.isDark(context);
    final card = AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppTheme.card(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? AppTheme.border(context)),
        boxShadow: [
          BoxShadow(
            color: (dark ? Colors.black : AppTheme.ink).withValues(
              alpha: dark ? 0.24 : 0.055,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return _PressableScale(onTap: onTap, child: card);
  }
}

class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressableScale({required this.child, required this.onTap});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.992 : 1,
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (value) => setState(() => _pressed = value),
        borderRadius: BorderRadius.circular(8),
        child: widget.child,
      ),
    );
  }
}

class AccentIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AccentIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    final background = AppTheme.subtleTint(context, color, 0.12);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: size * 0.56),
    );
  }
}
