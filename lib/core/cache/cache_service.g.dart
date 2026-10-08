// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Offline-first caching service using Drift (SQLite).
///
/// ## Features:
/// - Key-value storage with automatic expiration
/// - Type-safe SQL queries via Drift
/// - ETags for conditional requests
/// - Box-based organization (separate caches for different data types)
/// - Efficient expired entry cleanup
///
/// ## Usage:
///
/// ```dart
/// final cache = ref.read(cacheServiceProvider);
///
/// // Cache API response
/// await cache.put(
///   'users_list',
///   jsonEncode(usersList),
///   duration: const Duration(minutes: 30),
///   etag: response.headers['etag'],
/// );
///
/// // Get cached data
/// final entry = await cache.get('users_list');
/// if (entry != null && entry.isValid) {
///   final users = jsonDecode(entry.data);
///   // Use cached data
/// }
///
/// // Use specific box for organization
/// await cache.put('user_123', jsonEncode(user), boxName: 'users');
/// final user = await cache.get('user_123', boxName: 'users');
/// ```

@ProviderFor(cacheService)
final cacheServiceProvider = CacheServiceProvider._();

/// Offline-first caching service using Drift (SQLite).
///
/// ## Features:
/// - Key-value storage with automatic expiration
/// - Type-safe SQL queries via Drift
/// - ETags for conditional requests
/// - Box-based organization (separate caches for different data types)
/// - Efficient expired entry cleanup
///
/// ## Usage:
///
/// ```dart
/// final cache = ref.read(cacheServiceProvider);
///
/// // Cache API response
/// await cache.put(
///   'users_list',
///   jsonEncode(usersList),
///   duration: const Duration(minutes: 30),
///   etag: response.headers['etag'],
/// );
///
/// // Get cached data
/// final entry = await cache.get('users_list');
/// if (entry != null && entry.isValid) {
///   final users = jsonDecode(entry.data);
///   // Use cached data
/// }
///
/// // Use specific box for organization
/// await cache.put('user_123', jsonEncode(user), boxName: 'users');
/// final user = await cache.get('user_123', boxName: 'users');
/// ```

final class CacheServiceProvider
    extends $FunctionalProvider<CacheService, CacheService, CacheService>
    with $Provider<CacheService> {
  /// Offline-first caching service using Drift (SQLite).
  ///
  /// ## Features:
  /// - Key-value storage with automatic expiration
  /// - Type-safe SQL queries via Drift
  /// - ETags for conditional requests
  /// - Box-based organization (separate caches for different data types)
  /// - Efficient expired entry cleanup
  ///
  /// ## Usage:
  ///
  /// ```dart
  /// final cache = ref.read(cacheServiceProvider);
  ///
  /// // Cache API response
  /// await cache.put(
  ///   'users_list',
  ///   jsonEncode(usersList),
  ///   duration: const Duration(minutes: 30),
  ///   etag: response.headers['etag'],
  /// );
  ///
  /// // Get cached data
  /// final entry = await cache.get('users_list');
  /// if (entry != null && entry.isValid) {
  ///   final users = jsonDecode(entry.data);
  ///   // Use cached data
  /// }
  ///
  /// // Use specific box for organization
  /// await cache.put('user_123', jsonEncode(user), boxName: 'users');
  /// final user = await cache.get('user_123', boxName: 'users');
  /// ```
  CacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheServiceHash();

  @$internal
  @override
  $ProviderElement<CacheService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheService create(Ref ref) {
    return cacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheService>(value),
    );
  }
}

String _$cacheServiceHash() => r'50d7df127020e189b3cbaaa7eb9527bd416e4761';
