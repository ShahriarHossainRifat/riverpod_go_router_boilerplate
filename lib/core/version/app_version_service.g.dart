// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for [AppVersionService].

@ProviderFor(appVersionService)
final appVersionServiceProvider = AppVersionServiceProvider._();

/// Provider for [AppVersionService].

final class AppVersionServiceProvider
    extends
        $FunctionalProvider<
          AppVersionService,
          AppVersionService,
          AppVersionService
        >
    with $Provider<AppVersionService> {
  /// Provider for [AppVersionService].
  AppVersionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionServiceHash();

  @$internal
  @override
  $ProviderElement<AppVersionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppVersionService create(Ref ref) {
    return appVersionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppVersionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppVersionService>(value),
    );
  }
}

String _$appVersionServiceHash() => r'a535545b88ffcfc3c6c86ba3686da568bb4cb451';

/// Provider for the current [VersionInfo].
///
/// Watch this to reactively respond to version check results.

@ProviderFor(versionInfo)
final versionInfoProvider = VersionInfoProvider._();

/// Provider for the current [VersionInfo].
///
/// Watch this to reactively respond to version check results.

final class VersionInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<VersionInfo>,
          VersionInfo,
          FutureOr<VersionInfo>
        >
    with $FutureModifier<VersionInfo>, $FutureProvider<VersionInfo> {
  /// Provider for the current [VersionInfo].
  ///
  /// Watch this to reactively respond to version check results.
  VersionInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionInfoHash();

  @$internal
  @override
  $FutureProviderElement<VersionInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VersionInfo> create(Ref ref) {
    return versionInfo(ref);
  }
}

String _$versionInfoHash() => r'4c282cec117c7be9857b10c161044dc4f5e69533';

/// Provider that indicates if a force update is required.

@ProviderFor(requiresForceUpdate)
final requiresForceUpdateProvider = RequiresForceUpdateProvider._();

/// Provider that indicates if a force update is required.

final class RequiresForceUpdateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that indicates if a force update is required.
  RequiresForceUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requiresForceUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requiresForceUpdateHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return requiresForceUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$requiresForceUpdateHash() =>
    r'55d3e5989f63900fe3d2d5e42703f604d71ad21c';
