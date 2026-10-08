import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A widget that fades in when first built.
class FadeIn extends StatefulWidget {
  /// Creates a [FadeIn] widget.
  const new({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
  });

  /// Creates a [FadeIn] with staggered delay based on index.
  ///
  /// Useful for list items with automatic delay calculation:
  /// ```dart
  /// ListView.builder(
  ///   itemBuilder: (context, index) => FadeIn.staggered(
  ///     index: index,
  ///     child: ListTile(...),
  ///   ),
  /// )
  /// ```
  factory staggered({
    required Widget child,
    required int index,
    Key? key,
    Duration duration = AppConstants.animationNormal,
    Duration baseDelay = AppConstants.staggerDelay,
    Curve curve = Curves.easeOut,
  }) {
    return FadeIn(
      key: key,
      duration: duration,
      delay: baseDelay * index,
      curve: curve,
      child: child,
    );
  }

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// A widget that slides in when first built.
class SlideIn extends StatefulWidget {
  /// Creates a [SlideIn] widget.
  const new({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.direction = SlideDirection.fromBottom,
    this.offset = AppConstants.slideOffsetDefault,
  });

  /// Creates a [SlideIn] with staggered delay based on index.
  ///
  /// Useful for list items with automatic delay calculation:
  /// ```dart
  /// ListView.builder(
  ///   itemBuilder: (context, index) => SlideIn.staggered(
  ///     index: index,
  ///     child: ListTile(...),
  ///   ),
  /// )
  /// ```
  factory staggered({
    required Widget child,
    required int index,
    Key? key,
    Duration duration = AppConstants.animationNormal,
    Duration baseDelay = AppConstants.staggerDelay,
    Curve curve = Curves.easeOut,
    SlideDirection direction = SlideDirection.fromLeft,
    double offset = AppConstants.slideOffsetDefault,
  }) {
    return SlideIn(
      key: key,
      duration: duration,
      delay: baseDelay * index,
      curve: curve,
      direction: direction,
      offset: offset,
      child: child,
    );
  }

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  /// Direction to slide from.
  final SlideDirection direction;

  /// Initial offset multiplier.
  final double offset;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    final begin = switch (widget.direction) {
      SlideDirection.fromLeft => Offset(-widget.offset, 0),
      SlideDirection.fromRight => Offset(widget.offset, 0),
      SlideDirection.fromTop => Offset(0, -widget.offset),
      SlideDirection.fromBottom => Offset(0, widget.offset),
    };

    _animation = Tween(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}

/// Direction for slide animations.
enum SlideDirection {
  /// Slide from left.
  fromLeft,

  /// Slide from right.
  fromRight,

  /// Slide from top.
  fromTop,

  /// Slide from bottom.
  fromBottom,
}

/// A widget that scales in when first built.
class ScaleIn extends StatefulWidget {
  /// Creates a [ScaleIn] widget.
  const new({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.begin = AppConstants.scaleInStart,
    this.alignment = Alignment.center,
  });

  /// Creates a [ScaleIn] with staggered delay based on index.
  factory staggered({
    required Widget child,
    required int index,
    Key? key,
    Duration duration = AppConstants.animationNormal,
    Duration baseDelay = AppConstants.staggerDelay,
    Curve curve = Curves.easeOut,
    double begin = AppConstants.scaleInStart,
    Alignment alignment = Alignment.center,
  }) {
    return ScaleIn(
      key: key,
      duration: duration,
      delay: baseDelay * index,
      curve: curve,
      begin: begin,
      alignment: alignment,
      child: child,
    );
  }

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  /// Initial scale value.
  final double begin;

  /// Alignment for scale transform.
  final Alignment alignment;

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.begin,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
