import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that performs a bounce animation to draw attention.
///
/// Use for notifications, CTAs, or any element that needs user attention.
///
/// Example:
/// ```dart
/// Bounce(
///   child: Icon(Icons.notification_important, size: 32),
///   repeat: true,
/// )
/// ```
class Bounce extends StatefulWidget {
  /// Creates a [Bounce] widget.
  const new({
    required this.child,
    super.key,
    this.duration = AppConstants.bounceAnimation,
    this.delay = .zero,
    this.from = AppConstants.bounceScaleMin,
    this.to = AppConstants.bounceScaleMax,
    this.repeat = false,
    this.enabled = true,
    this.onComplete,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of one bounce cycle.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Minimum scale value.
  final double from;

  /// Maximum scale value.
  final double to;

  /// Whether to repeat the animation.
  final bool repeat;

  /// Whether animation is enabled.
  final bool enabled;

  /// Callback when animation completes (only if not repeating).
  final VoidCallback? onComplete;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: widget.to), weight: 1),
      TweenSequenceItem(
        tween: Tween(begin: widget.to, end: widget.from),
        weight: 1,
      ),
      TweenSequenceItem(tween: Tween(begin: widget.from, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.repeat && widget.enabled) {
          _controller.forward(from: 0);
        } else {
          widget.onComplete?.call();
        }
      }
    });

    if (widget.enabled) {
      _start();
    }
  }

  void _start() {
    if (widget.delay == .zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(Bounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _start();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
