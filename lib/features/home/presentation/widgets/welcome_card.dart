import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Welcome card displayed on the home page.
///
/// Shows a success message with a welcome icon to greet the user
/// after successful authentication. Demonstrates `ScaleIn` and `FadeIn`
/// animation widgets.
class WelcomeCard extends StatelessWidget {
  /// Creates a [WelcomeCard] instance.
  const new({required this.theme, super.key});

  /// The theme data for styling.
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FadeIn(
      child: Card(
        child: ResponsivePadding(
          child: Column(
            children: [
              ScaleIn(
                delay: AppConstants.animationFast,
                child: Bounce(
                  delay: AppConstants.animationNormal,
                  child: LottieAnimationWidget(
                    repeat: false,
                    assetPath: Assets.successAnimation,
                    fallback: Icon(
                      Icons.check_circle,
                      size: AppConstants.iconSizeXL,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const VerticalSpace.md(),
              SlideIn(
                delay: AppConstants.staggerDelay * 4,
                child: Text(
                  l10n.youAreAllSet,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const VerticalSpace.sm(),
              FadeIn(
                delay: AppConstants.staggerDelay * 6,
                child: Text(
                  l10n.startBuilding,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
