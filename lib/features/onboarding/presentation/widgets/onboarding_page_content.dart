import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Data model for onboarding page content.
class OnboardingPageData {
  /// Creates an [OnboardingPageData] instance.
  const new({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });

  /// Title of the onboarding page (already localized).
  final String title;

  /// Description of the onboarding page (already localized).
  final String description;

  /// Icon representing the onboarding page.
  final IconData icon;

  /// Optional color for the icon background.
  final Color? color;
}

/// Displays content for a single onboarding page.
class OnboardingPageContent extends StatelessWidget {
  /// Creates an [OnboardingPageContent] instance.
  const new({required this.page, super.key});

  /// The page data to display.
  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsivePadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppConstants.onboardingIconContainerSize,
            height: AppConstants.onboardingIconContainerSize,
            decoration: BoxDecoration(
              color: (page.color ?? theme.colorScheme.primary).withValues(
                alpha: AppConstants.onboardingIconBackgroundOpacity,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusXXL),
            ),
            child: Icon(
              page.icon,
              size: AppConstants.onboardingIconSize,
              color: page.color ?? theme.colorScheme.primary,
            ),
          ),
          const VerticalSpace.lg(),
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalSpace.md(),
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
