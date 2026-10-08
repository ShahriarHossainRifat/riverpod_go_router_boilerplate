// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing the app's locale.
///
/// Persists the user's language preference to SharedPreferences.
/// Falls back to the device locale if supported, otherwise defaults to English.
///
/// Usage:
/// ```dart
/// // Get current locale
/// final locale = ref.watch(localeNotifierProvider);
///
/// // Change locale
/// ref.read(localeNotifierProvider.notifier).setLocale(const Locale('es'));
///
/// // Reset to system locale
/// ref.read(localeNotifierProvider.notifier).resetToSystemLocale();
/// ```

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Provider for managing the app's locale.
///
/// Persists the user's language preference to SharedPreferences.
/// Falls back to the device locale if supported, otherwise defaults to English.
///
/// Usage:
/// ```dart
/// // Get current locale
/// final locale = ref.watch(localeNotifierProvider);
///
/// // Change locale
/// ref.read(localeNotifierProvider.notifier).setLocale(const Locale('es'));
///
/// // Reset to system locale
/// ref.read(localeNotifierProvider.notifier).resetToSystemLocale();
/// ```
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale?> {
  /// Provider for managing the app's locale.
  ///
  /// Persists the user's language preference to SharedPreferences.
  /// Falls back to the device locale if supported, otherwise defaults to English.
  ///
  /// Usage:
  /// ```dart
  /// // Get current locale
  /// final locale = ref.watch(localeNotifierProvider);
  ///
  /// // Change locale
  /// ref.read(localeNotifierProvider.notifier).setLocale(const Locale('es'));
  ///
  /// // Reset to system locale
  /// ref.read(localeNotifierProvider.notifier).resetToSystemLocale();
  /// ```
  LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeNotifierHash() => r'2cb148f7a410c86a502b62ada61c996d407a852c';

/// Provider for managing the app's locale.
///
/// Persists the user's language preference to SharedPreferences.
/// Falls back to the device locale if supported, otherwise defaults to English.
///
/// Usage:
/// ```dart
/// // Get current locale
/// final locale = ref.watch(localeNotifierProvider);
///
/// // Change locale
/// ref.read(localeNotifierProvider.notifier).setLocale(const Locale('es'));
///
/// // Reset to system locale
/// ref.read(localeNotifierProvider.notifier).resetToSystemLocale();
/// ```

abstract class _$LocaleNotifier extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
