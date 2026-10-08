import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/data/onboarding_service.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/presentation/widgets/onboarding_page_content.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Onboarding pages - customize these for your app
List<OnboardingPageData> _buildPages(AppLocalizations l10n) => [
  OnboardingPageData(
    title: l10n.onboardingWelcomeTitle,
    description: l10n.onboardingWelcomeDescription,
    icon: Icons.flutter_dash,
  ),
  OnboardingPageData(
    title: l10n.onboardingArchitectureTitle,
    description: l10n.onboardingArchitectureDescription,
    icon: Icons.architecture,
  ),
  OnboardingPageData(
    title: l10n.onboardingReadyTitle,
    description: l10n.onboardingReadyDescription,
    icon: Icons.rocket_launch,
  ),
];

/// Onboarding page shown to first-time users.
///
/// Demonstrates animation widgets including `FadeIn`, `SlideIn`, and
/// page transitions.
class OnboardingPage extends HookConsumerWidget {
  /// Creates an [OnboardingPage] instance.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);
    final pages = _buildPages(l10n);

    // Track screen view once on mount
    useOnMount(() {
      ref
          .read(analyticsServiceProvider)
          .logScreenView(screenName: 'onboarding');
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button with fade animation
            FadeIn(
              child: Align(
                alignment: Alignment.topRight,
                child: AppButton(
                  variant: .text,
                  onPressed: () => _completeOnboarding(context, ref),
                  label: l10n.onboardingSkip,
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return OnboardingPageContent(page: page);
                },
              ),
            ),

            // Page indicators with animation
            FadeIn(
              delay: AppConstants.staggerDelay * 4,
              child: ResponsivePadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => PageIndicator(
                      isActive: index == currentPage.value,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons with slide animation
            SlideIn(
              delay: AppConstants.staggerDelay * 6,
              child: ResponsivePadding(
                child: AnimatedSize(
                  duration: AppConstants.animationNormal,
                  curve: Curves.easeInOut,
                  child: Row(
                    children: [
                      // Back button with animated width transition
                      AnimatedSwitcher(
                        duration: AppConstants.animationNormal,
                        transitionBuilder: (child, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: currentPage.value > 0
                            ? Row(
                                key: const ValueKey('back-button'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width:
                                        (context.screenWidth -
                                            AppSpacing.lg * 2 -
                                            AppSpacing.md) /
                                        2,
                                    child: AppButton(
                                      variant: .secondary,
                                      label: l10n.onboardingBack,
                                      onPressed: () {
                                        pageController.previousPage(
                                          duration:
                                              AppConstants.animationNormal,
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                  const HorizontalSpace.md(),
                                ],
                              )
                            : const SizedBox.shrink(
                                key: ValueKey('no-back-button'),
                              ),
                      ),
                      // Next/Get Started button
                      Expanded(
                        child: AppButton(
                          label: currentPage.value == pages.length - 1
                              ? l10n.onboardingGetStarted
                              : l10n.onboardingNext,
                          onPressed: () {
                            if (currentPage.value == pages.length - 1) {
                              _completeOnboarding(context, ref);
                            } else {
                              pageController.nextPage(
                                duration: AppConstants.animationNormal,
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Mark onboarding as completed
    final onboardingService = ref.read(onboardingServiceProvider);
    await onboardingService.complete();

    // Track onboarding completion event
    ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.login);

    // Notify lifecycle notifier
    final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
    await lifecycleNotifier.onOnboardingCompleted();

    // Navigate to next screen based on current startup state
    if (context.mounted) {
      final currentState = ref.read(currentStartupStateProvider);
      final route = StartupRouteMapper.map(currentState);
      context.go(route);
    }
  }
}
