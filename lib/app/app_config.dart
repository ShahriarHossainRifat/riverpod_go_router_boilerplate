import 'package:riverpod_go_router_boilerplate/config/env_config.dart'
    show EnvConfig;
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart'
    show AppConstants;
import 'package:riverpod_go_router_boilerplate/core/core.dart'
    show AppConstants;

/// Static feature flags and configuration for the app.
///
/// These are compile-time constants that define the app's behavior.
/// Change these once per project - they should not change at runtime.
///
/// For runtime configuration (API keys, URLs), use [EnvConfig] instead.
///
/// Example usage:
/// ```dart
/// if (AppConfig.authEnabled) {
///   // Show login flow
/// }
/// ```
class AppConfig {
  new _();

  /// Whether authentication is enabled for this app.
  ///
  /// When `false`, the app operates in "public mode" without login.
  /// When `true`, users must authenticate to access protected routes.
  static const bool authEnabled = true;

  /// Whether onboarding flow is enabled.
  ///
  /// When `true`, new users see onboarding before main app content.
  /// When `false`, users go directly to login or home.
  static const bool onboardingEnabled = true;

  /// Minimum password length for validation.
  ///
  /// Note: This should match [AppConstants.minPasswordLength] for consistency.
  /// The strong password validator requires 8 characters minimum.
  static const int minPasswordLength = 8;

  /// Session timeout duration.
  ///
  /// After this duration of inactivity, the session may be refreshed
  /// or the user may be asked to re-authenticate.
  static const Duration sessionTimeout = Duration(hours: 24);

  /// Maximum retry attempts for network requests.
  static const int maxNetworkRetries = 3;

  /// Default page size for paginated requests.
  static const int defaultPageSize = 20;
}
