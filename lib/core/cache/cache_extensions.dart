import 'dart:convert';

import 'package:riverpod_go_router_boilerplate/core/cache/cache_service.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// Extension for convenient caching of typed objects.
extension CacheServiceExtensions on CacheService {
  /// Cache a JSON-serializable object.
  Future<void> putObject<T>(
    String key,
    T object,
    Map<String, dynamic> Function(T) toJson, {
    Duration duration = AppConstants.cacheExpiry,
    String? etag,
    String boxName = defaultCacheBoxName,
  }) async {
    final json = jsonEncode(toJson(object));
    await put(key, json, duration: duration, etag: etag, boxName: boxName);
  }

  /// Get a cached object with type conversion.
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson, {
    String boxName = defaultCacheBoxName,
  }) async {
    final data = await getIfValid(key, boxName: boxName);
    if (data == null) return null;

    try {
      return fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Cache a list of JSON-serializable objects.
  Future<void> putList<T>(
    String key,
    List<T> list,
    Map<String, dynamic> Function(T) toJson, {
    Duration duration = AppConstants.cacheExpiry,
    String? etag,
    String boxName = defaultCacheBoxName,
  }) async {
    final json = jsonEncode(list.map(toJson).toList());
    await put(key, json, duration: duration, etag: etag, boxName: boxName);
  }

  /// Get a cached list with type conversion.
  Future<List<T>?> getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson, {
    String boxName = defaultCacheBoxName,
  }) async {
    final data = await getIfValid(key, boxName: boxName);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }
}
