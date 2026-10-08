import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/localization/locale_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing onboarding state.
class OnboardingService {
  /// Creates an [OnboardingService] instance.
  new(this._prefs);

  final SharedPreferences _prefs;
  static const _completedKey = 'onboarding_completed';

  /// Check if onboarding has been completed
  bool get isCompleted => _prefs.getBool(_completedKey) ?? false;

  /// Mark onboarding as completed
  Future<void> complete() async {
    await _prefs.setBool(_completedKey, true);
  }

  /// Reset onboarding (for testing)
  Future<void> reset() async {
    await _prefs.remove(_completedKey);
  }
}

/// Provider for onboarding service
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingService(prefs);
});

/// Provider for checking if onboarding is completed
final isOnboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingServiceProvider).isCompleted;
});
