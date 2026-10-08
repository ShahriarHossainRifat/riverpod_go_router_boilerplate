import 'package:flutter/foundation.dart' show immutable;

/// Cache entry with metadata for use in the app layer.
@immutable
class CacheEntry {
  /// Creates a [CacheEntry] instance.
  const new({
    required this.data,
    required this.timestamp,
    required this.expiresAt,
    this.etag,
  });

  /// The cached data (JSON string).
  final String data;

  /// When this entry was cached.
  final DateTime timestamp;

  /// When this entry expires.
  final DateTime expiresAt;

  /// Optional ETag for conditional requests.
  final String? etag;

  /// Whether this cache entry has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Whether this cache entry is still valid.
  bool get isValid => !isExpired;
}

/// Cache statistics.
@immutable
class CacheStats {
  /// Creates a [CacheStats] instance.
  const new({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
  });

  /// Total number of entries in the cache.
  final int totalEntries;

  /// Number of valid (non-expired) entries.
  final int validEntries;

  /// Number of expired entries.
  final int expiredEntries;

  @override
  String toString() {
    return 'CacheStats(total: $totalEntries, valid: $validEntries, '
        'expired: $expiredEntries)';
  }
}
