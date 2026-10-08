import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';

part 'in_app_review_service.g.dart';

/// Keys for storing review-related data.
abstract class ReviewStorageKeys {
  /// Key for storing the positive actions count.
  static const String positiveActionsCount = 'review_positive_actions';

  /// Key for storing whether review was requested.
  static const String hasRequestedReview = 'review_requested';

  /// Key for storing the last review request date.
  static const String lastReviewRequestDate = 'review_last_request_date';

  /// Key for storing app launch count.
  static const String appLaunchCount = 'review_launch_count';
}

/// Configuration for when to request reviews.
class ReviewConfig {
  /// Creates a [ReviewConfig] instance.
  const new({
    this.minPositiveActions = 5,
    this.minLaunches = 3,
    this.daysBetweenRequests = 30,
    this.maxRequestsPerVersion = 1,
  });

  /// Minimum positive actions before requesting review.
  final int minPositiveActions;

  /// Minimum app launches before requesting review.
  final int minLaunches;

  /// Minimum days between review requests.
  final int daysBetweenRequests;

  /// Maximum review requests per app version.
  final int maxRequestsPerVersion;
}

/// Service for managing in-app reviews with smart prompting logic.
///
/// This service tracks positive user actions and only prompts for review
/// when the user has had enough good experiences with the app.
///
/// Example:
/// ```dart
/// // After a successful action (like completing a purchase)
/// final reviewService = ref.read(inAppReviewServiceProvider);
/// await reviewService.recordPositiveAction();
///
/// // This will only show the review prompt if conditions are met
/// await reviewService.requestReviewIfEligible();
///
/// // Or check eligibility manually
/// if (await reviewService.isEligibleForReview()) {
///   // Maybe show a custom pre-prompt dialog
/// }
/// ```
class InAppReviewService {
  /// Creates an [InAppReviewService] instance.
  new(this._ref, {this.config = const ReviewConfig()});

  final Ref _ref;

  /// Configuration for review prompting logic.
  final ReviewConfig config;

  FlutterSecureStorage get _storage => _ref.read(secureStorageProvider);

  /// Record a positive user action (e.g., successful purchase, task completed).
  ///
  /// Call this after users complete meaningful actions in your app.
  Future<void> recordPositiveAction() async {
    final current = await _getPositiveActionsCount();
    await _storage.write(
      key: ReviewStorageKeys.positiveActionsCount,
      value: (current + 1).toString(),
    );
  }

  /// Record an app launch.
  ///
  /// Call this in your app startup sequence.
  Future<void> recordAppLaunch() async {
    final current = await _getLaunchCount();
    await _storage.write(
      key: ReviewStorageKeys.appLaunchCount,
      value: (current + 1).toString(),
    );
  }

  /// Check if the app is eligible for requesting a review.
  Future<bool> isEligibleForReview() async {
    final inAppReview = InAppReview.instance;

    // Check if the platform supports in-app review
    if (!await inAppReview.isAvailable()) {
      return false;
    }

    // Check positive actions threshold
    final positiveActions = await _getPositiveActionsCount();
    if (positiveActions < config.minPositiveActions) {
      return false;
    }

    // Check launch count threshold
    final launchCount = await _getLaunchCount();
    if (launchCount < config.minLaunches) {
      return false;
    }

    // Check if enough time has passed since last request
    final lastRequest = await _getLastReviewRequestDate();
    if (lastRequest != null) {
      final daysSinceLastRequest = DateTime.now()
          .difference(lastRequest)
          .inDays;
      if (daysSinceLastRequest < config.daysBetweenRequests) {
        return false;
      }
    }

    return true;
  }

  /// Request a review if the user is eligible.
  ///
  /// Returns true if the review dialog was shown, false otherwise.
  /// Note: On iOS, the system controls when to actually show the dialog,
  /// so this may return true even if the dialog wasn't displayed.
  Future<bool> requestReviewIfEligible() async {
    if (!await isEligibleForReview()) {
      return false;
    }

    return requestReview();
  }

  /// Force request a review regardless of eligibility.
  ///
  /// Use sparingly - the app stores may limit or penalize apps
  /// that request reviews too frequently.
  Future<bool> requestReview() async {
    final inAppReview = InAppReview.instance;

    if (!await inAppReview.isAvailable()) {
      return false;
    }

    await inAppReview.requestReview();

    // Record that we requested a review
    await _storage.write(
      key: ReviewStorageKeys.hasRequestedReview,
      value: 'true',
    );
    await _storage.write(
      key: ReviewStorageKeys.lastReviewRequestDate,
      value: DateTime.now().toIso8601String(),
    );

    // Reset positive actions count after requesting
    await _storage.delete(key: ReviewStorageKeys.positiveActionsCount);

    return true;
  }

  /// Open the app store page for manual review.
  ///
  /// Use this as a fallback or for "Rate Us" buttons in settings.
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    final inAppReview = InAppReview.instance;
    await inAppReview.openStoreListing(
      appStoreId: appStoreId,
      microsoftStoreId: microsoftStoreId,
    );
  }

  /// Reset all review tracking data.
  ///
  /// Useful for testing or when you want to re-prompt users.
  Future<void> resetReviewData() async {
    await _storage.delete(key: ReviewStorageKeys.positiveActionsCount);
    await _storage.delete(key: ReviewStorageKeys.hasRequestedReview);
    await _storage.delete(key: ReviewStorageKeys.lastReviewRequestDate);
    await _storage.delete(key: ReviewStorageKeys.appLaunchCount);
  }

  Future<int> _getPositiveActionsCount() async {
    final value = await _storage.read(
      key: ReviewStorageKeys.positiveActionsCount,
    );
    return int.tryParse(value ?? '') ?? 0;
  }

  Future<int> _getLaunchCount() async {
    final value = await _storage.read(key: ReviewStorageKeys.appLaunchCount);
    return int.tryParse(value ?? '') ?? 0;
  }

  Future<DateTime?> _getLastReviewRequestDate() async {
    final value = await _storage.read(
      key: ReviewStorageKeys.lastReviewRequestDate,
    );
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}

/// Provider for [InAppReviewService].
@Riverpod(keepAlive: true)
InAppReviewService inAppReviewService(Ref ref) {
  return InAppReviewService(ref);
}
