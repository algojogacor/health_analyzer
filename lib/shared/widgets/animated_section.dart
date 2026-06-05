import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnimatedSection extends StatelessWidget {
  final Widget child;
  final int index;
  final double offset;

  const AnimatedSection({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 18,
  });

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 55 * index);
    return _DelayedFadeSlide(delay: delay, offset: offset, child: child);
  }
}

class _DelayedFadeSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double offset;

  const _DelayedFadeSlide({
    required this.child,
    required this.delay,
    required this.offset,
  });

  @override
  State<_DelayedFadeSlide> createState() => _DelayedFadeSlideState();
}

class _DelayedFadeSlideState extends State<_DelayedFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.slow);
    final curved = CurvedAnimation(parent: _controller, curve: AppMotion.curve);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offset / 100),
      end: Offset.zero,
    ).animate(curved);
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
