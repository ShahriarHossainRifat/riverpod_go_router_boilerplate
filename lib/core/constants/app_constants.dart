/// Application-wide constants for durations, timeouts, dimensions, and validation.
///
/// Use these constants instead of magic numbers throughout the app.
///
/// Usage:
/// ```dart
/// AnimatedContainer(
///   duration: AppConstants.animationNormal,
///   ...
/// )
/// ```
abstract class AppConstants {
  // ─────────────────────────────────────────────────────────────────────────────
  // ANIMATION DURATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Fast animation duration (150ms) - quick transitions, micro-interactions.
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Normal animation duration (300ms) - standard animations.
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animation duration (500ms) - emphasized animations.
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Page indicator animation duration (200ms) - carousel indicators.
  static const Duration pageIndicatorAnimation = Duration(milliseconds: 200);

  /// Stagger delay between list items (50ms).
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Typewriter effect character delay (50ms).
  static const Duration typewriterCharDelay = Duration(milliseconds: 50);

  /// Counter animation duration (800ms).
  static const Duration counterAnimation = Duration(milliseconds: 800);

  /// Flip animation duration (400ms).
  static const Duration flipAnimation = Duration(milliseconds: 400);

  /// Bounce animation duration (600ms).
  static const Duration bounceAnimation = Duration(milliseconds: 600);

  /// Expand/collapse animation duration (250ms).
  static const Duration expandAnimation = Duration(milliseconds: 250);

  /// Shake animation duration (500ms).
  static const Duration shakeAnimation = Duration(milliseconds: 500);

  /// Pulse animation duration (1000ms).
  static const Duration pulseAnimation = Duration(milliseconds: 1000);

  /// Cursor blink animation duration (500ms).
  static const Duration cursorBlinkAnimation = Duration(milliseconds: 500);

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK TIMEOUTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Connection timeout for HTTP requests.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout for HTTP requests.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout for HTTP requests.
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Maximum number of retry attempts for failed requests.
  static const int maxRetryAttempts = 3;

  /// Delays between retry attempts (exponential backoff).
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

  // ─────────────────────────────────────────────────────────────────────────────
  // CACHE TIMEOUTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Default cache expiry duration (24 hours).
  static const Duration cacheExpiry = Duration(hours: 24);

  /// Cache expiry for short-lived data (5 minutes) - e.g., search results.
  static const Duration cacheExpiryShort = Duration(minutes: 5);

  /// Cache expiry for long-lived data (7 days) - e.g., static content.
  static const Duration cacheExpiryLong = Duration(days: 7);

  // ─────────────────────────────────────────────────────────────────────────────
  // UI TIMEOUTS & DELAYS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Debounce delay for user input (500ms).
  static const Duration debounceDelay = Duration(milliseconds: 500);

  /// Throttle delay for actions (300ms).
  static const Duration throttleDelay = Duration(milliseconds: 300);

  /// Splash screen minimum duration.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Snackbar default duration.
  static const Duration snackbarDuration = Duration(seconds: 3);

  /// Tooltip display duration.
  static const Duration tooltipDuration = Duration(seconds: 2);

  // ─────────────────────────────────────────────────────────────────────────────
  // MOCK/TEST DELAYS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Mock repository quick delay (200ms) - for operations like logout.
  static const Duration mockQuickDelay = Duration(milliseconds: 200);

  /// Mock repository network delay (500ms) - simulates typical network latency.
  static const Duration mockNetworkDelay = Duration(milliseconds: 500);

  /// Mock repository slow network delay (2s) - simulates slow network conditions.
  static const Duration mockSlowNetworkDelay = Duration(seconds: 2);

  // ─────────────────────────────────────────────────────────────────────────────
  // PAGINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Default number of items per page for paginated requests.
  static const int defaultPageSize = 20;

  /// Maximum number of items per page allowed.
  static const int maxPageSize = 100;

  /// Infinite scroll threshold (pixels from bottom to trigger load).
  static const double infiniteScrollThreshold = 200;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - BORDER RADIUS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Extra small border radius (2px) - very subtle rounding.
  static const double borderRadiusXS = 2;

  /// Small border radius (4px) - subtle corners.
  static const double borderRadiusSM = 4;

  /// Medium border radius (8px) - standard corners.
  static const double borderRadiusMD = 8;

  /// Large border radius (12px) - prominent corners.
  static const double borderRadiusLG = 12;

  /// Extra large border radius (16px) - very rounded corners.
  static const double borderRadiusXL = 16;

  /// Extra extra large border radius (24px) - pill-like corners.
  static const double borderRadiusXXL = 24;

  /// Full/circular border radius.
  static const double borderRadiusFull = 9999;

  // Legacy aliases for backward compatibility
  /// @deprecated Use [borderRadiusSM] instead.
  static const double borderRadiusSmall = borderRadiusSM;

  /// @deprecated Use [borderRadiusMD] instead.
  static const double borderRadiusMedium = borderRadiusMD;

  /// @deprecated Use [borderRadiusLG] instead.
  static const double borderRadiusLarge = borderRadiusLG;

  /// @deprecated Use [borderRadiusXL] instead.
  static const double borderRadiusXLarge = borderRadiusXL;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - ICON SIZES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Extra small icon size (12px).
  static const double iconSizeXS = 12;

