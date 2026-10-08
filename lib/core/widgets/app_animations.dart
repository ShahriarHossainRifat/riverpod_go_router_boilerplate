import 'package:flutter/material.dart';

/// Animation utilities and pre-built animation curves/transitions.
abstract class AppAnimations {
  // ─────────────────────────────────────────────────────────────────────────────
  // CURVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Standard easing curve for most animations.
  static const Curve standard = Curves.easeInOut;

  /// Emphasized curve for important transitions.
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Deceleration curve for entering elements.
  static const Curve decelerate = Curves.decelerate;

  /// Acceleration curve for exiting elements.
  static const Curve accelerate = Curves.easeIn;

  /// Bounce curve for playful animations.
  static const Curve bounce = Curves.bounceOut;

  /// Elastic curve for spring-like animations.
  static const Curve elastic = Curves.elasticOut;

  // ─────────────────────────────────────────────────────────────────────────────
  // PAGE TRANSITIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Fade page transition.
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Slide up page transition.
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: standard));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Slide from right page transition.
  static Widget slideRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: standard));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Scale page transition.
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).chain(CurveTween(curve: standard));

    return ScaleTransition(
      scale: animation.drive(tween),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
