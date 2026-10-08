// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ফ্লাটার বয়লারপ্লেট';

  @override
  String get welcomeMessage => 'অ্যাপে স্বাগতম!';

  @override
  String get login => 'লগইন';

  @override
  String get logout => 'লগআউট';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get signUp => 'সাইন আপ';

  @override
  String get settings => 'সেটিংস';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get home => 'হোম';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get language => 'ভাষা';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get biometricAuthentication => 'বায়োমেট্রিক প্রমাণীকরণ';

  @override
  String get biometricPromptTitle => 'প্রমাণীকরণ';

  @override
  String get biometricPromptSubtitle => 'চালিয়ে যেতে আপনার পরিচয় যাচাই করুন';

  @override
  String get biometricPromptCancel => 'বাতিল';

  @override
  String get errorGeneric => 'কিছু ভুল হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorNetwork =>
      'নেটওয়ার্ক সমস্যা। অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get errorTimeout => 'সময় শেষ। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorUnauthorized =>
      'সেশন শেষ হয়েছে। অনুগ্রহ করে আবার লগইন করুন।';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get noData => 'কোন তথ্য পাওয়া যায়নি';

  @override
  String get searchHint => 'অনুসন্ধান করুন...';

  @override
  String version(String version) {
    return 'সংস্করণ $version';
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
      other: '$countStringটি আইটেম',
      one: '১টি আইটেম',
      zero: 'কোন আইটেম নেই',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'সর্বশেষ আপডেট: $dateString';
  }

  @override
  String get onboardingTitle1 => 'স্বাগতম';

  @override
  String get onboardingDescription1 =>
      'আমাদের অ্যাপের দারুণ ফিচারগুলো আবিষ্কার করুন এবং শুরু করুন।';

  @override
  String get onboardingTitle2 => 'অন্বেষণ';

  @override
  String get onboardingDescription2 =>
      'আপনার জন্য বিশেষভাবে তৈরি বিভিন্ন কন্টেন্ট ব্রাউজ করুন।';

  @override
  String get onboardingTitle3 => 'শুরু করুন';

  @override
  String get onboardingDescription3 =>
      'আপনার অ্যাকাউন্ট তৈরি করুন এবং যাত্রা শুরু করুন।';

  @override
  String get skip => 'স্কিপ';

  @override
  String get next => 'পরবর্তী';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get offlineModeEnabled => 'অফলাইন মোড সক্রিয়';

  @override
  String get backOnline => 'আপনি আবার অনলাইনে আছেন';

  @override
  String get badgeCount => 'ব্যাজ সংখ্যা';

  @override
  String notificationCountLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countStringটি নোটিফিকেশন',
      one: '১টি নোটিফিকেশন',
      zero: 'কোন নোটিফিকেশন নেই',
    );
    return '$_temp0';
  }

  @override
  String get addOne => '১টি যোগ করুন';

  @override
  String get addFive => '৫টি যোগ করুন';

  @override
  String get clear => 'সাফ করুন';

  @override
  String get badgeCountDescription =>
      'ব্যাজ সংখ্যা পরিচালনা করতে মেনু ট্যাপ করুন। এটি দেখায় কিভাবে অ্যাপ রিস্টার্ট জুড়ে নোটিফিকেশন সংখ্যা ট্র্যাক করতে হয়।';

  @override
  String get badgeIncremented => 'ব্যাজ বৃদ্ধি পেয়েছে';

  @override
  String get badgeCleared => 'ব্যাজ সাফ করা হয়েছে';

  @override
  String notificationsAddedFormat(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countStringটি নোটিফিকেশন যোগ করা হয়েছে';
  }

  @override
  String failedFormat(String error) {
    return 'ব্যর্থ: $error';
  }

  @override
  String get theme => 'থিম';

  @override
  String get packageName => 'প্যাকেজ নাম';

  @override
  String get termsOfService => 'সেবার শর্তাবলী';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get openSourceLicenses => 'ওপেন সোর্স লাইসেন্স';

  @override
  String get chooseTheme => 'থিম নির্বাচন করুন';

  @override
  String get lightMode => 'আলো';

  @override
  String get darkModeOption => 'অন্ধকার';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get signInToContinue => 'চালিয়ে যেতে সাইন ইন করুন';

  @override
  String get notificationsDeepLinking => 'নোটিফিকেশন এবং গভীর লিংকিং';

  @override
  String get sendNotificationInstruction =>
      'একটি নোটিফিকেশন পাঠান যা ট্যাপ করলে সেটিংস এ যাবে।';

  @override
  String get badgeCountUnavailable => 'ব্যাজ সংখ্যা উপলব্ধ নয়';

  @override
  String badgeCountLabel(int count) {
    return 'ব্যাজ সংখ্যা: $count';
  }

  @override
  String get appearance => 'চেহারা';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get legal => 'আইনি';

  @override
  String get versionLabel => 'সংস্করণ';

  @override
  String get chooseLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get english => 'English';

  @override
  String get bengali => 'বাংলা';

  @override
  String get featureShowcase => 'ফিচার শোকেস';

  @override
  String get featureShowcaseDescription =>
      'বয়লারপ্লেটের অন্তর্নির্মিত ইউটিলিটি এবং কম্পোনেন্ট অন্বেষণ করুন।';

  @override
  String get feedbackDemo => 'ফিডব্যাক সার্ভিস';

  @override
  String get feedbackDemoDescription =>
      'বিভিন্ন ধরনের স্ন্যাকবার বার্তা দেখান।';

  @override
  String get success => 'সফল';

  @override
  String get error => 'ত্রুটি';

  @override
  String get info => 'তথ্য';

  @override
  String get dialogDemo => 'ডায়ালগ';

  @override
  String get dialogDemoDescription =>
      'AppDialogs ব্যবহার করে নিশ্চিতকরণ ডায়ালগ দেখান।';

  @override
  String get showDialog => 'ডায়ালগ দেখান';

  @override
  String get navigationDemo => 'টাইপ-সেফ নেভিগেশন';

  @override
  String get navigationDemoDescription =>
      'কম্পাইল-টাইম সেফটির জন্য AppRoute enum ব্যবহার করে নেভিগেট করুন।';

  @override
  String get goToSettings => 'সেটিংসে যান';

  @override
  String get notificationsEnabled => 'নোটিফিকেশন সক্রিয়';

  @override
  String get notificationsEnabledDescription =>
      'এই অ্যাপের জন্য পুশ নোটিফিকেশন সক্রিয় বা নিষ্ক্রিয় করুন।';

  @override
  String get notificationDemo => 'নোটিফিকেশন';

  @override
  String get notificationDemoDescription => 'স্থানীয় নোটিফিকেশন পাঠান।';

  @override
  String get basicNotification => 'নোটিফিকেশন পাঠান';

  @override
  String get confirmLogout => 'আপনি কি সাইন আউট করতে চান?';

  @override
  String get logoutFailed =>
      'সাইন আউট ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get youAreAllSet => 'আপনি সব প্রস্তুত!';

  @override
  String get startBuilding => 'আপনার দুর্দান্ত অ্যাপ তৈরি করুন।';

  @override
  String get notificationTitle => 'হ্যালো!';

  @override
  String get notificationBody => 'এটি বয়লারপ্লেট থেকে একটি মৌলিক নোটিফিকেশন।';

  @override
  String get dialogConfirmTitle => 'পদক্ষেপ নিশ্চিত করুন';

  @override
  String get dialogConfirmMessage =>
      'এটি AppDialogs.confirm() হেল্পার প্রদর্শন করে।';

  @override
  String get dialogConfirmButton => 'বুঝলাম';

  @override
  String get dialogConfirmed => 'ডায়ালগ নিশ্চিত করা হয়েছে!';

  @override
  String get emailRequired => 'ইমেইল প্রয়োজন';

  @override
  String get emailInvalid => 'অনুগ্রহ করে একটি বৈধ ইমেইল প্রবেশ করুন';

  @override
  String get passwordRequired => 'পাসওয়ার্ড প্রয়োজন';

  @override
  String get passwordWeak =>
      'পাসওয়ার্ড ৮+ অক্ষরের সাথে বড় অক্ষর, ছোট অক্ষর, সংখ্যা এবং বিশেষ অক্ষর থাকতে হবে';

  @override
  String get onboardingWelcomeTitle => 'স্বাগতম';

  @override
  String get onboardingWelcomeDescription =>
      'ফ্লাটার বয়লারপ্লেটে স্বাগতম। আপনার পরবর্তী অ্যাপের জন্য একটি প্রোডাকশন-রেডি টেমপ্লেট।';

  @override
  String get onboardingArchitectureTitle => 'আধুনিক আর্কিটেকচার';

  @override
  String get onboardingArchitectureDescription =>
      'রিভারপড, গোরাউটার এবং ক্লিন আর্কিটেকচার নীতি দিয়ে তৈরি।';

  @override
  String get onboardingReadyTitle => 'পাঠানোর জন্য প্রস্তুত';

  @override
  String get onboardingReadyDescription =>
      'আপনার অ্যাপ দ্রুত তৈরি এবং পাঠানোর জন্য আপনার প্রয়োজনীয় সবকিছু।';

  @override
  String get onboardingSkip => 'স্কিপ';

  @override
  String get onboardingBack => 'পূর্ববর্তী';

  @override
  String get onboardingNext => 'পরবর্তী';

  @override
  String get onboardingGetStarted => 'শুরু করুন';

  @override
  String get notificationsEnabledFeedback => 'নোটিফিকেশন সক্রিয় করা হয়েছে';

  @override
  String get notificationsDisabledFeedback =>
      'নোটিফিকেশন নিষ্ক্রিয় করা হয়েছে';
}
