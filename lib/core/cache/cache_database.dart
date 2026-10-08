import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_database.g.dart';

/// Table for storing cached API responses and data.
@DataClassName('CacheEntryData')
class CacheEntries extends Table {
  /// Unique cache key (e.g., "GET:/api/users?page=1").
  TextColumn get key => text()();

  /// The cached data (JSON string).
  TextColumn get data => text()();

  /// When this entry was cached.
  DateTimeColumn get timestamp => dateTime()();

  /// When this entry expires.
  DateTimeColumn get expiresAt => dateTime()();

  /// Optional ETag for conditional requests.
  TextColumn get etag => text().nullable()();

  /// Box/category name for organization (e.g., "api_cache", "user_cache").
  TextColumn get boxName => text().withDefault(const Constant('default'))();

  @override
  Set<Column<Object>> get primaryKey => {key, boxName};
}

/// Drift database for offline caching.
@DriftDatabase(tables: [CacheEntries])
class CacheDatabase extends _$CacheDatabase {
  /// Default constructor that opens the database connection.
  new() : super(_openConnection());

  /// Constructor for testing with a custom executor.
  new forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Handle future migrations here
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CRUD Operations
  // ─────────────────────────────────────────────────────────────────────────────

  /// Insert or update a cache entry.
  Future<void> upsertEntry(CacheEntriesCompanion entry) async {
    await into(cacheEntries).insertOnConflictUpdate(entry);
  }

  /// Get a cache entry by key and box name.
  Future<CacheEntryData?> getEntry(
    String key, {
    String boxName = 'default',
  }) async {
    return (select(cacheEntries)
          ..where((t) => t.key.equals(key) & t.boxName.equals(boxName)))
        .getSingleOrNull();
  }

  /// Get a valid (non-expired) cache entry.
  Future<CacheEntryData?> getValidEntry(
    String key, {
    String boxName = 'default',
  }) async {
    final now = DateTime.now();
    return (select(cacheEntries)..where(
          (t) =>
              t.key.equals(key) &
              t.boxName.equals(boxName) &
              t.expiresAt.isBiggerThanValue(now),
        ))
        .getSingleOrNull();
  }

  /// Delete a cache entry.
  Future<int> deleteEntry(String key, {String boxName = 'default'}) async {
    return (delete(
      cacheEntries,
    )..where((t) => t.key.equals(key) & t.boxName.equals(boxName))).go();
  }

  /// Delete all entries in a box.
  Future<int> clearBox(String boxName) async {
    return (delete(cacheEntries)..where((t) => t.boxName.equals(boxName))).go();
  }

  /// Delete all cache entries.
  Future<int> clearAll() async {
    return delete(cacheEntries).go();
  }

  /// Delete all expired entries.
  Future<int> deleteExpired({String? boxName}) async {
    final now = DateTime.now();
    final query = delete(cacheEntries)
      ..where((t) {
        if (boxName != null) {
          return t.expiresAt.isSmallerThanValue(now) &
              t.boxName.equals(boxName);
        }
        return t.expiresAt.isSmallerThanValue(now);
      });
    return query.go();
  }

  /// Count entries in a box.
  Future<int> countEntries({String? boxName}) async {
    final query = selectOnly(cacheEntries)
      ..addColumns([cacheEntries.key.count()]);
    if (boxName != null) {
      query.where(cacheEntries.boxName.equals(boxName));
    }
    final result = await query.getSingle();
    return result.read(cacheEntries.key.count()) ?? 0;
  }

  /// Count valid (non-expired) entries in a box.
  Future<int> countValidEntries({String? boxName}) async {
    final now = DateTime.now();
    final query = selectOnly(cacheEntries)
      ..addColumns([cacheEntries.key.count()]);
    if (boxName != null) {
      query.where(
        cacheEntries.boxName.equals(boxName) &
            cacheEntries.expiresAt.isBiggerThanValue(now),
      );
    } else {
      query.where(cacheEntries.expiresAt.isBiggerThanValue(now));
    }
    final result = await query.getSingle();
    return result.read(cacheEntries.key.count()) ?? 0;
  }

  /// Get all keys in a box.
  Future<List<String>> getKeys({String boxName = 'default'}) async {
    final query = selectOnly(cacheEntries)
      ..addColumns([cacheEntries.key])
      ..where(cacheEntries.boxName.equals(boxName));
    final results = await query.get();
    return results
        .map((row) => row.read(cacheEntries.key))
        .whereType<String>()
        .toList();
  }
}

/// Open the SQLite database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cache.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Provider for the cache database.
///
/// This should be initialized once at app startup.
@Riverpod(keepAlive: true)
CacheDatabase cacheDatabase(Ref ref) {
  final db = CacheDatabase();
  ref.onDispose(db.close);
  return db;
}
