// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the default error converter.

@ProviderFor(errorConverter)
final errorConverterProvider = ErrorConverterProvider._();

/// Provider for the default error converter.

final class ErrorConverterProvider
    extends $FunctionalProvider<ErrorConverter, ErrorConverter, ErrorConverter>
    with $Provider<ErrorConverter> {
  /// Provider for the default error converter.
  ErrorConverterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorConverterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorConverterHash();

  @$internal
  @override
  $ProviderElement<ErrorConverter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorConverter create(Ref ref) {
    return errorConverter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorConverter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorConverter>(value),
    );
  }
}

String _$errorConverterHash() => r'2c0467c2201d612815cf84a8fc4afbcde529f635';

/// Provider for the API client.

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// Provider for the API client.

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// Provider for the API client.
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'dfd2c33e9d04443e755c1f585e0d18cd0a5eb28f';
