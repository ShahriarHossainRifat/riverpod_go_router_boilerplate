import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/widgets/feature_showcase.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/widgets/welcome_card.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Home page shown after successful authentication.
class HomePage extends HookConsumerWidget {
  /// Creates a [HomePage] instance.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'home');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          const ConnectivityIndicator(),
          AppIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => context.pushRoute(AppRoute.settings),
          ),
        ],
      ),
      body: AsyncValueWidget<User?>(
        value: authState,
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.noData));
          }
          return _HomeContent(user: user, theme: theme);
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const new({required this.user, required this.theme});

  final User user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // User avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.email.substring(0, 1).toUpperCase(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const VerticalSpace.md(),

            // User info
            Text(
              user.name ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalSpace.sm(),
            Text(
              user.email,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const VerticalSpace.md(),
            // Welcome message
            WelcomeCard(theme: theme),
            const VerticalSpace.md(),

            // Feature showcase demonstrating boilerplate capabilities
            const FeatureShowcase(),
            const VerticalSpace.md(),
            // Logout button
            AppButton(
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.large,
              onPressed: () => _handleLogout(context, ref),
              icon: Icons.logout,
              label: AppLocalizations.of(context).logout,
            ),
            const VerticalSpace.md(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialogs.confirm(
      context,
      title: l10n.logout,
      message: l10n.confirmLogout,
      confirmText: l10n.logout,
      cancelText: l10n.cancel,
    );

    if (confirmed ?? false) {
      try {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.logout();
        // Router will automatically redirect to login when authState becomes null
      } catch (e) {
        if (context.mounted) {
          ref.read(feedbackServiceProvider).showError(l10n.logoutFailed);
        }
      }
    }
  }
}
