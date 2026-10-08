import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// An animated counter that smoothly transitions between numeric values.
///
/// Perfect for displaying dynamic statistics, scores, or any numeric data
/// that changes over time.
///
/// Example:
/// ```dart
/// AnimatedCounter(
///   value: 1234,
///   duration: AppConstants.counterAnimation,
///   style: Theme.of(context).textTheme.headlineLarge,
/// )
/// ```
class AnimatedCounter extends StatefulWidget {
  /// Creates an [AnimatedCounter] widget.
  const new({
    required this.value,
    super.key,
    this.duration = AppConstants.counterAnimation,
    this.curve = Curves.easeOutCubic,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimalPlaces = 0,
    this.separator = ',',
  });

  /// The target value to animate to.
  final num value;

  /// Duration of the counting animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Text style for the counter.
  final TextStyle? style;

  /// Text to display before the number.
  final String prefix;

  /// Text to display after the number.
  final String suffix;

  /// Number of decimal places to show.
  final int decimalPlaces;

  /// Thousand separator character.
  final String separator;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
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
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value.toDouble();
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

  String _formatNumber(double value) {
    final fixedValue = value.toStringAsFixed(widget.decimalPlaces);
    if (widget.separator.isEmpty) return fixedValue;

    final parts = fixedValue.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}${widget.separator}',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_formatNumber(_animation.value)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
