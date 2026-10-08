import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// A reusable widget for displaying Lottie animations with fallback support.
///
/// Provides a clean API for showing Lottie animations with graceful fallback
/// when the animation fails to load.
///
/// Usage:
/// ```dart
/// LottieAnimationWidget(
///   assetPath: Assets.loadingAnimation,
///   size: 120,
///   fallback: CircularProgressIndicator(),
/// )
/// ```
class LottieAnimationWidget extends StatelessWidget {
  /// Creates a [LottieAnimationWidget].
  const new({
    required this.assetPath,
    required this.fallback,
    this.size = AppConstants.lottieAnimationSize,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.animate = true,
    super.key,
  });

  /// Path to the Lottie animation asset.
  final String assetPath;

  /// Size of the animation (width and height).
  final double size;

  /// How to fit the animation within the box.
  final BoxFit fit;

  /// Whether to repeat the animation.
  final bool repeat;

  /// Whether to reverse the animation after completing.
  final bool reverse;

  /// Whether to automatically animate or start in paused state.
  final bool animate;

  /// Widget to display if animation fails to load.
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      animate: animate,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}
