import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_database.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_entry.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

export 'cache_entry.dart';
export 'cache_extensions.dart';

part 'cache_service.g.dart';

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
@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return CacheService(
    database: ref.watch(cacheDatabaseProvider),
    logger: ref.read(loggerProvider),
  );
}

/// Default box name for general caching.
const String defaultCacheBoxName = 'app_cache';

/// Box name for API response caching.
const String apiCacheBoxName = 'api_cache';

/// Box name for image URL caching.
const String imageCacheBoxName = 'image_cache';

/// Drift-based caching service for offline-first support.
class CacheService {
  /// Creates a [CacheService] instance.
  new({required this.database, required this.logger});

  /// Drift database instance.
  final CacheDatabase database;

  /// Logger for cache operations
  final AppLogger logger;

  /// Store data in the cache with expiration.
  ///
  /// [key] - Unique identifier for this cache entry.
  /// [data] - The data to cache (should be a JSON string).
  /// [duration] - How long until this entry expires.
  /// [etag] - Optional ETag for conditional HTTP requests.
  /// [boxName] - The box to store in (defaults to 'app_cache').
  Future<void> put(
    String key,
    String data, {
    Duration duration = AppConstants.cacheExpiry,
    String? etag,
    String boxName = defaultCacheBoxName,
  }) async {
    try {
      final now = DateTime.now();

      await database.upsertEntry(
        CacheEntriesCompanion(
          key: Value(key),
          data: Value(data),
          timestamp: Value(now),
          expiresAt: Value(now.add(duration)),
          etag: Value(etag),
          boxName: Value(boxName),
        ),
      );

      logger.d('Cached: $key (expires in ${duration.inMinutes} minutes)');
    } catch (e, stack) {
      logger.e('Cache put error', error: e, stackTrace: stack);
    }
  }

  /// Get a cached entry.
  ///
  /// Returns null if the entry doesn't exist.
  /// Returns the entry even if expired (check [CacheEntry.isValid]).
  Future<CacheEntry?> get(
    String key, {
    String boxName = defaultCacheBoxName,
  }) async {
    try {
      final data = await database.getEntry(key, boxName: boxName);
      if (data == null) return null;
      return _fromData(data);
    } catch (e, stack) {
      logger.e('Cache get error', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Get cached data if valid (not expired).
  ///
  /// Returns null if entry doesn't exist or has expired.
  Future<String?> getIfValid(
    String key, {
    String boxName = defaultCacheBoxName,
  }) async {
    try {
      final data = await database.getValidEntry(key, boxName: boxName);
      return data?.data;
    } catch (e, stack) {
      logger.e('Cache getIfValid error', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Get the ETag for a cached entry.
  ///
  /// Useful for conditional requests (If-None-Match header).
  Future<String?> getEtag(
    String key, {
    String boxName = defaultCacheBoxName,
  }) async {
    final entry = await get(key, boxName: boxName);
    return entry?.etag;
  }

  /// Check if a cache entry exists and is valid.
  Future<bool> hasValid(
    String key, {
    String boxName = defaultCacheBoxName,
  }) async {
    final data = await database.getValidEntry(key, boxName: boxName);
    return data != null;
  }

  /// Delete a cache entry.
  Future<void> delete(
    String key, {
    String boxName = defaultCacheBoxName,
  }) async {
    try {
      await database.deleteEntry(key, boxName: boxName);
      logger.d('Cache deleted: $key');
    } catch (e, stack) {
      logger.e('Cache delete error', error: e, stackTrace: stack);
    }
  }

  /// Clear all entries in a box.
  Future<void> clearBox(String boxName) async {
    try {
      await database.clearBox(boxName);
      logger.d('Cache box cleared: $boxName');
    } catch (e, stack) {
      logger.e('Cache clear error', error: e, stackTrace: stack);
    }
  }

  /// Clear all cache entries.
  Future<void> clearAll() async {
    try {
      await database.clearAll();
      logger.i('All cache cleared');
    } catch (e, stack) {
      logger.e('Cache clear all error', error: e, stackTrace: stack);
    }
  }

  /// Remove all expired entries.
  ///
  /// Call periodically to free up storage.
  Future<int> cleanExpired({String? boxName}) async {
    try {
      final deleted = await database.deleteExpired(boxName: boxName);
      logger.d(
        'Cleaned $deleted expired entries${boxName != null ? ' from $boxName' : ''}',
      );
      return deleted;
    } catch (e, stack) {
      logger.e('Cache cleanup error', error: e, stackTrace: stack);
      return 0;
    }
  }

  /// Get cache statistics.
  Future<CacheStats> getStats({String? boxName}) async {
    try {
      final total = await database.countEntries(boxName: boxName);
      final valid = await database.countValidEntries(boxName: boxName);

      return CacheStats(
        totalEntries: total,
        validEntries: valid,
        expiredEntries: total - valid,
      );
    } catch (e) {
      return const CacheStats(
        totalEntries: 0,
        validEntries: 0,
        expiredEntries: 0,
      );
    }
  }

  /// Get all keys in a box.
  Future<List<String>> getKeys({String boxName = defaultCacheBoxName}) async {
    return database.getKeys(boxName: boxName);
  }

  /// Create CacheEntry from database row.
  CacheEntry _fromData(CacheEntryData data) {
    return CacheEntry(
      data: data.data,
      timestamp: data.timestamp,
      expiresAt: data.expiresAt,
      etag: data.etag,
    );
  }
}
