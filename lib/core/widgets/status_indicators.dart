import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';

/// A status indicator dot.
class StatusDot extends StatelessWidget {
  /// Creates a [StatusDot].
  const new({
    super.key,
    this.status = StatusType.info,
    this.size = 8,
    this.animated = false,
  });

  /// Creates an online status dot.
  const new online({super.key, this.size = 8, this.animated = false})
    : status = StatusType.success;

  /// Creates an offline status dot.
  const new offline({super.key, this.size = 8, this.animated = false})
    : status = StatusType.neutral;

  /// Creates a busy status dot.
  const new busy({super.key, this.size = 8, this.animated = false})
    : status = StatusType.error;

  /// Creates an away status dot.
  const new away({super.key, this.size = 8, this.animated = false})
    : status = StatusType.warning;

  /// Status type determining color.
  final StatusType status;

  /// Size of the dot.
  final double size;

  /// Whether to show pulse animation.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final color = switch (status) {
      StatusType.success => colorScheme.primary,
      StatusType.warning => colorScheme.tertiary,
      StatusType.error => colorScheme.error,
      StatusType.info => colorScheme.secondary,
      StatusType.neutral => colorScheme.outline,
    };

    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    if (!animated) return dot;

    return _PulsingDot(color: color, size: size);
  }
}

/// Status types for status indicators.
enum StatusType {
  /// Success/online status.
  success,

  /// Warning/away status.
  warning,

  /// Error/busy status.
  error,

  /// Informational status.
  info,

  /// Neutral/offline status.
  neutral,
}

class _PulsingDot extends StatefulWidget {
  const new({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value * 0.5),
                blurRadius: widget.size,
                spreadRadius: widget.size * 0.25 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
