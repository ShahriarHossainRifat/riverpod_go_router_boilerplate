// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get welcomeMessage => 'Welcome to the app!';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get home => 'Home';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get biometricAuthentication => 'Biometric Authentication';

  @override
  String get biometricPromptTitle => 'Authenticate';

  @override
  String get biometricPromptSubtitle => 'Verify your identity to continue';

  @override
  String get biometricPromptCancel => 'Cancel';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorUnauthorized => 'Session expired. Please login again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get searchHint => 'Search...';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String itemCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Last updated: $dateString';
  }

  @override
  String get onboardingTitle1 => 'Welcome';

  @override
  String get onboardingDescription1 =>
      'Discover amazing features and get started with our app.';

  @override
  String get onboardingTitle2 => 'Explore';

  @override
  String get onboardingDescription2 =>
      'Browse through a wide variety of content tailored for you.';

  @override
  String get onboardingTitle3 => 'Get Started';

  @override
  String get onboardingDescription3 =>
      'Create your account and start your journey.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get offlineModeEnabled => 'Offline mode enabled';

  @override
  String get backOnline => 'You\'re back online';

  @override
  String get badgeCount => 'Badge Count';

  @override
  String notificationCountLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString notifications',
      one: '1 notification',
      zero: 'No notifications',
    );
    return '$_temp0';
  }

  @override
  String get addOne => 'Add 1';

  @override
  String get addFive => 'Add 5';

  @override
  String get clear => 'Clear';

  @override
  String get badgeCountDescription =>
      'Tap the menu to manage badge count. This demonstrates how to track notification count across app restarts.';

  @override
  String get badgeIncremented => 'Badge incremented';

  @override
  String get badgeCleared => 'Badge cleared';

  @override
  String notificationsAddedFormat(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'Added $countString notifications';
  }

  @override
  String failedFormat(String error) {
    return 'Failed: $error';
  }

  @override
  String get theme => 'Theme';

  @override
  String get packageName => 'Package Name';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get lightMode => 'Light';

  @override
  String get darkModeOption => 'Dark';

  @override
  String get systemDefault => 'System default';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get notificationsDeepLinking => 'Notifications & Deep Linking';

  @override
  String get sendNotificationInstruction =>
      'Send a notification that routes to Settings when tapped.';

  @override
  String get badgeCountUnavailable => 'Badge count unavailable';

  @override
  String badgeCountLabel(int count) {
    return 'Badge Count: $count';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get about => 'About';

  @override
  String get legal => 'Legal';

  @override
  String get versionLabel => 'Version';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get english => 'English';

  @override
  String get bengali => 'Bengali (বাংলা)';

  @override
  String get featureShowcase => 'Feature Showcase';

  @override
  String get featureShowcaseDescription =>
      'Explore the boilerplate\'s built-in utilities and components.';

  @override
  String get feedbackDemo => 'Feedback Service';

  @override
  String get feedbackDemoDescription =>
      'Show different types of snackbar messages.';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get info => 'Info';

  @override
  String get dialogDemo => 'Dialogs';

  @override
  String get dialogDemoDescription =>
      'Show confirmation dialogs using AppDialogs.';

  @override
  String get showDialog => 'Show Dialog';

  @override
  String get navigationDemo => 'Type-Safe Navigation';

  @override
  String get navigationDemoDescription =>
      'Navigate using AppRoute enum for compile-time safety.';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get notificationsEnabled => 'Notifications Enabled';

  @override
  String get notificationsEnabledDescription =>
      'Enable or disable push notifications for this app.';

  @override
  String get notificationDemo => 'Notifications';

  @override
  String get notificationDemoDescription =>
      'Send local notifications with scheduling support.';

  @override
  String get basicNotification => 'Send Notification';

  @override
  String get confirmLogout => 'Are you sure you want to sign out?';

  @override
  String get logoutFailed => 'Failed to sign out. Please try again.';

  @override
  String get youAreAllSet => 'You\'re all set!';

  @override
  String get startBuilding => 'Start building your amazing app.';

  @override
  String get notificationTitle => 'Hello!';

  @override
  String get notificationBody =>
      'This is a basic notification from the boilerplate.';

  @override
  String get dialogConfirmTitle => 'Confirm Action';

  @override
  String get dialogConfirmMessage =>
      'This demonstrates the AppDialogs.confirm() helper.';

  @override
  String get dialogConfirmButton => 'Got it';

  @override
  String get dialogConfirmed => 'Dialog confirmed!';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordWeak =>
      'Password must be 8+ chars with uppercase, lowercase, number & special char';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeDescription =>
      'Welcome to Flutter Boilerplate. A production-ready template for your next app.';

  @override
  String get onboardingArchitectureTitle => 'Modern Architecture';

  @override
  String get onboardingArchitectureDescription =>
      'Built with Riverpod, GoRouter, and clean architecture principles.';

  @override
  String get onboardingReadyTitle => 'Ready to Ship';

  @override
  String get onboardingReadyDescription =>
      'Everything you need to build and ship your app faster.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get notificationsEnabledFeedback => 'Notifications enabled';

  @override
  String get notificationsDisabledFeedback => 'Notifications disabled';
}
