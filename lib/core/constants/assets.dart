/// Asset paths for images, icons, animations, and other assets.
///
/// Centralizes all asset paths to avoid hardcoding strings
/// and ensure consistency across the app.
///
/// Usage:
/// ```dart
/// Image.asset(Assets.logo);
/// SvgPicture.asset(Assets.icons.home);
/// ```
abstract class Assets {
  // ─────────────────────────────────────────────────────────────────────────────
  // BASE PATHS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Base path for all assets.
  static const String _basePath = 'assets';

  /// Base path for images.
  static const String imagesPath = '$_basePath/images';

  /// Base path for icons.
  static const String iconsPath = '$_basePath/icons';

  /// Base path for animations (Lottie/Rive).
  static const String animationsPath = '$_basePath/animations';

  /// Base path for fonts.
  static const String fontsPath = '$_basePath/fonts';

  // ─────────────────────────────────────────────────────────────────────────────
  // BRANDING
  // ─────────────────────────────────────────────────────────────────────────────

  /// App logo.
  static const String logo = '$imagesPath/logo.png';

  /// App logo (dark mode variant).
  static const String logoDark = '$imagesPath/logo_dark.png';

  /// App icon.
  static const String appIcon = '$imagesPath/app_icon.png';

  /// Splash screen image.
  static const String splash = '$imagesPath/splash.png';

  // ─────────────────────────────────────────────────────────────────────────────
  // PLACEHOLDERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Generic placeholder image.
  static const String placeholder = '$imagesPath/placeholder.png';

  /// Avatar placeholder.
  static const String avatarPlaceholder = '$imagesPath/avatar_placeholder.png';

  /// Image loading placeholder.
  static const String imagePlaceholder = '$imagesPath/image_placeholder.png';

  // ─────────────────────────────────────────────────────────────────────────────
  // ILLUSTRATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Empty state illustration.
  static const String emptyState = '$imagesPath/empty_state.png';

  /// Error state illustration.
  static const String errorState = '$imagesPath/error_state.png';

  /// No connection illustration.
  static const String noConnection = '$imagesPath/no_connection.png';

  /// Success illustration.
  static const String success = '$imagesPath/success.png';

  /// Onboarding illustrations.
  static const onboarding = _OnboardingAssets();

  // ─────────────────────────────────────────────────────────────────────────────
  // ANIMATIONS (LOTTIE)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Loading animation.
  static const String loadingAnimation = '$animationsPath/loading.json';

  /// Success animation.
  static const String successAnimation = '$animationsPath/success.json';

  /// Error animation.
  static const String errorAnimation = '$animationsPath/error.json';

  /// Empty state animation.
  static const String emptyAnimation = '$animationsPath/empty.json';

  /// Confetti animation.
  static const String confettiAnimation = '$animationsPath/confetti.json';
}

/// Onboarding-specific assets.
class _OnboardingAssets {
  const new();

  /// First onboarding page illustration.
  String get page1 => '${Assets.imagesPath}/onboarding_1.png';

  /// Second onboarding page illustration.
  String get page2 => '${Assets.imagesPath}/onboarding_2.png';

  /// Third onboarding page illustration.
  String get page3 => '${Assets.imagesPath}/onboarding_3.png';
}

/// Icon assets (SVG or PNG).
///
/// Usage:
/// ```dart
/// SvgPicture.asset(AppIcons.home);
/// Image.asset(AppIcons.settings);
/// ```
abstract class AppIcons {
  /// Base path for icons.
  static const String _path = Assets.iconsPath;

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Home icon.
  static const String home = '$_path/home.svg';

  /// Search icon.
  static const String search = '$_path/search.svg';

  /// Profile icon.
  static const String profile = '$_path/profile.svg';

  /// Settings icon.
  static const String settings = '$_path/settings.svg';

  /// Menu icon.
  static const String menu = '$_path/menu.svg';

  /// Back icon.
  static const String back = '$_path/back.svg';

  /// Close icon.
  static const String close = '$_path/close.svg';

  // ─────────────────────────────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Add/plus icon.
  static const String add = '$_path/add.svg';

  /// Edit icon.
  static const String edit = '$_path/edit.svg';

  /// Delete icon.
  static const String delete = '$_path/delete.svg';

  /// Share icon.
  static const String share = '$_path/share.svg';

  /// Favorite icon.
  static const String favorite = '$_path/favorite.svg';

  /// Bookmark icon.
  static const String bookmark = '$_path/bookmark.svg';

  /// Download icon.
  static const String download = '$_path/download.svg';

  /// Upload icon.
  static const String upload = '$_path/upload.svg';

  // ─────────────────────────────────────────────────────────────────────────────
  // STATUS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check/success icon.
  static const String check = '$_path/check.svg';

  /// Error icon.
  static const String error = '$_path/error.svg';

  /// Warning icon.
  static const String warning = '$_path/warning.svg';

  /// Info icon.
  static const String info = '$_path/info.svg';

  // ─────────────────────────────────────────────────────────────────────────────
  // SOCIAL
  // ─────────────────────────────────────────────────────────────────────────────

  /// Google icon.
  static const String google = '$_path/google.svg';

  /// Apple icon.
  static const String apple = '$_path/apple.svg';

  /// Facebook icon.
  static const String facebook = '$_path/facebook.svg';

  /// Twitter/X icon.
  static const String twitter = '$_path/twitter.svg';
}
