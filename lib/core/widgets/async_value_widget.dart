import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// A widget that renders loading, error, or data states
/// for a Riverpod [AsyncValue].
///
/// Simplifies handling common async UI patterns.
class AsyncValueWidget<T> extends StatelessWidget {
  /// Creates an [AsyncValueWidget].
  const new({
    required this.value,
    required this.data,
    super.key,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
  });

  /// The async value to render.
  final AsyncValue<T> value;

  /// Builder for the data state.
  final Widget Function(T data) data;

  /// Optional builder for the loading state.
  final Widget Function()? loading;

  /// Optional builder for the error state.
  final Widget Function(Object error, StackTrace stackTrace)? error;

  /// Whether to skip the loading indicator during refresh.
  final bool skipLoadingOnRefresh;

  /// Whether to skip the loading indicator during reload.
  final bool skipLoadingOnReload;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: loading ?? () => const LoadingWidget(),
      error: error ?? (e, st) => AppErrorWidget.fromError(error: e),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
    );
  }
}

/// A widget that displays a centered loading indicator.
///
/// By default uses a Lottie animation for a polished look.
/// Set [useLottie] to false to use a simple CircularProgressIndicator.
class LoadingWidget extends StatelessWidget {
  /// Creates a [LoadingWidget].
  const new({
    super.key,
    this.size = AppConstants.lottieAnimationSize,
    this.strokeWidth = 3.0,
    this.message,
    this.useLottie = true,
  });

  /// Size of the loading indicator.
  final double size;

  /// Stroke width of the loading indicator (when not using Lottie).
  final double strokeWidth;

  /// Optional message displayed below the indicator.
  final String? message;

  /// Whether to use Lottie animation instead of CircularProgressIndicator.
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (useLottie)
            LottieAnimationWidget(
              assetPath: Assets.loadingAnimation,
              size: size,
              fallback: SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(strokeWidth: strokeWidth),
              ),
            )
          else
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(strokeWidth: strokeWidth),
            ),
          if (message != null) ...[
            const VerticalSpace.md(),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays an error message with an optional retry action.
///
/// Named `AppErrorWidget` to avoid collision with Flutter's built-in `ErrorWidget`.
/// By default uses a Lottie animation for a polished look.
class AppErrorWidget extends StatelessWidget {
  /// Creates an [AppErrorWidget].
  const new({
    required this.message,
    super.key,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.useLottie = true,
    this.animationSize = AppConstants.lottieAnimationSize,
  });

  /// Builds an [AppErrorWidget] from an error object.
  factory fromError({
    required Object error,
    VoidCallback? onRetry,
    bool useLottie = true,
  }) {
    return AppErrorWidget(
      message: error.toString(),
      onRetry: onRetry,
      useLottie: useLottie,
    );
  }

  /// Error message to display.
  final String message;

  /// Optional retry callback.
  final VoidCallback? onRetry;

  /// Icon displayed above the message (when not using Lottie).
  final IconData icon;

  /// Whether to use Lottie animation instead of an icon.
  final bool useLottie;

  /// Size of the animation or icon.
  final double animationSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useLottie)
              LottieAnimationWidget(
                assetPath: Assets.errorAnimation,
                size: animationSize,
                fallback: Icon(
                  icon,
                  size: AppConstants.onboardingIconSize,
                  color: theme.colorScheme.error,
                ),
              )
            else
              Icon(
                icon,
                size: AppConstants.onboardingIconSize,
                color: theme.colorScheme.error,
              ),
            const VerticalSpace.md(),
            Text('Something went wrong', style: theme.textTheme.titleMedium),
            const VerticalSpace.sm(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const VerticalSpace.lg(),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that displays an empty or no-content state.
///
/// By default uses a Lottie animation for a polished look.
class EmptyWidget extends StatelessWidget {
  /// Creates an [EmptyWidget].
  const new({
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
    this.useLottie = true,
    this.animationSize = AppConstants.lottieAnimationSize,
  });

  /// Message describing the empty state.
  final String message;

  /// Icon displayed above the message (when not using Lottie).
  final IconData icon;

  /// Optional action callback.
  final VoidCallback? action;

  /// Label for the optional action button.
  final String? actionLabel;

  /// Whether to use Lottie animation instead of an icon.
  final bool useLottie;

  /// Size of the animation or icon.
  final double animationSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useLottie)
              LottieAnimationWidget(
                assetPath: Assets.emptyAnimation,
                size: animationSize,
                fallback: Icon(
                  icon,
                  size: AppConstants.iconSizeXXL,
                  color: theme.colorScheme.outline,
                ),
              )
            else
              Icon(
                icon,
                size: AppConstants.iconSizeXXL,
                color: theme.colorScheme.outline,
              ),
            const VerticalSpace.md(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null && actionLabel != null) ...[
              const VerticalSpace.lg(),
              AppButton(onPressed: action, label: actionLabel!),
            ],
          ],
        ),
      ),
    );
  }
}