  /// Small icon size (16px).
  static const double iconSizeSM = 16;

  /// Medium icon size (24px) - default.
  static const double iconSizeMD = 24;

  /// Large icon size (32px).
  static const double iconSizeLG = 32;

  /// Extra large icon size (48px).
  static const double iconSizeXL = 48;

  /// Extra extra large icon size (80px) - large placeholders.
  static const double iconSizeXXL = 80;

  /// Default Lottie animation size (120px).
  static const double lottieAnimationSize = 120;

  /// Dialog icon size (48px).
  static const double dialogIconSize = 48;

  /// Onboarding icon size (64px).
  static const double onboardingIconSize = 64;

  /// Onboarding icon container size (120x120px).
  static const double onboardingIconContainerSize = 120;

  /// Onboarding icon background opacity (0.1).
  static const double onboardingIconBackgroundOpacity = 0.1;

  /// Page indicator active width (24px).
  static const double pageIndicatorActiveWidth = 24;

  /// Page indicator inactive width (8px).
  static const double pageIndicatorInactiveWidth = 8;

  /// Page indicator height (8px).
  static const double pageIndicatorHeight = 8;

  /// Page indicator opacity when inactive (0.3).
  static const double pageIndicatorInactiveOpacity = 0.3;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - ANIMATION VALUES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Default slide offset for slide animations (0.3 = 30% of widget size).
  static const double slideOffsetDefault = 0.3;

  /// Default scale start value for scale-in animations.
  static const double scaleInStart = 0;

  /// Bounce scale minimum (0.95).
  static const double bounceScaleMin = 0.95;

  /// Bounce scale maximum (1.05).
  static const double bounceScaleMax = 1.05;

  /// Flip card perspective value.
  static const double flipPerspective = 0.001;

  /// Pulse scale minimum (0.95).
  static const double pulseScaleMin = 0.95;

  /// Pulse scale maximum (1.0).
  static const double pulseScaleMax = 1;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - SHIMMER DEFAULTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shimmer line default height (16px).
  static const double shimmerLineHeight = 16;

  /// Shimmer circle default size (48px).
  static const double shimmerCircleSize = 48;

  /// Shimmer title line height (14px).
  static const double shimmerTitleHeight = 14;

  /// Shimmer subtitle line height (12px).
  static const double shimmerSubtitleHeight = 12;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - CONNECTIVITY BANNER
  // ─────────────────────────────────────────────────────────────────────────────

  /// Connectivity banner icon size (18px).
  static const double connectivityIconSize = 18;

  /// Connectivity banner font size (13px).
  static const double connectivityFontSize = 13;

  /// Chip icon size (18px).
  static const double chipIconSize = 18;

  // Legacy aliases
  /// @deprecated Use [iconSizeSM] instead.
  static const double iconSizeSmall = iconSizeSM;

  /// @deprecated Use [iconSizeMD] instead.
  static const double iconSizeMedium = iconSizeMD;

  /// @deprecated Use [iconSizeLG] instead.
  static const double iconSizeLarge = iconSizeLG;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - COMPONENT HEIGHTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Small button height (36px).
  static const double buttonHeightSM = 36;

  /// Standard button height (48px).
  static const double buttonHeight = 48;

  /// Large button height (56px).
  static const double buttonHeightLG = 56;

  /// Standard input field height (56px).
  static const double inputHeight = 56;

  /// Standard app bar height (56px).
  static const double appBarHeight = 56;

  /// Bottom navigation bar height (64px).
  static const double bottomNavHeight = 64;

  /// Tab bar height (48px).
  static const double tabBarHeight = 48;

  /// List tile height (56px).
  static const double listTileHeight = 56;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS - LAYOUT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Maximum content width for large screens (600px).
  static const double maxContentWidth = 600;

  /// Maximum width for tablets (900px).
  static const double maxTabletWidth = 900;

  /// Maximum width for desktop (1200px).
  static const double maxDesktopWidth = 1200;

  /// Minimum touch target size (48px) - accessibility requirement.
  static const double minTouchTarget = 48;

  // ─────────────────────────────────────────────────────────────────────────────
  // VALIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Minimum password length.
  static const int minPasswordLength = 8;

  /// Maximum password length.
  static const int maxPasswordLength = 128;

  /// Minimum username length.
  static const int minUsernameLength = 3;

  /// Maximum username length.
  static const int maxUsernameLength = 30;

  /// Maximum bio/description length.
  static const int maxBioLength = 500;

  /// Maximum file size in bytes (10MB).
  static const int maxFileSize = 10 * 1024 * 1024;

  /// Maximum image dimension (for upload).
  static const int maxImageDimension = 2048;

  // ─────────────────────────────────────────────────────────────────────────────
  // REGEX PATTERNS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Email validation pattern.
  static final RegExp emailPattern = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Phone number validation pattern (international format).
  static final RegExp phonePattern = RegExp(r'^\+?[\d\s-]{10,}$');

  /// URL validation pattern.
  static final RegExp urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  /// Username validation pattern (alphanumeric, underscore, hyphen).
  static final RegExp usernamePattern = RegExp(r'^[a-zA-Z0-9_-]+$');

  /// Strong password pattern (min 8 chars, 1 upper, 1 lower, 1 digit, 1 special).
  static final RegExp strongPasswordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
}
