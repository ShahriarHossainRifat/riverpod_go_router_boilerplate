// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// ignore_for_file: type=lint
class $CacheEntriesTable extends CacheEntries
    with TableInfo<$CacheEntriesTable, CacheEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _boxNameMeta = const VerificationMeta(
    'boxName',
  );
  @override
  late final GeneratedColumn<String> boxName = GeneratedColumn<String>(
    'box_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    data,
    timestamp,
    expiresAt,
    etag,
    boxName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('box_name')) {
      context.handle(
        _boxNameMeta,
        boxName.isAcceptableOrUnknown(data['box_name']!, _boxNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, boxName};
  @override
  CacheEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheEntryData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      boxName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}box_name'],
      )!,
    );
  }

  @override
  $CacheEntriesTable createAlias(String alias) {
    return $CacheEntriesTable(attachedDatabase, alias);
  }
}

class CacheEntryData extends DataClass implements Insertable<CacheEntryData> {
  /// Unique cache key (e.g., "GET:/api/users?page=1").
  final String key;

  /// The cached data (JSON string).
  final String data;

  /// When this entry was cached.
  final DateTime timestamp;

  /// When this entry expires.
  final DateTime expiresAt;

  /// Optional ETag for conditional requests.
  final String? etag;

  /// Box/category name for organization (e.g., "api_cache", "user_cache").
  final String boxName;
  const CacheEntryData({
    required this.key,
    required this.data,
    required this.timestamp,
    required this.expiresAt,
    this.etag,
    required this.boxName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['data'] = Variable<String>(data);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    map['box_name'] = Variable<String>(boxName);
    return map;
  }

  CacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CacheEntriesCompanion(
      key: Value(key),
      data: Value(data),
      timestamp: Value(timestamp),
      expiresAt: Value(expiresAt),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      boxName: Value(boxName),
    );
  }

