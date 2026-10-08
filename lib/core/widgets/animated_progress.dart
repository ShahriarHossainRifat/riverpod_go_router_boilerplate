import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// An animated progress indicator that smoothly animates value changes.
///
/// Great for loading states, upload progress, or skill bars.
///
/// Example:
/// ```dart
/// AnimatedProgress(
///   value: 0.75,
///   label: '75%',
///   color: Theme.of(context).colorScheme.primary,
/// )
/// ```
class AnimatedProgress extends StatefulWidget {
  /// Creates an [AnimatedProgress] widget.
  const new({
    required this.value,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeInOutCubic,
    this.height = 8.0,
    this.borderRadius,
    this.backgroundColor,
    this.color,
    this.gradient,
    this.label,
    this.labelStyle,
    this.showLabel = false,
  });

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Duration of the animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Height of the progress bar.
  final double height;

  /// Border radius of the progress bar.
  final BorderRadius? borderRadius;

  /// Background color of the track.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? color;

  /// Optional gradient for the progress indicator.
  final Gradient? gradient;

  /// Optional label to display (e.g., percentage).
  final String? label;

  /// Style for the label.
  final TextStyle? labelStyle;

  /// Whether to show the label.
  final bool showLabel;

  @override
  State<AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(AnimatedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation();
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius =
        widget.borderRadius ??
        BorderRadius.circular(AppConstants.borderRadiusFull);
    final bgColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fgColor = widget.color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(widget.label!, style: widget.labelStyle),
          const SizedBox(height: 4),
        ],
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: widget.height,
              decoration: BoxDecoration(color: bgColor, borderRadius: radius),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.gradient == null ? fgColor : null,
                    gradient: widget.gradient,
                    borderRadius: radius,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// A circular progress indicator with animated value changes.
class AnimatedCircularProgress extends StatefulWidget {
  /// Creates an [AnimatedCircularProgress] widget.
  const new({
    required this.value,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeInOutCubic,
    this.size = 48.0,
    this.strokeWidth = 4.0,
    this.backgroundColor,
    this.color,
    this.child,
  });

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Duration of the animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Size of the circular progress.
  final double size;

  /// Width of the progress stroke.
  final double strokeWidth;

  /// Background color of the track.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? color;

  /// Optional child widget to display in the center.
  final Widget? child;

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation();
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fgColor = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1,
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation(bgColor),
              ),
              CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation(fgColor),
              ),
              if (widget.child != null) Center(child: widget.child),
            ],
          );
        },
      ),
    );
  }
}
