import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/async_value_widget.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Splash page shown during app initialization.
///
/// Handles app startup lifecycle:
/// - Initializes the app lifecycle notifier
/// - Resolves startup state (auth, maintenance, onboarding, etc.)
/// - Routes to appropriate page based on startup state
class SplashPage extends ConsumerStatefulWidget {
  /// Creates the [SplashPage] widget.
  const new({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app lifecycle and navigate to appropriate route.
  Future<void> _initializeApp() async {
    try {
      // Initialize the app lifecycle (resolves startup state)
      final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
      await lifecycleNotifier.initialize();

      // Minimum splash screen visibility duration
      await Future<void>.delayed(AppConstants.splashDuration);

      if (mounted) {
        _navigateToInitialRoute();
      }
    } catch (e) {
      // Handle initialization errors - log and proceed
      if (mounted) {
        _navigateToInitialRoute();
      }
    }
  }

  /// Navigate to the appropriate route based on startup state.
  void _navigateToInitialRoute() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final lifecycleState = ref.read(appLifecycleNotifierProvider);
    final route = StartupRouteMapper.map(lifecycleState.currentState);

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            _buildLogoContainer(context),
            const VerticalSpace.xl(),
            _buildAppName(context),
            const VerticalSpace.xxl(),
            const _LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  /// Builds the app logo container.
  Widget _buildLogoContainer(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: .circular(AppConstants.borderRadiusMedium),
      ),
      child: Icon(Icons.flutter_dash, size: 64, color: colorScheme.primary),
    );
  }

  /// Builds the app name text.
  Widget _buildAppName(BuildContext context) {
    final textTheme = context.textTheme;

    return Text(
      'Flutter Boilerplate',
      style: textTheme.headlineSmall?.copyWith(fontWeight: .bold),
    );
  }
}

/// Loading indicator shown during app initialization.
class _LoadingIndicator extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const LoadingWidget();
  }
}