  factory CacheEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheEntryData(
      key: serializer.fromJson<String>(json['key']),
      data: serializer.fromJson<String>(json['data']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      etag: serializer.fromJson<String?>(json['etag']),
      boxName: serializer.fromJson<String>(json['boxName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'data': serializer.toJson<String>(data),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'etag': serializer.toJson<String?>(etag),
      'boxName': serializer.toJson<String>(boxName),
    };
  }

  CacheEntryData copyWith({
    String? key,
    String? data,
    DateTime? timestamp,
    DateTime? expiresAt,
    Value<String?> etag = const Value.absent(),
    String? boxName,
  }) => CacheEntryData(
    key: key ?? this.key,
    data: data ?? this.data,
    timestamp: timestamp ?? this.timestamp,
    expiresAt: expiresAt ?? this.expiresAt,
    etag: etag.present ? etag.value : this.etag,
    boxName: boxName ?? this.boxName,
  );
  CacheEntryData copyWithCompanion(CacheEntriesCompanion data) {
    return CacheEntryData(
      key: data.key.present ? data.key.value : this.key,
      data: data.data.present ? data.data.value : this.data,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      etag: data.etag.present ? data.etag.value : this.etag,
      boxName: data.boxName.present ? data.boxName.value : this.boxName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntryData(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('timestamp: $timestamp, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('etag: $etag, ')
          ..write('boxName: $boxName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, data, timestamp, expiresAt, etag, boxName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheEntryData &&
          other.key == this.key &&
          other.data == this.data &&
          other.timestamp == this.timestamp &&
          other.expiresAt == this.expiresAt &&
          other.etag == this.etag &&
          other.boxName == this.boxName);
}

class CacheEntriesCompanion extends UpdateCompanion<CacheEntryData> {
  final Value<String> key;
  final Value<String> data;
  final Value<DateTime> timestamp;
  final Value<DateTime> expiresAt;
  final Value<String?> etag;
  final Value<String> boxName;
  final Value<int> rowid;
  const CacheEntriesCompanion({
    this.key = const Value.absent(),
    this.data = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.etag = const Value.absent(),
    this.boxName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheEntriesCompanion.insert({
    required String key,
    required String data,
    required DateTime timestamp,
    required DateTime expiresAt,
    this.etag = const Value.absent(),
    this.boxName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       data = Value(data),
       timestamp = Value(timestamp),
       expiresAt = Value(expiresAt);
  static Insertable<CacheEntryData> custom({
    Expression<String>? key,
    Expression<String>? data,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? expiresAt,
    Expression<String>? etag,
    Expression<String>? boxName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (data != null) 'data': data,
      if (timestamp != null) 'timestamp': timestamp,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (etag != null) 'etag': etag,
      if (boxName != null) 'box_name': boxName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? data,
    Value<DateTime>? timestamp,
    Value<DateTime>? expiresAt,
    Value<String?>? etag,
    Value<String>? boxName,
    Value<int>? rowid,
  }) {
    return CacheEntriesCompanion(
      key: key ?? this.key,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      expiresAt: expiresAt ?? this.expiresAt,
      etag: etag ?? this.etag,
      boxName: boxName ?? this.boxName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (boxName.present) {
      map['box_name'] = Variable<String>(boxName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntriesCompanion(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('timestamp: $timestamp, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('etag: $etag, ')
          ..write('boxName: $boxName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(e);
  $CacheDatabaseManager get managers => $CacheDatabaseManager(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheEntries];
}

typedef $$CacheEntriesTableCreateCompanionBuilder =
    CacheEntriesCompanion Function({
      required String key,
      required String data,
      required DateTime timestamp,
      required DateTime expiresAt,
      Value<String?> etag,
      Value<String> boxName,
      Value<int> rowid,
    });
typedef $$CacheEntriesTableUpdateCompanionBuilder =
    CacheEntriesCompanion Function({
      Value<String> key,
      Value<String> data,
      Value<DateTime> timestamp,
      Value<DateTime> expiresAt,
      Value<String?> etag,
      Value<String> boxName,
      Value<int> rowid,
    });

class $$CacheEntriesTableFilterComposer
    extends Composer<_$CacheDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boxName => $composableBuilder(
    column: $table.boxName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheEntriesTableOrderingComposer
    extends Composer<_$CacheDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boxName => $composableBuilder(
    column: $table.boxName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheEntriesTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get boxName =>
      $composableBuilder(column: $table.boxName, builder: (column) => column);
}

class $$CacheEntriesTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CacheEntriesTable,
          CacheEntryData,
          $$CacheEntriesTableFilterComposer,
          $$CacheEntriesTableOrderingComposer,
          $$CacheEntriesTableAnnotationComposer,
          $$CacheEntriesTableCreateCompanionBuilder,
          $$CacheEntriesTableUpdateCompanionBuilder,
          (
            CacheEntryData,
            BaseReferences<_$CacheDatabase, $CacheEntriesTable, CacheEntryData>,
          ),
          CacheEntryData,
          PrefetchHooks Function()
        > {
  $$CacheEntriesTableTableManager(_$CacheDatabase db, $CacheEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String> boxName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion(
                key: key,
                data: data,
                timestamp: timestamp,
                expiresAt: expiresAt,
                etag: etag,
                boxName: boxName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String data,
                required DateTime timestamp,
                required DateTime expiresAt,
                Value<String?> etag = const Value.absent(),
                Value<String> boxName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion.insert(
                key: key,
                data: data,
                timestamp: timestamp,
                expiresAt: expiresAt,
                etag: etag,
                boxName: boxName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CacheEntriesTable, CacheEntryData>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CacheEntriesTable,
                    CacheEntryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CacheEntriesTable,
      CacheEntryData,
      $$CacheEntriesTableFilterComposer,
      $$CacheEntriesTableOrderingComposer,
      $$CacheEntriesTableAnnotationComposer,
      $$CacheEntriesTableCreateCompanionBuilder,
      $$CacheEntriesTableUpdateCompanionBuilder,
      (
        CacheEntryData,
        BaseReferences<_$CacheDatabase, $CacheEntriesTable, CacheEntryData>,
      ),
      CacheEntryData,
      PrefetchHooks Function()
    >;

class $CacheDatabaseManager {
  final _$CacheDatabase _db;
  $CacheDatabaseManager(this._db);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the cache database.
///
/// This should be initialized once at app startup.

@ProviderFor(cacheDatabase)
final cacheDatabaseProvider = CacheDatabaseProvider._();

/// Provider for the cache database.
///
/// This should be initialized once at app startup.

final class CacheDatabaseProvider
    extends $FunctionalProvider<CacheDatabase, CacheDatabase, CacheDatabase>
    with $Provider<CacheDatabase> {
  /// Provider for the cache database.
  ///
  /// This should be initialized once at app startup.
  CacheDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheDatabaseHash();

  @$internal
  @override
  $ProviderElement<CacheDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheDatabase create(Ref ref) {
    return cacheDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheDatabase>(value),
    );
  }
}

String _$cacheDatabaseHash() => r'ac1691586b869171dbd6c7d7338d4059d52e747c';
