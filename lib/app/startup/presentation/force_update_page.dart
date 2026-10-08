import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/review/in_app_review_service.dart';
import 'package:riverpod_go_router_boilerplate/core/version/app_version_service.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/buttons.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Force update page shown when app version is below minimum required.
///
/// This page blocks all app functionality until the user updates.
/// It displays:
/// - Current vs. minimum required version
/// - A clear call-to-action to open the app store
class ForceUpdatePage extends ConsumerWidget {
  /// Creates a [ForceUpdatePage] widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(versionInfoProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsivePadding(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Spacer(),
              _buildUpdateIcon(context),
              const VerticalSpace.xl(),
              _buildTitle(context),
              const VerticalSpace.md(),
              _buildDescription(context),
              const VerticalSpace.lg(),
              _buildVersionInfo(context, versionAsync),
              const Spacer(),
              _buildUpdateButton(ref),
              const VerticalSpace.md(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the update icon container.
  Widget _buildUpdateIcon(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: .circle,
      ),
      child: Icon(Icons.system_update, size: 64, color: colorScheme.primary),
    );
  }

  /// Builds the title text.
  Widget _buildTitle(BuildContext context) {
    final textTheme = context.textTheme;

    return Text(
      'Update Required',
      style: textTheme.headlineMedium?.copyWith(fontWeight: .bold),
      textAlign: .center,
    );
  }

  /// Builds the description text.
  Widget _buildDescription(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Text(
      'A new version of the app is available. '
      'Please update to continue using the app.',
      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      textAlign: .center,
    );
  }

  /// Builds the version info container.
  Widget _buildVersionInfo(
    BuildContext context,
    AsyncValue<VersionInfo> versionAsync,
  ) {
    return versionAsync.when(
      data: (info) => _VersionInfoContainer(info: info),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  /// Builds the update button.
  Widget _buildUpdateButton(WidgetRef ref) {
    return AppButton(
      size: .large,
      onPressed: () => _openStore(ref),
      icon: Icons.download,
      label: 'Update Now',
    );
  }

  /// Opens the app store listing.
  Future<void> _openStore(WidgetRef ref) async {
    final reviewService = ref.read(inAppReviewServiceProvider);
    await reviewService.openStoreListing();
  }
}

/// Container displaying current and minimum version information.
class _VersionInfoContainer extends StatelessWidget {
  const new({required this.info});

  final VersionInfo info;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      padding: const .symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: .circular(AppConstants.borderRadiusMedium),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(
            'v${info.currentVersion}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
              decoration: .lineThrough,
            ),
          ),
          const HorizontalSpace.sm(),
          Icon(
            Icons.arrow_forward,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const HorizontalSpace.sm(),
          Text(
            'v${info.minimumVersion ?? 'Latest'}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: .bold,
            ),
          ),
        ],
      ),
    );
  }
}
