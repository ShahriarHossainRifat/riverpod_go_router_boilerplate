import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that flips between front and back faces with a 3D animation.
///
/// Great for reveal cards, settings toggles, or any interactive element
/// that has two states to show.
///
/// Example:
/// ```dart
/// FlipCard(
///   front: CardFront(),
///   back: CardBack(),
///   onFlip: (isFront) => print('Is showing front: $isFront'),
/// )
/// ```
class FlipCard extends StatefulWidget {
  /// Creates a [FlipCard] widget.
  const new({
    required this.front,
    required this.back,
    super.key,
    this.duration = AppConstants.flipAnimation,
    this.direction = .horizontal,
    this.onFlip,
    this.controller,
    this.flipOnTap = true,
  });

  /// Widget to show on the front face.
  final Widget front;

  /// Widget to show on the back face.
  final Widget back;

  /// Duration of the flip animation.
  final Duration duration;

  /// Direction of the flip.
  final FlipDirection direction;

  /// Callback when flip completes.
  final ValueChanged<bool>? onFlip;

  /// Optional controller for programmatic control.
  final FlipCardController? controller;

  /// Whether tapping the card triggers a flip.
  final bool flipOnTap;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    widget.controller?._attach(this);
  }

  void flip() {
    if (_controller.isAnimating) return;

    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
    widget.onFlip?.call(_showFront);
  }

  void flipToFront() {
    if (!_showFront) flip();
  }

  void flipToBack() {
    if (_showFront) flip();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flipOnTap ? flip : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, AppConstants.flipPerspective);

          if (widget.direction == FlipDirection.horizontal) {
            transform.rotateY(angle);
          } else {
            transform.rotateX(angle);
          }

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _animation.value < 0.5
                ? widget.front
                : Transform(
                    transform: Matrix4.identity()
                      ..rotateY(widget.direction == .horizontal ? math.pi : 0)
                      ..rotateX(widget.direction == .vertical ? math.pi : 0),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}

/// Controller for [FlipCard].
class FlipCardController {
  _FlipCardState? _state;

  void _attach(_FlipCardState state) {
    _state = state;
  }

  /// Flips the card to the opposite side.
  void flip() => _state?.flip();

  /// Flips the card to show the front face.
  void flipToFront() => _state?.flipToFront();

  /// Flips the card to show the back face.
  void flipToBack() => _state?.flipToBack();
}

/// Direction for flip animations.
enum FlipDirection {
  /// Flip horizontally (around Y axis).
  horizontal,

  /// Flip vertically (around X axis).
  vertical,
}
