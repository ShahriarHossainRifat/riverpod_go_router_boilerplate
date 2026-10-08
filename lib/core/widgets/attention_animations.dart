import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that shakes when triggered.
class ShakeWidget extends StatefulWidget {
  /// Creates a [ShakeWidget].
  const new({
    required this.child,
    required this.controller,
    super.key,
    this.duration = AppConstants.shakeAnimation,
    this.shakeCount = 3,
    this.shakeOffset = 10.0,
  });

  /// Child widget to shake.
  final Widget child;

  /// Controller to trigger shake.
  final ShakeController controller;

  /// Duration of shake animation.
  final Duration duration;

  /// Number of shakes.
  final int shakeCount;

  /// Offset of each shake.
  final double shakeOffset;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = TweenSequence<double>([
      for (int i = 0; i < widget.shakeCount; i++) ...[
        TweenSequenceItem(
          tween: Tween(begin: 0, end: widget.shakeOffset),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: widget.shakeOffset, end: -widget.shakeOffset),
          weight: 2,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -widget.shakeOffset, end: 0),
          weight: 1,
        ),
      ],
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.controller._attach(this);
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// Controller for [ShakeWidget].
class ShakeController {
  _ShakeWidgetState? _state;

  void _attach(_ShakeWidgetState state) {
    _state = state;
  }

  /// Triggers the shake animation.
  void shake() {
    _state?.shake();
  }
}

/// A pulsing animation widget.
class Pulse extends StatefulWidget {
  /// Creates a [Pulse] widget.
  const new({
    required this.child,
    super.key,
    this.duration = AppConstants.pulseAnimation,
    this.minScale = AppConstants.pulseScaleMin,
    this.maxScale = AppConstants.pulseScaleMax,
    this.enabled = true,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of one pulse cycle.
  final Duration duration;

  /// Minimum scale value.
  final double minScale;

  /// Maximum scale value.
  final double maxScale;

  /// Whether animation is enabled.
  final bool enabled;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 1.0;
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
