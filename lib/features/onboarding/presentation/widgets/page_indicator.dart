import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Page indicator dot widget for onboarding carousel.
///
/// Animates between active and inactive states with smooth transitions.
class PageIndicator extends StatelessWidget {
  /// Creates a [PageIndicator] instance.
  const new({required this.isActive, required this.color, super.key});

  /// Whether this indicator is active (current page).
  final bool isActive;

  /// Color of the indicator.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.pageIndicatorAnimation,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      width: isActive
          ? AppConstants.pageIndicatorActiveWidth
          : AppConstants.pageIndicatorInactiveWidth,
      height: AppConstants.pageIndicatorHeight,
      decoration: BoxDecoration(
        color: isActive
            ? color
            : color.withValues(
                alpha: AppConstants.pageIndicatorInactiveOpacity,
              ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
      ),
    );
  }
}
