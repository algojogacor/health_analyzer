// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class HealthRecords extends Table with TableInfo<HealthRecords, HealthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HealthRecords(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _dataTypeMeta = const VerificationMeta(
    'dataType',
  );
  late final GeneratedColumn<String> dataType = GeneratedColumn<String>(
    'data_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dateFromMeta = const VerificationMeta(
    'dateFrom',
  );
  late final GeneratedColumn<DateTime> dateFrom = GeneratedColumn<DateTime>(
    'date_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  late final GeneratedColumn<DateTime> dateTo = GeneratedColumn<DateTime>(
    'date_to',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'pending\'',
    defaultValue: const CustomExpression('\'pending\''),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dataType,
    value,
    unit,
    dateFrom,
    dateTo,
    sourceName,
    sourceId,
    syncStatus,
    metadata,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_type')) {
      context.handle(
        _dataTypeMeta,
        dataType.isAcceptableOrUnknown(data['data_type']!, _dataTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dataTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(
        _dateFromMeta,
        dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(
        _dateToMeta,
        dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta),
      );
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecord(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      dataType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data_type'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}value'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      dateFrom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date_from'],
          )!,
      dateTo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date_to'],
          )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  HealthRecords createAlias(String alias) {
    return HealthRecords(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HealthRecord extends DataClass implements Insertable<HealthRecord> {
  final int id;

  /// Data type: HEART_RATE, SPO2, STEPS, SLEEP_DEEP, SLEEP_LIGHT, SLEEP_REM,
  ///            SLEEP_AWAKE, CALORIES, STRESS, DISTANCE
  final String dataType;

  /// Numeric value for most types. For sleep, this is duration in minutes
  final double value;

  /// Unit: BPM, PERCENT, COUNT, MINUTES, KCAL, METERS
  final String unit;

  /// Time range
  final DateTime dateFrom;
  final DateTime dateTo;

  /// Source info
  final String? sourceName;
  final String? sourceId;

  /// Sync status: 'pending', 'synced', 'failed'
  final String syncStatus;

  /// Metadata JSON (extra fields like sleep stage details)
  final String? metadata;

  /// Timestamps
  final DateTime createdAt;
  final DateTime? syncedAt;
  const HealthRecord({
    required this.id,
    required this.dataType,
    required this.value,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
    this.sourceName,
    this.sourceId,
    required this.syncStatus,
    this.metadata,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_type'] = Variable<String>(dataType);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['date_from'] = Variable<DateTime>(dateFrom);
    map['date_to'] = Variable<DateTime>(dateTo);
    if (!nullToAbsent || sourceName != null) {
      map['source_name'] = Variable<String>(sourceName);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  HealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordsCompanion(
      id: Value(id),
      dataType: Value(dataType),
      value: Value(value),
      unit: Value(unit),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
      sourceName:
          sourceName == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceName),
      sourceId:
          sourceId == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceId),
      syncStatus: Value(syncStatus),
      metadata:
          metadata == null && nullToAbsent
              ? const Value.absent()
              : Value(metadata),
      createdAt: Value(createdAt),
      syncedAt:
          syncedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(syncedAt),
    );
  }

  factory HealthRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecord(
      id: serializer.fromJson<int>(json['id']),
      dataType: serializer.fromJson<String>(json['data_type']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      dateFrom: serializer.fromJson<DateTime>(json['date_from']),
      dateTo: serializer.fromJson<DateTime>(json['date_to']),
      sourceName: serializer.fromJson<String?>(json['source_name']),
      sourceId: serializer.fromJson<String?>(json['source_id']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      syncedAt: serializer.fromJson<DateTime?>(json['synced_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data_type': serializer.toJson<String>(dataType),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'date_from': serializer.toJson<DateTime>(dateFrom),
      'date_to': serializer.toJson<DateTime>(dateTo),
      'source_name': serializer.toJson<String?>(sourceName),
      'source_id': serializer.toJson<String?>(sourceId),
      'sync_status': serializer.toJson<String>(syncStatus),
      'metadata': serializer.toJson<String?>(metadata),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'synced_at': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  HealthRecord copyWith({
    int? id,
    String? dataType,
    double? value,
    String? unit,
    DateTime? dateFrom,
    DateTime? dateTo,
    Value<String?> sourceName = const Value.absent(),
    Value<String?> sourceId = const Value.absent(),
    String? syncStatus,
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => HealthRecord(
    id: id ?? this.id,
    dataType: dataType ?? this.dataType,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    dateFrom: dateFrom ?? this.dateFrom,
    dateTo: dateTo ?? this.dateTo,
    sourceName: sourceName.present ? sourceName.value : this.sourceName,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    syncStatus: syncStatus ?? this.syncStatus,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  HealthRecord copyWithCompanion(HealthRecordsCompanion data) {
    return HealthRecord(
      id: data.id.present ? data.id.value : this.id,
      dataType: data.dataType.present ? data.dataType.value : this.dataType,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      dateFrom: data.dateFrom.present ? data.dateFrom.value : this.dateFrom,
      dateTo: data.dateTo.present ? data.dateTo.value : this.dateTo,
      sourceName:
          data.sourceName.present ? data.sourceName.value : this.sourceName,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecord(')
          ..write('id: $id, ')
          ..write('dataType: $dataType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceId: $sourceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dataType,
    value,
    unit,
    dateFrom,
    dateTo,
    sourceName,
    sourceId,
    syncStatus,
    metadata,
    createdAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecord &&
          other.id == this.id &&
          other.dataType == this.dataType &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.sourceName == this.sourceName &&
          other.sourceId == this.sourceId &&
          other.syncStatus == this.syncStatus &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class HealthRecordsCompanion extends UpdateCompanion<HealthRecord> {
  final Value<int> id;
  final Value<String> dataType;
  final Value<double> value;
  final Value<String> unit;
  final Value<DateTime> dateFrom;
  final Value<DateTime> dateTo;
  final Value<String?> sourceName;
  final Value<String?> sourceId;
  final Value<String> syncStatus;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  const HealthRecordsCompanion({
    this.id = const Value.absent(),
    this.dataType = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  HealthRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String dataType,
    required double value,
    required String unit,
    required DateTime dateFrom,
    required DateTime dateTo,
    this.sourceName = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : dataType = Value(dataType),
       value = Value(value),
       unit = Value(unit),
       dateFrom = Value(dateFrom),
       dateTo = Value(dateTo);
  static Insertable<HealthRecord> custom({
    Expression<int>? id,
    Expression<String>? dataType,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<DateTime>? dateFrom,
    Expression<DateTime>? dateTo,
    Expression<String>? sourceName,
    Expression<String>? sourceId,
    Expression<String>? syncStatus,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataType != null) 'data_type': dataType,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceId != null) 'source_id': sourceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  HealthRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? dataType,
    Value<double>? value,
    Value<String>? unit,
    Value<DateTime>? dateFrom,
    Value<DateTime>? dateTo,
    Value<String?>? sourceName,
    Value<String?>? sourceId,
    Value<String>? syncStatus,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
  }) {
    return HealthRecordsCompanion(
      id: id ?? this.id,
      dataType: dataType ?? this.dataType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      sourceName: sourceName ?? this.sourceName,
      sourceId: sourceId ?? this.sourceId,
      syncStatus: syncStatus ?? this.syncStatus,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataType.present) {
      map['data_type'] = Variable<String>(dataType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<DateTime>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<DateTime>(dateTo.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('dataType: $dataType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceId: $sourceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class SyncLogs extends Table with TableInfo<SyncLogs, SyncLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncLogs(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _collectedCountMeta = const VerificationMeta(
    'collectedCount',
  );
  late final GeneratedColumn<int> collectedCount = GeneratedColumn<int>(
    'collected_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _insertedCountMeta = const VerificationMeta(
    'insertedCount',
  );
  late final GeneratedColumn<int> insertedCount = GeneratedColumn<int>(
    'inserted_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _syncedCountMeta = const VerificationMeta(
    'syncedCount',
  );
  late final GeneratedColumn<int> syncedCount = GeneratedColumn<int>(
    'synced_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    status,
    startedAt,
    finishedAt,
    collectedCount,
    insertedCount,
    syncedCount,
    message,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('collected_count')) {
      context.handle(
        _collectedCountMeta,
        collectedCount.isAcceptableOrUnknown(
          data['collected_count']!,
          _collectedCountMeta,
        ),
      );
    }
    if (data.containsKey('inserted_count')) {
      context.handle(
        _insertedCountMeta,
        insertedCount.isAcceptableOrUnknown(
          data['inserted_count']!,
          _insertedCountMeta,
        ),
      );
    }
    if (data.containsKey('synced_count')) {
      context.handle(
        _syncedCountMeta,
        syncedCount.isAcceptableOrUnknown(
          data['synced_count']!,
          _syncedCountMeta,
        ),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      operation:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}operation'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      collectedCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}collected_count'],
          )!,
      insertedCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}inserted_count'],
          )!,
      syncedCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}synced_count'],
          )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
    );
  }

  @override
  SyncLogs createAlias(String alias) {
    return SyncLogs(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SyncLog extends DataClass implements Insertable<SyncLog> {
  final int id;
  final String operation;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int collectedCount;
  final int insertedCount;
  final int syncedCount;
  final String? message;
  const SyncLog({
    required this.id,
    required this.operation,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    required this.collectedCount,
    required this.insertedCount,
    required this.syncedCount,
    this.message,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['collected_count'] = Variable<int>(collectedCount);
    map['inserted_count'] = Variable<int>(insertedCount);
    map['synced_count'] = Variable<int>(syncedCount);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      operation: Value(operation),
      status: Value(status),
      startedAt: Value(startedAt),
      finishedAt:
          finishedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(finishedAt),
      collectedCount: Value(collectedCount),
      insertedCount: Value(insertedCount),
      syncedCount: Value(syncedCount),
      message:
          message == null && nullToAbsent
              ? const Value.absent()
              : Value(message),
    );
  }

  factory SyncLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLog(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['started_at']),
      finishedAt: serializer.fromJson<DateTime?>(json['finished_at']),
      collectedCount: serializer.fromJson<int>(json['collected_count']),
      insertedCount: serializer.fromJson<int>(json['inserted_count']),
      syncedCount: serializer.fromJson<int>(json['synced_count']),
      message: serializer.fromJson<String?>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'status': serializer.toJson<String>(status),
      'started_at': serializer.toJson<DateTime>(startedAt),
      'finished_at': serializer.toJson<DateTime?>(finishedAt),
      'collected_count': serializer.toJson<int>(collectedCount),
      'inserted_count': serializer.toJson<int>(insertedCount),
      'synced_count': serializer.toJson<int>(syncedCount),
      'message': serializer.toJson<String?>(message),
    };
  }

  SyncLog copyWith({
    int? id,
    String? operation,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    int? collectedCount,
    int? insertedCount,
    int? syncedCount,
    Value<String?> message = const Value.absent(),
  }) => SyncLog(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    collectedCount: collectedCount ?? this.collectedCount,
    insertedCount: insertedCount ?? this.insertedCount,
    syncedCount: syncedCount ?? this.syncedCount,
    message: message.present ? message.value : this.message,
  );
  SyncLog copyWithCompanion(SyncLogsCompanion data) {
    return SyncLog(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      collectedCount:
          data.collectedCount.present
              ? data.collectedCount.value
              : this.collectedCount,
      insertedCount:
          data.insertedCount.present
              ? data.insertedCount.value
              : this.insertedCount,
      syncedCount:
          data.syncedCount.present ? data.syncedCount.value : this.syncedCount,
      message: data.message.present ? data.message.value : this.message,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLog(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('collectedCount: $collectedCount, ')
          ..write('insertedCount: $insertedCount, ')
          ..write('syncedCount: $syncedCount, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operation,
    status,
    startedAt,
    finishedAt,
    collectedCount,
    insertedCount,
    syncedCount,
    message,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLog &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.collectedCount == this.collectedCount &&
          other.insertedCount == this.insertedCount &&
          other.syncedCount == this.syncedCount &&
          other.message == this.message);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLog> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> collectedCount;
  final Value<int> insertedCount;
  final Value<int> syncedCount;
  final Value<String?> message;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.collectedCount = const Value.absent(),
    this.insertedCount = const Value.absent(),
    this.syncedCount = const Value.absent(),
    this.message = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String status,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.collectedCount = const Value.absent(),
    this.insertedCount = const Value.absent(),
    this.syncedCount = const Value.absent(),
    this.message = const Value.absent(),
  }) : operation = Value(operation),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<SyncLog> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? collectedCount,
    Expression<int>? insertedCount,
    Expression<int>? syncedCount,
    Expression<String>? message,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (collectedCount != null) 'collected_count': collectedCount,
      if (insertedCount != null) 'inserted_count': insertedCount,
      if (syncedCount != null) 'synced_count': syncedCount,
      if (message != null) 'message': message,
    });
  }

  SyncLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? operation,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? collectedCount,
    Value<int>? insertedCount,
    Value<int>? syncedCount,
    Value<String?>? message,
  }) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      collectedCount: collectedCount ?? this.collectedCount,
      insertedCount: insertedCount ?? this.insertedCount,
      syncedCount: syncedCount ?? this.syncedCount,
      message: message ?? this.message,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (collectedCount.present) {
      map['collected_count'] = Variable<int>(collectedCount.value);
    }
    if (insertedCount.present) {
      map['inserted_count'] = Variable<int>(insertedCount.value);
    }
    if (syncedCount.present) {
      map['synced_count'] = Variable<int>(syncedCount.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('collectedCount: $collectedCount, ')
          ..write('insertedCount: $insertedCount, ')
          ..write('syncedCount: $syncedCount, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }
}

class ActivitySessions extends Table
    with TableInfo<ActivitySessions, ActivitySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ActivitySessions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sportKeyMeta = const VerificationMeta(
    'sportKey',
  );
  late final GeneratedColumn<String> sportKey = GeneratedColumn<String>(
    'sport_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sportNameMeta = const VerificationMeta(
    'sportName',
  );
  late final GeneratedColumn<String> sportName = GeneratedColumn<String>(
    'sport_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _requiresGpsMeta = const VerificationMeta(
    'requiresGps',
  );
  late final GeneratedColumn<bool> requiresGps = GeneratedColumn<bool>(
    'requires_gps',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'draft\'',
    defaultValue: const CustomExpression('\'draft\''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _movingSecondsMeta = const VerificationMeta(
    'movingSeconds',
  );
  late final GeneratedColumn<int> movingSeconds = GeneratedColumn<int>(
    'moving_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _stoppedSecondsMeta = const VerificationMeta(
    'stoppedSeconds',
  );
  late final GeneratedColumn<int> stoppedSeconds = GeneratedColumn<int>(
    'stopped_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _caloriesKcalMeta = const VerificationMeta(
    'caloriesKcal',
  );
  late final GeneratedColumn<double> caloriesKcal = GeneratedColumn<double>(
    'calories_kcal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _ascentMetersMeta = const VerificationMeta(
    'ascentMeters',
  );
  late final GeneratedColumn<double> ascentMeters = GeneratedColumn<double>(
    'ascent_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _descentMetersMeta = const VerificationMeta(
    'descentMeters',
  );
  late final GeneratedColumn<double> descentMeters = GeneratedColumn<double>(
    'descent_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _avgSpeedMpsMeta = const VerificationMeta(
    'avgSpeedMps',
  );
  late final GeneratedColumn<double> avgSpeedMps = GeneratedColumn<double>(
    'avg_speed_mps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _maxSpeedMpsMeta = const VerificationMeta(
    'maxSpeedMps',
  );
  late final GeneratedColumn<double> maxSpeedMps = GeneratedColumn<double>(
    'max_speed_mps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _avgHeartRateMeta = const VerificationMeta(
    'avgHeartRate',
  );
  late final GeneratedColumn<double> avgHeartRate = GeneratedColumn<double>(
    'avg_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _maxHeartRateMeta = const VerificationMeta(
    'maxHeartRate',
  );
  late final GeneratedColumn<double> maxHeartRate = GeneratedColumn<double>(
    'max_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _manualPausedSecondsMeta =
      const VerificationMeta('manualPausedSeconds');
  late final GeneratedColumn<int> manualPausedSeconds = GeneratedColumn<int>(
    'manual_paused_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _feelingMeta = const VerificationMeta(
    'feeling',
  );
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
    'feeling',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _gearIdMeta = const VerificationMeta('gearId');
  late final GeneratedColumn<String> gearId = GeneratedColumn<String>(
    'gear_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'phone_gps\'',
    defaultValue: const CustomExpression('\'phone_gps\''),
  );
  static const VerificationMeta _routeVisibilityMeta = const VerificationMeta(
    'routeVisibility',
  );
  late final GeneratedColumn<String> routeVisibility = GeneratedColumn<String>(
    'route_visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'private\'',
    defaultValue: const CustomExpression('\'private\''),
  );
  static const VerificationMeta _hideStartEndMetersMeta =
      const VerificationMeta('hideStartEndMeters');
  late final GeneratedColumn<double> hideStartEndMeters =
      GeneratedColumn<double>(
        'hide_start_end_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        $customConstraints: 'NOT NULL DEFAULT 300',
        defaultValue: const CustomExpression('300'),
      );
  static const VerificationMeta _syncRouteDetailMeta = const VerificationMeta(
    'syncRouteDetail',
  );
  late final GeneratedColumn<bool> syncRouteDetail = GeneratedColumn<bool>(
    'sync_route_detail',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _writeHealthConnectMeta =
      const VerificationMeta('writeHealthConnect');
  late final GeneratedColumn<bool> writeHealthConnect = GeneratedColumn<bool>(
    'write_health_connect',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'pending\'',
    defaultValue: const CustomExpression('\'pending\''),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    title,
    sportKey,
    sportName,
    category,
    requiresGps,
    status,
    startedAt,
    endedAt,
    elapsedSeconds,
    movingSeconds,
    stoppedSeconds,
    distanceMeters,
    caloriesKcal,
    ascentMeters,
    descentMeters,
    avgSpeedMps,
    maxSpeedMps,
    avgHeartRate,
    maxHeartRate,
    manualPausedSeconds,
    notes,
    tags,
    feeling,
    rpe,
    gearId,
    source,
    routeVisibility,
    hideStartEndMeters,
    syncRouteDetail,
    writeHealthConnect,
    syncStatus,
    metadata,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivitySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('sport_key')) {
      context.handle(
        _sportKeyMeta,
        sportKey.isAcceptableOrUnknown(data['sport_key']!, _sportKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sportKeyMeta);
    }
    if (data.containsKey('sport_name')) {
      context.handle(
        _sportNameMeta,
        sportName.isAcceptableOrUnknown(data['sport_name']!, _sportNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sportNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('requires_gps')) {
      context.handle(
        _requiresGpsMeta,
        requiresGps.isAcceptableOrUnknown(
          data['requires_gps']!,
          _requiresGpsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('moving_seconds')) {
      context.handle(
        _movingSecondsMeta,
        movingSeconds.isAcceptableOrUnknown(
          data['moving_seconds']!,
          _movingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('stopped_seconds')) {
      context.handle(
        _stoppedSecondsMeta,
        stoppedSeconds.isAcceptableOrUnknown(
          data['stopped_seconds']!,
          _stoppedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('calories_kcal')) {
      context.handle(
        _caloriesKcalMeta,
        caloriesKcal.isAcceptableOrUnknown(
          data['calories_kcal']!,
          _caloriesKcalMeta,
        ),
      );
    }
    if (data.containsKey('ascent_meters')) {
      context.handle(
        _ascentMetersMeta,
        ascentMeters.isAcceptableOrUnknown(
          data['ascent_meters']!,
          _ascentMetersMeta,
        ),
      );
    }
    if (data.containsKey('descent_meters')) {
      context.handle(
        _descentMetersMeta,
        descentMeters.isAcceptableOrUnknown(
          data['descent_meters']!,
          _descentMetersMeta,
        ),
      );
    }
    if (data.containsKey('avg_speed_mps')) {
      context.handle(
        _avgSpeedMpsMeta,
        avgSpeedMps.isAcceptableOrUnknown(
          data['avg_speed_mps']!,
          _avgSpeedMpsMeta,
        ),
      );
    }
    if (data.containsKey('max_speed_mps')) {
      context.handle(
        _maxSpeedMpsMeta,
        maxSpeedMps.isAcceptableOrUnknown(
          data['max_speed_mps']!,
          _maxSpeedMpsMeta,
        ),
      );
    }
    if (data.containsKey('avg_heart_rate')) {
      context.handle(
        _avgHeartRateMeta,
        avgHeartRate.isAcceptableOrUnknown(
          data['avg_heart_rate']!,
          _avgHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
        _maxHeartRateMeta,
        maxHeartRate.isAcceptableOrUnknown(
          data['max_heart_rate']!,
          _maxHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('manual_paused_seconds')) {
      context.handle(
        _manualPausedSecondsMeta,
        manualPausedSeconds.isAcceptableOrUnknown(
          data['manual_paused_seconds']!,
          _manualPausedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('feeling')) {
      context.handle(
        _feelingMeta,
        feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('gear_id')) {
      context.handle(
        _gearIdMeta,
        gearId.isAcceptableOrUnknown(data['gear_id']!, _gearIdMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('route_visibility')) {
      context.handle(
        _routeVisibilityMeta,
        routeVisibility.isAcceptableOrUnknown(
          data['route_visibility']!,
          _routeVisibilityMeta,
        ),
      );
    }
    if (data.containsKey('hide_start_end_meters')) {
      context.handle(
        _hideStartEndMetersMeta,
        hideStartEndMeters.isAcceptableOrUnknown(
          data['hide_start_end_meters']!,
          _hideStartEndMetersMeta,
        ),
      );
    }
    if (data.containsKey('sync_route_detail')) {
      context.handle(
        _syncRouteDetailMeta,
        syncRouteDetail.isAcceptableOrUnknown(
          data['sync_route_detail']!,
          _syncRouteDetailMeta,
        ),
      );
    }
    if (data.containsKey('write_health_connect')) {
      context.handle(
        _writeHealthConnectMeta,
        writeHealthConnect.isAcceptableOrUnknown(
          data['write_health_connect']!,
          _writeHealthConnectMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivitySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitySession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      sportKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sport_key'],
          )!,
      sportName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sport_name'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      requiresGps:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}requires_gps'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      elapsedSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}elapsed_seconds'],
          )!,
      movingSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}moving_seconds'],
          )!,
      stoppedSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}stopped_seconds'],
          )!,
      distanceMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}distance_meters'],
          )!,
      caloriesKcal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calories_kcal'],
          )!,
      ascentMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}ascent_meters'],
          )!,
      descentMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}descent_meters'],
          )!,
      avgSpeedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed_mps'],
      ),
      maxSpeedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_mps'],
      ),
      avgHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_heart_rate'],
      ),
      maxHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_heart_rate'],
      ),
      manualPausedSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}manual_paused_seconds'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tags'],
          )!,
      feeling: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feeling'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpe'],
      ),
      gearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gear_id'],
      ),
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      routeVisibility:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}route_visibility'],
          )!,
      hideStartEndMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}hide_start_end_meters'],
          )!,
      syncRouteDetail:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}sync_route_detail'],
          )!,
      writeHealthConnect:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}write_health_connect'],
          )!,
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  ActivitySessions createAlias(String alias) {
    return ActivitySessions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ActivitySession extends DataClass implements Insertable<ActivitySession> {
  final int id;
  final String localId;
  final String? title;
  final String sportKey;
  final String sportName;
  final String category;
  final bool requiresGps;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int elapsedSeconds;
  final int movingSeconds;
  final int stoppedSeconds;
  final double distanceMeters;
  final double caloriesKcal;
  final double ascentMeters;
  final double descentMeters;
  final double? avgSpeedMps;
  final double? maxSpeedMps;
  final double? avgHeartRate;
  final double? maxHeartRate;
  final int manualPausedSeconds;
  final String? notes;
  final String tags;
  final String? feeling;
  final int? rpe;
  final String? gearId;
  final String source;
  final String routeVisibility;
  final double hideStartEndMeters;
  final bool syncRouteDetail;
  final bool writeHealthConnect;
  final String syncStatus;
  final String? metadata;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const ActivitySession({
    required this.id,
    required this.localId,
    this.title,
    required this.sportKey,
    required this.sportName,
    required this.category,
    required this.requiresGps,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.elapsedSeconds,
    required this.movingSeconds,
    required this.stoppedSeconds,
    required this.distanceMeters,
    required this.caloriesKcal,
    required this.ascentMeters,
    required this.descentMeters,
    this.avgSpeedMps,
    this.maxSpeedMps,
    this.avgHeartRate,
    this.maxHeartRate,
    required this.manualPausedSeconds,
    this.notes,
    required this.tags,
    this.feeling,
    this.rpe,
    this.gearId,
    required this.source,
    required this.routeVisibility,
    required this.hideStartEndMeters,
    required this.syncRouteDetail,
    required this.writeHealthConnect,
    required this.syncStatus,
    this.metadata,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['sport_key'] = Variable<String>(sportKey);
    map['sport_name'] = Variable<String>(sportName);
    map['category'] = Variable<String>(category);
    map['requires_gps'] = Variable<bool>(requiresGps);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['moving_seconds'] = Variable<int>(movingSeconds);
    map['stopped_seconds'] = Variable<int>(stoppedSeconds);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['calories_kcal'] = Variable<double>(caloriesKcal);
    map['ascent_meters'] = Variable<double>(ascentMeters);
    map['descent_meters'] = Variable<double>(descentMeters);
    if (!nullToAbsent || avgSpeedMps != null) {
      map['avg_speed_mps'] = Variable<double>(avgSpeedMps);
    }
    if (!nullToAbsent || maxSpeedMps != null) {
      map['max_speed_mps'] = Variable<double>(maxSpeedMps);
    }
    if (!nullToAbsent || avgHeartRate != null) {
      map['avg_heart_rate'] = Variable<double>(avgHeartRate);
    }
    if (!nullToAbsent || maxHeartRate != null) {
      map['max_heart_rate'] = Variable<double>(maxHeartRate);
    }
    map['manual_paused_seconds'] = Variable<int>(manualPausedSeconds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || feeling != null) {
      map['feeling'] = Variable<String>(feeling);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<int>(rpe);
    }
    if (!nullToAbsent || gearId != null) {
      map['gear_id'] = Variable<String>(gearId);
    }
    map['source'] = Variable<String>(source);
    map['route_visibility'] = Variable<String>(routeVisibility);
    map['hide_start_end_meters'] = Variable<double>(hideStartEndMeters);
    map['sync_route_detail'] = Variable<bool>(syncRouteDetail);
    map['write_health_connect'] = Variable<bool>(writeHealthConnect);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ActivitySessionsCompanion toCompanion(bool nullToAbsent) {
    return ActivitySessionsCompanion(
      id: Value(id),
      localId: Value(localId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      sportKey: Value(sportKey),
      sportName: Value(sportName),
      category: Value(category),
      requiresGps: Value(requiresGps),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt:
          endedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(endedAt),
      elapsedSeconds: Value(elapsedSeconds),
      movingSeconds: Value(movingSeconds),
      stoppedSeconds: Value(stoppedSeconds),
      distanceMeters: Value(distanceMeters),
      caloriesKcal: Value(caloriesKcal),
      ascentMeters: Value(ascentMeters),
      descentMeters: Value(descentMeters),
      avgSpeedMps:
          avgSpeedMps == null && nullToAbsent
              ? const Value.absent()
              : Value(avgSpeedMps),
      maxSpeedMps:
          maxSpeedMps == null && nullToAbsent
              ? const Value.absent()
              : Value(maxSpeedMps),
      avgHeartRate:
          avgHeartRate == null && nullToAbsent
              ? const Value.absent()
              : Value(avgHeartRate),
      maxHeartRate:
          maxHeartRate == null && nullToAbsent
              ? const Value.absent()
              : Value(maxHeartRate),
      manualPausedSeconds: Value(manualPausedSeconds),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      tags: Value(tags),
      feeling:
          feeling == null && nullToAbsent
              ? const Value.absent()
              : Value(feeling),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      gearId:
          gearId == null && nullToAbsent ? const Value.absent() : Value(gearId),
      source: Value(source),
      routeVisibility: Value(routeVisibility),
      hideStartEndMeters: Value(hideStartEndMeters),
      syncRouteDetail: Value(syncRouteDetail),
      writeHealthConnect: Value(writeHealthConnect),
      syncStatus: Value(syncStatus),
      metadata:
          metadata == null && nullToAbsent
              ? const Value.absent()
              : Value(metadata),
      createdAt: Value(createdAt),
      syncedAt:
          syncedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(syncedAt),
    );
  }

  factory ActivitySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitySession(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      title: serializer.fromJson<String?>(json['title']),
      sportKey: serializer.fromJson<String>(json['sport_key']),
      sportName: serializer.fromJson<String>(json['sport_name']),
      category: serializer.fromJson<String>(json['category']),
      requiresGps: serializer.fromJson<bool>(json['requires_gps']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['started_at']),
      endedAt: serializer.fromJson<DateTime?>(json['ended_at']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsed_seconds']),
      movingSeconds: serializer.fromJson<int>(json['moving_seconds']),
      stoppedSeconds: serializer.fromJson<int>(json['stopped_seconds']),
      distanceMeters: serializer.fromJson<double>(json['distance_meters']),
      caloriesKcal: serializer.fromJson<double>(json['calories_kcal']),
      ascentMeters: serializer.fromJson<double>(json['ascent_meters']),
      descentMeters: serializer.fromJson<double>(json['descent_meters']),
      avgSpeedMps: serializer.fromJson<double?>(json['avg_speed_mps']),
      maxSpeedMps: serializer.fromJson<double?>(json['max_speed_mps']),
      avgHeartRate: serializer.fromJson<double?>(json['avg_heart_rate']),
      maxHeartRate: serializer.fromJson<double?>(json['max_heart_rate']),
      manualPausedSeconds: serializer.fromJson<int>(
        json['manual_paused_seconds'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      feeling: serializer.fromJson<String?>(json['feeling']),
      rpe: serializer.fromJson<int?>(json['rpe']),
      gearId: serializer.fromJson<String?>(json['gear_id']),
      source: serializer.fromJson<String>(json['source']),
      routeVisibility: serializer.fromJson<String>(json['route_visibility']),
      hideStartEndMeters: serializer.fromJson<double>(
        json['hide_start_end_meters'],
      ),
      syncRouteDetail: serializer.fromJson<bool>(json['sync_route_detail']),
      writeHealthConnect: serializer.fromJson<bool>(
        json['write_health_connect'],
      ),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      syncedAt: serializer.fromJson<DateTime?>(json['synced_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'title': serializer.toJson<String?>(title),
      'sport_key': serializer.toJson<String>(sportKey),
      'sport_name': serializer.toJson<String>(sportName),
      'category': serializer.toJson<String>(category),
      'requires_gps': serializer.toJson<bool>(requiresGps),
      'status': serializer.toJson<String>(status),
      'started_at': serializer.toJson<DateTime>(startedAt),
      'ended_at': serializer.toJson<DateTime?>(endedAt),
      'elapsed_seconds': serializer.toJson<int>(elapsedSeconds),
      'moving_seconds': serializer.toJson<int>(movingSeconds),
      'stopped_seconds': serializer.toJson<int>(stoppedSeconds),
      'distance_meters': serializer.toJson<double>(distanceMeters),
      'calories_kcal': serializer.toJson<double>(caloriesKcal),
      'ascent_meters': serializer.toJson<double>(ascentMeters),
      'descent_meters': serializer.toJson<double>(descentMeters),
      'avg_speed_mps': serializer.toJson<double?>(avgSpeedMps),
      'max_speed_mps': serializer.toJson<double?>(maxSpeedMps),
      'avg_heart_rate': serializer.toJson<double?>(avgHeartRate),
      'max_heart_rate': serializer.toJson<double?>(maxHeartRate),
      'manual_paused_seconds': serializer.toJson<int>(manualPausedSeconds),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String>(tags),
      'feeling': serializer.toJson<String?>(feeling),
      'rpe': serializer.toJson<int?>(rpe),
      'gear_id': serializer.toJson<String?>(gearId),
      'source': serializer.toJson<String>(source),
      'route_visibility': serializer.toJson<String>(routeVisibility),
      'hide_start_end_meters': serializer.toJson<double>(hideStartEndMeters),
      'sync_route_detail': serializer.toJson<bool>(syncRouteDetail),
      'write_health_connect': serializer.toJson<bool>(writeHealthConnect),
      'sync_status': serializer.toJson<String>(syncStatus),
      'metadata': serializer.toJson<String?>(metadata),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'synced_at': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ActivitySession copyWith({
    int? id,
    String? localId,
    Value<String?> title = const Value.absent(),
    String? sportKey,
    String? sportName,
    String? category,
    bool? requiresGps,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? elapsedSeconds,
    int? movingSeconds,
    int? stoppedSeconds,
    double? distanceMeters,
    double? caloriesKcal,
    double? ascentMeters,
    double? descentMeters,
    Value<double?> avgSpeedMps = const Value.absent(),
    Value<double?> maxSpeedMps = const Value.absent(),
    Value<double?> avgHeartRate = const Value.absent(),
    Value<double?> maxHeartRate = const Value.absent(),
    int? manualPausedSeconds,
    Value<String?> notes = const Value.absent(),
    String? tags,
    Value<String?> feeling = const Value.absent(),
    Value<int?> rpe = const Value.absent(),
    Value<String?> gearId = const Value.absent(),
    String? source,
    String? routeVisibility,
    double? hideStartEndMeters,
    bool? syncRouteDetail,
    bool? writeHealthConnect,
    String? syncStatus,
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => ActivitySession(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    title: title.present ? title.value : this.title,
    sportKey: sportKey ?? this.sportKey,
    sportName: sportName ?? this.sportName,
    category: category ?? this.category,
    requiresGps: requiresGps ?? this.requiresGps,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    movingSeconds: movingSeconds ?? this.movingSeconds,
    stoppedSeconds: stoppedSeconds ?? this.stoppedSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    caloriesKcal: caloriesKcal ?? this.caloriesKcal,
    ascentMeters: ascentMeters ?? this.ascentMeters,
    descentMeters: descentMeters ?? this.descentMeters,
    avgSpeedMps: avgSpeedMps.present ? avgSpeedMps.value : this.avgSpeedMps,
    maxSpeedMps: maxSpeedMps.present ? maxSpeedMps.value : this.maxSpeedMps,
    avgHeartRate: avgHeartRate.present ? avgHeartRate.value : this.avgHeartRate,
    maxHeartRate: maxHeartRate.present ? maxHeartRate.value : this.maxHeartRate,
    manualPausedSeconds: manualPausedSeconds ?? this.manualPausedSeconds,
    notes: notes.present ? notes.value : this.notes,
    tags: tags ?? this.tags,
    feeling: feeling.present ? feeling.value : this.feeling,
    rpe: rpe.present ? rpe.value : this.rpe,
    gearId: gearId.present ? gearId.value : this.gearId,
    source: source ?? this.source,
    routeVisibility: routeVisibility ?? this.routeVisibility,
    hideStartEndMeters: hideStartEndMeters ?? this.hideStartEndMeters,
    syncRouteDetail: syncRouteDetail ?? this.syncRouteDetail,
    writeHealthConnect: writeHealthConnect ?? this.writeHealthConnect,
    syncStatus: syncStatus ?? this.syncStatus,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  ActivitySession copyWithCompanion(ActivitySessionsCompanion data) {
    return ActivitySession(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      title: data.title.present ? data.title.value : this.title,
      sportKey: data.sportKey.present ? data.sportKey.value : this.sportKey,
      sportName: data.sportName.present ? data.sportName.value : this.sportName,
      category: data.category.present ? data.category.value : this.category,
      requiresGps:
          data.requiresGps.present ? data.requiresGps.value : this.requiresGps,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      elapsedSeconds:
          data.elapsedSeconds.present
              ? data.elapsedSeconds.value
              : this.elapsedSeconds,
      movingSeconds:
          data.movingSeconds.present
              ? data.movingSeconds.value
              : this.movingSeconds,
      stoppedSeconds:
          data.stoppedSeconds.present
              ? data.stoppedSeconds.value
              : this.stoppedSeconds,
      distanceMeters:
          data.distanceMeters.present
              ? data.distanceMeters.value
              : this.distanceMeters,
      caloriesKcal:
          data.caloriesKcal.present
              ? data.caloriesKcal.value
              : this.caloriesKcal,
      ascentMeters:
          data.ascentMeters.present
              ? data.ascentMeters.value
              : this.ascentMeters,
      descentMeters:
          data.descentMeters.present
              ? data.descentMeters.value
              : this.descentMeters,
      avgSpeedMps:
          data.avgSpeedMps.present ? data.avgSpeedMps.value : this.avgSpeedMps,
      maxSpeedMps:
          data.maxSpeedMps.present ? data.maxSpeedMps.value : this.maxSpeedMps,
      avgHeartRate:
          data.avgHeartRate.present
              ? data.avgHeartRate.value
              : this.avgHeartRate,
      maxHeartRate:
          data.maxHeartRate.present
              ? data.maxHeartRate.value
              : this.maxHeartRate,
      manualPausedSeconds:
          data.manualPausedSeconds.present
              ? data.manualPausedSeconds.value
              : this.manualPausedSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      gearId: data.gearId.present ? data.gearId.value : this.gearId,
      source: data.source.present ? data.source.value : this.source,
      routeVisibility:
          data.routeVisibility.present
              ? data.routeVisibility.value
              : this.routeVisibility,
      hideStartEndMeters:
          data.hideStartEndMeters.present
              ? data.hideStartEndMeters.value
              : this.hideStartEndMeters,
      syncRouteDetail:
          data.syncRouteDetail.present
              ? data.syncRouteDetail.value
              : this.syncRouteDetail,
      writeHealthConnect:
          data.writeHealthConnect.present
              ? data.writeHealthConnect.value
              : this.writeHealthConnect,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySession(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('sportKey: $sportKey, ')
          ..write('sportName: $sportName, ')
          ..write('category: $category, ')
          ..write('requiresGps: $requiresGps, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('movingSeconds: $movingSeconds, ')
          ..write('stoppedSeconds: $stoppedSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('caloriesKcal: $caloriesKcal, ')
          ..write('ascentMeters: $ascentMeters, ')
          ..write('descentMeters: $descentMeters, ')
          ..write('avgSpeedMps: $avgSpeedMps, ')
          ..write('maxSpeedMps: $maxSpeedMps, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('manualPausedSeconds: $manualPausedSeconds, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('feeling: $feeling, ')
          ..write('rpe: $rpe, ')
          ..write('gearId: $gearId, ')
          ..write('source: $source, ')
          ..write('routeVisibility: $routeVisibility, ')
          ..write('hideStartEndMeters: $hideStartEndMeters, ')
          ..write('syncRouteDetail: $syncRouteDetail, ')
          ..write('writeHealthConnect: $writeHealthConnect, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    localId,
    title,
    sportKey,
    sportName,
    category,
    requiresGps,
    status,
    startedAt,
    endedAt,
    elapsedSeconds,
    movingSeconds,
    stoppedSeconds,
    distanceMeters,
    caloriesKcal,
    ascentMeters,
    descentMeters,
    avgSpeedMps,
    maxSpeedMps,
    avgHeartRate,
    maxHeartRate,
    manualPausedSeconds,
    notes,
    tags,
    feeling,
    rpe,
    gearId,
    source,
    routeVisibility,
    hideStartEndMeters,
    syncRouteDetail,
    writeHealthConnect,
    syncStatus,
    metadata,
    createdAt,
    syncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitySession &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.title == this.title &&
          other.sportKey == this.sportKey &&
          other.sportName == this.sportName &&
          other.category == this.category &&
          other.requiresGps == this.requiresGps &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.movingSeconds == this.movingSeconds &&
          other.stoppedSeconds == this.stoppedSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.caloriesKcal == this.caloriesKcal &&
          other.ascentMeters == this.ascentMeters &&
          other.descentMeters == this.descentMeters &&
          other.avgSpeedMps == this.avgSpeedMps &&
          other.maxSpeedMps == this.maxSpeedMps &&
          other.avgHeartRate == this.avgHeartRate &&
          other.maxHeartRate == this.maxHeartRate &&
          other.manualPausedSeconds == this.manualPausedSeconds &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.feeling == this.feeling &&
          other.rpe == this.rpe &&
          other.gearId == this.gearId &&
          other.source == this.source &&
          other.routeVisibility == this.routeVisibility &&
          other.hideStartEndMeters == this.hideStartEndMeters &&
          other.syncRouteDetail == this.syncRouteDetail &&
          other.writeHealthConnect == this.writeHealthConnect &&
          other.syncStatus == this.syncStatus &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class ActivitySessionsCompanion extends UpdateCompanion<ActivitySession> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String?> title;
  final Value<String> sportKey;
  final Value<String> sportName;
  final Value<String> category;
  final Value<bool> requiresGps;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> elapsedSeconds;
  final Value<int> movingSeconds;
  final Value<int> stoppedSeconds;
  final Value<double> distanceMeters;
  final Value<double> caloriesKcal;
  final Value<double> ascentMeters;
  final Value<double> descentMeters;
  final Value<double?> avgSpeedMps;
  final Value<double?> maxSpeedMps;
  final Value<double?> avgHeartRate;
  final Value<double?> maxHeartRate;
  final Value<int> manualPausedSeconds;
  final Value<String?> notes;
  final Value<String> tags;
  final Value<String?> feeling;
  final Value<int?> rpe;
  final Value<String?> gearId;
  final Value<String> source;
  final Value<String> routeVisibility;
  final Value<double> hideStartEndMeters;
  final Value<bool> syncRouteDetail;
  final Value<bool> writeHealthConnect;
  final Value<String> syncStatus;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  const ActivitySessionsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.title = const Value.absent(),
    this.sportKey = const Value.absent(),
    this.sportName = const Value.absent(),
    this.category = const Value.absent(),
    this.requiresGps = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.movingSeconds = const Value.absent(),
    this.stoppedSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.caloriesKcal = const Value.absent(),
    this.ascentMeters = const Value.absent(),
    this.descentMeters = const Value.absent(),
    this.avgSpeedMps = const Value.absent(),
    this.maxSpeedMps = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.manualPausedSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.feeling = const Value.absent(),
    this.rpe = const Value.absent(),
    this.gearId = const Value.absent(),
    this.source = const Value.absent(),
    this.routeVisibility = const Value.absent(),
    this.hideStartEndMeters = const Value.absent(),
    this.syncRouteDetail = const Value.absent(),
    this.writeHealthConnect = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  ActivitySessionsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    this.title = const Value.absent(),
    required String sportKey,
    required String sportName,
    required String category,
    this.requiresGps = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.movingSeconds = const Value.absent(),
    this.stoppedSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.caloriesKcal = const Value.absent(),
    this.ascentMeters = const Value.absent(),
    this.descentMeters = const Value.absent(),
    this.avgSpeedMps = const Value.absent(),
    this.maxSpeedMps = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.manualPausedSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.feeling = const Value.absent(),
    this.rpe = const Value.absent(),
    this.gearId = const Value.absent(),
    this.source = const Value.absent(),
    this.routeVisibility = const Value.absent(),
    this.hideStartEndMeters = const Value.absent(),
    this.syncRouteDetail = const Value.absent(),
    this.writeHealthConnect = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : localId = Value(localId),
       sportKey = Value(sportKey),
       sportName = Value(sportName),
       category = Value(category),
       startedAt = Value(startedAt);
  static Insertable<ActivitySession> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? title,
    Expression<String>? sportKey,
    Expression<String>? sportName,
    Expression<String>? category,
    Expression<bool>? requiresGps,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? elapsedSeconds,
    Expression<int>? movingSeconds,
    Expression<int>? stoppedSeconds,
    Expression<double>? distanceMeters,
    Expression<double>? caloriesKcal,
    Expression<double>? ascentMeters,
    Expression<double>? descentMeters,
    Expression<double>? avgSpeedMps,
    Expression<double>? maxSpeedMps,
    Expression<double>? avgHeartRate,
    Expression<double>? maxHeartRate,
    Expression<int>? manualPausedSeconds,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? feeling,
    Expression<int>? rpe,
    Expression<String>? gearId,
    Expression<String>? source,
    Expression<String>? routeVisibility,
    Expression<double>? hideStartEndMeters,
    Expression<bool>? syncRouteDetail,
    Expression<bool>? writeHealthConnect,
    Expression<String>? syncStatus,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (title != null) 'title': title,
      if (sportKey != null) 'sport_key': sportKey,
      if (sportName != null) 'sport_name': sportName,
      if (category != null) 'category': category,
      if (requiresGps != null) 'requires_gps': requiresGps,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (movingSeconds != null) 'moving_seconds': movingSeconds,
      if (stoppedSeconds != null) 'stopped_seconds': stoppedSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (caloriesKcal != null) 'calories_kcal': caloriesKcal,
      if (ascentMeters != null) 'ascent_meters': ascentMeters,
      if (descentMeters != null) 'descent_meters': descentMeters,
      if (avgSpeedMps != null) 'avg_speed_mps': avgSpeedMps,
      if (maxSpeedMps != null) 'max_speed_mps': maxSpeedMps,
      if (avgHeartRate != null) 'avg_heart_rate': avgHeartRate,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (manualPausedSeconds != null)
        'manual_paused_seconds': manualPausedSeconds,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (feeling != null) 'feeling': feeling,
      if (rpe != null) 'rpe': rpe,
      if (gearId != null) 'gear_id': gearId,
      if (source != null) 'source': source,
      if (routeVisibility != null) 'route_visibility': routeVisibility,
      if (hideStartEndMeters != null)
        'hide_start_end_meters': hideStartEndMeters,
      if (syncRouteDetail != null) 'sync_route_detail': syncRouteDetail,
      if (writeHealthConnect != null)
        'write_health_connect': writeHealthConnect,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  ActivitySessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String?>? title,
    Value<String>? sportKey,
    Value<String>? sportName,
    Value<String>? category,
    Value<bool>? requiresGps,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? elapsedSeconds,
    Value<int>? movingSeconds,
    Value<int>? stoppedSeconds,
    Value<double>? distanceMeters,
    Value<double>? caloriesKcal,
    Value<double>? ascentMeters,
    Value<double>? descentMeters,
    Value<double?>? avgSpeedMps,
    Value<double?>? maxSpeedMps,
    Value<double?>? avgHeartRate,
    Value<double?>? maxHeartRate,
    Value<int>? manualPausedSeconds,
    Value<String?>? notes,
    Value<String>? tags,
    Value<String?>? feeling,
    Value<int?>? rpe,
    Value<String?>? gearId,
    Value<String>? source,
    Value<String>? routeVisibility,
    Value<double>? hideStartEndMeters,
    Value<bool>? syncRouteDetail,
    Value<bool>? writeHealthConnect,
    Value<String>? syncStatus,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
  }) {
    return ActivitySessionsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      title: title ?? this.title,
      sportKey: sportKey ?? this.sportKey,
      sportName: sportName ?? this.sportName,
      category: category ?? this.category,
      requiresGps: requiresGps ?? this.requiresGps,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      movingSeconds: movingSeconds ?? this.movingSeconds,
      stoppedSeconds: stoppedSeconds ?? this.stoppedSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      caloriesKcal: caloriesKcal ?? this.caloriesKcal,
      ascentMeters: ascentMeters ?? this.ascentMeters,
      descentMeters: descentMeters ?? this.descentMeters,
      avgSpeedMps: avgSpeedMps ?? this.avgSpeedMps,
      maxSpeedMps: maxSpeedMps ?? this.maxSpeedMps,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      manualPausedSeconds: manualPausedSeconds ?? this.manualPausedSeconds,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      feeling: feeling ?? this.feeling,
      rpe: rpe ?? this.rpe,
      gearId: gearId ?? this.gearId,
      source: source ?? this.source,
      routeVisibility: routeVisibility ?? this.routeVisibility,
      hideStartEndMeters: hideStartEndMeters ?? this.hideStartEndMeters,
      syncRouteDetail: syncRouteDetail ?? this.syncRouteDetail,
      writeHealthConnect: writeHealthConnect ?? this.writeHealthConnect,
      syncStatus: syncStatus ?? this.syncStatus,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sportKey.present) {
      map['sport_key'] = Variable<String>(sportKey.value);
    }
    if (sportName.present) {
      map['sport_name'] = Variable<String>(sportName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (requiresGps.present) {
      map['requires_gps'] = Variable<bool>(requiresGps.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (movingSeconds.present) {
      map['moving_seconds'] = Variable<int>(movingSeconds.value);
    }
    if (stoppedSeconds.present) {
      map['stopped_seconds'] = Variable<int>(stoppedSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (caloriesKcal.present) {
      map['calories_kcal'] = Variable<double>(caloriesKcal.value);
    }
    if (ascentMeters.present) {
      map['ascent_meters'] = Variable<double>(ascentMeters.value);
    }
    if (descentMeters.present) {
      map['descent_meters'] = Variable<double>(descentMeters.value);
    }
    if (avgSpeedMps.present) {
      map['avg_speed_mps'] = Variable<double>(avgSpeedMps.value);
    }
    if (maxSpeedMps.present) {
      map['max_speed_mps'] = Variable<double>(maxSpeedMps.value);
    }
    if (avgHeartRate.present) {
      map['avg_heart_rate'] = Variable<double>(avgHeartRate.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<double>(maxHeartRate.value);
    }
    if (manualPausedSeconds.present) {
      map['manual_paused_seconds'] = Variable<int>(manualPausedSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (gearId.present) {
      map['gear_id'] = Variable<String>(gearId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (routeVisibility.present) {
      map['route_visibility'] = Variable<String>(routeVisibility.value);
    }
    if (hideStartEndMeters.present) {
      map['hide_start_end_meters'] = Variable<double>(hideStartEndMeters.value);
    }
    if (syncRouteDetail.present) {
      map['sync_route_detail'] = Variable<bool>(syncRouteDetail.value);
    }
    if (writeHealthConnect.present) {
      map['write_health_connect'] = Variable<bool>(writeHealthConnect.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySessionsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('sportKey: $sportKey, ')
          ..write('sportName: $sportName, ')
          ..write('category: $category, ')
          ..write('requiresGps: $requiresGps, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('movingSeconds: $movingSeconds, ')
          ..write('stoppedSeconds: $stoppedSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('caloriesKcal: $caloriesKcal, ')
          ..write('ascentMeters: $ascentMeters, ')
          ..write('descentMeters: $descentMeters, ')
          ..write('avgSpeedMps: $avgSpeedMps, ')
          ..write('maxSpeedMps: $maxSpeedMps, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('manualPausedSeconds: $manualPausedSeconds, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('feeling: $feeling, ')
          ..write('rpe: $rpe, ')
          ..write('gearId: $gearId, ')
          ..write('source: $source, ')
          ..write('routeVisibility: $routeVisibility, ')
          ..write('hideStartEndMeters: $hideStartEndMeters, ')
          ..write('syncRouteDetail: $syncRouteDetail, ')
          ..write('writeHealthConnect: $writeHealthConnect, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class ActivityEvents extends Table
    with TableInfo<ActivityEvents, ActivityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ActivityEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _sessionLocalIdMeta = const VerificationMeta(
    'sessionLocalId',
  );
  late final GeneratedColumn<String> sessionLocalId = GeneratedColumn<String>(
    'session_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionLocalId,
    eventType,
    timestamp,
    metadata,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_local_id')) {
      context.handle(
        _sessionLocalIdMeta,
        sessionLocalId.isAcceptableOrUnknown(
          data['session_local_id']!,
          _sessionLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionLocalIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionLocalId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_local_id'],
          )!,
      eventType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_type'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  ActivityEvents createAlias(String alias) {
    return ActivityEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ActivityEvent extends DataClass implements Insertable<ActivityEvent> {
  final int id;
  final String sessionLocalId;
  final String eventType;
  final DateTime timestamp;
  final String? metadata;
  final DateTime createdAt;
  const ActivityEvent({
    required this.id,
    required this.sessionLocalId,
    required this.eventType,
    required this.timestamp,
    this.metadata,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_local_id'] = Variable<String>(sessionLocalId);
    map['event_type'] = Variable<String>(eventType);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityEventsCompanion toCompanion(bool nullToAbsent) {
    return ActivityEventsCompanion(
      id: Value(id),
      sessionLocalId: Value(sessionLocalId),
      eventType: Value(eventType),
      timestamp: Value(timestamp),
      metadata:
          metadata == null && nullToAbsent
              ? const Value.absent()
              : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEvent(
      id: serializer.fromJson<int>(json['id']),
      sessionLocalId: serializer.fromJson<String>(json['session_local_id']),
      eventType: serializer.fromJson<String>(json['event_type']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'session_local_id': serializer.toJson<String>(sessionLocalId),
      'event_type': serializer.toJson<String>(eventType),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'metadata': serializer.toJson<String?>(metadata),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityEvent copyWith({
    int? id,
    String? sessionLocalId,
    String? eventType,
    DateTime? timestamp,
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
  }) => ActivityEvent(
    id: id ?? this.id,
    sessionLocalId: sessionLocalId ?? this.sessionLocalId,
    eventType: eventType ?? this.eventType,
    timestamp: timestamp ?? this.timestamp,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityEvent copyWithCompanion(ActivityEventsCompanion data) {
    return ActivityEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionLocalId:
          data.sessionLocalId.present
              ? data.sessionLocalId.value
              : this.sessionLocalId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEvent(')
          ..write('id: $id, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionLocalId,
    eventType,
    timestamp,
    metadata,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEvent &&
          other.id == this.id &&
          other.sessionLocalId == this.sessionLocalId &&
          other.eventType == this.eventType &&
          other.timestamp == this.timestamp &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class ActivityEventsCompanion extends UpdateCompanion<ActivityEvent> {
  final Value<int> id;
  final Value<String> sessionLocalId;
  final Value<String> eventType;
  final Value<DateTime> timestamp;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  const ActivityEventsCompanion({
    this.id = const Value.absent(),
    this.sessionLocalId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivityEventsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionLocalId,
    required String eventType,
    required DateTime timestamp,
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionLocalId = Value(sessionLocalId),
       eventType = Value(eventType),
       timestamp = Value(timestamp);
  static Insertable<ActivityEvent> custom({
    Expression<int>? id,
    Expression<String>? sessionLocalId,
    Expression<String>? eventType,
    Expression<DateTime>? timestamp,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionLocalId != null) 'session_local_id': sessionLocalId,
      if (eventType != null) 'event_type': eventType,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivityEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionLocalId,
    Value<String>? eventType,
    Value<DateTime>? timestamp,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
  }) {
    return ActivityEventsCompanion(
      id: id ?? this.id,
      sessionLocalId: sessionLocalId ?? this.sessionLocalId,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionLocalId.present) {
      map['session_local_id'] = Variable<String>(sessionLocalId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class ActivityPoints extends Table
    with TableInfo<ActivityPoints, ActivityPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ActivityPoints(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _sessionLocalIdMeta = const VerificationMeta(
    'sessionLocalId',
  );
  late final GeneratedColumn<String> sessionLocalId = GeneratedColumn<String>(
    'session_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _altitudeMetersMeta = const VerificationMeta(
    'altitudeMeters',
  );
  late final GeneratedColumn<double> altitudeMeters = GeneratedColumn<double>(
    'altitude_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _altitudeCorrectedMetersMeta =
      const VerificationMeta('altitudeCorrectedMeters');
  late final GeneratedColumn<double> altitudeCorrectedMeters =
      GeneratedColumn<double>(
        'altitude_corrected_meters',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _speedMpsMeta = const VerificationMeta(
    'speedMps',
  );
  late final GeneratedColumn<double> speedMps = GeneratedColumn<double>(
    'speed_mps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _bearingDegreesMeta = const VerificationMeta(
    'bearingDegrees',
  );
  late final GeneratedColumn<double> bearingDegrees = GeneratedColumn<double>(
    'bearing_degrees',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _distanceFromPrevMetersMeta =
      const VerificationMeta('distanceFromPrevMeters');
  late final GeneratedColumn<double> distanceFromPrevMeters =
      GeneratedColumn<double>(
        'distance_from_prev_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression('0'),
      );
  static const VerificationMeta _movingMeta = const VerificationMeta('moving');
  late final GeneratedColumn<bool> moving = GeneratedColumn<bool>(
    'moving',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _pointQualityMeta = const VerificationMeta(
    'pointQuality',
  );
  late final GeneratedColumn<String> pointQuality = GeneratedColumn<String>(
    'point_quality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'unknown\'',
    defaultValue: const CustomExpression('\'unknown\''),
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionLocalId,
    timestamp,
    latitude,
    longitude,
    altitudeMeters,
    altitudeCorrectedMeters,
    accuracyMeters,
    speedMps,
    bearingDegrees,
    distanceFromPrevMeters,
    moving,
    pointQuality,
    provider,
    metadata,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_local_id')) {
      context.handle(
        _sessionLocalIdMeta,
        sessionLocalId.isAcceptableOrUnknown(
          data['session_local_id']!,
          _sessionLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionLocalIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude_meters')) {
      context.handle(
        _altitudeMetersMeta,
        altitudeMeters.isAcceptableOrUnknown(
          data['altitude_meters']!,
          _altitudeMetersMeta,
        ),
      );
    }
    if (data.containsKey('altitude_corrected_meters')) {
      context.handle(
        _altitudeCorrectedMetersMeta,
        altitudeCorrectedMeters.isAcceptableOrUnknown(
          data['altitude_corrected_meters']!,
          _altitudeCorrectedMetersMeta,
        ),
      );
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('speed_mps')) {
      context.handle(
        _speedMpsMeta,
        speedMps.isAcceptableOrUnknown(data['speed_mps']!, _speedMpsMeta),
      );
    }
    if (data.containsKey('bearing_degrees')) {
      context.handle(
        _bearingDegreesMeta,
        bearingDegrees.isAcceptableOrUnknown(
          data['bearing_degrees']!,
          _bearingDegreesMeta,
        ),
      );
    }
    if (data.containsKey('distance_from_prev_meters')) {
      context.handle(
        _distanceFromPrevMetersMeta,
        distanceFromPrevMeters.isAcceptableOrUnknown(
          data['distance_from_prev_meters']!,
          _distanceFromPrevMetersMeta,
        ),
      );
    }
    if (data.containsKey('moving')) {
      context.handle(
        _movingMeta,
        moving.isAcceptableOrUnknown(data['moving']!, _movingMeta),
      );
    }
    if (data.containsKey('point_quality')) {
      context.handle(
        _pointQualityMeta,
        pointQuality.isAcceptableOrUnknown(
          data['point_quality']!,
          _pointQualityMeta,
        ),
      );
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityPoint(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionLocalId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_local_id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      latitude:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}latitude'],
          )!,
      longitude:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}longitude'],
          )!,
      altitudeMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_meters'],
      ),
      altitudeCorrectedMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_corrected_meters'],
      ),
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      ),
      speedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_mps'],
      ),
      bearingDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bearing_degrees'],
      ),
      distanceFromPrevMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}distance_from_prev_meters'],
          )!,
      moving:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}moving'],
          )!,
      pointQuality:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}point_quality'],
          )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  ActivityPoints createAlias(String alias) {
    return ActivityPoints(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ActivityPoint extends DataClass implements Insertable<ActivityPoint> {
  final int id;
  final String sessionLocalId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double? altitudeMeters;
  final double? altitudeCorrectedMeters;
  final double? accuracyMeters;
  final double? speedMps;
  final double? bearingDegrees;
  final double distanceFromPrevMeters;
  final bool moving;
  final String pointQuality;
  final String? provider;
  final String? metadata;
  final DateTime createdAt;
  const ActivityPoint({
    required this.id,
    required this.sessionLocalId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitudeMeters,
    this.altitudeCorrectedMeters,
    this.accuracyMeters,
    this.speedMps,
    this.bearingDegrees,
    required this.distanceFromPrevMeters,
    required this.moving,
    required this.pointQuality,
    this.provider,
    this.metadata,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_local_id'] = Variable<String>(sessionLocalId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || altitudeMeters != null) {
      map['altitude_meters'] = Variable<double>(altitudeMeters);
    }
    if (!nullToAbsent || altitudeCorrectedMeters != null) {
      map['altitude_corrected_meters'] = Variable<double>(
        altitudeCorrectedMeters,
      );
    }
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    if (!nullToAbsent || speedMps != null) {
      map['speed_mps'] = Variable<double>(speedMps);
    }
    if (!nullToAbsent || bearingDegrees != null) {
      map['bearing_degrees'] = Variable<double>(bearingDegrees);
    }
    map['distance_from_prev_meters'] = Variable<double>(distanceFromPrevMeters);
    map['moving'] = Variable<bool>(moving);
    map['point_quality'] = Variable<String>(pointQuality);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityPointsCompanion toCompanion(bool nullToAbsent) {
    return ActivityPointsCompanion(
      id: Value(id),
      sessionLocalId: Value(sessionLocalId),
      timestamp: Value(timestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitudeMeters:
          altitudeMeters == null && nullToAbsent
              ? const Value.absent()
              : Value(altitudeMeters),
      altitudeCorrectedMeters:
          altitudeCorrectedMeters == null && nullToAbsent
              ? const Value.absent()
              : Value(altitudeCorrectedMeters),
      accuracyMeters:
          accuracyMeters == null && nullToAbsent
              ? const Value.absent()
              : Value(accuracyMeters),
      speedMps:
          speedMps == null && nullToAbsent
              ? const Value.absent()
              : Value(speedMps),
      bearingDegrees:
          bearingDegrees == null && nullToAbsent
              ? const Value.absent()
              : Value(bearingDegrees),
      distanceFromPrevMeters: Value(distanceFromPrevMeters),
      moving: Value(moving),
      pointQuality: Value(pointQuality),
      provider:
          provider == null && nullToAbsent
              ? const Value.absent()
              : Value(provider),
      metadata:
          metadata == null && nullToAbsent
              ? const Value.absent()
              : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityPoint(
      id: serializer.fromJson<int>(json['id']),
      sessionLocalId: serializer.fromJson<String>(json['session_local_id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitudeMeters: serializer.fromJson<double?>(json['altitude_meters']),
      altitudeCorrectedMeters: serializer.fromJson<double?>(
        json['altitude_corrected_meters'],
      ),
      accuracyMeters: serializer.fromJson<double?>(json['accuracy_meters']),
      speedMps: serializer.fromJson<double?>(json['speed_mps']),
      bearingDegrees: serializer.fromJson<double?>(json['bearing_degrees']),
      distanceFromPrevMeters: serializer.fromJson<double>(
        json['distance_from_prev_meters'],
      ),
      moving: serializer.fromJson<bool>(json['moving']),
      pointQuality: serializer.fromJson<String>(json['point_quality']),
      provider: serializer.fromJson<String?>(json['provider']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'session_local_id': serializer.toJson<String>(sessionLocalId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitude_meters': serializer.toJson<double?>(altitudeMeters),
      'altitude_corrected_meters': serializer.toJson<double?>(
        altitudeCorrectedMeters,
      ),
      'accuracy_meters': serializer.toJson<double?>(accuracyMeters),
      'speed_mps': serializer.toJson<double?>(speedMps),
      'bearing_degrees': serializer.toJson<double?>(bearingDegrees),
      'distance_from_prev_meters': serializer.toJson<double>(
        distanceFromPrevMeters,
      ),
      'moving': serializer.toJson<bool>(moving),
      'point_quality': serializer.toJson<String>(pointQuality),
      'provider': serializer.toJson<String?>(provider),
      'metadata': serializer.toJson<String?>(metadata),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityPoint copyWith({
    int? id,
    String? sessionLocalId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    Value<double?> altitudeMeters = const Value.absent(),
    Value<double?> altitudeCorrectedMeters = const Value.absent(),
    Value<double?> accuracyMeters = const Value.absent(),
    Value<double?> speedMps = const Value.absent(),
    Value<double?> bearingDegrees = const Value.absent(),
    double? distanceFromPrevMeters,
    bool? moving,
    String? pointQuality,
    Value<String?> provider = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
  }) => ActivityPoint(
    id: id ?? this.id,
    sessionLocalId: sessionLocalId ?? this.sessionLocalId,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    altitudeMeters:
        altitudeMeters.present ? altitudeMeters.value : this.altitudeMeters,
    altitudeCorrectedMeters:
        altitudeCorrectedMeters.present
            ? altitudeCorrectedMeters.value
            : this.altitudeCorrectedMeters,
    accuracyMeters:
        accuracyMeters.present ? accuracyMeters.value : this.accuracyMeters,
    speedMps: speedMps.present ? speedMps.value : this.speedMps,
    bearingDegrees:
        bearingDegrees.present ? bearingDegrees.value : this.bearingDegrees,
    distanceFromPrevMeters:
        distanceFromPrevMeters ?? this.distanceFromPrevMeters,
    moving: moving ?? this.moving,
    pointQuality: pointQuality ?? this.pointQuality,
    provider: provider.present ? provider.value : this.provider,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityPoint copyWithCompanion(ActivityPointsCompanion data) {
    return ActivityPoint(
      id: data.id.present ? data.id.value : this.id,
      sessionLocalId:
          data.sessionLocalId.present
              ? data.sessionLocalId.value
              : this.sessionLocalId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitudeMeters:
          data.altitudeMeters.present
              ? data.altitudeMeters.value
              : this.altitudeMeters,
      altitudeCorrectedMeters:
          data.altitudeCorrectedMeters.present
              ? data.altitudeCorrectedMeters.value
              : this.altitudeCorrectedMeters,
      accuracyMeters:
          data.accuracyMeters.present
              ? data.accuracyMeters.value
              : this.accuracyMeters,
      speedMps: data.speedMps.present ? data.speedMps.value : this.speedMps,
      bearingDegrees:
          data.bearingDegrees.present
              ? data.bearingDegrees.value
              : this.bearingDegrees,
      distanceFromPrevMeters:
          data.distanceFromPrevMeters.present
              ? data.distanceFromPrevMeters.value
              : this.distanceFromPrevMeters,
      moving: data.moving.present ? data.moving.value : this.moving,
      pointQuality:
          data.pointQuality.present
              ? data.pointQuality.value
              : this.pointQuality,
      provider: data.provider.present ? data.provider.value : this.provider,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPoint(')
          ..write('id: $id, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('altitudeCorrectedMeters: $altitudeCorrectedMeters, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMps: $speedMps, ')
          ..write('bearingDegrees: $bearingDegrees, ')
          ..write('distanceFromPrevMeters: $distanceFromPrevMeters, ')
          ..write('moving: $moving, ')
          ..write('pointQuality: $pointQuality, ')
          ..write('provider: $provider, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionLocalId,
    timestamp,
    latitude,
    longitude,
    altitudeMeters,
    altitudeCorrectedMeters,
    accuracyMeters,
    speedMps,
    bearingDegrees,
    distanceFromPrevMeters,
    moving,
    pointQuality,
    provider,
    metadata,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityPoint &&
          other.id == this.id &&
          other.sessionLocalId == this.sessionLocalId &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitudeMeters == this.altitudeMeters &&
          other.altitudeCorrectedMeters == this.altitudeCorrectedMeters &&
          other.accuracyMeters == this.accuracyMeters &&
          other.speedMps == this.speedMps &&
          other.bearingDegrees == this.bearingDegrees &&
          other.distanceFromPrevMeters == this.distanceFromPrevMeters &&
          other.moving == this.moving &&
          other.pointQuality == this.pointQuality &&
          other.provider == this.provider &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class ActivityPointsCompanion extends UpdateCompanion<ActivityPoint> {
  final Value<int> id;
  final Value<String> sessionLocalId;
  final Value<DateTime> timestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> altitudeMeters;
  final Value<double?> altitudeCorrectedMeters;
  final Value<double?> accuracyMeters;
  final Value<double?> speedMps;
  final Value<double?> bearingDegrees;
  final Value<double> distanceFromPrevMeters;
  final Value<bool> moving;
  final Value<String> pointQuality;
  final Value<String?> provider;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  const ActivityPointsCompanion({
    this.id = const Value.absent(),
    this.sessionLocalId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeMeters = const Value.absent(),
    this.altitudeCorrectedMeters = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.speedMps = const Value.absent(),
    this.bearingDegrees = const Value.absent(),
    this.distanceFromPrevMeters = const Value.absent(),
    this.moving = const Value.absent(),
    this.pointQuality = const Value.absent(),
    this.provider = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivityPointsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionLocalId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    this.altitudeMeters = const Value.absent(),
    this.altitudeCorrectedMeters = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.speedMps = const Value.absent(),
    this.bearingDegrees = const Value.absent(),
    this.distanceFromPrevMeters = const Value.absent(),
    this.moving = const Value.absent(),
    this.pointQuality = const Value.absent(),
    this.provider = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionLocalId = Value(sessionLocalId),
       timestamp = Value(timestamp),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<ActivityPoint> custom({
    Expression<int>? id,
    Expression<String>? sessionLocalId,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitudeMeters,
    Expression<double>? altitudeCorrectedMeters,
    Expression<double>? accuracyMeters,
    Expression<double>? speedMps,
    Expression<double>? bearingDegrees,
    Expression<double>? distanceFromPrevMeters,
    Expression<bool>? moving,
    Expression<String>? pointQuality,
    Expression<String>? provider,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionLocalId != null) 'session_local_id': sessionLocalId,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitudeMeters != null) 'altitude_meters': altitudeMeters,
      if (altitudeCorrectedMeters != null)
        'altitude_corrected_meters': altitudeCorrectedMeters,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (speedMps != null) 'speed_mps': speedMps,
      if (bearingDegrees != null) 'bearing_degrees': bearingDegrees,
      if (distanceFromPrevMeters != null)
        'distance_from_prev_meters': distanceFromPrevMeters,
      if (moving != null) 'moving': moving,
      if (pointQuality != null) 'point_quality': pointQuality,
      if (provider != null) 'provider': provider,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivityPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionLocalId,
    Value<DateTime>? timestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? altitudeMeters,
    Value<double?>? altitudeCorrectedMeters,
    Value<double?>? accuracyMeters,
    Value<double?>? speedMps,
    Value<double?>? bearingDegrees,
    Value<double>? distanceFromPrevMeters,
    Value<bool>? moving,
    Value<String>? pointQuality,
    Value<String?>? provider,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
  }) {
    return ActivityPointsCompanion(
      id: id ?? this.id,
      sessionLocalId: sessionLocalId ?? this.sessionLocalId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      altitudeCorrectedMeters:
          altitudeCorrectedMeters ?? this.altitudeCorrectedMeters,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      speedMps: speedMps ?? this.speedMps,
      bearingDegrees: bearingDegrees ?? this.bearingDegrees,
      distanceFromPrevMeters:
          distanceFromPrevMeters ?? this.distanceFromPrevMeters,
      moving: moving ?? this.moving,
      pointQuality: pointQuality ?? this.pointQuality,
      provider: provider ?? this.provider,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionLocalId.present) {
      map['session_local_id'] = Variable<String>(sessionLocalId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitudeMeters.present) {
      map['altitude_meters'] = Variable<double>(altitudeMeters.value);
    }
    if (altitudeCorrectedMeters.present) {
      map['altitude_corrected_meters'] = Variable<double>(
        altitudeCorrectedMeters.value,
      );
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (speedMps.present) {
      map['speed_mps'] = Variable<double>(speedMps.value);
    }
    if (bearingDegrees.present) {
      map['bearing_degrees'] = Variable<double>(bearingDegrees.value);
    }
    if (distanceFromPrevMeters.present) {
      map['distance_from_prev_meters'] = Variable<double>(
        distanceFromPrevMeters.value,
      );
    }
    if (moving.present) {
      map['moving'] = Variable<bool>(moving.value);
    }
    if (pointQuality.present) {
      map['point_quality'] = Variable<String>(pointQuality.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPointsCompanion(')
          ..write('id: $id, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('altitudeCorrectedMeters: $altitudeCorrectedMeters, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMps: $speedMps, ')
          ..write('bearingDegrees: $bearingDegrees, ')
          ..write('distanceFromPrevMeters: $distanceFromPrevMeters, ')
          ..write('moving: $moving, ')
          ..write('pointQuality: $pointQuality, ')
          ..write('provider: $provider, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class ActivitySummaries extends Table
    with TableInfo<ActivitySummaries, ActivitySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ActivitySummaries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionLocalIdMeta = const VerificationMeta(
    'sessionLocalId',
  );
  late final GeneratedColumn<String> sessionLocalId = GeneratedColumn<String>(
    'session_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _jsonSummaryMeta = const VerificationMeta(
    'jsonSummary',
  );
  late final GeneratedColumn<String> jsonSummary = GeneratedColumn<String>(
    'json_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _markdownSummaryMeta = const VerificationMeta(
    'markdownSummary',
  );
  late final GeneratedColumn<String> markdownSummary = GeneratedColumn<String>(
    'markdown_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _generatedByMeta = const VerificationMeta(
    'generatedBy',
  );
  late final GeneratedColumn<String> generatedBy = GeneratedColumn<String>(
    'generated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'local\'',
    defaultValue: const CustomExpression('\'local\''),
  );
  static const VerificationMeta _agentNotesMeta = const VerificationMeta(
    'agentNotes',
  );
  late final GeneratedColumn<String> agentNotes = GeneratedColumn<String>(
    'agent_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'pending\'',
    defaultValue: const CustomExpression('\'pending\''),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionLocalId,
    jsonSummary,
    markdownSummary,
    generatedAt,
    model,
    confidence,
    generatedBy,
    agentNotes,
    syncStatus,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivitySummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_local_id')) {
      context.handle(
        _sessionLocalIdMeta,
        sessionLocalId.isAcceptableOrUnknown(
          data['session_local_id']!,
          _sessionLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionLocalIdMeta);
    }
    if (data.containsKey('json_summary')) {
      context.handle(
        _jsonSummaryMeta,
        jsonSummary.isAcceptableOrUnknown(
          data['json_summary']!,
          _jsonSummaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jsonSummaryMeta);
    }
    if (data.containsKey('markdown_summary')) {
      context.handle(
        _markdownSummaryMeta,
        markdownSummary.isAcceptableOrUnknown(
          data['markdown_summary']!,
          _markdownSummaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_markdownSummaryMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('generated_by')) {
      context.handle(
        _generatedByMeta,
        generatedBy.isAcceptableOrUnknown(
          data['generated_by']!,
          _generatedByMeta,
        ),
      );
    }
    if (data.containsKey('agent_notes')) {
      context.handle(
        _agentNotesMeta,
        agentNotes.isAcceptableOrUnknown(data['agent_notes']!, _agentNotesMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionLocalId};
  @override
  ActivitySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitySummary(
      sessionLocalId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_local_id'],
          )!,
      jsonSummary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}json_summary'],
          )!,
      markdownSummary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}markdown_summary'],
          )!,
      generatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}generated_at'],
          )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      generatedBy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}generated_by'],
          )!,
      agentNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agent_notes'],
      ),
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  ActivitySummaries createAlias(String alias) {
    return ActivitySummaries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ActivitySummary extends DataClass implements Insertable<ActivitySummary> {
  final String sessionLocalId;
  final String jsonSummary;
  final String markdownSummary;
  final DateTime generatedAt;
  final String? model;
  final String? confidence;
  final String generatedBy;
  final String? agentNotes;
  final String syncStatus;
  final DateTime? syncedAt;
  const ActivitySummary({
    required this.sessionLocalId,
    required this.jsonSummary,
    required this.markdownSummary,
    required this.generatedAt,
    this.model,
    this.confidence,
    required this.generatedBy,
    this.agentNotes,
    required this.syncStatus,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_local_id'] = Variable<String>(sessionLocalId);
    map['json_summary'] = Variable<String>(jsonSummary);
    map['markdown_summary'] = Variable<String>(markdownSummary);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    map['generated_by'] = Variable<String>(generatedBy);
    if (!nullToAbsent || agentNotes != null) {
      map['agent_notes'] = Variable<String>(agentNotes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ActivitySummariesCompanion toCompanion(bool nullToAbsent) {
    return ActivitySummariesCompanion(
      sessionLocalId: Value(sessionLocalId),
      jsonSummary: Value(jsonSummary),
      markdownSummary: Value(markdownSummary),
      generatedAt: Value(generatedAt),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      confidence:
          confidence == null && nullToAbsent
              ? const Value.absent()
              : Value(confidence),
      generatedBy: Value(generatedBy),
      agentNotes:
          agentNotes == null && nullToAbsent
              ? const Value.absent()
              : Value(agentNotes),
      syncStatus: Value(syncStatus),
      syncedAt:
          syncedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(syncedAt),
    );
  }

  factory ActivitySummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitySummary(
      sessionLocalId: serializer.fromJson<String>(json['session_local_id']),
      jsonSummary: serializer.fromJson<String>(json['json_summary']),
      markdownSummary: serializer.fromJson<String>(json['markdown_summary']),
      generatedAt: serializer.fromJson<DateTime>(json['generated_at']),
      model: serializer.fromJson<String?>(json['model']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      generatedBy: serializer.fromJson<String>(json['generated_by']),
      agentNotes: serializer.fromJson<String?>(json['agent_notes']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      syncedAt: serializer.fromJson<DateTime?>(json['synced_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'session_local_id': serializer.toJson<String>(sessionLocalId),
      'json_summary': serializer.toJson<String>(jsonSummary),
      'markdown_summary': serializer.toJson<String>(markdownSummary),
      'generated_at': serializer.toJson<DateTime>(generatedAt),
      'model': serializer.toJson<String?>(model),
      'confidence': serializer.toJson<String?>(confidence),
      'generated_by': serializer.toJson<String>(generatedBy),
      'agent_notes': serializer.toJson<String?>(agentNotes),
      'sync_status': serializer.toJson<String>(syncStatus),
      'synced_at': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ActivitySummary copyWith({
    String? sessionLocalId,
    String? jsonSummary,
    String? markdownSummary,
    DateTime? generatedAt,
    Value<String?> model = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    String? generatedBy,
    Value<String?> agentNotes = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => ActivitySummary(
    sessionLocalId: sessionLocalId ?? this.sessionLocalId,
    jsonSummary: jsonSummary ?? this.jsonSummary,
    markdownSummary: markdownSummary ?? this.markdownSummary,
    generatedAt: generatedAt ?? this.generatedAt,
    model: model.present ? model.value : this.model,
    confidence: confidence.present ? confidence.value : this.confidence,
    generatedBy: generatedBy ?? this.generatedBy,
    agentNotes: agentNotes.present ? agentNotes.value : this.agentNotes,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  ActivitySummary copyWithCompanion(ActivitySummariesCompanion data) {
    return ActivitySummary(
      sessionLocalId:
          data.sessionLocalId.present
              ? data.sessionLocalId.value
              : this.sessionLocalId,
      jsonSummary:
          data.jsonSummary.present ? data.jsonSummary.value : this.jsonSummary,
      markdownSummary:
          data.markdownSummary.present
              ? data.markdownSummary.value
              : this.markdownSummary,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      model: data.model.present ? data.model.value : this.model,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      generatedBy:
          data.generatedBy.present ? data.generatedBy.value : this.generatedBy,
      agentNotes:
          data.agentNotes.present ? data.agentNotes.value : this.agentNotes,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySummary(')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('jsonSummary: $jsonSummary, ')
          ..write('markdownSummary: $markdownSummary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('model: $model, ')
          ..write('confidence: $confidence, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('agentNotes: $agentNotes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionLocalId,
    jsonSummary,
    markdownSummary,
    generatedAt,
    model,
    confidence,
    generatedBy,
    agentNotes,
    syncStatus,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitySummary &&
          other.sessionLocalId == this.sessionLocalId &&
          other.jsonSummary == this.jsonSummary &&
          other.markdownSummary == this.markdownSummary &&
          other.generatedAt == this.generatedAt &&
          other.model == this.model &&
          other.confidence == this.confidence &&
          other.generatedBy == this.generatedBy &&
          other.agentNotes == this.agentNotes &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class ActivitySummariesCompanion extends UpdateCompanion<ActivitySummary> {
  final Value<String> sessionLocalId;
  final Value<String> jsonSummary;
  final Value<String> markdownSummary;
  final Value<DateTime> generatedAt;
  final Value<String?> model;
  final Value<String?> confidence;
  final Value<String> generatedBy;
  final Value<String?> agentNotes;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ActivitySummariesCompanion({
    this.sessionLocalId = const Value.absent(),
    this.jsonSummary = const Value.absent(),
    this.markdownSummary = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.model = const Value.absent(),
    this.confidence = const Value.absent(),
    this.generatedBy = const Value.absent(),
    this.agentNotes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitySummariesCompanion.insert({
    required String sessionLocalId,
    required String jsonSummary,
    required String markdownSummary,
    required DateTime generatedAt,
    this.model = const Value.absent(),
    this.confidence = const Value.absent(),
    this.generatedBy = const Value.absent(),
    this.agentNotes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionLocalId = Value(sessionLocalId),
       jsonSummary = Value(jsonSummary),
       markdownSummary = Value(markdownSummary),
       generatedAt = Value(generatedAt);
  static Insertable<ActivitySummary> custom({
    Expression<String>? sessionLocalId,
    Expression<String>? jsonSummary,
    Expression<String>? markdownSummary,
    Expression<DateTime>? generatedAt,
    Expression<String>? model,
    Expression<String>? confidence,
    Expression<String>? generatedBy,
    Expression<String>? agentNotes,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionLocalId != null) 'session_local_id': sessionLocalId,
      if (jsonSummary != null) 'json_summary': jsonSummary,
      if (markdownSummary != null) 'markdown_summary': markdownSummary,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (model != null) 'model': model,
      if (confidence != null) 'confidence': confidence,
      if (generatedBy != null) 'generated_by': generatedBy,
      if (agentNotes != null) 'agent_notes': agentNotes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitySummariesCompanion copyWith({
    Value<String>? sessionLocalId,
    Value<String>? jsonSummary,
    Value<String>? markdownSummary,
    Value<DateTime>? generatedAt,
    Value<String?>? model,
    Value<String?>? confidence,
    Value<String>? generatedBy,
    Value<String?>? agentNotes,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return ActivitySummariesCompanion(
      sessionLocalId: sessionLocalId ?? this.sessionLocalId,
      jsonSummary: jsonSummary ?? this.jsonSummary,
      markdownSummary: markdownSummary ?? this.markdownSummary,
      generatedAt: generatedAt ?? this.generatedAt,
      model: model ?? this.model,
      confidence: confidence ?? this.confidence,
      generatedBy: generatedBy ?? this.generatedBy,
      agentNotes: agentNotes ?? this.agentNotes,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionLocalId.present) {
      map['session_local_id'] = Variable<String>(sessionLocalId.value);
    }
    if (jsonSummary.present) {
      map['json_summary'] = Variable<String>(jsonSummary.value);
    }
    if (markdownSummary.present) {
      map['markdown_summary'] = Variable<String>(markdownSummary.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (generatedBy.present) {
      map['generated_by'] = Variable<String>(generatedBy.value);
    }
    if (agentNotes.present) {
      map['agent_notes'] = Variable<String>(agentNotes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySummariesCompanion(')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('jsonSummary: $jsonSummary, ')
          ..write('markdownSummary: $markdownSummary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('model: $model, ')
          ..write('confidence: $confidence, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('agentNotes: $agentNotes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class OfflineMapRegions extends Table
    with TableInfo<OfflineMapRegions, OfflineMapRegion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OfflineMapRegions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _boundsMeta = const VerificationMeta('bounds');
  late final GeneratedColumn<String> bounds = GeneratedColumn<String>(
    'bounds',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _minZoomMeta = const VerificationMeta(
    'minZoom',
  );
  late final GeneratedColumn<int> minZoom = GeneratedColumn<int>(
    'min_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _maxZoomMeta = const VerificationMeta(
    'maxZoom',
  );
  late final GeneratedColumn<int> maxZoom = GeneratedColumn<int>(
    'max_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _styleMeta = const VerificationMeta('style');
  late final GeneratedColumn<String> style = GeneratedColumn<String>(
    'style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _storageBytesMeta = const VerificationMeta(
    'storageBytes',
  );
  late final GeneratedColumn<int> storageBytes = GeneratedColumn<int>(
    'storage_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'planned\'',
    defaultValue: const CustomExpression('\'planned\''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bounds,
    minZoom,
    maxZoom,
    style,
    storageBytes,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_map_regions';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineMapRegion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bounds')) {
      context.handle(
        _boundsMeta,
        bounds.isAcceptableOrUnknown(data['bounds']!, _boundsMeta),
      );
    } else if (isInserting) {
      context.missing(_boundsMeta);
    }
    if (data.containsKey('min_zoom')) {
      context.handle(
        _minZoomMeta,
        minZoom.isAcceptableOrUnknown(data['min_zoom']!, _minZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_minZoomMeta);
    }
    if (data.containsKey('max_zoom')) {
      context.handle(
        _maxZoomMeta,
        maxZoom.isAcceptableOrUnknown(data['max_zoom']!, _maxZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_maxZoomMeta);
    }
    if (data.containsKey('style')) {
      context.handle(
        _styleMeta,
        style.isAcceptableOrUnknown(data['style']!, _styleMeta),
      );
    } else if (isInserting) {
      context.missing(_styleMeta);
    }
    if (data.containsKey('storage_bytes')) {
      context.handle(
        _storageBytesMeta,
        storageBytes.isAcceptableOrUnknown(
          data['storage_bytes']!,
          _storageBytesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineMapRegion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineMapRegion(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      bounds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bounds'],
          )!,
      minZoom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}min_zoom'],
          )!,
      maxZoom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_zoom'],
          )!,
      style:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}style'],
          )!,
      storageBytes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}storage_bytes'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  OfflineMapRegions createAlias(String alias) {
    return OfflineMapRegions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OfflineMapRegion extends DataClass
    implements Insertable<OfflineMapRegion> {
  final int id;
  final String name;
  final String bounds;
  final int minZoom;
  final int maxZoom;
  final String style;
  final int storageBytes;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const OfflineMapRegion({
    required this.id,
    required this.name,
    required this.bounds,
    required this.minZoom,
    required this.maxZoom,
    required this.style,
    required this.storageBytes,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['bounds'] = Variable<String>(bounds);
    map['min_zoom'] = Variable<int>(minZoom);
    map['max_zoom'] = Variable<int>(maxZoom);
    map['style'] = Variable<String>(style);
    map['storage_bytes'] = Variable<int>(storageBytes);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  OfflineMapRegionsCompanion toCompanion(bool nullToAbsent) {
    return OfflineMapRegionsCompanion(
      id: Value(id),
      name: Value(name),
      bounds: Value(bounds),
      minZoom: Value(minZoom),
      maxZoom: Value(maxZoom),
      style: Value(style),
      storageBytes: Value(storageBytes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory OfflineMapRegion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineMapRegion(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bounds: serializer.fromJson<String>(json['bounds']),
      minZoom: serializer.fromJson<int>(json['min_zoom']),
      maxZoom: serializer.fromJson<int>(json['max_zoom']),
      style: serializer.fromJson<String>(json['style']),
      storageBytes: serializer.fromJson<int>(json['storage_bytes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bounds': serializer.toJson<String>(bounds),
      'min_zoom': serializer.toJson<int>(minZoom),
      'max_zoom': serializer.toJson<int>(maxZoom),
      'style': serializer.toJson<String>(style),
      'storage_bytes': serializer.toJson<int>(storageBytes),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  OfflineMapRegion copyWith({
    int? id,
    String? name,
    String? bounds,
    int? minZoom,
    int? maxZoom,
    String? style,
    int? storageBytes,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => OfflineMapRegion(
    id: id ?? this.id,
    name: name ?? this.name,
    bounds: bounds ?? this.bounds,
    minZoom: minZoom ?? this.minZoom,
    maxZoom: maxZoom ?? this.maxZoom,
    style: style ?? this.style,
    storageBytes: storageBytes ?? this.storageBytes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  OfflineMapRegion copyWithCompanion(OfflineMapRegionsCompanion data) {
    return OfflineMapRegion(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bounds: data.bounds.present ? data.bounds.value : this.bounds,
      minZoom: data.minZoom.present ? data.minZoom.value : this.minZoom,
      maxZoom: data.maxZoom.present ? data.maxZoom.value : this.maxZoom,
      style: data.style.present ? data.style.value : this.style,
      storageBytes:
          data.storageBytes.present
              ? data.storageBytes.value
              : this.storageBytes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineMapRegion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bounds: $bounds, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('style: $style, ')
          ..write('storageBytes: $storageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    bounds,
    minZoom,
    maxZoom,
    style,
    storageBytes,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineMapRegion &&
          other.id == this.id &&
          other.name == this.name &&
          other.bounds == this.bounds &&
          other.minZoom == this.minZoom &&
          other.maxZoom == this.maxZoom &&
          other.style == this.style &&
          other.storageBytes == this.storageBytes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OfflineMapRegionsCompanion extends UpdateCompanion<OfflineMapRegion> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bounds;
  final Value<int> minZoom;
  final Value<int> maxZoom;
  final Value<String> style;
  final Value<int> storageBytes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const OfflineMapRegionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bounds = const Value.absent(),
    this.minZoom = const Value.absent(),
    this.maxZoom = const Value.absent(),
    this.style = const Value.absent(),
    this.storageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OfflineMapRegionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bounds,
    required int minZoom,
    required int maxZoom,
    required String style,
    this.storageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       bounds = Value(bounds),
       minZoom = Value(minZoom),
       maxZoom = Value(maxZoom),
       style = Value(style);
  static Insertable<OfflineMapRegion> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bounds,
    Expression<int>? minZoom,
    Expression<int>? maxZoom,
    Expression<String>? style,
    Expression<int>? storageBytes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bounds != null) 'bounds': bounds,
      if (minZoom != null) 'min_zoom': minZoom,
      if (maxZoom != null) 'max_zoom': maxZoom,
      if (style != null) 'style': style,
      if (storageBytes != null) 'storage_bytes': storageBytes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OfflineMapRegionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? bounds,
    Value<int>? minZoom,
    Value<int>? maxZoom,
    Value<String>? style,
    Value<int>? storageBytes,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return OfflineMapRegionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bounds: bounds ?? this.bounds,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      style: style ?? this.style,
      storageBytes: storageBytes ?? this.storageBytes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bounds.present) {
      map['bounds'] = Variable<String>(bounds.value);
    }
    if (minZoom.present) {
      map['min_zoom'] = Variable<int>(minZoom.value);
    }
    if (maxZoom.present) {
      map['max_zoom'] = Variable<int>(maxZoom.value);
    }
    if (style.present) {
      map['style'] = Variable<String>(style.value);
    }
    if (storageBytes.present) {
      map['storage_bytes'] = Variable<int>(storageBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineMapRegionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bounds: $bounds, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('style: $style, ')
          ..write('storageBytes: $storageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class SavedRoutes extends Table with TableInfo<SavedRoutes, SavedRoute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SavedRoutes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _sourceSessionLocalIdMeta =
      const VerificationMeta('sourceSessionLocalId');
  late final GeneratedColumn<String> sourceSessionLocalId =
      GeneratedColumn<String>(
        'source_session_local_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sportKeyMeta = const VerificationMeta(
    'sportKey',
  );
  late final GeneratedColumn<String> sportKey = GeneratedColumn<String>(
    'sport_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _ascentMetersMeta = const VerificationMeta(
    'ascentMeters',
  );
  late final GeneratedColumn<double> ascentMeters = GeneratedColumn<double>(
    'ascent_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _descentMetersMeta = const VerificationMeta(
    'descentMeters',
  );
  late final GeneratedColumn<double> descentMeters = GeneratedColumn<double>(
    'descent_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _pointCountMeta = const VerificationMeta(
    'pointCount',
  );
  late final GeneratedColumn<int> pointCount = GeneratedColumn<int>(
    'point_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _routeVisibilityMeta = const VerificationMeta(
    'routeVisibility',
  );
  late final GeneratedColumn<String> routeVisibility = GeneratedColumn<String>(
    'route_visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'private\'',
    defaultValue: const CustomExpression('\'private\''),
  );
  static const VerificationMeta _hideStartEndMetersMeta =
      const VerificationMeta('hideStartEndMeters');
  late final GeneratedColumn<double> hideStartEndMeters =
      GeneratedColumn<double>(
        'hide_start_end_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        $customConstraints: 'NOT NULL DEFAULT 300',
        defaultValue: const CustomExpression('300'),
      );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    sourceSessionLocalId,
    name,
    sportKey,
    distanceMeters,
    ascentMeters,
    descentMeters,
    pointCount,
    routeVisibility,
    hideStartEndMeters,
    summaryJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedRoute> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('source_session_local_id')) {
      context.handle(
        _sourceSessionLocalIdMeta,
        sourceSessionLocalId.isAcceptableOrUnknown(
          data['source_session_local_id']!,
          _sourceSessionLocalIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sport_key')) {
      context.handle(
        _sportKeyMeta,
        sportKey.isAcceptableOrUnknown(data['sport_key']!, _sportKeyMeta),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('ascent_meters')) {
      context.handle(
        _ascentMetersMeta,
        ascentMeters.isAcceptableOrUnknown(
          data['ascent_meters']!,
          _ascentMetersMeta,
        ),
      );
    }
    if (data.containsKey('descent_meters')) {
      context.handle(
        _descentMetersMeta,
        descentMeters.isAcceptableOrUnknown(
          data['descent_meters']!,
          _descentMetersMeta,
        ),
      );
    }
    if (data.containsKey('point_count')) {
      context.handle(
        _pointCountMeta,
        pointCount.isAcceptableOrUnknown(data['point_count']!, _pointCountMeta),
      );
    }
    if (data.containsKey('route_visibility')) {
      context.handle(
        _routeVisibilityMeta,
        routeVisibility.isAcceptableOrUnknown(
          data['route_visibility']!,
          _routeVisibilityMeta,
        ),
      );
    }
    if (data.containsKey('hide_start_end_meters')) {
      context.handle(
        _hideStartEndMetersMeta,
        hideStartEndMeters.isAcceptableOrUnknown(
          data['hide_start_end_meters']!,
          _hideStartEndMetersMeta,
        ),
      );
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedRoute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedRoute(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      sourceSessionLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_session_local_id'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      sportKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sport_key'],
      ),
      distanceMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}distance_meters'],
          )!,
      ascentMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}ascent_meters'],
          )!,
      descentMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}descent_meters'],
          )!,
      pointCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}point_count'],
          )!,
      routeVisibility:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}route_visibility'],
          )!,
      hideStartEndMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}hide_start_end_meters'],
          )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  SavedRoutes createAlias(String alias) {
    return SavedRoutes(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SavedRoute extends DataClass implements Insertable<SavedRoute> {
  final int id;
  final String localId;
  final String? sourceSessionLocalId;
  final String name;
  final String? sportKey;
  final double distanceMeters;
  final double ascentMeters;
  final double descentMeters;
  final int pointCount;
  final String routeVisibility;
  final double hideStartEndMeters;
  final String? summaryJson;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const SavedRoute({
    required this.id,
    required this.localId,
    this.sourceSessionLocalId,
    required this.name,
    this.sportKey,
    required this.distanceMeters,
    required this.ascentMeters,
    required this.descentMeters,
    required this.pointCount,
    required this.routeVisibility,
    required this.hideStartEndMeters,
    this.summaryJson,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || sourceSessionLocalId != null) {
      map['source_session_local_id'] = Variable<String>(sourceSessionLocalId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sportKey != null) {
      map['sport_key'] = Variable<String>(sportKey);
    }
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['ascent_meters'] = Variable<double>(ascentMeters);
    map['descent_meters'] = Variable<double>(descentMeters);
    map['point_count'] = Variable<int>(pointCount);
    map['route_visibility'] = Variable<String>(routeVisibility);
    map['hide_start_end_meters'] = Variable<double>(hideStartEndMeters);
    if (!nullToAbsent || summaryJson != null) {
      map['summary_json'] = Variable<String>(summaryJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SavedRoutesCompanion toCompanion(bool nullToAbsent) {
    return SavedRoutesCompanion(
      id: Value(id),
      localId: Value(localId),
      sourceSessionLocalId:
          sourceSessionLocalId == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceSessionLocalId),
      name: Value(name),
      sportKey:
          sportKey == null && nullToAbsent
              ? const Value.absent()
              : Value(sportKey),
      distanceMeters: Value(distanceMeters),
      ascentMeters: Value(ascentMeters),
      descentMeters: Value(descentMeters),
      pointCount: Value(pointCount),
      routeVisibility: Value(routeVisibility),
      hideStartEndMeters: Value(hideStartEndMeters),
      summaryJson:
          summaryJson == null && nullToAbsent
              ? const Value.absent()
              : Value(summaryJson),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory SavedRoute.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedRoute(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      sourceSessionLocalId: serializer.fromJson<String?>(
        json['source_session_local_id'],
      ),
      name: serializer.fromJson<String>(json['name']),
      sportKey: serializer.fromJson<String?>(json['sport_key']),
      distanceMeters: serializer.fromJson<double>(json['distance_meters']),
      ascentMeters: serializer.fromJson<double>(json['ascent_meters']),
      descentMeters: serializer.fromJson<double>(json['descent_meters']),
      pointCount: serializer.fromJson<int>(json['point_count']),
      routeVisibility: serializer.fromJson<String>(json['route_visibility']),
      hideStartEndMeters: serializer.fromJson<double>(
        json['hide_start_end_meters'],
      ),
      summaryJson: serializer.fromJson<String?>(json['summary_json']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'source_session_local_id': serializer.toJson<String?>(
        sourceSessionLocalId,
      ),
      'name': serializer.toJson<String>(name),
      'sport_key': serializer.toJson<String?>(sportKey),
      'distance_meters': serializer.toJson<double>(distanceMeters),
      'ascent_meters': serializer.toJson<double>(ascentMeters),
      'descent_meters': serializer.toJson<double>(descentMeters),
      'point_count': serializer.toJson<int>(pointCount),
      'route_visibility': serializer.toJson<String>(routeVisibility),
      'hide_start_end_meters': serializer.toJson<double>(hideStartEndMeters),
      'summary_json': serializer.toJson<String?>(summaryJson),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SavedRoute copyWith({
    int? id,
    String? localId,
    Value<String?> sourceSessionLocalId = const Value.absent(),
    String? name,
    Value<String?> sportKey = const Value.absent(),
    double? distanceMeters,
    double? ascentMeters,
    double? descentMeters,
    int? pointCount,
    String? routeVisibility,
    double? hideStartEndMeters,
    Value<String?> summaryJson = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => SavedRoute(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    sourceSessionLocalId:
        sourceSessionLocalId.present
            ? sourceSessionLocalId.value
            : this.sourceSessionLocalId,
    name: name ?? this.name,
    sportKey: sportKey.present ? sportKey.value : this.sportKey,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    ascentMeters: ascentMeters ?? this.ascentMeters,
    descentMeters: descentMeters ?? this.descentMeters,
    pointCount: pointCount ?? this.pointCount,
    routeVisibility: routeVisibility ?? this.routeVisibility,
    hideStartEndMeters: hideStartEndMeters ?? this.hideStartEndMeters,
    summaryJson: summaryJson.present ? summaryJson.value : this.summaryJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  SavedRoute copyWithCompanion(SavedRoutesCompanion data) {
    return SavedRoute(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      sourceSessionLocalId:
          data.sourceSessionLocalId.present
              ? data.sourceSessionLocalId.value
              : this.sourceSessionLocalId,
      name: data.name.present ? data.name.value : this.name,
      sportKey: data.sportKey.present ? data.sportKey.value : this.sportKey,
      distanceMeters:
          data.distanceMeters.present
              ? data.distanceMeters.value
              : this.distanceMeters,
      ascentMeters:
          data.ascentMeters.present
              ? data.ascentMeters.value
              : this.ascentMeters,
      descentMeters:
          data.descentMeters.present
              ? data.descentMeters.value
              : this.descentMeters,
      pointCount:
          data.pointCount.present ? data.pointCount.value : this.pointCount,
      routeVisibility:
          data.routeVisibility.present
              ? data.routeVisibility.value
              : this.routeVisibility,
      hideStartEndMeters:
          data.hideStartEndMeters.present
              ? data.hideStartEndMeters.value
              : this.hideStartEndMeters,
      summaryJson:
          data.summaryJson.present ? data.summaryJson.value : this.summaryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoute(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sourceSessionLocalId: $sourceSessionLocalId, ')
          ..write('name: $name, ')
          ..write('sportKey: $sportKey, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('ascentMeters: $ascentMeters, ')
          ..write('descentMeters: $descentMeters, ')
          ..write('pointCount: $pointCount, ')
          ..write('routeVisibility: $routeVisibility, ')
          ..write('hideStartEndMeters: $hideStartEndMeters, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    sourceSessionLocalId,
    name,
    sportKey,
    distanceMeters,
    ascentMeters,
    descentMeters,
    pointCount,
    routeVisibility,
    hideStartEndMeters,
    summaryJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedRoute &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.sourceSessionLocalId == this.sourceSessionLocalId &&
          other.name == this.name &&
          other.sportKey == this.sportKey &&
          other.distanceMeters == this.distanceMeters &&
          other.ascentMeters == this.ascentMeters &&
          other.descentMeters == this.descentMeters &&
          other.pointCount == this.pointCount &&
          other.routeVisibility == this.routeVisibility &&
          other.hideStartEndMeters == this.hideStartEndMeters &&
          other.summaryJson == this.summaryJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavedRoutesCompanion extends UpdateCompanion<SavedRoute> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String?> sourceSessionLocalId;
  final Value<String> name;
  final Value<String?> sportKey;
  final Value<double> distanceMeters;
  final Value<double> ascentMeters;
  final Value<double> descentMeters;
  final Value<int> pointCount;
  final Value<String> routeVisibility;
  final Value<double> hideStartEndMeters;
  final Value<String?> summaryJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const SavedRoutesCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.sourceSessionLocalId = const Value.absent(),
    this.name = const Value.absent(),
    this.sportKey = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.ascentMeters = const Value.absent(),
    this.descentMeters = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.routeVisibility = const Value.absent(),
    this.hideStartEndMeters = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SavedRoutesCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    this.sourceSessionLocalId = const Value.absent(),
    required String name,
    this.sportKey = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.ascentMeters = const Value.absent(),
    this.descentMeters = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.routeVisibility = const Value.absent(),
    this.hideStartEndMeters = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : localId = Value(localId),
       name = Value(name);
  static Insertable<SavedRoute> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? sourceSessionLocalId,
    Expression<String>? name,
    Expression<String>? sportKey,
    Expression<double>? distanceMeters,
    Expression<double>? ascentMeters,
    Expression<double>? descentMeters,
    Expression<int>? pointCount,
    Expression<String>? routeVisibility,
    Expression<double>? hideStartEndMeters,
    Expression<String>? summaryJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (sourceSessionLocalId != null)
        'source_session_local_id': sourceSessionLocalId,
      if (name != null) 'name': name,
      if (sportKey != null) 'sport_key': sportKey,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (ascentMeters != null) 'ascent_meters': ascentMeters,
      if (descentMeters != null) 'descent_meters': descentMeters,
      if (pointCount != null) 'point_count': pointCount,
      if (routeVisibility != null) 'route_visibility': routeVisibility,
      if (hideStartEndMeters != null)
        'hide_start_end_meters': hideStartEndMeters,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SavedRoutesCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String?>? sourceSessionLocalId,
    Value<String>? name,
    Value<String?>? sportKey,
    Value<double>? distanceMeters,
    Value<double>? ascentMeters,
    Value<double>? descentMeters,
    Value<int>? pointCount,
    Value<String>? routeVisibility,
    Value<double>? hideStartEndMeters,
    Value<String?>? summaryJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return SavedRoutesCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      sourceSessionLocalId: sourceSessionLocalId ?? this.sourceSessionLocalId,
      name: name ?? this.name,
      sportKey: sportKey ?? this.sportKey,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      ascentMeters: ascentMeters ?? this.ascentMeters,
      descentMeters: descentMeters ?? this.descentMeters,
      pointCount: pointCount ?? this.pointCount,
      routeVisibility: routeVisibility ?? this.routeVisibility,
      hideStartEndMeters: hideStartEndMeters ?? this.hideStartEndMeters,
      summaryJson: summaryJson ?? this.summaryJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (sourceSessionLocalId.present) {
      map['source_session_local_id'] = Variable<String>(
        sourceSessionLocalId.value,
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sportKey.present) {
      map['sport_key'] = Variable<String>(sportKey.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (ascentMeters.present) {
      map['ascent_meters'] = Variable<double>(ascentMeters.value);
    }
    if (descentMeters.present) {
      map['descent_meters'] = Variable<double>(descentMeters.value);
    }
    if (pointCount.present) {
      map['point_count'] = Variable<int>(pointCount.value);
    }
    if (routeVisibility.present) {
      map['route_visibility'] = Variable<String>(routeVisibility.value);
    }
    if (hideStartEndMeters.present) {
      map['hide_start_end_meters'] = Variable<double>(hideStartEndMeters.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoutesCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sourceSessionLocalId: $sourceSessionLocalId, ')
          ..write('name: $name, ')
          ..write('sportKey: $sportKey, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('ascentMeters: $ascentMeters, ')
          ..write('descentMeters: $descentMeters, ')
          ..write('pointCount: $pointCount, ')
          ..write('routeVisibility: $routeVisibility, ')
          ..write('hideStartEndMeters: $hideStartEndMeters, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class DailySummaries extends Table
    with TableInfo<DailySummaries, DailySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DailySummaries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _jsonSummaryMeta = const VerificationMeta(
    'jsonSummary',
  );
  late final GeneratedColumn<String> jsonSummary = GeneratedColumn<String>(
    'json_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _markdownSummaryMeta = const VerificationMeta(
    'markdownSummary',
  );
  late final GeneratedColumn<String> markdownSummary = GeneratedColumn<String>(
    'markdown_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'pending\'',
    defaultValue: const CustomExpression('\'pending\''),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    localDate,
    jsonSummary,
    markdownSummary,
    generatedAt,
    model,
    confidence,
    syncStatus,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('json_summary')) {
      context.handle(
        _jsonSummaryMeta,
        jsonSummary.isAcceptableOrUnknown(
          data['json_summary']!,
          _jsonSummaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jsonSummaryMeta);
    }
    if (data.containsKey('markdown_summary')) {
      context.handle(
        _markdownSummaryMeta,
        markdownSummary.isAcceptableOrUnknown(
          data['markdown_summary']!,
          _markdownSummaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_markdownSummaryMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate};
  @override
  DailySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummary(
      localDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_date'],
          )!,
      jsonSummary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}json_summary'],
          )!,
      markdownSummary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}markdown_summary'],
          )!,
      generatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}generated_at'],
          )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  DailySummaries createAlias(String alias) {
    return DailySummaries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DailySummary extends DataClass implements Insertable<DailySummary> {
  final String localDate;
  final String jsonSummary;
  final String markdownSummary;
  final DateTime generatedAt;
  final String? model;
  final String? confidence;
  final String syncStatus;
  final DateTime? syncedAt;
  const DailySummary({
    required this.localDate,
    required this.jsonSummary,
    required this.markdownSummary,
    required this.generatedAt,
    this.model,
    this.confidence,
    required this.syncStatus,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['json_summary'] = Variable<String>(jsonSummary);
    map['markdown_summary'] = Variable<String>(markdownSummary);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  DailySummariesCompanion toCompanion(bool nullToAbsent) {
    return DailySummariesCompanion(
      localDate: Value(localDate),
      jsonSummary: Value(jsonSummary),
      markdownSummary: Value(markdownSummary),
      generatedAt: Value(generatedAt),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      confidence:
          confidence == null && nullToAbsent
              ? const Value.absent()
              : Value(confidence),
      syncStatus: Value(syncStatus),
      syncedAt:
          syncedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(syncedAt),
    );
  }

  factory DailySummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummary(
      localDate: serializer.fromJson<String>(json['local_date']),
      jsonSummary: serializer.fromJson<String>(json['json_summary']),
      markdownSummary: serializer.fromJson<String>(json['markdown_summary']),
      generatedAt: serializer.fromJson<DateTime>(json['generated_at']),
      model: serializer.fromJson<String?>(json['model']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      syncedAt: serializer.fromJson<DateTime?>(json['synced_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_date': serializer.toJson<String>(localDate),
      'json_summary': serializer.toJson<String>(jsonSummary),
      'markdown_summary': serializer.toJson<String>(markdownSummary),
      'generated_at': serializer.toJson<DateTime>(generatedAt),
      'model': serializer.toJson<String?>(model),
      'confidence': serializer.toJson<String?>(confidence),
      'sync_status': serializer.toJson<String>(syncStatus),
      'synced_at': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  DailySummary copyWith({
    String? localDate,
    String? jsonSummary,
    String? markdownSummary,
    DateTime? generatedAt,
    Value<String?> model = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => DailySummary(
    localDate: localDate ?? this.localDate,
    jsonSummary: jsonSummary ?? this.jsonSummary,
    markdownSummary: markdownSummary ?? this.markdownSummary,
    generatedAt: generatedAt ?? this.generatedAt,
    model: model.present ? model.value : this.model,
    confidence: confidence.present ? confidence.value : this.confidence,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  DailySummary copyWithCompanion(DailySummariesCompanion data) {
    return DailySummary(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      jsonSummary:
          data.jsonSummary.present ? data.jsonSummary.value : this.jsonSummary,
      markdownSummary:
          data.markdownSummary.present
              ? data.markdownSummary.value
              : this.markdownSummary,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      model: data.model.present ? data.model.value : this.model,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummary(')
          ..write('localDate: $localDate, ')
          ..write('jsonSummary: $jsonSummary, ')
          ..write('markdownSummary: $markdownSummary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('model: $model, ')
          ..write('confidence: $confidence, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localDate,
    jsonSummary,
    markdownSummary,
    generatedAt,
    model,
    confidence,
    syncStatus,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummary &&
          other.localDate == this.localDate &&
          other.jsonSummary == this.jsonSummary &&
          other.markdownSummary == this.markdownSummary &&
          other.generatedAt == this.generatedAt &&
          other.model == this.model &&
          other.confidence == this.confidence &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class DailySummariesCompanion extends UpdateCompanion<DailySummary> {
  final Value<String> localDate;
  final Value<String> jsonSummary;
  final Value<String> markdownSummary;
  final Value<DateTime> generatedAt;
  final Value<String?> model;
  final Value<String?> confidence;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const DailySummariesCompanion({
    this.localDate = const Value.absent(),
    this.jsonSummary = const Value.absent(),
    this.markdownSummary = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.model = const Value.absent(),
    this.confidence = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySummariesCompanion.insert({
    required String localDate,
    required String jsonSummary,
    required String markdownSummary,
    required DateTime generatedAt,
    this.model = const Value.absent(),
    this.confidence = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate),
       jsonSummary = Value(jsonSummary),
       markdownSummary = Value(markdownSummary),
       generatedAt = Value(generatedAt);
  static Insertable<DailySummary> custom({
    Expression<String>? localDate,
    Expression<String>? jsonSummary,
    Expression<String>? markdownSummary,
    Expression<DateTime>? generatedAt,
    Expression<String>? model,
    Expression<String>? confidence,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (jsonSummary != null) 'json_summary': jsonSummary,
      if (markdownSummary != null) 'markdown_summary': markdownSummary,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (model != null) 'model': model,
      if (confidence != null) 'confidence': confidence,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySummariesCompanion copyWith({
    Value<String>? localDate,
    Value<String>? jsonSummary,
    Value<String>? markdownSummary,
    Value<DateTime>? generatedAt,
    Value<String?>? model,
    Value<String?>? confidence,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return DailySummariesCompanion(
      localDate: localDate ?? this.localDate,
      jsonSummary: jsonSummary ?? this.jsonSummary,
      markdownSummary: markdownSummary ?? this.markdownSummary,
      generatedAt: generatedAt ?? this.generatedAt,
      model: model ?? this.model,
      confidence: confidence ?? this.confidence,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (jsonSummary.present) {
      map['json_summary'] = Variable<String>(jsonSummary.value);
    }
    if (markdownSummary.present) {
      map['markdown_summary'] = Variable<String>(markdownSummary.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummariesCompanion(')
          ..write('localDate: $localDate, ')
          ..write('jsonSummary: $jsonSummary, ')
          ..write('markdownSummary: $markdownSummary, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('model: $model, ')
          ..write('confidence: $confidence, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AiToolCalls extends Table with TableInfo<AiToolCalls, AiToolCall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AiToolCalls(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _usageWindowIdMeta = const VerificationMeta(
    'usageWindowId',
  );
  late final GeneratedColumn<String> usageWindowId = GeneratedColumn<String>(
    'usage_window_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'free\'',
    defaultValue: const CustomExpression('\'free\''),
  );
  static const VerificationMeta _toolNameMeta = const VerificationMeta(
    'toolName',
  );
  late final GeneratedColumn<String> toolName = GeneratedColumn<String>(
    'tool_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _inputJsonMeta = const VerificationMeta(
    'inputJson',
  );
  late final GeneratedColumn<String> inputJson = GeneratedColumn<String>(
    'input_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _resultJsonMeta = const VerificationMeta(
    'resultJson',
  );
  late final GeneratedColumn<String> resultJson = GeneratedColumn<String>(
    'result_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _tokenInputMeta = const VerificationMeta(
    'tokenInput',
  );
  late final GeneratedColumn<int> tokenInput = GeneratedColumn<int>(
    'token_input',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _tokenOutputMeta = const VerificationMeta(
    'tokenOutput',
  );
  late final GeneratedColumn<int> tokenOutput = GeneratedColumn<int>(
    'token_output',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _estimatedCostMeta = const VerificationMeta(
    'estimatedCost',
  );
  late final GeneratedColumn<double> estimatedCost = GeneratedColumn<double>(
    'estimated_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'success\'',
    defaultValue: const CustomExpression('\'success\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    messageId,
    usageWindowId,
    tier,
    toolName,
    inputJson,
    resultJson,
    createdAt,
    model,
    tokenInput,
    tokenOutput,
    estimatedCost,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_tool_calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiToolCall> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    if (data.containsKey('usage_window_id')) {
      context.handle(
        _usageWindowIdMeta,
        usageWindowId.isAcceptableOrUnknown(
          data['usage_window_id']!,
          _usageWindowIdMeta,
        ),
      );
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('tool_name')) {
      context.handle(
        _toolNameMeta,
        toolName.isAcceptableOrUnknown(data['tool_name']!, _toolNameMeta),
      );
    } else if (isInserting) {
      context.missing(_toolNameMeta);
    }
    if (data.containsKey('input_json')) {
      context.handle(
        _inputJsonMeta,
        inputJson.isAcceptableOrUnknown(data['input_json']!, _inputJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_inputJsonMeta);
    }
    if (data.containsKey('result_json')) {
      context.handle(
        _resultJsonMeta,
        resultJson.isAcceptableOrUnknown(data['result_json']!, _resultJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_resultJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('token_input')) {
      context.handle(
        _tokenInputMeta,
        tokenInput.isAcceptableOrUnknown(data['token_input']!, _tokenInputMeta),
      );
    }
    if (data.containsKey('token_output')) {
      context.handle(
        _tokenOutputMeta,
        tokenOutput.isAcceptableOrUnknown(
          data['token_output']!,
          _tokenOutputMeta,
        ),
      );
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
        _estimatedCostMeta,
        estimatedCost.isAcceptableOrUnknown(
          data['estimated_cost']!,
          _estimatedCostMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiToolCall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiToolCall(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      ),
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      ),
      usageWindowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usage_window_id'],
      ),
      tier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tier'],
          )!,
      toolName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tool_name'],
          )!,
      inputJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}input_json'],
          )!,
      resultJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}result_json'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      tokenInput:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}token_input'],
          )!,
      tokenOutput:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}token_output'],
          )!,
      estimatedCost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}estimated_cost'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
    );
  }

  @override
  AiToolCalls createAlias(String alias) {
    return AiToolCalls(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AiToolCall extends DataClass implements Insertable<AiToolCall> {
  final int id;
  final String? conversationId;
  final String? messageId;
  final String? usageWindowId;
  final String tier;
  final String toolName;
  final String inputJson;
  final String resultJson;
  final DateTime createdAt;
  final String? model;
  final int tokenInput;
  final int tokenOutput;
  final double estimatedCost;
  final String status;
  const AiToolCall({
    required this.id,
    this.conversationId,
    this.messageId,
    this.usageWindowId,
    required this.tier,
    required this.toolName,
    required this.inputJson,
    required this.resultJson,
    required this.createdAt,
    this.model,
    required this.tokenInput,
    required this.tokenOutput,
    required this.estimatedCost,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || conversationId != null) {
      map['conversation_id'] = Variable<String>(conversationId);
    }
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<String>(messageId);
    }
    if (!nullToAbsent || usageWindowId != null) {
      map['usage_window_id'] = Variable<String>(usageWindowId);
    }
    map['tier'] = Variable<String>(tier);
    map['tool_name'] = Variable<String>(toolName);
    map['input_json'] = Variable<String>(inputJson);
    map['result_json'] = Variable<String>(resultJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['token_input'] = Variable<int>(tokenInput);
    map['token_output'] = Variable<int>(tokenOutput);
    map['estimated_cost'] = Variable<double>(estimatedCost);
    map['status'] = Variable<String>(status);
    return map;
  }

  AiToolCallsCompanion toCompanion(bool nullToAbsent) {
    return AiToolCallsCompanion(
      id: Value(id),
      conversationId:
          conversationId == null && nullToAbsent
              ? const Value.absent()
              : Value(conversationId),
      messageId:
          messageId == null && nullToAbsent
              ? const Value.absent()
              : Value(messageId),
      usageWindowId:
          usageWindowId == null && nullToAbsent
              ? const Value.absent()
              : Value(usageWindowId),
      tier: Value(tier),
      toolName: Value(toolName),
      inputJson: Value(inputJson),
      resultJson: Value(resultJson),
      createdAt: Value(createdAt),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      tokenInput: Value(tokenInput),
      tokenOutput: Value(tokenOutput),
      estimatedCost: Value(estimatedCost),
      status: Value(status),
    );
  }

  factory AiToolCall.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiToolCall(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String?>(json['conversation_id']),
      messageId: serializer.fromJson<String?>(json['message_id']),
      usageWindowId: serializer.fromJson<String?>(json['usage_window_id']),
      tier: serializer.fromJson<String>(json['tier']),
      toolName: serializer.fromJson<String>(json['tool_name']),
      inputJson: serializer.fromJson<String>(json['input_json']),
      resultJson: serializer.fromJson<String>(json['result_json']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      model: serializer.fromJson<String?>(json['model']),
      tokenInput: serializer.fromJson<int>(json['token_input']),
      tokenOutput: serializer.fromJson<int>(json['token_output']),
      estimatedCost: serializer.fromJson<double>(json['estimated_cost']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversation_id': serializer.toJson<String?>(conversationId),
      'message_id': serializer.toJson<String?>(messageId),
      'usage_window_id': serializer.toJson<String?>(usageWindowId),
      'tier': serializer.toJson<String>(tier),
      'tool_name': serializer.toJson<String>(toolName),
      'input_json': serializer.toJson<String>(inputJson),
      'result_json': serializer.toJson<String>(resultJson),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'model': serializer.toJson<String?>(model),
      'token_input': serializer.toJson<int>(tokenInput),
      'token_output': serializer.toJson<int>(tokenOutput),
      'estimated_cost': serializer.toJson<double>(estimatedCost),
      'status': serializer.toJson<String>(status),
    };
  }

  AiToolCall copyWith({
    int? id,
    Value<String?> conversationId = const Value.absent(),
    Value<String?> messageId = const Value.absent(),
    Value<String?> usageWindowId = const Value.absent(),
    String? tier,
    String? toolName,
    String? inputJson,
    String? resultJson,
    DateTime? createdAt,
    Value<String?> model = const Value.absent(),
    int? tokenInput,
    int? tokenOutput,
    double? estimatedCost,
    String? status,
  }) => AiToolCall(
    id: id ?? this.id,
    conversationId:
        conversationId.present ? conversationId.value : this.conversationId,
    messageId: messageId.present ? messageId.value : this.messageId,
    usageWindowId:
        usageWindowId.present ? usageWindowId.value : this.usageWindowId,
    tier: tier ?? this.tier,
    toolName: toolName ?? this.toolName,
    inputJson: inputJson ?? this.inputJson,
    resultJson: resultJson ?? this.resultJson,
    createdAt: createdAt ?? this.createdAt,
    model: model.present ? model.value : this.model,
    tokenInput: tokenInput ?? this.tokenInput,
    tokenOutput: tokenOutput ?? this.tokenOutput,
    estimatedCost: estimatedCost ?? this.estimatedCost,
    status: status ?? this.status,
  );
  AiToolCall copyWithCompanion(AiToolCallsCompanion data) {
    return AiToolCall(
      id: data.id.present ? data.id.value : this.id,
      conversationId:
          data.conversationId.present
              ? data.conversationId.value
              : this.conversationId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      usageWindowId:
          data.usageWindowId.present
              ? data.usageWindowId.value
              : this.usageWindowId,
      tier: data.tier.present ? data.tier.value : this.tier,
      toolName: data.toolName.present ? data.toolName.value : this.toolName,
      inputJson: data.inputJson.present ? data.inputJson.value : this.inputJson,
      resultJson:
          data.resultJson.present ? data.resultJson.value : this.resultJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      model: data.model.present ? data.model.value : this.model,
      tokenInput:
          data.tokenInput.present ? data.tokenInput.value : this.tokenInput,
      tokenOutput:
          data.tokenOutput.present ? data.tokenOutput.value : this.tokenOutput,
      estimatedCost:
          data.estimatedCost.present
              ? data.estimatedCost.value
              : this.estimatedCost,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiToolCall(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageId: $messageId, ')
          ..write('usageWindowId: $usageWindowId, ')
          ..write('tier: $tier, ')
          ..write('toolName: $toolName, ')
          ..write('inputJson: $inputJson, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('tokenInput: $tokenInput, ')
          ..write('tokenOutput: $tokenOutput, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    messageId,
    usageWindowId,
    tier,
    toolName,
    inputJson,
    resultJson,
    createdAt,
    model,
    tokenInput,
    tokenOutput,
    estimatedCost,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiToolCall &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.messageId == this.messageId &&
          other.usageWindowId == this.usageWindowId &&
          other.tier == this.tier &&
          other.toolName == this.toolName &&
          other.inputJson == this.inputJson &&
          other.resultJson == this.resultJson &&
          other.createdAt == this.createdAt &&
          other.model == this.model &&
          other.tokenInput == this.tokenInput &&
          other.tokenOutput == this.tokenOutput &&
          other.estimatedCost == this.estimatedCost &&
          other.status == this.status);
}

class AiToolCallsCompanion extends UpdateCompanion<AiToolCall> {
  final Value<int> id;
  final Value<String?> conversationId;
  final Value<String?> messageId;
  final Value<String?> usageWindowId;
  final Value<String> tier;
  final Value<String> toolName;
  final Value<String> inputJson;
  final Value<String> resultJson;
  final Value<DateTime> createdAt;
  final Value<String?> model;
  final Value<int> tokenInput;
  final Value<int> tokenOutput;
  final Value<double> estimatedCost;
  final Value<String> status;
  const AiToolCallsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.usageWindowId = const Value.absent(),
    this.tier = const Value.absent(),
    this.toolName = const Value.absent(),
    this.inputJson = const Value.absent(),
    this.resultJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.model = const Value.absent(),
    this.tokenInput = const Value.absent(),
    this.tokenOutput = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.status = const Value.absent(),
  });
  AiToolCallsCompanion.insert({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.usageWindowId = const Value.absent(),
    this.tier = const Value.absent(),
    required String toolName,
    required String inputJson,
    required String resultJson,
    this.createdAt = const Value.absent(),
    this.model = const Value.absent(),
    this.tokenInput = const Value.absent(),
    this.tokenOutput = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.status = const Value.absent(),
  }) : toolName = Value(toolName),
       inputJson = Value(inputJson),
       resultJson = Value(resultJson);
  static Insertable<AiToolCall> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? messageId,
    Expression<String>? usageWindowId,
    Expression<String>? tier,
    Expression<String>? toolName,
    Expression<String>? inputJson,
    Expression<String>? resultJson,
    Expression<DateTime>? createdAt,
    Expression<String>? model,
    Expression<int>? tokenInput,
    Expression<int>? tokenOutput,
    Expression<double>? estimatedCost,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (messageId != null) 'message_id': messageId,
      if (usageWindowId != null) 'usage_window_id': usageWindowId,
      if (tier != null) 'tier': tier,
      if (toolName != null) 'tool_name': toolName,
      if (inputJson != null) 'input_json': inputJson,
      if (resultJson != null) 'result_json': resultJson,
      if (createdAt != null) 'created_at': createdAt,
      if (model != null) 'model': model,
      if (tokenInput != null) 'token_input': tokenInput,
      if (tokenOutput != null) 'token_output': tokenOutput,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (status != null) 'status': status,
    });
  }

  AiToolCallsCompanion copyWith({
    Value<int>? id,
    Value<String?>? conversationId,
    Value<String?>? messageId,
    Value<String?>? usageWindowId,
    Value<String>? tier,
    Value<String>? toolName,
    Value<String>? inputJson,
    Value<String>? resultJson,
    Value<DateTime>? createdAt,
    Value<String?>? model,
    Value<int>? tokenInput,
    Value<int>? tokenOutput,
    Value<double>? estimatedCost,
    Value<String>? status,
  }) {
    return AiToolCallsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      messageId: messageId ?? this.messageId,
      usageWindowId: usageWindowId ?? this.usageWindowId,
      tier: tier ?? this.tier,
      toolName: toolName ?? this.toolName,
      inputJson: inputJson ?? this.inputJson,
      resultJson: resultJson ?? this.resultJson,
      createdAt: createdAt ?? this.createdAt,
      model: model ?? this.model,
      tokenInput: tokenInput ?? this.tokenInput,
      tokenOutput: tokenOutput ?? this.tokenOutput,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (usageWindowId.present) {
      map['usage_window_id'] = Variable<String>(usageWindowId.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (toolName.present) {
      map['tool_name'] = Variable<String>(toolName.value);
    }
    if (inputJson.present) {
      map['input_json'] = Variable<String>(inputJson.value);
    }
    if (resultJson.present) {
      map['result_json'] = Variable<String>(resultJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (tokenInput.present) {
      map['token_input'] = Variable<int>(tokenInput.value);
    }
    if (tokenOutput.present) {
      map['token_output'] = Variable<int>(tokenOutput.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<double>(estimatedCost.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiToolCallsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageId: $messageId, ')
          ..write('usageWindowId: $usageWindowId, ')
          ..write('tier: $tier, ')
          ..write('toolName: $toolName, ')
          ..write('inputJson: $inputJson, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('tokenInput: $tokenInput, ')
          ..write('tokenOutput: $tokenOutput, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class AiUsageWindows extends Table
    with TableInfo<AiUsageWindows, AiUsageWindow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AiUsageWindows(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _windowIdMeta = const VerificationMeta(
    'windowId',
  );
  late final GeneratedColumn<String> windowId = GeneratedColumn<String>(
    'window_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'free\'',
    defaultValue: const CustomExpression('\'free\''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _resetsAtMeta = const VerificationMeta(
    'resetsAt',
  );
  late final GeneratedColumn<DateTime> resetsAt = GeneratedColumn<DateTime>(
    'resets_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _toolCallsUsedMeta = const VerificationMeta(
    'toolCallsUsed',
  );
  late final GeneratedColumn<int> toolCallsUsed = GeneratedColumn<int>(
    'tool_calls_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _inputTokensMeta = const VerificationMeta(
    'inputTokens',
  );
  late final GeneratedColumn<int> inputTokens = GeneratedColumn<int>(
    'input_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _outputTokensMeta = const VerificationMeta(
    'outputTokens',
  );
  late final GeneratedColumn<int> outputTokens = GeneratedColumn<int>(
    'output_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _estimatedCostMeta = const VerificationMeta(
    'estimatedCost',
  );
  late final GeneratedColumn<double> estimatedCost = GeneratedColumn<double>(
    'estimated_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    windowId,
    tier,
    startedAt,
    resetsAt,
    toolCallsUsed,
    inputTokens,
    outputTokens,
    estimatedCost,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_usage_windows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiUsageWindow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('window_id')) {
      context.handle(
        _windowIdMeta,
        windowId.isAcceptableOrUnknown(data['window_id']!, _windowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_windowIdMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('resets_at')) {
      context.handle(
        _resetsAtMeta,
        resetsAt.isAcceptableOrUnknown(data['resets_at']!, _resetsAtMeta),
      );
    }
    if (data.containsKey('tool_calls_used')) {
      context.handle(
        _toolCallsUsedMeta,
        toolCallsUsed.isAcceptableOrUnknown(
          data['tool_calls_used']!,
          _toolCallsUsedMeta,
        ),
      );
    }
    if (data.containsKey('input_tokens')) {
      context.handle(
        _inputTokensMeta,
        inputTokens.isAcceptableOrUnknown(
          data['input_tokens']!,
          _inputTokensMeta,
        ),
      );
    }
    if (data.containsKey('output_tokens')) {
      context.handle(
        _outputTokensMeta,
        outputTokens.isAcceptableOrUnknown(
          data['output_tokens']!,
          _outputTokensMeta,
        ),
      );
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
        _estimatedCostMeta,
        estimatedCost.isAcceptableOrUnknown(
          data['estimated_cost']!,
          _estimatedCostMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {windowId};
  @override
  AiUsageWindow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiUsageWindow(
      windowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}window_id'],
          )!,
      tier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tier'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      resetsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resets_at'],
      ),
      toolCallsUsed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tool_calls_used'],
          )!,
      inputTokens:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}input_tokens'],
          )!,
      outputTokens:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}output_tokens'],
          )!,
      estimatedCost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}estimated_cost'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  AiUsageWindows createAlias(String alias) {
    return AiUsageWindows(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AiUsageWindow extends DataClass implements Insertable<AiUsageWindow> {
  final String windowId;
  final String tier;
  final DateTime startedAt;
  final DateTime? resetsAt;
  final int toolCallsUsed;
  final int inputTokens;
  final int outputTokens;
  final double estimatedCost;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const AiUsageWindow({
    required this.windowId,
    required this.tier,
    required this.startedAt,
    this.resetsAt,
    required this.toolCallsUsed,
    required this.inputTokens,
    required this.outputTokens,
    required this.estimatedCost,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['window_id'] = Variable<String>(windowId);
    map['tier'] = Variable<String>(tier);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || resetsAt != null) {
      map['resets_at'] = Variable<DateTime>(resetsAt);
    }
    map['tool_calls_used'] = Variable<int>(toolCallsUsed);
    map['input_tokens'] = Variable<int>(inputTokens);
    map['output_tokens'] = Variable<int>(outputTokens);
    map['estimated_cost'] = Variable<double>(estimatedCost);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AiUsageWindowsCompanion toCompanion(bool nullToAbsent) {
    return AiUsageWindowsCompanion(
      windowId: Value(windowId),
      tier: Value(tier),
      startedAt: Value(startedAt),
      resetsAt:
          resetsAt == null && nullToAbsent
              ? const Value.absent()
              : Value(resetsAt),
      toolCallsUsed: Value(toolCallsUsed),
      inputTokens: Value(inputTokens),
      outputTokens: Value(outputTokens),
      estimatedCost: Value(estimatedCost),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory AiUsageWindow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiUsageWindow(
      windowId: serializer.fromJson<String>(json['window_id']),
      tier: serializer.fromJson<String>(json['tier']),
      startedAt: serializer.fromJson<DateTime>(json['started_at']),
      resetsAt: serializer.fromJson<DateTime?>(json['resets_at']),
      toolCallsUsed: serializer.fromJson<int>(json['tool_calls_used']),
      inputTokens: serializer.fromJson<int>(json['input_tokens']),
      outputTokens: serializer.fromJson<int>(json['output_tokens']),
      estimatedCost: serializer.fromJson<double>(json['estimated_cost']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'window_id': serializer.toJson<String>(windowId),
      'tier': serializer.toJson<String>(tier),
      'started_at': serializer.toJson<DateTime>(startedAt),
      'resets_at': serializer.toJson<DateTime?>(resetsAt),
      'tool_calls_used': serializer.toJson<int>(toolCallsUsed),
      'input_tokens': serializer.toJson<int>(inputTokens),
      'output_tokens': serializer.toJson<int>(outputTokens),
      'estimated_cost': serializer.toJson<double>(estimatedCost),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AiUsageWindow copyWith({
    String? windowId,
    String? tier,
    DateTime? startedAt,
    Value<DateTime?> resetsAt = const Value.absent(),
    int? toolCallsUsed,
    int? inputTokens,
    int? outputTokens,
    double? estimatedCost,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => AiUsageWindow(
    windowId: windowId ?? this.windowId,
    tier: tier ?? this.tier,
    startedAt: startedAt ?? this.startedAt,
    resetsAt: resetsAt.present ? resetsAt.value : this.resetsAt,
    toolCallsUsed: toolCallsUsed ?? this.toolCallsUsed,
    inputTokens: inputTokens ?? this.inputTokens,
    outputTokens: outputTokens ?? this.outputTokens,
    estimatedCost: estimatedCost ?? this.estimatedCost,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  AiUsageWindow copyWithCompanion(AiUsageWindowsCompanion data) {
    return AiUsageWindow(
      windowId: data.windowId.present ? data.windowId.value : this.windowId,
      tier: data.tier.present ? data.tier.value : this.tier,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      resetsAt: data.resetsAt.present ? data.resetsAt.value : this.resetsAt,
      toolCallsUsed:
          data.toolCallsUsed.present
              ? data.toolCallsUsed.value
              : this.toolCallsUsed,
      inputTokens:
          data.inputTokens.present ? data.inputTokens.value : this.inputTokens,
      outputTokens:
          data.outputTokens.present
              ? data.outputTokens.value
              : this.outputTokens,
      estimatedCost:
          data.estimatedCost.present
              ? data.estimatedCost.value
              : this.estimatedCost,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageWindow(')
          ..write('windowId: $windowId, ')
          ..write('tier: $tier, ')
          ..write('startedAt: $startedAt, ')
          ..write('resetsAt: $resetsAt, ')
          ..write('toolCallsUsed: $toolCallsUsed, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    windowId,
    tier,
    startedAt,
    resetsAt,
    toolCallsUsed,
    inputTokens,
    outputTokens,
    estimatedCost,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiUsageWindow &&
          other.windowId == this.windowId &&
          other.tier == this.tier &&
          other.startedAt == this.startedAt &&
          other.resetsAt == this.resetsAt &&
          other.toolCallsUsed == this.toolCallsUsed &&
          other.inputTokens == this.inputTokens &&
          other.outputTokens == this.outputTokens &&
          other.estimatedCost == this.estimatedCost &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AiUsageWindowsCompanion extends UpdateCompanion<AiUsageWindow> {
  final Value<String> windowId;
  final Value<String> tier;
  final Value<DateTime> startedAt;
  final Value<DateTime?> resetsAt;
  final Value<int> toolCallsUsed;
  final Value<int> inputTokens;
  final Value<int> outputTokens;
  final Value<double> estimatedCost;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const AiUsageWindowsCompanion({
    this.windowId = const Value.absent(),
    this.tier = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.resetsAt = const Value.absent(),
    this.toolCallsUsed = const Value.absent(),
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiUsageWindowsCompanion.insert({
    required String windowId,
    this.tier = const Value.absent(),
    required DateTime startedAt,
    this.resetsAt = const Value.absent(),
    this.toolCallsUsed = const Value.absent(),
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : windowId = Value(windowId),
       startedAt = Value(startedAt);
  static Insertable<AiUsageWindow> custom({
    Expression<String>? windowId,
    Expression<String>? tier,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? resetsAt,
    Expression<int>? toolCallsUsed,
    Expression<int>? inputTokens,
    Expression<int>? outputTokens,
    Expression<double>? estimatedCost,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (windowId != null) 'window_id': windowId,
      if (tier != null) 'tier': tier,
      if (startedAt != null) 'started_at': startedAt,
      if (resetsAt != null) 'resets_at': resetsAt,
      if (toolCallsUsed != null) 'tool_calls_used': toolCallsUsed,
      if (inputTokens != null) 'input_tokens': inputTokens,
      if (outputTokens != null) 'output_tokens': outputTokens,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiUsageWindowsCompanion copyWith({
    Value<String>? windowId,
    Value<String>? tier,
    Value<DateTime>? startedAt,
    Value<DateTime?>? resetsAt,
    Value<int>? toolCallsUsed,
    Value<int>? inputTokens,
    Value<int>? outputTokens,
    Value<double>? estimatedCost,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiUsageWindowsCompanion(
      windowId: windowId ?? this.windowId,
      tier: tier ?? this.tier,
      startedAt: startedAt ?? this.startedAt,
      resetsAt: resetsAt ?? this.resetsAt,
      toolCallsUsed: toolCallsUsed ?? this.toolCallsUsed,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (windowId.present) {
      map['window_id'] = Variable<String>(windowId.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (resetsAt.present) {
      map['resets_at'] = Variable<DateTime>(resetsAt.value);
    }
    if (toolCallsUsed.present) {
      map['tool_calls_used'] = Variable<int>(toolCallsUsed.value);
    }
    if (inputTokens.present) {
      map['input_tokens'] = Variable<int>(inputTokens.value);
    }
    if (outputTokens.present) {
      map['output_tokens'] = Variable<int>(outputTokens.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<double>(estimatedCost.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageWindowsCompanion(')
          ..write('windowId: $windowId, ')
          ..write('tier: $tier, ')
          ..write('startedAt: $startedAt, ')
          ..write('resetsAt: $resetsAt, ')
          ..write('toolCallsUsed: $toolCallsUsed, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AiConversations extends Table
    with TableInfo<AiConversations, AiConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AiConversations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _contextModeMeta = const VerificationMeta(
    'contextMode',
  );
  late final GeneratedColumn<String> contextMode = GeneratedColumn<String>(
    'context_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'daily\'',
    defaultValue: const CustomExpression('\'daily\''),
  );
  static const VerificationMeta _messageCountMeta = const VerificationMeta(
    'messageCount',
  );
  late final GeneratedColumn<int> messageCount = GeneratedColumn<int>(
    'message_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _compactedAtMeta = const VerificationMeta(
    'compactedAt',
  );
  late final GeneratedColumn<DateTime> compactedAt = GeneratedColumn<DateTime>(
    'compacted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    title,
    summary,
    contextMode,
    messageCount,
    createdAt,
    updatedAt,
    compactedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('context_mode')) {
      context.handle(
        _contextModeMeta,
        contextMode.isAcceptableOrUnknown(
          data['context_mode']!,
          _contextModeMeta,
        ),
      );
    }
    if (data.containsKey('message_count')) {
      context.handle(
        _messageCountMeta,
        messageCount.isAcceptableOrUnknown(
          data['message_count']!,
          _messageCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('compacted_at')) {
      context.handle(
        _compactedAtMeta,
        compactedAt.isAcceptableOrUnknown(
          data['compacted_at']!,
          _compactedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  AiConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiConversation(
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      contextMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}context_mode'],
          )!,
      messageCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}message_count'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      compactedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}compacted_at'],
      ),
    );
  }

  @override
  AiConversations createAlias(String alias) {
    return AiConversations(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AiConversation extends DataClass implements Insertable<AiConversation> {
  final String localId;
  final String title;
  final String? summary;
  final String contextMode;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? compactedAt;
  const AiConversation({
    required this.localId,
    required this.title,
    this.summary,
    required this.contextMode,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
    this.compactedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['context_mode'] = Variable<String>(contextMode);
    map['message_count'] = Variable<int>(messageCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || compactedAt != null) {
      map['compacted_at'] = Variable<DateTime>(compactedAt);
    }
    return map;
  }

  AiConversationsCompanion toCompanion(bool nullToAbsent) {
    return AiConversationsCompanion(
      localId: Value(localId),
      title: Value(title),
      summary:
          summary == null && nullToAbsent
              ? const Value.absent()
              : Value(summary),
      contextMode: Value(contextMode),
      messageCount: Value(messageCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      compactedAt:
          compactedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(compactedAt),
    );
  }

  factory AiConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiConversation(
      localId: serializer.fromJson<String>(json['local_id']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String?>(json['summary']),
      contextMode: serializer.fromJson<String>(json['context_mode']),
      messageCount: serializer.fromJson<int>(json['message_count']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      compactedAt: serializer.fromJson<DateTime?>(json['compacted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<String>(localId),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String?>(summary),
      'context_mode': serializer.toJson<String>(contextMode),
      'message_count': serializer.toJson<int>(messageCount),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'compacted_at': serializer.toJson<DateTime?>(compactedAt),
    };
  }

  AiConversation copyWith({
    String? localId,
    String? title,
    Value<String?> summary = const Value.absent(),
    String? contextMode,
    int? messageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> compactedAt = const Value.absent(),
  }) => AiConversation(
    localId: localId ?? this.localId,
    title: title ?? this.title,
    summary: summary.present ? summary.value : this.summary,
    contextMode: contextMode ?? this.contextMode,
    messageCount: messageCount ?? this.messageCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    compactedAt: compactedAt.present ? compactedAt.value : this.compactedAt,
  );
  AiConversation copyWithCompanion(AiConversationsCompanion data) {
    return AiConversation(
      localId: data.localId.present ? data.localId.value : this.localId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      contextMode:
          data.contextMode.present ? data.contextMode.value : this.contextMode,
      messageCount:
          data.messageCount.present
              ? data.messageCount.value
              : this.messageCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      compactedAt:
          data.compactedAt.present ? data.compactedAt.value : this.compactedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiConversation(')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('contextMode: $contextMode, ')
          ..write('messageCount: $messageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('compactedAt: $compactedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    title,
    summary,
    contextMode,
    messageCount,
    createdAt,
    updatedAt,
    compactedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiConversation &&
          other.localId == this.localId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.contextMode == this.contextMode &&
          other.messageCount == this.messageCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.compactedAt == this.compactedAt);
}

class AiConversationsCompanion extends UpdateCompanion<AiConversation> {
  final Value<String> localId;
  final Value<String> title;
  final Value<String?> summary;
  final Value<String> contextMode;
  final Value<int> messageCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> compactedAt;
  final Value<int> rowid;
  const AiConversationsCompanion({
    this.localId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.contextMode = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.compactedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiConversationsCompanion.insert({
    required String localId,
    required String title,
    this.summary = const Value.absent(),
    this.contextMode = const Value.absent(),
    this.messageCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.compactedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AiConversation> custom({
    Expression<String>? localId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? contextMode,
    Expression<int>? messageCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? compactedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (contextMode != null) 'context_mode': contextMode,
      if (messageCount != null) 'message_count': messageCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (compactedAt != null) 'compacted_at': compactedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiConversationsCompanion copyWith({
    Value<String>? localId,
    Value<String>? title,
    Value<String?>? summary,
    Value<String>? contextMode,
    Value<int>? messageCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? compactedAt,
    Value<int>? rowid,
  }) {
    return AiConversationsCompanion(
      localId: localId ?? this.localId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      contextMode: contextMode ?? this.contextMode,
      messageCount: messageCount ?? this.messageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      compactedAt: compactedAt ?? this.compactedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (contextMode.present) {
      map['context_mode'] = Variable<String>(contextMode.value);
    }
    if (messageCount.present) {
      map['message_count'] = Variable<int>(messageCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (compactedAt.present) {
      map['compacted_at'] = Variable<DateTime>(compactedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsCompanion(')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('contextMode: $contextMode, ')
          ..write('messageCount: $messageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('compactedAt: $compactedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AiMessages extends Table with TableInfo<AiMessages, AiMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AiMessages(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _toolCallsUsedMeta = const VerificationMeta(
    'toolCallsUsed',
  );
  late final GeneratedColumn<int> toolCallsUsed = GeneratedColumn<int>(
    'tool_calls_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    conversationId,
    role,
    content,
    mode,
    toolCallsUsed,
    error,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('tool_calls_used')) {
      context.handle(
        _toolCallsUsedMeta,
        toolCallsUsed.isAcceptableOrUnknown(
          data['tool_calls_used']!,
          _toolCallsUsedMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMessage(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      conversationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}conversation_id'],
          )!,
      role:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}role'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      ),
      toolCallsUsed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tool_calls_used'],
          )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  AiMessages createAlias(String alias) {
    return AiMessages(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AiMessage extends DataClass implements Insertable<AiMessage> {
  final int id;
  final String localId;
  final String conversationId;
  final String role;
  final String content;
  final String? mode;
  final int toolCallsUsed;
  final String? error;
  final DateTime createdAt;
  const AiMessage({
    required this.id,
    required this.localId,
    required this.conversationId,
    required this.role,
    required this.content,
    this.mode,
    required this.toolCallsUsed,
    this.error,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || mode != null) {
      map['mode'] = Variable<String>(mode);
    }
    map['tool_calls_used'] = Variable<int>(toolCallsUsed);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AiMessagesCompanion toCompanion(bool nullToAbsent) {
    return AiMessagesCompanion(
      id: Value(id),
      localId: Value(localId),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      mode: mode == null && nullToAbsent ? const Value.absent() : Value(mode),
      toolCallsUsed: Value(toolCallsUsed),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      createdAt: Value(createdAt),
    );
  }

  factory AiMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMessage(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      conversationId: serializer.fromJson<String>(json['conversation_id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      mode: serializer.fromJson<String?>(json['mode']),
      toolCallsUsed: serializer.fromJson<int>(json['tool_calls_used']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'conversation_id': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'mode': serializer.toJson<String?>(mode),
      'tool_calls_used': serializer.toJson<int>(toolCallsUsed),
      'error': serializer.toJson<String?>(error),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  AiMessage copyWith({
    int? id,
    String? localId,
    String? conversationId,
    String? role,
    String? content,
    Value<String?> mode = const Value.absent(),
    int? toolCallsUsed,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
  }) => AiMessage(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    content: content ?? this.content,
    mode: mode.present ? mode.value : this.mode,
    toolCallsUsed: toolCallsUsed ?? this.toolCallsUsed,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
  );
  AiMessage copyWithCompanion(AiMessagesCompanion data) {
    return AiMessage(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      conversationId:
          data.conversationId.present
              ? data.conversationId.value
              : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      mode: data.mode.present ? data.mode.value : this.mode,
      toolCallsUsed:
          data.toolCallsUsed.present
              ? data.toolCallsUsed.value
              : this.toolCallsUsed,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMessage(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('mode: $mode, ')
          ..write('toolCallsUsed: $toolCallsUsed, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    conversationId,
    role,
    content,
    mode,
    toolCallsUsed,
    error,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMessage &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.content == this.content &&
          other.mode == this.mode &&
          other.toolCallsUsed == this.toolCallsUsed &&
          other.error == this.error &&
          other.createdAt == this.createdAt);
}

class AiMessagesCompanion extends UpdateCompanion<AiMessage> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> content;
  final Value<String?> mode;
  final Value<int> toolCallsUsed;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  const AiMessagesCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.mode = const Value.absent(),
    this.toolCallsUsed = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AiMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String conversationId,
    required String role,
    required String content,
    this.mode = const Value.absent(),
    this.toolCallsUsed = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime createdAt,
  }) : localId = Value(localId),
       conversationId = Value(conversationId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<AiMessage> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? mode,
    Expression<int>? toolCallsUsed,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (mode != null) 'mode': mode,
      if (toolCallsUsed != null) 'tool_calls_used': toolCallsUsed,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AiMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? content,
    Value<String?>? mode,
    Value<int>? toolCallsUsed,
    Value<String?>? error,
    Value<DateTime>? createdAt,
  }) {
    return AiMessagesCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      mode: mode ?? this.mode,
      toolCallsUsed: toolCallsUsed ?? this.toolCallsUsed,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (toolCallsUsed.present) {
      map['tool_calls_used'] = Variable<int>(toolCallsUsed.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiMessagesCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('mode: $mode, ')
          ..write('toolCallsUsed: $toolCallsUsed, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class CommunityShareRecords extends Table
    with TableInfo<CommunityShareRecords, CommunityShareRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CommunityShareRecords(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _sessionLocalIdMeta = const VerificationMeta(
    'sessionLocalId',
  );
  late final GeneratedColumn<String> sessionLocalId = GeneratedColumn<String>(
    'session_local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _shareIdMeta = const VerificationMeta(
    'shareId',
  );
  late final GeneratedColumn<String> shareId = GeneratedColumn<String>(
    'share_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _publicUrlMeta = const VerificationMeta(
    'publicUrl',
  );
  late final GeneratedColumn<String> publicUrl = GeneratedColumn<String>(
    'public_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'draft\'',
    defaultValue: const CustomExpression('\'draft\''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _sharedAtMeta = const VerificationMeta(
    'sharedAt',
  );
  late final GeneratedColumn<DateTime> sharedAt = GeneratedColumn<DateTime>(
    'shared_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    sessionLocalId,
    shareId,
    publicUrl,
    payloadJson,
    status,
    createdAt,
    sharedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_share_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommunityShareRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('session_local_id')) {
      context.handle(
        _sessionLocalIdMeta,
        sessionLocalId.isAcceptableOrUnknown(
          data['session_local_id']!,
          _sessionLocalIdMeta,
        ),
      );
    }
    if (data.containsKey('share_id')) {
      context.handle(
        _shareIdMeta,
        shareId.isAcceptableOrUnknown(data['share_id']!, _shareIdMeta),
      );
    }
    if (data.containsKey('public_url')) {
      context.handle(
        _publicUrlMeta,
        publicUrl.isAcceptableOrUnknown(data['public_url']!, _publicUrlMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('shared_at')) {
      context.handle(
        _sharedAtMeta,
        sharedAt.isAcceptableOrUnknown(data['shared_at']!, _sharedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommunityShareRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityShareRecord(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      sessionLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_local_id'],
      ),
      shareId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_id'],
      ),
      publicUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_url'],
      ),
      payloadJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payload_json'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      sharedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}shared_at'],
      ),
    );
  }

  @override
  CommunityShareRecords createAlias(String alias) {
    return CommunityShareRecords(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CommunityShareRecord extends DataClass
    implements Insertable<CommunityShareRecord> {
  final int id;
  final String localId;
  final String? sessionLocalId;
  final String? shareId;
  final String? publicUrl;
  final String payloadJson;
  final String status;
  final DateTime createdAt;
  final DateTime? sharedAt;
  const CommunityShareRecord({
    required this.id,
    required this.localId,
    this.sessionLocalId,
    this.shareId,
    this.publicUrl,
    required this.payloadJson,
    required this.status,
    required this.createdAt,
    this.sharedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || sessionLocalId != null) {
      map['session_local_id'] = Variable<String>(sessionLocalId);
    }
    if (!nullToAbsent || shareId != null) {
      map['share_id'] = Variable<String>(shareId);
    }
    if (!nullToAbsent || publicUrl != null) {
      map['public_url'] = Variable<String>(publicUrl);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sharedAt != null) {
      map['shared_at'] = Variable<DateTime>(sharedAt);
    }
    return map;
  }

  CommunityShareRecordsCompanion toCompanion(bool nullToAbsent) {
    return CommunityShareRecordsCompanion(
      id: Value(id),
      localId: Value(localId),
      sessionLocalId:
          sessionLocalId == null && nullToAbsent
              ? const Value.absent()
              : Value(sessionLocalId),
      shareId:
          shareId == null && nullToAbsent
              ? const Value.absent()
              : Value(shareId),
      publicUrl:
          publicUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(publicUrl),
      payloadJson: Value(payloadJson),
      status: Value(status),
      createdAt: Value(createdAt),
      sharedAt:
          sharedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(sharedAt),
    );
  }

  factory CommunityShareRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityShareRecord(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      sessionLocalId: serializer.fromJson<String?>(json['session_local_id']),
      shareId: serializer.fromJson<String?>(json['share_id']),
      publicUrl: serializer.fromJson<String?>(json['public_url']),
      payloadJson: serializer.fromJson<String>(json['payload_json']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      sharedAt: serializer.fromJson<DateTime?>(json['shared_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'session_local_id': serializer.toJson<String?>(sessionLocalId),
      'share_id': serializer.toJson<String?>(shareId),
      'public_url': serializer.toJson<String?>(publicUrl),
      'payload_json': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'shared_at': serializer.toJson<DateTime?>(sharedAt),
    };
  }

  CommunityShareRecord copyWith({
    int? id,
    String? localId,
    Value<String?> sessionLocalId = const Value.absent(),
    Value<String?> shareId = const Value.absent(),
    Value<String?> publicUrl = const Value.absent(),
    String? payloadJson,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> sharedAt = const Value.absent(),
  }) => CommunityShareRecord(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    sessionLocalId:
        sessionLocalId.present ? sessionLocalId.value : this.sessionLocalId,
    shareId: shareId.present ? shareId.value : this.shareId,
    publicUrl: publicUrl.present ? publicUrl.value : this.publicUrl,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    sharedAt: sharedAt.present ? sharedAt.value : this.sharedAt,
  );
  CommunityShareRecord copyWithCompanion(CommunityShareRecordsCompanion data) {
    return CommunityShareRecord(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      sessionLocalId:
          data.sessionLocalId.present
              ? data.sessionLocalId.value
              : this.sessionLocalId,
      shareId: data.shareId.present ? data.shareId.value : this.shareId,
      publicUrl: data.publicUrl.present ? data.publicUrl.value : this.publicUrl,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sharedAt: data.sharedAt.present ? data.sharedAt.value : this.sharedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityShareRecord(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('shareId: $shareId, ')
          ..write('publicUrl: $publicUrl, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('sharedAt: $sharedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    sessionLocalId,
    shareId,
    publicUrl,
    payloadJson,
    status,
    createdAt,
    sharedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityShareRecord &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.sessionLocalId == this.sessionLocalId &&
          other.shareId == this.shareId &&
          other.publicUrl == this.publicUrl &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.sharedAt == this.sharedAt);
}

class CommunityShareRecordsCompanion
    extends UpdateCompanion<CommunityShareRecord> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String?> sessionLocalId;
  final Value<String?> shareId;
  final Value<String?> publicUrl;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> sharedAt;
  const CommunityShareRecordsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.sessionLocalId = const Value.absent(),
    this.shareId = const Value.absent(),
    this.publicUrl = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sharedAt = const Value.absent(),
  });
  CommunityShareRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    this.sessionLocalId = const Value.absent(),
    this.shareId = const Value.absent(),
    this.publicUrl = const Value.absent(),
    required String payloadJson,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sharedAt = const Value.absent(),
  }) : localId = Value(localId),
       payloadJson = Value(payloadJson);
  static Insertable<CommunityShareRecord> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? sessionLocalId,
    Expression<String>? shareId,
    Expression<String>? publicUrl,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? sharedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (sessionLocalId != null) 'session_local_id': sessionLocalId,
      if (shareId != null) 'share_id': shareId,
      if (publicUrl != null) 'public_url': publicUrl,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (sharedAt != null) 'shared_at': sharedAt,
    });
  }

  CommunityShareRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String?>? sessionLocalId,
    Value<String?>? shareId,
    Value<String?>? publicUrl,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? sharedAt,
  }) {
    return CommunityShareRecordsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      sessionLocalId: sessionLocalId ?? this.sessionLocalId,
      shareId: shareId ?? this.shareId,
      publicUrl: publicUrl ?? this.publicUrl,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sharedAt: sharedAt ?? this.sharedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (sessionLocalId.present) {
      map['session_local_id'] = Variable<String>(sessionLocalId.value);
    }
    if (shareId.present) {
      map['share_id'] = Variable<String>(shareId.value);
    }
    if (publicUrl.present) {
      map['public_url'] = Variable<String>(publicUrl.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sharedAt.present) {
      map['shared_at'] = Variable<DateTime>(sharedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityShareRecordsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('shareId: $shareId, ')
          ..write('publicUrl: $publicUrl, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('sharedAt: $sharedAt')
          ..write(')'))
        .toString();
  }
}

class ChallengeInvites extends Table
    with TableInfo<ChallengeInvites, ChallengeInvite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ChallengeInvites(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _challengeIdMeta = const VerificationMeta(
    'challengeId',
  );
  late final GeneratedColumn<String> challengeId = GeneratedColumn<String>(
    'challenge_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _inviteUrlMeta = const VerificationMeta(
    'inviteUrl',
  );
  late final GeneratedColumn<String> inviteUrl = GeneratedColumn<String>(
    'invite_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'draft\'',
    defaultValue: const CustomExpression('\'draft\''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    challengeId,
    title,
    metric,
    targetValue,
    inviteUrl,
    status,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'challenge_invites';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChallengeInvite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('challenge_id')) {
      context.handle(
        _challengeIdMeta,
        challengeId.isAcceptableOrUnknown(
          data['challenge_id']!,
          _challengeIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('invite_url')) {
      context.handle(
        _inviteUrlMeta,
        inviteUrl.isAcceptableOrUnknown(data['invite_url']!, _inviteUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChallengeInvite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChallengeInvite(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      challengeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_id'],
      ),
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      metric:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}metric'],
          )!,
      targetValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}target_value'],
          )!,
      inviteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invite_url'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  ChallengeInvites createAlias(String alias) {
    return ChallengeInvites(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ChallengeInvite extends DataClass implements Insertable<ChallengeInvite> {
  final int id;
  final String localId;
  final String? challengeId;
  final String title;
  final String metric;
  final double targetValue;
  final String? inviteUrl;
  final String status;
  final DateTime createdAt;
  final DateTime? expiresAt;
  const ChallengeInvite({
    required this.id,
    required this.localId,
    this.challengeId,
    required this.title,
    required this.metric,
    required this.targetValue,
    this.inviteUrl,
    required this.status,
    required this.createdAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || challengeId != null) {
      map['challenge_id'] = Variable<String>(challengeId);
    }
    map['title'] = Variable<String>(title);
    map['metric'] = Variable<String>(metric);
    map['target_value'] = Variable<double>(targetValue);
    if (!nullToAbsent || inviteUrl != null) {
      map['invite_url'] = Variable<String>(inviteUrl);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  ChallengeInvitesCompanion toCompanion(bool nullToAbsent) {
    return ChallengeInvitesCompanion(
      id: Value(id),
      localId: Value(localId),
      challengeId:
          challengeId == null && nullToAbsent
              ? const Value.absent()
              : Value(challengeId),
      title: Value(title),
      metric: Value(metric),
      targetValue: Value(targetValue),
      inviteUrl:
          inviteUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(inviteUrl),
      status: Value(status),
      createdAt: Value(createdAt),
      expiresAt:
          expiresAt == null && nullToAbsent
              ? const Value.absent()
              : Value(expiresAt),
    );
  }

  factory ChallengeInvite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChallengeInvite(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      challengeId: serializer.fromJson<String?>(json['challenge_id']),
      title: serializer.fromJson<String>(json['title']),
      metric: serializer.fromJson<String>(json['metric']),
      targetValue: serializer.fromJson<double>(json['target_value']),
      inviteUrl: serializer.fromJson<String?>(json['invite_url']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      expiresAt: serializer.fromJson<DateTime?>(json['expires_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'challenge_id': serializer.toJson<String?>(challengeId),
      'title': serializer.toJson<String>(title),
      'metric': serializer.toJson<String>(metric),
      'target_value': serializer.toJson<double>(targetValue),
      'invite_url': serializer.toJson<String?>(inviteUrl),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'expires_at': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  ChallengeInvite copyWith({
    int? id,
    String? localId,
    Value<String?> challengeId = const Value.absent(),
    String? title,
    String? metric,
    double? targetValue,
    Value<String?> inviteUrl = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => ChallengeInvite(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    challengeId: challengeId.present ? challengeId.value : this.challengeId,
    title: title ?? this.title,
    metric: metric ?? this.metric,
    targetValue: targetValue ?? this.targetValue,
    inviteUrl: inviteUrl.present ? inviteUrl.value : this.inviteUrl,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  ChallengeInvite copyWithCompanion(ChallengeInvitesCompanion data) {
    return ChallengeInvite(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      challengeId:
          data.challengeId.present ? data.challengeId.value : this.challengeId,
      title: data.title.present ? data.title.value : this.title,
      metric: data.metric.present ? data.metric.value : this.metric,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      inviteUrl: data.inviteUrl.present ? data.inviteUrl.value : this.inviteUrl,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChallengeInvite(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('challengeId: $challengeId, ')
          ..write('title: $title, ')
          ..write('metric: $metric, ')
          ..write('targetValue: $targetValue, ')
          ..write('inviteUrl: $inviteUrl, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    challengeId,
    title,
    metric,
    targetValue,
    inviteUrl,
    status,
    createdAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChallengeInvite &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.challengeId == this.challengeId &&
          other.title == this.title &&
          other.metric == this.metric &&
          other.targetValue == this.targetValue &&
          other.inviteUrl == this.inviteUrl &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class ChallengeInvitesCompanion extends UpdateCompanion<ChallengeInvite> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String?> challengeId;
  final Value<String> title;
  final Value<String> metric;
  final Value<double> targetValue;
  final Value<String?> inviteUrl;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  const ChallengeInvitesCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.title = const Value.absent(),
    this.metric = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.inviteUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  ChallengeInvitesCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    this.challengeId = const Value.absent(),
    required String title,
    required String metric,
    this.targetValue = const Value.absent(),
    this.inviteUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  }) : localId = Value(localId),
       title = Value(title),
       metric = Value(metric);
  static Insertable<ChallengeInvite> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? challengeId,
    Expression<String>? title,
    Expression<String>? metric,
    Expression<double>? targetValue,
    Expression<String>? inviteUrl,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (challengeId != null) 'challenge_id': challengeId,
      if (title != null) 'title': title,
      if (metric != null) 'metric': metric,
      if (targetValue != null) 'target_value': targetValue,
      if (inviteUrl != null) 'invite_url': inviteUrl,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  ChallengeInvitesCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String?>? challengeId,
    Value<String>? title,
    Value<String>? metric,
    Value<double>? targetValue,
    Value<String?>? inviteUrl,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
  }) {
    return ChallengeInvitesCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      challengeId: challengeId ?? this.challengeId,
      title: title ?? this.title,
      metric: metric ?? this.metric,
      targetValue: targetValue ?? this.targetValue,
      inviteUrl: inviteUrl ?? this.inviteUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (challengeId.present) {
      map['challenge_id'] = Variable<String>(challengeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (inviteUrl.present) {
      map['invite_url'] = Variable<String>(inviteUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChallengeInvitesCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('challengeId: $challengeId, ')
          ..write('title: $title, ')
          ..write('metric: $metric, ')
          ..write('targetValue: $targetValue, ')
          ..write('inviteUrl: $inviteUrl, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class PersonalRecords extends Table
    with TableInfo<PersonalRecords, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PersonalRecords(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _sportKeyMeta = const VerificationMeta(
    'sportKey',
  );
  late final GeneratedColumn<String> sportKey = GeneratedColumn<String>(
    'sport_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _recordKeyMeta = const VerificationMeta(
    'recordKey',
  );
  late final GeneratedColumn<String> recordKey = GeneratedColumn<String>(
    'record_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sessionLocalIdMeta = const VerificationMeta(
    'sessionLocalId',
  );
  late final GeneratedColumn<String> sessionLocalId = GeneratedColumn<String>(
    'session_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
    defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    sportKey,
    recordKey,
    label,
    metric,
    value,
    unit,
    sessionLocalId,
    achievedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('sport_key')) {
      context.handle(
        _sportKeyMeta,
        sportKey.isAcceptableOrUnknown(data['sport_key']!, _sportKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sportKeyMeta);
    }
    if (data.containsKey('record_key')) {
      context.handle(
        _recordKeyMeta,
        recordKey.isAcceptableOrUnknown(data['record_key']!, _recordKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_recordKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('session_local_id')) {
      context.handle(
        _sessionLocalIdMeta,
        sessionLocalId.isAcceptableOrUnknown(
          data['session_local_id']!,
          _sessionLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionLocalIdMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sportKey, recordKey},
  ];
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      sportKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sport_key'],
          )!,
      recordKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}record_key'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
      metric:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}metric'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}value'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      sessionLocalId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_local_id'],
          )!,
      achievedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}achieved_at'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  PersonalRecords createAlias(String alias) {
    return PersonalRecords(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(sport_key, record_key)'];
  @override
  bool get dontWriteConstraints => true;
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  final int id;
  final String localId;
  final String sportKey;
  final String recordKey;
  final String label;
  final String metric;
  final double value;
  final String unit;
  final String sessionLocalId;
  final DateTime achievedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PersonalRecord({
    required this.id,
    required this.localId,
    required this.sportKey,
    required this.recordKey,
    required this.label,
    required this.metric,
    required this.value,
    required this.unit,
    required this.sessionLocalId,
    required this.achievedAt,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['sport_key'] = Variable<String>(sportKey);
    map['record_key'] = Variable<String>(recordKey);
    map['label'] = Variable<String>(label);
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['session_local_id'] = Variable<String>(sessionLocalId);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      localId: Value(localId),
      sportKey: Value(sportKey),
      recordKey: Value(recordKey),
      label: Value(label),
      metric: Value(metric),
      value: Value(value),
      unit: Value(unit),
      sessionLocalId: Value(sessionLocalId),
      achievedAt: Value(achievedAt),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory PersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      sportKey: serializer.fromJson<String>(json['sport_key']),
      recordKey: serializer.fromJson<String>(json['record_key']),
      label: serializer.fromJson<String>(json['label']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      sessionLocalId: serializer.fromJson<String>(json['session_local_id']),
      achievedAt: serializer.fromJson<DateTime>(json['achieved_at']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'sport_key': serializer.toJson<String>(sportKey),
      'record_key': serializer.toJson<String>(recordKey),
      'label': serializer.toJson<String>(label),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'session_local_id': serializer.toJson<String>(sessionLocalId),
      'achieved_at': serializer.toJson<DateTime>(achievedAt),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PersonalRecord copyWith({
    int? id,
    String? localId,
    String? sportKey,
    String? recordKey,
    String? label,
    String? metric,
    double? value,
    String? unit,
    String? sessionLocalId,
    DateTime? achievedAt,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => PersonalRecord(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    sportKey: sportKey ?? this.sportKey,
    recordKey: recordKey ?? this.recordKey,
    label: label ?? this.label,
    metric: metric ?? this.metric,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    sessionLocalId: sessionLocalId ?? this.sessionLocalId,
    achievedAt: achievedAt ?? this.achievedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      sportKey: data.sportKey.present ? data.sportKey.value : this.sportKey,
      recordKey: data.recordKey.present ? data.recordKey.value : this.recordKey,
      label: data.label.present ? data.label.value : this.label,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      sessionLocalId:
          data.sessionLocalId.present
              ? data.sessionLocalId.value
              : this.sessionLocalId,
      achievedAt:
          data.achievedAt.present ? data.achievedAt.value : this.achievedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sportKey: $sportKey, ')
          ..write('recordKey: $recordKey, ')
          ..write('label: $label, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    sportKey,
    recordKey,
    label,
    metric,
    value,
    unit,
    sessionLocalId,
    achievedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.sportKey == this.sportKey &&
          other.recordKey == this.recordKey &&
          other.label == this.label &&
          other.metric == this.metric &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.sessionLocalId == this.sessionLocalId &&
          other.achievedAt == this.achievedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String> sportKey;
  final Value<String> recordKey;
  final Value<String> label;
  final Value<String> metric;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> sessionLocalId;
  final Value<DateTime> achievedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.sportKey = const Value.absent(),
    this.recordKey = const Value.absent(),
    this.label = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.sessionLocalId = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String sportKey,
    required String recordKey,
    required String label,
    required String metric,
    required double value,
    required String unit,
    required String sessionLocalId,
    required DateTime achievedAt,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : localId = Value(localId),
       sportKey = Value(sportKey),
       recordKey = Value(recordKey),
       label = Value(label),
       metric = Value(metric),
       value = Value(value),
       unit = Value(unit),
       sessionLocalId = Value(sessionLocalId),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalRecord> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? sportKey,
    Expression<String>? recordKey,
    Expression<String>? label,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? sessionLocalId,
    Expression<DateTime>? achievedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (sportKey != null) 'sport_key': sportKey,
      if (recordKey != null) 'record_key': recordKey,
      if (label != null) 'label': label,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (sessionLocalId != null) 'session_local_id': sessionLocalId,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String>? sportKey,
    Value<String>? recordKey,
    Value<String>? label,
    Value<String>? metric,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? sessionLocalId,
    Value<DateTime>? achievedAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      sportKey: sportKey ?? this.sportKey,
      recordKey: recordKey ?? this.recordKey,
      label: label ?? this.label,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      sessionLocalId: sessionLocalId ?? this.sessionLocalId,
      achievedAt: achievedAt ?? this.achievedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (sportKey.present) {
      map['sport_key'] = Variable<String>(sportKey.value);
    }
    if (recordKey.present) {
      map['record_key'] = Variable<String>(recordKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (sessionLocalId.present) {
      map['session_local_id'] = Variable<String>(sessionLocalId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('sportKey: $sportKey, ')
          ..write('recordKey: $recordKey, ')
          ..write('label: $label, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sessionLocalId: $sessionLocalId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class TrainingPlans extends Table with TableInfo<TrainingPlans, TrainingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TrainingPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _planKeyMeta = const VerificationMeta(
    'planKey',
  );
  late final GeneratedColumn<String> planKey = GeneratedColumn<String>(
    'plan_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sportKeyMeta = const VerificationMeta(
    'sportKey',
  );
  late final GeneratedColumn<String> sportKey = GeneratedColumn<String>(
    'sport_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _weeksMeta = const VerificationMeta('weeks');
  late final GeneratedColumn<int> weeks = GeneratedColumn<int>(
    'weeks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'active\'',
    defaultValue: const CustomExpression('\'active\''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    planKey,
    title,
    sportKey,
    level,
    startDate,
    weeks,
    status,
    createdAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('plan_key')) {
      context.handle(
        _planKeyMeta,
        planKey.isAcceptableOrUnknown(data['plan_key']!, _planKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_planKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sport_key')) {
      context.handle(
        _sportKeyMeta,
        sportKey.isAcceptableOrUnknown(data['sport_key']!, _sportKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sportKeyMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('weeks')) {
      context.handle(
        _weeksMeta,
        weeks.isAcceptableOrUnknown(data['weeks']!, _weeksMeta),
      );
    } else if (isInserting) {
      context.missing(_weeksMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  TrainingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlan(
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      planKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}plan_key'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      sportKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sport_key'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}level'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      weeks:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}weeks'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  TrainingPlans createAlias(String alias) {
    return TrainingPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TrainingPlan extends DataClass implements Insertable<TrainingPlan> {
  final String localId;
  final String planKey;
  final String title;
  final String sportKey;
  final String level;
  final DateTime startDate;
  final int weeks;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  const TrainingPlan({
    required this.localId,
    required this.planKey,
    required this.title,
    required this.sportKey,
    required this.level,
    required this.startDate,
    required this.weeks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['plan_key'] = Variable<String>(planKey);
    map['title'] = Variable<String>(title);
    map['sport_key'] = Variable<String>(sportKey);
    map['level'] = Variable<String>(level);
    map['start_date'] = Variable<DateTime>(startDate);
    map['weeks'] = Variable<int>(weeks);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TrainingPlansCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlansCompanion(
      localId: Value(localId),
      planKey: Value(planKey),
      title: Value(title),
      sportKey: Value(sportKey),
      level: Value(level),
      startDate: Value(startDate),
      weeks: Value(weeks),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
    );
  }

  factory TrainingPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlan(
      localId: serializer.fromJson<String>(json['local_id']),
      planKey: serializer.fromJson<String>(json['plan_key']),
      title: serializer.fromJson<String>(json['title']),
      sportKey: serializer.fromJson<String>(json['sport_key']),
      level: serializer.fromJson<String>(json['level']),
      startDate: serializer.fromJson<DateTime>(json['start_date']),
      weeks: serializer.fromJson<int>(json['weeks']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      completedAt: serializer.fromJson<DateTime?>(json['completed_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<String>(localId),
      'plan_key': serializer.toJson<String>(planKey),
      'title': serializer.toJson<String>(title),
      'sport_key': serializer.toJson<String>(sportKey),
      'level': serializer.toJson<String>(level),
      'start_date': serializer.toJson<DateTime>(startDate),
      'weeks': serializer.toJson<int>(weeks),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'completed_at': serializer.toJson<DateTime?>(completedAt),
    };
  }

  TrainingPlan copyWith({
    String? localId,
    String? planKey,
    String? title,
    String? sportKey,
    String? level,
    DateTime? startDate,
    int? weeks,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => TrainingPlan(
    localId: localId ?? this.localId,
    planKey: planKey ?? this.planKey,
    title: title ?? this.title,
    sportKey: sportKey ?? this.sportKey,
    level: level ?? this.level,
    startDate: startDate ?? this.startDate,
    weeks: weeks ?? this.weeks,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  TrainingPlan copyWithCompanion(TrainingPlansCompanion data) {
    return TrainingPlan(
      localId: data.localId.present ? data.localId.value : this.localId,
      planKey: data.planKey.present ? data.planKey.value : this.planKey,
      title: data.title.present ? data.title.value : this.title,
      sportKey: data.sportKey.present ? data.sportKey.value : this.sportKey,
      level: data.level.present ? data.level.value : this.level,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      weeks: data.weeks.present ? data.weeks.value : this.weeks,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlan(')
          ..write('localId: $localId, ')
          ..write('planKey: $planKey, ')
          ..write('title: $title, ')
          ..write('sportKey: $sportKey, ')
          ..write('level: $level, ')
          ..write('startDate: $startDate, ')
          ..write('weeks: $weeks, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    planKey,
    title,
    sportKey,
    level,
    startDate,
    weeks,
    status,
    createdAt,
    updatedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlan &&
          other.localId == this.localId &&
          other.planKey == this.planKey &&
          other.title == this.title &&
          other.sportKey == this.sportKey &&
          other.level == this.level &&
          other.startDate == this.startDate &&
          other.weeks == this.weeks &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class TrainingPlansCompanion extends UpdateCompanion<TrainingPlan> {
  final Value<String> localId;
  final Value<String> planKey;
  final Value<String> title;
  final Value<String> sportKey;
  final Value<String> level;
  final Value<DateTime> startDate;
  final Value<int> weeks;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const TrainingPlansCompanion({
    this.localId = const Value.absent(),
    this.planKey = const Value.absent(),
    this.title = const Value.absent(),
    this.sportKey = const Value.absent(),
    this.level = const Value.absent(),
    this.startDate = const Value.absent(),
    this.weeks = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingPlansCompanion.insert({
    required String localId,
    required String planKey,
    required String title,
    required String sportKey,
    required String level,
    required DateTime startDate,
    required int weeks,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       planKey = Value(planKey),
       title = Value(title),
       sportKey = Value(sportKey),
       level = Value(level),
       startDate = Value(startDate),
       weeks = Value(weeks),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrainingPlan> custom({
    Expression<String>? localId,
    Expression<String>? planKey,
    Expression<String>? title,
    Expression<String>? sportKey,
    Expression<String>? level,
    Expression<DateTime>? startDate,
    Expression<int>? weeks,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (planKey != null) 'plan_key': planKey,
      if (title != null) 'title': title,
      if (sportKey != null) 'sport_key': sportKey,
      if (level != null) 'level': level,
      if (startDate != null) 'start_date': startDate,
      if (weeks != null) 'weeks': weeks,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingPlansCompanion copyWith({
    Value<String>? localId,
    Value<String>? planKey,
    Value<String>? title,
    Value<String>? sportKey,
    Value<String>? level,
    Value<DateTime>? startDate,
    Value<int>? weeks,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return TrainingPlansCompanion(
      localId: localId ?? this.localId,
      planKey: planKey ?? this.planKey,
      title: title ?? this.title,
      sportKey: sportKey ?? this.sportKey,
      level: level ?? this.level,
      startDate: startDate ?? this.startDate,
      weeks: weeks ?? this.weeks,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (planKey.present) {
      map['plan_key'] = Variable<String>(planKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sportKey.present) {
      map['sport_key'] = Variable<String>(sportKey.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (weeks.present) {
      map['weeks'] = Variable<int>(weeks.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlansCompanion(')
          ..write('localId: $localId, ')
          ..write('planKey: $planKey, ')
          ..write('title: $title, ')
          ..write('sportKey: $sportKey, ')
          ..write('level: $level, ')
          ..write('startDate: $startDate, ')
          ..write('weeks: $weeks, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TrainingPlanWorkouts extends Table
    with TableInfo<TrainingPlanWorkouts, TrainingPlanWorkout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TrainingPlanWorkouts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _planLocalIdMeta = const VerificationMeta(
    'planLocalId',
  );
  late final GeneratedColumn<String> planLocalId = GeneratedColumn<String>(
    'plan_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _weekIndexMeta = const VerificationMeta(
    'weekIndex',
  );
  late final GeneratedColumn<int> weekIndex = GeneratedColumn<int>(
    'week_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>(
        'scheduled_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _workoutTypeMeta = const VerificationMeta(
    'workoutType',
  );
  late final GeneratedColumn<String> workoutType = GeneratedColumn<String>(
    'workout_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _targetDurationMinutesMeta =
      const VerificationMeta('targetDurationMinutes');
  late final GeneratedColumn<int> targetDurationMinutes = GeneratedColumn<int>(
    'target_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _targetDistanceMetersMeta =
      const VerificationMeta('targetDistanceMeters');
  late final GeneratedColumn<double> targetDistanceMeters =
      GeneratedColumn<double>(
        'target_distance_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression('0'),
      );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  late final GeneratedColumn<String> intensity = GeneratedColumn<String>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'easy\'',
    defaultValue: const CustomExpression('\'easy\''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'planned\'',
    defaultValue: const CustomExpression('\'planned\''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    planLocalId,
    weekIndex,
    dayIndex,
    scheduledDate,
    title,
    workoutType,
    targetDurationMinutes,
    targetDistanceMeters,
    intensity,
    status,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plan_workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlanWorkout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('plan_local_id')) {
      context.handle(
        _planLocalIdMeta,
        planLocalId.isAcceptableOrUnknown(
          data['plan_local_id']!,
          _planLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_planLocalIdMeta);
    }
    if (data.containsKey('week_index')) {
      context.handle(
        _weekIndexMeta,
        weekIndex.isAcceptableOrUnknown(data['week_index']!, _weekIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_weekIndexMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('workout_type')) {
      context.handle(
        _workoutTypeMeta,
        workoutType.isAcceptableOrUnknown(
          data['workout_type']!,
          _workoutTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutTypeMeta);
    }
    if (data.containsKey('target_duration_minutes')) {
      context.handle(
        _targetDurationMinutesMeta,
        targetDurationMinutes.isAcceptableOrUnknown(
          data['target_duration_minutes']!,
          _targetDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('target_distance_meters')) {
      context.handle(
        _targetDistanceMetersMeta,
        targetDistanceMeters.isAcceptableOrUnknown(
          data['target_distance_meters']!,
          _targetDistanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingPlanWorkout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlanWorkout(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      planLocalId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}plan_local_id'],
          )!,
      weekIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}week_index'],
          )!,
      dayIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}day_index'],
          )!,
      scheduledDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_date'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      workoutType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}workout_type'],
          )!,
      targetDurationMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}target_duration_minutes'],
          )!,
      targetDistanceMeters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}target_distance_meters'],
          )!,
      intensity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}intensity'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  TrainingPlanWorkouts createAlias(String alias) {
    return TrainingPlanWorkouts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TrainingPlanWorkout extends DataClass
    implements Insertable<TrainingPlanWorkout> {
  final int id;
  final String localId;
  final String planLocalId;
  final int weekIndex;
  final int dayIndex;
  final DateTime scheduledDate;
  final String title;
  final String workoutType;
  final int targetDurationMinutes;
  final double targetDistanceMeters;
  final String intensity;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const TrainingPlanWorkout({
    required this.id,
    required this.localId,
    required this.planLocalId,
    required this.weekIndex,
    required this.dayIndex,
    required this.scheduledDate,
    required this.title,
    required this.workoutType,
    required this.targetDurationMinutes,
    required this.targetDistanceMeters,
    required this.intensity,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['plan_local_id'] = Variable<String>(planLocalId);
    map['week_index'] = Variable<int>(weekIndex);
    map['day_index'] = Variable<int>(dayIndex);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    map['title'] = Variable<String>(title);
    map['workout_type'] = Variable<String>(workoutType);
    map['target_duration_minutes'] = Variable<int>(targetDurationMinutes);
    map['target_distance_meters'] = Variable<double>(targetDistanceMeters);
    map['intensity'] = Variable<String>(intensity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TrainingPlanWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlanWorkoutsCompanion(
      id: Value(id),
      localId: Value(localId),
      planLocalId: Value(planLocalId),
      weekIndex: Value(weekIndex),
      dayIndex: Value(dayIndex),
      scheduledDate: Value(scheduledDate),
      title: Value(title),
      workoutType: Value(workoutType),
      targetDurationMinutes: Value(targetDurationMinutes),
      targetDistanceMeters: Value(targetDistanceMeters),
      intensity: Value(intensity),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory TrainingPlanWorkout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlanWorkout(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['local_id']),
      planLocalId: serializer.fromJson<String>(json['plan_local_id']),
      weekIndex: serializer.fromJson<int>(json['week_index']),
      dayIndex: serializer.fromJson<int>(json['day_index']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduled_date']),
      title: serializer.fromJson<String>(json['title']),
      workoutType: serializer.fromJson<String>(json['workout_type']),
      targetDurationMinutes: serializer.fromJson<int>(
        json['target_duration_minutes'],
      ),
      targetDistanceMeters: serializer.fromJson<double>(
        json['target_distance_meters'],
      ),
      intensity: serializer.fromJson<String>(json['intensity']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'local_id': serializer.toJson<String>(localId),
      'plan_local_id': serializer.toJson<String>(planLocalId),
      'week_index': serializer.toJson<int>(weekIndex),
      'day_index': serializer.toJson<int>(dayIndex),
      'scheduled_date': serializer.toJson<DateTime>(scheduledDate),
      'title': serializer.toJson<String>(title),
      'workout_type': serializer.toJson<String>(workoutType),
      'target_duration_minutes': serializer.toJson<int>(targetDurationMinutes),
      'target_distance_meters': serializer.toJson<double>(targetDistanceMeters),
      'intensity': serializer.toJson<String>(intensity),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TrainingPlanWorkout copyWith({
    int? id,
    String? localId,
    String? planLocalId,
    int? weekIndex,
    int? dayIndex,
    DateTime? scheduledDate,
    String? title,
    String? workoutType,
    int? targetDurationMinutes,
    double? targetDistanceMeters,
    String? intensity,
    String? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => TrainingPlanWorkout(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    planLocalId: planLocalId ?? this.planLocalId,
    weekIndex: weekIndex ?? this.weekIndex,
    dayIndex: dayIndex ?? this.dayIndex,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    title: title ?? this.title,
    workoutType: workoutType ?? this.workoutType,
    targetDurationMinutes: targetDurationMinutes ?? this.targetDurationMinutes,
    targetDistanceMeters: targetDistanceMeters ?? this.targetDistanceMeters,
    intensity: intensity ?? this.intensity,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TrainingPlanWorkout copyWithCompanion(TrainingPlanWorkoutsCompanion data) {
    return TrainingPlanWorkout(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      planLocalId:
          data.planLocalId.present ? data.planLocalId.value : this.planLocalId,
      weekIndex: data.weekIndex.present ? data.weekIndex.value : this.weekIndex,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      scheduledDate:
          data.scheduledDate.present
              ? data.scheduledDate.value
              : this.scheduledDate,
      title: data.title.present ? data.title.value : this.title,
      workoutType:
          data.workoutType.present ? data.workoutType.value : this.workoutType,
      targetDurationMinutes:
          data.targetDurationMinutes.present
              ? data.targetDurationMinutes.value
              : this.targetDurationMinutes,
      targetDistanceMeters:
          data.targetDistanceMeters.present
              ? data.targetDistanceMeters.value
              : this.targetDistanceMeters,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanWorkout(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('planLocalId: $planLocalId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('title: $title, ')
          ..write('workoutType: $workoutType, ')
          ..write('targetDurationMinutes: $targetDurationMinutes, ')
          ..write('targetDistanceMeters: $targetDistanceMeters, ')
          ..write('intensity: $intensity, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    planLocalId,
    weekIndex,
    dayIndex,
    scheduledDate,
    title,
    workoutType,
    targetDurationMinutes,
    targetDistanceMeters,
    intensity,
    status,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlanWorkout &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.planLocalId == this.planLocalId &&
          other.weekIndex == this.weekIndex &&
          other.dayIndex == this.dayIndex &&
          other.scheduledDate == this.scheduledDate &&
          other.title == this.title &&
          other.workoutType == this.workoutType &&
          other.targetDurationMinutes == this.targetDurationMinutes &&
          other.targetDistanceMeters == this.targetDistanceMeters &&
          other.intensity == this.intensity &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrainingPlanWorkoutsCompanion
    extends UpdateCompanion<TrainingPlanWorkout> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String> planLocalId;
  final Value<int> weekIndex;
  final Value<int> dayIndex;
  final Value<DateTime> scheduledDate;
  final Value<String> title;
  final Value<String> workoutType;
  final Value<int> targetDurationMinutes;
  final Value<double> targetDistanceMeters;
  final Value<String> intensity;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const TrainingPlanWorkoutsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.planLocalId = const Value.absent(),
    this.weekIndex = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.title = const Value.absent(),
    this.workoutType = const Value.absent(),
    this.targetDurationMinutes = const Value.absent(),
    this.targetDistanceMeters = const Value.absent(),
    this.intensity = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TrainingPlanWorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String planLocalId,
    required int weekIndex,
    required int dayIndex,
    required DateTime scheduledDate,
    required String title,
    required String workoutType,
    this.targetDurationMinutes = const Value.absent(),
    this.targetDistanceMeters = const Value.absent(),
    this.intensity = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  }) : localId = Value(localId),
       planLocalId = Value(planLocalId),
       weekIndex = Value(weekIndex),
       dayIndex = Value(dayIndex),
       scheduledDate = Value(scheduledDate),
       title = Value(title),
       workoutType = Value(workoutType),
       createdAt = Value(createdAt);
  static Insertable<TrainingPlanWorkout> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? planLocalId,
    Expression<int>? weekIndex,
    Expression<int>? dayIndex,
    Expression<DateTime>? scheduledDate,
    Expression<String>? title,
    Expression<String>? workoutType,
    Expression<int>? targetDurationMinutes,
    Expression<double>? targetDistanceMeters,
    Expression<String>? intensity,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (planLocalId != null) 'plan_local_id': planLocalId,
      if (weekIndex != null) 'week_index': weekIndex,
      if (dayIndex != null) 'day_index': dayIndex,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (title != null) 'title': title,
      if (workoutType != null) 'workout_type': workoutType,
      if (targetDurationMinutes != null)
        'target_duration_minutes': targetDurationMinutes,
      if (targetDistanceMeters != null)
        'target_distance_meters': targetDistanceMeters,
      if (intensity != null) 'intensity': intensity,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TrainingPlanWorkoutsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String>? planLocalId,
    Value<int>? weekIndex,
    Value<int>? dayIndex,
    Value<DateTime>? scheduledDate,
    Value<String>? title,
    Value<String>? workoutType,
    Value<int>? targetDurationMinutes,
    Value<double>? targetDistanceMeters,
    Value<String>? intensity,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return TrainingPlanWorkoutsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      planLocalId: planLocalId ?? this.planLocalId,
      weekIndex: weekIndex ?? this.weekIndex,
      dayIndex: dayIndex ?? this.dayIndex,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      title: title ?? this.title,
      workoutType: workoutType ?? this.workoutType,
      targetDurationMinutes:
          targetDurationMinutes ?? this.targetDurationMinutes,
      targetDistanceMeters: targetDistanceMeters ?? this.targetDistanceMeters,
      intensity: intensity ?? this.intensity,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (planLocalId.present) {
      map['plan_local_id'] = Variable<String>(planLocalId.value);
    }
    if (weekIndex.present) {
      map['week_index'] = Variable<int>(weekIndex.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (workoutType.present) {
      map['workout_type'] = Variable<String>(workoutType.value);
    }
    if (targetDurationMinutes.present) {
      map['target_duration_minutes'] = Variable<int>(
        targetDurationMinutes.value,
      );
    }
    if (targetDistanceMeters.present) {
      map['target_distance_meters'] = Variable<double>(
        targetDistanceMeters.value,
      );
    }
    if (intensity.present) {
      map['intensity'] = Variable<String>(intensity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('planLocalId: $planLocalId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('title: $title, ')
          ..write('workoutType: $workoutType, ')
          ..write('targetDurationMinutes: $targetDurationMinutes, ')
          ..write('targetDistanceMeters: $targetDistanceMeters, ')
          ..write('intensity: $intensity, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final HealthRecords healthRecords = HealthRecords(this);
  late final Index idxRecordsTypeTime = Index(
    'idx_records_type_time',
    'CREATE INDEX idx_records_type_time ON health_records (data_type, date_from)',
  );
  late final Index idxRecordsSync = Index(
    'idx_records_sync',
    'CREATE INDEX idx_records_sync ON health_records (sync_status)',
  );
  late final SyncLogs syncLogs = SyncLogs(this);
  late final Index idxSyncLogsStarted = Index(
    'idx_sync_logs_started',
    'CREATE INDEX idx_sync_logs_started ON sync_logs (started_at)',
  );
  late final ActivitySessions activitySessions = ActivitySessions(this);
  late final ActivityEvents activityEvents = ActivityEvents(this);
  late final ActivityPoints activityPoints = ActivityPoints(this);
  late final ActivitySummaries activitySummaries = ActivitySummaries(this);
  late final OfflineMapRegions offlineMapRegions = OfflineMapRegions(this);
  late final SavedRoutes savedRoutes = SavedRoutes(this);
  late final DailySummaries dailySummaries = DailySummaries(this);
  late final AiToolCalls aiToolCalls = AiToolCalls(this);
  late final AiUsageWindows aiUsageWindows = AiUsageWindows(this);
  late final AiConversations aiConversations = AiConversations(this);
  late final AiMessages aiMessages = AiMessages(this);
  late final CommunityShareRecords communityShareRecords =
      CommunityShareRecords(this);
  late final ChallengeInvites challengeInvites = ChallengeInvites(this);
  late final PersonalRecords personalRecords = PersonalRecords(this);
  late final TrainingPlans trainingPlans = TrainingPlans(this);
  late final TrainingPlanWorkouts trainingPlanWorkouts = TrainingPlanWorkouts(
    this,
  );
  late final Index idxActivitySessionsStatus = Index(
    'idx_activity_sessions_status',
    'CREATE INDEX idx_activity_sessions_status ON activity_sessions (status, started_at)',
  );
  late final Index idxActivitySessionsSync = Index(
    'idx_activity_sessions_sync',
    'CREATE INDEX idx_activity_sessions_sync ON activity_sessions (sync_status)',
  );
  late final Index idxActivityPointsSessionTime = Index(
    'idx_activity_points_session_time',
    'CREATE INDEX idx_activity_points_session_time ON activity_points (session_local_id, timestamp)',
  );
  late final Index idxActivityEventsSessionTime = Index(
    'idx_activity_events_session_time',
    'CREATE INDEX idx_activity_events_session_time ON activity_events (session_local_id, timestamp)',
  );
  late final Index idxActivitySummariesSync = Index(
    'idx_activity_summaries_sync',
    'CREATE INDEX idx_activity_summaries_sync ON activity_summaries (sync_status)',
  );
  late final Index idxOfflineMapRegionsStatus = Index(
    'idx_offline_map_regions_status',
    'CREATE INDEX idx_offline_map_regions_status ON offline_map_regions (status)',
  );
  late final Index idxSavedRoutesSource = Index(
    'idx_saved_routes_source',
    'CREATE INDEX idx_saved_routes_source ON saved_routes (source_session_local_id)',
  );
  late final Index idxDailySummariesSync = Index(
    'idx_daily_summaries_sync',
    'CREATE INDEX idx_daily_summaries_sync ON daily_summaries (sync_status)',
  );
  late final Index idxAiToolCallsCreated = Index(
    'idx_ai_tool_calls_created',
    'CREATE INDEX idx_ai_tool_calls_created ON ai_tool_calls (created_at)',
  );
  late final Index idxAiToolCallsWindow = Index(
    'idx_ai_tool_calls_window',
    'CREATE INDEX idx_ai_tool_calls_window ON ai_tool_calls (usage_window_id)',
  );
  late final Index idxAiUsageWindowsTierStarted = Index(
    'idx_ai_usage_windows_tier_started',
    'CREATE INDEX idx_ai_usage_windows_tier_started ON ai_usage_windows (tier, started_at)',
  );
  late final Index idxAiConversationsUpdated = Index(
    'idx_ai_conversations_updated',
    'CREATE INDEX idx_ai_conversations_updated ON ai_conversations (updated_at)',
  );
  late final Index idxAiMessagesConversationTime = Index(
    'idx_ai_messages_conversation_time',
    'CREATE INDEX idx_ai_messages_conversation_time ON ai_messages (conversation_id, created_at)',
  );
  late final Index idxCommunityShareSession = Index(
    'idx_community_share_session',
    'CREATE INDEX idx_community_share_session ON community_share_records (session_local_id)',
  );
  late final Index idxChallengeInvitesStatus = Index(
    'idx_challenge_invites_status',
    'CREATE INDEX idx_challenge_invites_status ON challenge_invites (status)',
  );
  late final Index idxPersonalRecordsSport = Index(
    'idx_personal_records_sport',
    'CREATE INDEX idx_personal_records_sport ON personal_records (sport_key, record_key)',
  );
  late final Index idxPersonalRecordsSession = Index(
    'idx_personal_records_session',
    'CREATE INDEX idx_personal_records_session ON personal_records (session_local_id)',
  );
  late final Index idxTrainingPlansStatus = Index(
    'idx_training_plans_status',
    'CREATE INDEX idx_training_plans_status ON training_plans (status, start_date)',
  );
  late final Index idxTrainingPlanWorkoutsPlan = Index(
    'idx_training_plan_workouts_plan',
    'CREATE INDEX idx_training_plan_workouts_plan ON training_plan_workouts (plan_local_id, scheduled_date)',
  );
  late final Index idxTrainingPlanWorkoutsDate = Index(
    'idx_training_plan_workouts_date',
    'CREATE INDEX idx_training_plan_workouts_date ON training_plan_workouts (scheduled_date, status)',
  );
  Selectable<HealthRecord> unsyncedRecords() {
    return customSelect(
      'SELECT * FROM health_records WHERE sync_status = \'pending\' ORDER BY date_from ASC',
      variables: [],
      readsFrom: {healthRecords},
    ).asyncMap(healthRecords.mapFromRow);
  }

  Selectable<HealthRecord> recordsByType(
    String var1,
    DateTime var2,
    DateTime var3,
  ) {
    return customSelect(
      'SELECT * FROM health_records WHERE data_type = ?1 AND date_from >= ?2 AND date_from <= ?3 ORDER BY date_from DESC',
      variables: [
        Variable<String>(var1),
        Variable<DateTime>(var2),
        Variable<DateTime>(var3),
      ],
      readsFrom: {healthRecords},
    ).asyncMap(healthRecords.mapFromRow);
  }

  Future<int> markSynced(List<int> var1) {
    var $arrayStartIndex = 1;
    final expandedvar1 = $expandVar($arrayStartIndex, var1.length);
    $arrayStartIndex += var1.length;
    return customUpdate(
      'UPDATE health_records SET sync_status = \'synced\', synced_at = strftime(\'%s\', \'now\') WHERE id IN ($expandedvar1)',
      variables: [for (var $ in var1) Variable<int>($)],
      updates: {healthRecords},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<int> unsyncedCount() {
    return customSelect(
      'SELECT COUNT(*) AS cnt FROM health_records WHERE sync_status = \'pending\'',
      variables: [],
      readsFrom: {healthRecords},
    ).map((QueryRow row) => row.read<int>('cnt'));
  }

  Selectable<SyncLog> latestSyncLogs(int var1) {
    return customSelect(
      'SELECT * FROM sync_logs ORDER BY started_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {syncLogs},
    ).asyncMap(syncLogs.mapFromRow);
  }

  Selectable<ActivitySession> activeActivitySession() {
    return customSelect(
      'SELECT * FROM activity_sessions WHERE status = \'recording\' OR status = \'paused\' ORDER BY started_at DESC LIMIT 1',
      variables: [],
      readsFrom: {activitySessions},
    ).asyncMap(activitySessions.mapFromRow);
  }

  Selectable<ActivitySession> activitySessionsRecent(int var1) {
    return customSelect(
      'SELECT * FROM activity_sessions WHERE status = \'completed\' ORDER BY started_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {activitySessions},
    ).asyncMap(activitySessions.mapFromRow);
  }

  Selectable<ActivitySession> activitySessionByLocalId(String var1) {
    return customSelect(
      'SELECT * FROM activity_sessions WHERE local_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {activitySessions},
    ).asyncMap(activitySessions.mapFromRow);
  }

  Selectable<ActivityPoint> activityPointsForSession(String var1) {
    return customSelect(
      'SELECT * FROM activity_points WHERE session_local_id = ?1 ORDER BY timestamp ASC',
      variables: [Variable<String>(var1)],
      readsFrom: {activityPoints},
    ).asyncMap(activityPoints.mapFromRow);
  }

  Selectable<ActivitySummary> activitySummaryBySession(String var1) {
    return customSelect(
      'SELECT * FROM activity_summaries WHERE session_local_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {activitySummaries},
    ).asyncMap(activitySummaries.mapFromRow);
  }

  Selectable<SavedRoute> savedRoutesRecent(int var1) {
    return customSelect(
      'SELECT * FROM saved_routes ORDER BY created_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {savedRoutes},
    ).asyncMap(savedRoutes.mapFromRow);
  }

  Selectable<SavedRoute> savedRouteByLocalId(String var1) {
    return customSelect(
      'SELECT * FROM saved_routes WHERE local_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {savedRoutes},
    ).asyncMap(savedRoutes.mapFromRow);
  }

  Selectable<DailySummary> dailySummaryByDate(String var1) {
    return customSelect(
      'SELECT * FROM daily_summaries WHERE local_date = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {dailySummaries},
    ).asyncMap(dailySummaries.mapFromRow);
  }

  Selectable<AiUsageWindow> aiUsageWindowById(String var1) {
    return customSelect(
      'SELECT * FROM ai_usage_windows WHERE window_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {aiUsageWindows},
    ).asyncMap(aiUsageWindows.mapFromRow);
  }

  Selectable<AiUsageWindow> latestAiUsageWindowForTier(String var1) {
    return customSelect(
      'SELECT * FROM ai_usage_windows WHERE tier = ?1 ORDER BY started_at DESC LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {aiUsageWindows},
    ).asyncMap(aiUsageWindows.mapFromRow);
  }

  Selectable<AiConversation> aiConversationsRecent(int var1) {
    return customSelect(
      'SELECT * FROM ai_conversations ORDER BY updated_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {aiConversations},
    ).asyncMap(aiConversations.mapFromRow);
  }

  Selectable<AiConversation> aiConversationById(String var1) {
    return customSelect(
      'SELECT * FROM ai_conversations WHERE local_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {aiConversations},
    ).asyncMap(aiConversations.mapFromRow);
  }

  Selectable<AiMessage> aiMessagesForConversation(String var1, int var2) {
    return customSelect(
      'SELECT * FROM ai_messages WHERE conversation_id = ?1 ORDER BY created_at ASC LIMIT ?2',
      variables: [Variable<String>(var1), Variable<int>(var2)],
      readsFrom: {aiMessages},
    ).asyncMap(aiMessages.mapFromRow);
  }

  Selectable<CommunityShareRecord> communitySharesRecent(int var1) {
    return customSelect(
      'SELECT * FROM community_share_records ORDER BY created_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {communityShareRecords},
    ).asyncMap(communityShareRecords.mapFromRow);
  }

  Selectable<ChallengeInvite> challengeInvitesRecent(int var1) {
    return customSelect(
      'SELECT * FROM challenge_invites ORDER BY created_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {challengeInvites},
    ).asyncMap(challengeInvites.mapFromRow);
  }

  Selectable<PersonalRecord> personalRecordsRecent(int var1) {
    return customSelect(
      'SELECT * FROM personal_records ORDER BY achieved_at DESC LIMIT ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {personalRecords},
    ).asyncMap(personalRecords.mapFromRow);
  }

  Selectable<PersonalRecord> personalRecordsForSession(String var1) {
    return customSelect(
      'SELECT * FROM personal_records WHERE session_local_id = ?1 ORDER BY achieved_at DESC',
      variables: [Variable<String>(var1)],
      readsFrom: {personalRecords},
    ).asyncMap(personalRecords.mapFromRow);
  }

  Selectable<TrainingPlan> activeTrainingPlan() {
    return customSelect(
      'SELECT * FROM training_plans WHERE status = \'active\' ORDER BY start_date DESC LIMIT 1',
      variables: [],
      readsFrom: {trainingPlans},
    ).asyncMap(trainingPlans.mapFromRow);
  }

  Selectable<TrainingPlan> trainingPlanByLocalId(String var1) {
    return customSelect(
      'SELECT * FROM training_plans WHERE local_id = ?1 LIMIT 1',
      variables: [Variable<String>(var1)],
      readsFrom: {trainingPlans},
    ).asyncMap(trainingPlans.mapFromRow);
  }

  Selectable<TrainingPlanWorkout> trainingPlanWorkoutsForPlan(String var1) {
    return customSelect(
      'SELECT * FROM training_plan_workouts WHERE plan_local_id = ?1 ORDER BY scheduled_date ASC',
      variables: [Variable<String>(var1)],
      readsFrom: {trainingPlanWorkouts},
    ).asyncMap(trainingPlanWorkouts.mapFromRow);
  }

  Selectable<TrainingPlanWorkout> trainingPlanWorkoutsBetween(
    DateTime var1,
    DateTime var2,
  ) {
    return customSelect(
      'SELECT * FROM training_plan_workouts WHERE scheduled_date >= ?1 AND scheduled_date < ?2 ORDER BY scheduled_date ASC',
      variables: [Variable<DateTime>(var1), Variable<DateTime>(var2)],
      readsFrom: {trainingPlanWorkouts},
    ).asyncMap(trainingPlanWorkouts.mapFromRow);
  }

  Future<int> cleanOldRecords(String var1) {
    return customUpdate(
      'DELETE FROM health_records WHERE sync_status = \'synced\' AND created_at < DATETIME(\'now\', ?1)',
      variables: [Variable<String>(var1)],
      updates: {healthRecords},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    healthRecords,
    idxRecordsTypeTime,
    idxRecordsSync,
    syncLogs,
    idxSyncLogsStarted,
    activitySessions,
    activityEvents,
    activityPoints,
    activitySummaries,
    offlineMapRegions,
    savedRoutes,
    dailySummaries,
    aiToolCalls,
    aiUsageWindows,
    aiConversations,
    aiMessages,
    communityShareRecords,
    challengeInvites,
    personalRecords,
    trainingPlans,
    trainingPlanWorkouts,
    idxActivitySessionsStatus,
    idxActivitySessionsSync,
    idxActivityPointsSessionTime,
    idxActivityEventsSessionTime,
    idxActivitySummariesSync,
    idxOfflineMapRegionsStatus,
    idxSavedRoutesSource,
    idxDailySummariesSync,
    idxAiToolCallsCreated,
    idxAiToolCallsWindow,
    idxAiUsageWindowsTierStarted,
    idxAiConversationsUpdated,
    idxAiMessagesConversationTime,
    idxCommunityShareSession,
    idxChallengeInvitesStatus,
    idxPersonalRecordsSport,
    idxPersonalRecordsSession,
    idxTrainingPlansStatus,
    idxTrainingPlanWorkoutsPlan,
    idxTrainingPlanWorkoutsDate,
  ];
}

typedef $HealthRecordsCreateCompanionBuilder =
    HealthRecordsCompanion Function({
      Value<int> id,
      required String dataType,
      required double value,
      required String unit,
      required DateTime dateFrom,
      required DateTime dateTo,
      Value<String?> sourceName,
      Value<String?> sourceId,
      Value<String> syncStatus,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
    });
typedef $HealthRecordsUpdateCompanionBuilder =
    HealthRecordsCompanion Function({
      Value<int> id,
      Value<String> dataType,
      Value<double> value,
      Value<String> unit,
      Value<DateTime> dateFrom,
      Value<DateTime> dateTo,
      Value<String?> sourceName,
      Value<String?> sourceId,
      Value<String> syncStatus,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
    });

class $HealthRecordsFilterComposer
    extends Composer<_$AppDatabase, HealthRecords> {
  $HealthRecordsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $HealthRecordsOrderingComposer
    extends Composer<_$AppDatabase, HealthRecords> {
  $HealthRecordsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $HealthRecordsAnnotationComposer
    extends Composer<_$AppDatabase, HealthRecords> {
  $HealthRecordsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dataType =>
      $composableBuilder(column: $table.dataType, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFrom =>
      $composableBuilder(column: $table.dateFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get dateTo =>
      $composableBuilder(column: $table.dateTo, builder: (column) => column);

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $HealthRecordsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          HealthRecords,
          HealthRecord,
          $HealthRecordsFilterComposer,
          $HealthRecordsOrderingComposer,
          $HealthRecordsAnnotationComposer,
          $HealthRecordsCreateCompanionBuilder,
          $HealthRecordsUpdateCompanionBuilder,
          (
            HealthRecord,
            BaseReferences<_$AppDatabase, HealthRecords, HealthRecord>,
          ),
          HealthRecord,
          PrefetchHooks Function()
        > {
  $HealthRecordsTableManager(_$AppDatabase db, HealthRecords table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $HealthRecordsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $HealthRecordsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $HealthRecordsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dataType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> dateFrom = const Value.absent(),
                Value<DateTime> dateTo = const Value.absent(),
                Value<String?> sourceName = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => HealthRecordsCompanion(
                id: id,
                dataType: dataType,
                value: value,
                unit: unit,
                dateFrom: dateFrom,
                dateTo: dateTo,
                sourceName: sourceName,
                sourceId: sourceId,
                syncStatus: syncStatus,
                metadata: metadata,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dataType,
                required double value,
                required String unit,
                required DateTime dateFrom,
                required DateTime dateTo,
                Value<String?> sourceName = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => HealthRecordsCompanion.insert(
                id: id,
                dataType: dataType,
                value: value,
                unit: unit,
                dateFrom: dateFrom,
                dateTo: dateTo,
                sourceName: sourceName,
                sourceId: sourceId,
                syncStatus: syncStatus,
                metadata: metadata,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $HealthRecordsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      HealthRecords,
      HealthRecord,
      $HealthRecordsFilterComposer,
      $HealthRecordsOrderingComposer,
      $HealthRecordsAnnotationComposer,
      $HealthRecordsCreateCompanionBuilder,
      $HealthRecordsUpdateCompanionBuilder,
      (
        HealthRecord,
        BaseReferences<_$AppDatabase, HealthRecords, HealthRecord>,
      ),
      HealthRecord,
      PrefetchHooks Function()
    >;
typedef $SyncLogsCreateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      required String operation,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> collectedCount,
      Value<int> insertedCount,
      Value<int> syncedCount,
      Value<String?> message,
    });
typedef $SyncLogsUpdateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      Value<String> operation,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> collectedCount,
      Value<int> insertedCount,
      Value<int> syncedCount,
      Value<String?> message,
    });

class $SyncLogsFilterComposer extends Composer<_$AppDatabase, SyncLogs> {
  $SyncLogsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get collectedCount => $composableBuilder(
    column: $table.collectedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insertedCount => $composableBuilder(
    column: $table.insertedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncedCount => $composableBuilder(
    column: $table.syncedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );
}

class $SyncLogsOrderingComposer extends Composer<_$AppDatabase, SyncLogs> {
  $SyncLogsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get collectedCount => $composableBuilder(
    column: $table.collectedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insertedCount => $composableBuilder(
    column: $table.insertedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncedCount => $composableBuilder(
    column: $table.syncedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SyncLogsAnnotationComposer extends Composer<_$AppDatabase, SyncLogs> {
  $SyncLogsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get collectedCount => $composableBuilder(
    column: $table.collectedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get insertedCount => $composableBuilder(
    column: $table.insertedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncedCount => $composableBuilder(
    column: $table.syncedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);
}

class $SyncLogsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SyncLogs,
          SyncLog,
          $SyncLogsFilterComposer,
          $SyncLogsOrderingComposer,
          $SyncLogsAnnotationComposer,
          $SyncLogsCreateCompanionBuilder,
          $SyncLogsUpdateCompanionBuilder,
          (SyncLog, BaseReferences<_$AppDatabase, SyncLogs, SyncLog>),
          SyncLog,
          PrefetchHooks Function()
        > {
  $SyncLogsTableManager(_$AppDatabase db, SyncLogs table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $SyncLogsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $SyncLogsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $SyncLogsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> collectedCount = const Value.absent(),
                Value<int> insertedCount = const Value.absent(),
                Value<int> syncedCount = const Value.absent(),
                Value<String?> message = const Value.absent(),
              }) => SyncLogsCompanion(
                id: id,
                operation: operation,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                collectedCount: collectedCount,
                insertedCount: insertedCount,
                syncedCount: syncedCount,
                message: message,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operation,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> collectedCount = const Value.absent(),
                Value<int> insertedCount = const Value.absent(),
                Value<int> syncedCount = const Value.absent(),
                Value<String?> message = const Value.absent(),
              }) => SyncLogsCompanion.insert(
                id: id,
                operation: operation,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                collectedCount: collectedCount,
                insertedCount: insertedCount,
                syncedCount: syncedCount,
                message: message,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SyncLogsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SyncLogs,
      SyncLog,
      $SyncLogsFilterComposer,
      $SyncLogsOrderingComposer,
      $SyncLogsAnnotationComposer,
      $SyncLogsCreateCompanionBuilder,
      $SyncLogsUpdateCompanionBuilder,
      (SyncLog, BaseReferences<_$AppDatabase, SyncLogs, SyncLog>),
      SyncLog,
      PrefetchHooks Function()
    >;
typedef $ActivitySessionsCreateCompanionBuilder =
    ActivitySessionsCompanion Function({
      Value<int> id,
      required String localId,
      Value<String?> title,
      required String sportKey,
      required String sportName,
      required String category,
      Value<bool> requiresGps,
      Value<String> status,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> elapsedSeconds,
      Value<int> movingSeconds,
      Value<int> stoppedSeconds,
      Value<double> distanceMeters,
      Value<double> caloriesKcal,
      Value<double> ascentMeters,
      Value<double> descentMeters,
      Value<double?> avgSpeedMps,
      Value<double?> maxSpeedMps,
      Value<double?> avgHeartRate,
      Value<double?> maxHeartRate,
      Value<int> manualPausedSeconds,
      Value<String?> notes,
      Value<String> tags,
      Value<String?> feeling,
      Value<int?> rpe,
      Value<String?> gearId,
      Value<String> source,
      Value<String> routeVisibility,
      Value<double> hideStartEndMeters,
      Value<bool> syncRouteDetail,
      Value<bool> writeHealthConnect,
      Value<String> syncStatus,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
    });
typedef $ActivitySessionsUpdateCompanionBuilder =
    ActivitySessionsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String?> title,
      Value<String> sportKey,
      Value<String> sportName,
      Value<String> category,
      Value<bool> requiresGps,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> elapsedSeconds,
      Value<int> movingSeconds,
      Value<int> stoppedSeconds,
      Value<double> distanceMeters,
      Value<double> caloriesKcal,
      Value<double> ascentMeters,
      Value<double> descentMeters,
      Value<double?> avgSpeedMps,
      Value<double?> maxSpeedMps,
      Value<double?> avgHeartRate,
      Value<double?> maxHeartRate,
      Value<int> manualPausedSeconds,
      Value<String?> notes,
      Value<String> tags,
      Value<String?> feeling,
      Value<int?> rpe,
      Value<String?> gearId,
      Value<String> source,
      Value<String> routeVisibility,
      Value<double> hideStartEndMeters,
      Value<bool> syncRouteDetail,
      Value<bool> writeHealthConnect,
      Value<String> syncStatus,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
    });

class $ActivitySessionsFilterComposer
    extends Composer<_$AppDatabase, ActivitySessions> {
  $ActivitySessionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportName => $composableBuilder(
    column: $table.sportName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresGps => $composableBuilder(
    column: $table.requiresGps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stoppedSeconds => $composableBuilder(
    column: $table.stoppedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get manualPausedSeconds => $composableBuilder(
    column: $table.manualPausedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gearId => $composableBuilder(
    column: $table.gearId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncRouteDetail => $composableBuilder(
    column: $table.syncRouteDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get writeHealthConnect => $composableBuilder(
    column: $table.writeHealthConnect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ActivitySessionsOrderingComposer
    extends Composer<_$AppDatabase, ActivitySessions> {
  $ActivitySessionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportName => $composableBuilder(
    column: $table.sportName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresGps => $composableBuilder(
    column: $table.requiresGps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stoppedSeconds => $composableBuilder(
    column: $table.stoppedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manualPausedSeconds => $composableBuilder(
    column: $table.manualPausedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gearId => $composableBuilder(
    column: $table.gearId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncRouteDetail => $composableBuilder(
    column: $table.syncRouteDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get writeHealthConnect => $composableBuilder(
    column: $table.writeHealthConnect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ActivitySessionsAnnotationComposer
    extends Composer<_$AppDatabase, ActivitySessions> {
  $ActivitySessionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sportKey =>
      $composableBuilder(column: $table.sportKey, builder: (column) => column);

  GeneratedColumn<String> get sportName =>
      $composableBuilder(column: $table.sportName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get requiresGps => $composableBuilder(
    column: $table.requiresGps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stoppedSeconds => $composableBuilder(
    column: $table.stoppedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get manualPausedSeconds => $composableBuilder(
    column: $table.manualPausedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<int> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<String> get gearId =>
      $composableBuilder(column: $table.gearId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncRouteDetail => $composableBuilder(
    column: $table.syncRouteDetail,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get writeHealthConnect => $composableBuilder(
    column: $table.writeHealthConnect,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $ActivitySessionsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ActivitySessions,
          ActivitySession,
          $ActivitySessionsFilterComposer,
          $ActivitySessionsOrderingComposer,
          $ActivitySessionsAnnotationComposer,
          $ActivitySessionsCreateCompanionBuilder,
          $ActivitySessionsUpdateCompanionBuilder,
          (
            ActivitySession,
            BaseReferences<_$AppDatabase, ActivitySessions, ActivitySession>,
          ),
          ActivitySession,
          PrefetchHooks Function()
        > {
  $ActivitySessionsTableManager(_$AppDatabase db, ActivitySessions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $ActivitySessionsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $ActivitySessionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $ActivitySessionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> sportKey = const Value.absent(),
                Value<String> sportName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> requiresGps = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> movingSeconds = const Value.absent(),
                Value<int> stoppedSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> caloriesKcal = const Value.absent(),
                Value<double> ascentMeters = const Value.absent(),
                Value<double> descentMeters = const Value.absent(),
                Value<double?> avgSpeedMps = const Value.absent(),
                Value<double?> maxSpeedMps = const Value.absent(),
                Value<double?> avgHeartRate = const Value.absent(),
                Value<double?> maxHeartRate = const Value.absent(),
                Value<int> manualPausedSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<int?> rpe = const Value.absent(),
                Value<String?> gearId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> routeVisibility = const Value.absent(),
                Value<double> hideStartEndMeters = const Value.absent(),
                Value<bool> syncRouteDetail = const Value.absent(),
                Value<bool> writeHealthConnect = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => ActivitySessionsCompanion(
                id: id,
                localId: localId,
                title: title,
                sportKey: sportKey,
                sportName: sportName,
                category: category,
                requiresGps: requiresGps,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                elapsedSeconds: elapsedSeconds,
                movingSeconds: movingSeconds,
                stoppedSeconds: stoppedSeconds,
                distanceMeters: distanceMeters,
                caloriesKcal: caloriesKcal,
                ascentMeters: ascentMeters,
                descentMeters: descentMeters,
                avgSpeedMps: avgSpeedMps,
                maxSpeedMps: maxSpeedMps,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                manualPausedSeconds: manualPausedSeconds,
                notes: notes,
                tags: tags,
                feeling: feeling,
                rpe: rpe,
                gearId: gearId,
                source: source,
                routeVisibility: routeVisibility,
                hideStartEndMeters: hideStartEndMeters,
                syncRouteDetail: syncRouteDetail,
                writeHealthConnect: writeHealthConnect,
                syncStatus: syncStatus,
                metadata: metadata,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                Value<String?> title = const Value.absent(),
                required String sportKey,
                required String sportName,
                required String category,
                Value<bool> requiresGps = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> movingSeconds = const Value.absent(),
                Value<int> stoppedSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> caloriesKcal = const Value.absent(),
                Value<double> ascentMeters = const Value.absent(),
                Value<double> descentMeters = const Value.absent(),
                Value<double?> avgSpeedMps = const Value.absent(),
                Value<double?> maxSpeedMps = const Value.absent(),
                Value<double?> avgHeartRate = const Value.absent(),
                Value<double?> maxHeartRate = const Value.absent(),
                Value<int> manualPausedSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<int?> rpe = const Value.absent(),
                Value<String?> gearId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> routeVisibility = const Value.absent(),
                Value<double> hideStartEndMeters = const Value.absent(),
                Value<bool> syncRouteDetail = const Value.absent(),
                Value<bool> writeHealthConnect = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => ActivitySessionsCompanion.insert(
                id: id,
                localId: localId,
                title: title,
                sportKey: sportKey,
                sportName: sportName,
                category: category,
                requiresGps: requiresGps,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                elapsedSeconds: elapsedSeconds,
                movingSeconds: movingSeconds,
                stoppedSeconds: stoppedSeconds,
                distanceMeters: distanceMeters,
                caloriesKcal: caloriesKcal,
                ascentMeters: ascentMeters,
                descentMeters: descentMeters,
                avgSpeedMps: avgSpeedMps,
                maxSpeedMps: maxSpeedMps,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                manualPausedSeconds: manualPausedSeconds,
                notes: notes,
                tags: tags,
                feeling: feeling,
                rpe: rpe,
                gearId: gearId,
                source: source,
                routeVisibility: routeVisibility,
                hideStartEndMeters: hideStartEndMeters,
                syncRouteDetail: syncRouteDetail,
                writeHealthConnect: writeHealthConnect,
                syncStatus: syncStatus,
                metadata: metadata,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ActivitySessionsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ActivitySessions,
      ActivitySession,
      $ActivitySessionsFilterComposer,
      $ActivitySessionsOrderingComposer,
      $ActivitySessionsAnnotationComposer,
      $ActivitySessionsCreateCompanionBuilder,
      $ActivitySessionsUpdateCompanionBuilder,
      (
        ActivitySession,
        BaseReferences<_$AppDatabase, ActivitySessions, ActivitySession>,
      ),
      ActivitySession,
      PrefetchHooks Function()
    >;
typedef $ActivityEventsCreateCompanionBuilder =
    ActivityEventsCompanion Function({
      Value<int> id,
      required String sessionLocalId,
      required String eventType,
      required DateTime timestamp,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });
typedef $ActivityEventsUpdateCompanionBuilder =
    ActivityEventsCompanion Function({
      Value<int> id,
      Value<String> sessionLocalId,
      Value<String> eventType,
      Value<DateTime> timestamp,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });

class $ActivityEventsFilterComposer
    extends Composer<_$AppDatabase, ActivityEvents> {
  $ActivityEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ActivityEventsOrderingComposer
    extends Composer<_$AppDatabase, ActivityEvents> {
  $ActivityEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ActivityEventsAnnotationComposer
    extends Composer<_$AppDatabase, ActivityEvents> {
  $ActivityEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $ActivityEventsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ActivityEvents,
          ActivityEvent,
          $ActivityEventsFilterComposer,
          $ActivityEventsOrderingComposer,
          $ActivityEventsAnnotationComposer,
          $ActivityEventsCreateCompanionBuilder,
          $ActivityEventsUpdateCompanionBuilder,
          (
            ActivityEvent,
            BaseReferences<_$AppDatabase, ActivityEvents, ActivityEvent>,
          ),
          ActivityEvent,
          PrefetchHooks Function()
        > {
  $ActivityEventsTableManager(_$AppDatabase db, ActivityEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $ActivityEventsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $ActivityEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $ActivityEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionLocalId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityEventsCompanion(
                id: id,
                sessionLocalId: sessionLocalId,
                eventType: eventType,
                timestamp: timestamp,
                metadata: metadata,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionLocalId,
                required String eventType,
                required DateTime timestamp,
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityEventsCompanion.insert(
                id: id,
                sessionLocalId: sessionLocalId,
                eventType: eventType,
                timestamp: timestamp,
                metadata: metadata,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ActivityEventsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ActivityEvents,
      ActivityEvent,
      $ActivityEventsFilterComposer,
      $ActivityEventsOrderingComposer,
      $ActivityEventsAnnotationComposer,
      $ActivityEventsCreateCompanionBuilder,
      $ActivityEventsUpdateCompanionBuilder,
      (
        ActivityEvent,
        BaseReferences<_$AppDatabase, ActivityEvents, ActivityEvent>,
      ),
      ActivityEvent,
      PrefetchHooks Function()
    >;
typedef $ActivityPointsCreateCompanionBuilder =
    ActivityPointsCompanion Function({
      Value<int> id,
      required String sessionLocalId,
      required DateTime timestamp,
      required double latitude,
      required double longitude,
      Value<double?> altitudeMeters,
      Value<double?> altitudeCorrectedMeters,
      Value<double?> accuracyMeters,
      Value<double?> speedMps,
      Value<double?> bearingDegrees,
      Value<double> distanceFromPrevMeters,
      Value<bool> moving,
      Value<String> pointQuality,
      Value<String?> provider,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });
typedef $ActivityPointsUpdateCompanionBuilder =
    ActivityPointsCompanion Function({
      Value<int> id,
      Value<String> sessionLocalId,
      Value<DateTime> timestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> altitudeMeters,
      Value<double?> altitudeCorrectedMeters,
      Value<double?> accuracyMeters,
      Value<double?> speedMps,
      Value<double?> bearingDegrees,
      Value<double> distanceFromPrevMeters,
      Value<bool> moving,
      Value<String> pointQuality,
      Value<String?> provider,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });

class $ActivityPointsFilterComposer
    extends Composer<_$AppDatabase, ActivityPoints> {
  $ActivityPointsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeCorrectedMeters => $composableBuilder(
    column: $table.altitudeCorrectedMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceFromPrevMeters => $composableBuilder(
    column: $table.distanceFromPrevMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get moving => $composableBuilder(
    column: $table.moving,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointQuality => $composableBuilder(
    column: $table.pointQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ActivityPointsOrderingComposer
    extends Composer<_$AppDatabase, ActivityPoints> {
  $ActivityPointsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeCorrectedMeters => $composableBuilder(
    column: $table.altitudeCorrectedMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceFromPrevMeters => $composableBuilder(
    column: $table.distanceFromPrevMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get moving => $composableBuilder(
    column: $table.moving,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointQuality => $composableBuilder(
    column: $table.pointQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ActivityPointsAnnotationComposer
    extends Composer<_$AppDatabase, ActivityPoints> {
  $ActivityPointsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get altitudeCorrectedMeters => $composableBuilder(
    column: $table.altitudeCorrectedMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedMps =>
      $composableBuilder(column: $table.speedMps, builder: (column) => column);

  GeneratedColumn<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceFromPrevMeters => $composableBuilder(
    column: $table.distanceFromPrevMeters,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get moving =>
      $composableBuilder(column: $table.moving, builder: (column) => column);

  GeneratedColumn<String> get pointQuality => $composableBuilder(
    column: $table.pointQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $ActivityPointsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ActivityPoints,
          ActivityPoint,
          $ActivityPointsFilterComposer,
          $ActivityPointsOrderingComposer,
          $ActivityPointsAnnotationComposer,
          $ActivityPointsCreateCompanionBuilder,
          $ActivityPointsUpdateCompanionBuilder,
          (
            ActivityPoint,
            BaseReferences<_$AppDatabase, ActivityPoints, ActivityPoint>,
          ),
          ActivityPoint,
          PrefetchHooks Function()
        > {
  $ActivityPointsTableManager(_$AppDatabase db, ActivityPoints table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $ActivityPointsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $ActivityPointsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $ActivityPointsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionLocalId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> altitudeMeters = const Value.absent(),
                Value<double?> altitudeCorrectedMeters = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<double?> speedMps = const Value.absent(),
                Value<double?> bearingDegrees = const Value.absent(),
                Value<double> distanceFromPrevMeters = const Value.absent(),
                Value<bool> moving = const Value.absent(),
                Value<String> pointQuality = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityPointsCompanion(
                id: id,
                sessionLocalId: sessionLocalId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                altitudeCorrectedMeters: altitudeCorrectedMeters,
                accuracyMeters: accuracyMeters,
                speedMps: speedMps,
                bearingDegrees: bearingDegrees,
                distanceFromPrevMeters: distanceFromPrevMeters,
                moving: moving,
                pointQuality: pointQuality,
                provider: provider,
                metadata: metadata,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionLocalId,
                required DateTime timestamp,
                required double latitude,
                required double longitude,
                Value<double?> altitudeMeters = const Value.absent(),
                Value<double?> altitudeCorrectedMeters = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<double?> speedMps = const Value.absent(),
                Value<double?> bearingDegrees = const Value.absent(),
                Value<double> distanceFromPrevMeters = const Value.absent(),
                Value<bool> moving = const Value.absent(),
                Value<String> pointQuality = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityPointsCompanion.insert(
                id: id,
                sessionLocalId: sessionLocalId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                altitudeCorrectedMeters: altitudeCorrectedMeters,
                accuracyMeters: accuracyMeters,
                speedMps: speedMps,
                bearingDegrees: bearingDegrees,
                distanceFromPrevMeters: distanceFromPrevMeters,
                moving: moving,
                pointQuality: pointQuality,
                provider: provider,
                metadata: metadata,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ActivityPointsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ActivityPoints,
      ActivityPoint,
      $ActivityPointsFilterComposer,
      $ActivityPointsOrderingComposer,
      $ActivityPointsAnnotationComposer,
      $ActivityPointsCreateCompanionBuilder,
      $ActivityPointsUpdateCompanionBuilder,
      (
        ActivityPoint,
        BaseReferences<_$AppDatabase, ActivityPoints, ActivityPoint>,
      ),
      ActivityPoint,
      PrefetchHooks Function()
    >;
typedef $ActivitySummariesCreateCompanionBuilder =
    ActivitySummariesCompanion Function({
      required String sessionLocalId,
      required String jsonSummary,
      required String markdownSummary,
      required DateTime generatedAt,
      Value<String?> model,
      Value<String?> confidence,
      Value<String> generatedBy,
      Value<String?> agentNotes,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $ActivitySummariesUpdateCompanionBuilder =
    ActivitySummariesCompanion Function({
      Value<String> sessionLocalId,
      Value<String> jsonSummary,
      Value<String> markdownSummary,
      Value<DateTime> generatedAt,
      Value<String?> model,
      Value<String?> confidence,
      Value<String> generatedBy,
      Value<String?> agentNotes,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $ActivitySummariesFilterComposer
    extends Composer<_$AppDatabase, ActivitySummaries> {
  $ActivitySummariesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agentNotes => $composableBuilder(
    column: $table.agentNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ActivitySummariesOrderingComposer
    extends Composer<_$AppDatabase, ActivitySummaries> {
  $ActivitySummariesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agentNotes => $composableBuilder(
    column: $table.agentNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ActivitySummariesAnnotationComposer
    extends Composer<_$AppDatabase, ActivitySummaries> {
  $ActivitySummariesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get agentNotes => $composableBuilder(
    column: $table.agentNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $ActivitySummariesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ActivitySummaries,
          ActivitySummary,
          $ActivitySummariesFilterComposer,
          $ActivitySummariesOrderingComposer,
          $ActivitySummariesAnnotationComposer,
          $ActivitySummariesCreateCompanionBuilder,
          $ActivitySummariesUpdateCompanionBuilder,
          (
            ActivitySummary,
            BaseReferences<_$AppDatabase, ActivitySummaries, ActivitySummary>,
          ),
          ActivitySummary,
          PrefetchHooks Function()
        > {
  $ActivitySummariesTableManager(_$AppDatabase db, ActivitySummaries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $ActivitySummariesFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $ActivitySummariesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $ActivitySummariesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionLocalId = const Value.absent(),
                Value<String> jsonSummary = const Value.absent(),
                Value<String> markdownSummary = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> generatedBy = const Value.absent(),
                Value<String?> agentNotes = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitySummariesCompanion(
                sessionLocalId: sessionLocalId,
                jsonSummary: jsonSummary,
                markdownSummary: markdownSummary,
                generatedAt: generatedAt,
                model: model,
                confidence: confidence,
                generatedBy: generatedBy,
                agentNotes: agentNotes,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionLocalId,
                required String jsonSummary,
                required String markdownSummary,
                required DateTime generatedAt,
                Value<String?> model = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> generatedBy = const Value.absent(),
                Value<String?> agentNotes = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitySummariesCompanion.insert(
                sessionLocalId: sessionLocalId,
                jsonSummary: jsonSummary,
                markdownSummary: markdownSummary,
                generatedAt: generatedAt,
                model: model,
                confidence: confidence,
                generatedBy: generatedBy,
                agentNotes: agentNotes,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ActivitySummariesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ActivitySummaries,
      ActivitySummary,
      $ActivitySummariesFilterComposer,
      $ActivitySummariesOrderingComposer,
      $ActivitySummariesAnnotationComposer,
      $ActivitySummariesCreateCompanionBuilder,
      $ActivitySummariesUpdateCompanionBuilder,
      (
        ActivitySummary,
        BaseReferences<_$AppDatabase, ActivitySummaries, ActivitySummary>,
      ),
      ActivitySummary,
      PrefetchHooks Function()
    >;
typedef $OfflineMapRegionsCreateCompanionBuilder =
    OfflineMapRegionsCompanion Function({
      Value<int> id,
      required String name,
      required String bounds,
      required int minZoom,
      required int maxZoom,
      required String style,
      Value<int> storageBytes,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $OfflineMapRegionsUpdateCompanionBuilder =
    OfflineMapRegionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> bounds,
      Value<int> minZoom,
      Value<int> maxZoom,
      Value<String> style,
      Value<int> storageBytes,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $OfflineMapRegionsFilterComposer
    extends Composer<_$AppDatabase, OfflineMapRegions> {
  $OfflineMapRegionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bounds => $composableBuilder(
    column: $table.bounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get storageBytes => $composableBuilder(
    column: $table.storageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $OfflineMapRegionsOrderingComposer
    extends Composer<_$AppDatabase, OfflineMapRegions> {
  $OfflineMapRegionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bounds => $composableBuilder(
    column: $table.bounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get storageBytes => $composableBuilder(
    column: $table.storageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $OfflineMapRegionsAnnotationComposer
    extends Composer<_$AppDatabase, OfflineMapRegions> {
  $OfflineMapRegionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bounds =>
      $composableBuilder(column: $table.bounds, builder: (column) => column);

  GeneratedColumn<int> get minZoom =>
      $composableBuilder(column: $table.minZoom, builder: (column) => column);

  GeneratedColumn<int> get maxZoom =>
      $composableBuilder(column: $table.maxZoom, builder: (column) => column);

  GeneratedColumn<String> get style =>
      $composableBuilder(column: $table.style, builder: (column) => column);

  GeneratedColumn<int> get storageBytes => $composableBuilder(
    column: $table.storageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $OfflineMapRegionsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          OfflineMapRegions,
          OfflineMapRegion,
          $OfflineMapRegionsFilterComposer,
          $OfflineMapRegionsOrderingComposer,
          $OfflineMapRegionsAnnotationComposer,
          $OfflineMapRegionsCreateCompanionBuilder,
          $OfflineMapRegionsUpdateCompanionBuilder,
          (
            OfflineMapRegion,
            BaseReferences<_$AppDatabase, OfflineMapRegions, OfflineMapRegion>,
          ),
          OfflineMapRegion,
          PrefetchHooks Function()
        > {
  $OfflineMapRegionsTableManager(_$AppDatabase db, OfflineMapRegions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $OfflineMapRegionsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $OfflineMapRegionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $OfflineMapRegionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> bounds = const Value.absent(),
                Value<int> minZoom = const Value.absent(),
                Value<int> maxZoom = const Value.absent(),
                Value<String> style = const Value.absent(),
                Value<int> storageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => OfflineMapRegionsCompanion(
                id: id,
                name: name,
                bounds: bounds,
                minZoom: minZoom,
                maxZoom: maxZoom,
                style: style,
                storageBytes: storageBytes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String bounds,
                required int minZoom,
                required int maxZoom,
                required String style,
                Value<int> storageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => OfflineMapRegionsCompanion.insert(
                id: id,
                name: name,
                bounds: bounds,
                minZoom: minZoom,
                maxZoom: maxZoom,
                style: style,
                storageBytes: storageBytes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $OfflineMapRegionsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      OfflineMapRegions,
      OfflineMapRegion,
      $OfflineMapRegionsFilterComposer,
      $OfflineMapRegionsOrderingComposer,
      $OfflineMapRegionsAnnotationComposer,
      $OfflineMapRegionsCreateCompanionBuilder,
      $OfflineMapRegionsUpdateCompanionBuilder,
      (
        OfflineMapRegion,
        BaseReferences<_$AppDatabase, OfflineMapRegions, OfflineMapRegion>,
      ),
      OfflineMapRegion,
      PrefetchHooks Function()
    >;
typedef $SavedRoutesCreateCompanionBuilder =
    SavedRoutesCompanion Function({
      Value<int> id,
      required String localId,
      Value<String?> sourceSessionLocalId,
      required String name,
      Value<String?> sportKey,
      Value<double> distanceMeters,
      Value<double> ascentMeters,
      Value<double> descentMeters,
      Value<int> pointCount,
      Value<String> routeVisibility,
      Value<double> hideStartEndMeters,
      Value<String?> summaryJson,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $SavedRoutesUpdateCompanionBuilder =
    SavedRoutesCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String?> sourceSessionLocalId,
      Value<String> name,
      Value<String?> sportKey,
      Value<double> distanceMeters,
      Value<double> ascentMeters,
      Value<double> descentMeters,
      Value<int> pointCount,
      Value<String> routeVisibility,
      Value<double> hideStartEndMeters,
      Value<String?> summaryJson,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $SavedRoutesFilterComposer extends Composer<_$AppDatabase, SavedRoutes> {
  $SavedRoutesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceSessionLocalId => $composableBuilder(
    column: $table.sourceSessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $SavedRoutesOrderingComposer
    extends Composer<_$AppDatabase, SavedRoutes> {
  $SavedRoutesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceSessionLocalId => $composableBuilder(
    column: $table.sourceSessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SavedRoutesAnnotationComposer
    extends Composer<_$AppDatabase, SavedRoutes> {
  $SavedRoutesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get sourceSessionLocalId => $composableBuilder(
    column: $table.sourceSessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sportKey =>
      $composableBuilder(column: $table.sportKey, builder: (column) => column);

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ascentMeters => $composableBuilder(
    column: $table.ascentMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get descentMeters => $composableBuilder(
    column: $table.descentMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routeVisibility => $composableBuilder(
    column: $table.routeVisibility,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hideStartEndMeters => $composableBuilder(
    column: $table.hideStartEndMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $SavedRoutesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SavedRoutes,
          SavedRoute,
          $SavedRoutesFilterComposer,
          $SavedRoutesOrderingComposer,
          $SavedRoutesAnnotationComposer,
          $SavedRoutesCreateCompanionBuilder,
          $SavedRoutesUpdateCompanionBuilder,
          (SavedRoute, BaseReferences<_$AppDatabase, SavedRoutes, SavedRoute>),
          SavedRoute,
          PrefetchHooks Function()
        > {
  $SavedRoutesTableManager(_$AppDatabase db, SavedRoutes table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $SavedRoutesFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $SavedRoutesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $SavedRoutesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String?> sourceSessionLocalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> sportKey = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> ascentMeters = const Value.absent(),
                Value<double> descentMeters = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
                Value<String> routeVisibility = const Value.absent(),
                Value<double> hideStartEndMeters = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SavedRoutesCompanion(
                id: id,
                localId: localId,
                sourceSessionLocalId: sourceSessionLocalId,
                name: name,
                sportKey: sportKey,
                distanceMeters: distanceMeters,
                ascentMeters: ascentMeters,
                descentMeters: descentMeters,
                pointCount: pointCount,
                routeVisibility: routeVisibility,
                hideStartEndMeters: hideStartEndMeters,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                Value<String?> sourceSessionLocalId = const Value.absent(),
                required String name,
                Value<String?> sportKey = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> ascentMeters = const Value.absent(),
                Value<double> descentMeters = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
                Value<String> routeVisibility = const Value.absent(),
                Value<double> hideStartEndMeters = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SavedRoutesCompanion.insert(
                id: id,
                localId: localId,
                sourceSessionLocalId: sourceSessionLocalId,
                name: name,
                sportKey: sportKey,
                distanceMeters: distanceMeters,
                ascentMeters: ascentMeters,
                descentMeters: descentMeters,
                pointCount: pointCount,
                routeVisibility: routeVisibility,
                hideStartEndMeters: hideStartEndMeters,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SavedRoutesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SavedRoutes,
      SavedRoute,
      $SavedRoutesFilterComposer,
      $SavedRoutesOrderingComposer,
      $SavedRoutesAnnotationComposer,
      $SavedRoutesCreateCompanionBuilder,
      $SavedRoutesUpdateCompanionBuilder,
      (SavedRoute, BaseReferences<_$AppDatabase, SavedRoutes, SavedRoute>),
      SavedRoute,
      PrefetchHooks Function()
    >;
typedef $DailySummariesCreateCompanionBuilder =
    DailySummariesCompanion Function({
      required String localDate,
      required String jsonSummary,
      required String markdownSummary,
      required DateTime generatedAt,
      Value<String?> model,
      Value<String?> confidence,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $DailySummariesUpdateCompanionBuilder =
    DailySummariesCompanion Function({
      Value<String> localDate,
      Value<String> jsonSummary,
      Value<String> markdownSummary,
      Value<DateTime> generatedAt,
      Value<String?> model,
      Value<String?> confidence,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $DailySummariesFilterComposer
    extends Composer<_$AppDatabase, DailySummaries> {
  $DailySummariesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $DailySummariesOrderingComposer
    extends Composer<_$AppDatabase, DailySummaries> {
  $DailySummariesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DailySummariesAnnotationComposer
    extends Composer<_$AppDatabase, DailySummaries> {
  $DailySummariesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get jsonSummary => $composableBuilder(
    column: $table.jsonSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get markdownSummary => $composableBuilder(
    column: $table.markdownSummary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $DailySummariesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DailySummaries,
          DailySummary,
          $DailySummariesFilterComposer,
          $DailySummariesOrderingComposer,
          $DailySummariesAnnotationComposer,
          $DailySummariesCreateCompanionBuilder,
          $DailySummariesUpdateCompanionBuilder,
          (
            DailySummary,
            BaseReferences<_$AppDatabase, DailySummaries, DailySummary>,
          ),
          DailySummary,
          PrefetchHooks Function()
        > {
  $DailySummariesTableManager(_$AppDatabase db, DailySummaries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $DailySummariesFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $DailySummariesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $DailySummariesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localDate = const Value.absent(),
                Value<String> jsonSummary = const Value.absent(),
                Value<String> markdownSummary = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySummariesCompanion(
                localDate: localDate,
                jsonSummary: jsonSummary,
                markdownSummary: markdownSummary,
                generatedAt: generatedAt,
                model: model,
                confidence: confidence,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDate,
                required String jsonSummary,
                required String markdownSummary,
                required DateTime generatedAt,
                Value<String?> model = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySummariesCompanion.insert(
                localDate: localDate,
                jsonSummary: jsonSummary,
                markdownSummary: markdownSummary,
                generatedAt: generatedAt,
                model: model,
                confidence: confidence,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DailySummariesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DailySummaries,
      DailySummary,
      $DailySummariesFilterComposer,
      $DailySummariesOrderingComposer,
      $DailySummariesAnnotationComposer,
      $DailySummariesCreateCompanionBuilder,
      $DailySummariesUpdateCompanionBuilder,
      (
        DailySummary,
        BaseReferences<_$AppDatabase, DailySummaries, DailySummary>,
      ),
      DailySummary,
      PrefetchHooks Function()
    >;
typedef $AiToolCallsCreateCompanionBuilder =
    AiToolCallsCompanion Function({
      Value<int> id,
      Value<String?> conversationId,
      Value<String?> messageId,
      Value<String?> usageWindowId,
      Value<String> tier,
      required String toolName,
      required String inputJson,
      required String resultJson,
      Value<DateTime> createdAt,
      Value<String?> model,
      Value<int> tokenInput,
      Value<int> tokenOutput,
      Value<double> estimatedCost,
      Value<String> status,
    });
typedef $AiToolCallsUpdateCompanionBuilder =
    AiToolCallsCompanion Function({
      Value<int> id,
      Value<String?> conversationId,
      Value<String?> messageId,
      Value<String?> usageWindowId,
      Value<String> tier,
      Value<String> toolName,
      Value<String> inputJson,
      Value<String> resultJson,
      Value<DateTime> createdAt,
      Value<String?> model,
      Value<int> tokenInput,
      Value<int> tokenOutput,
      Value<double> estimatedCost,
      Value<String> status,
    });

class $AiToolCallsFilterComposer extends Composer<_$AppDatabase, AiToolCalls> {
  $AiToolCallsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usageWindowId => $composableBuilder(
    column: $table.usageWindowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolName => $composableBuilder(
    column: $table.toolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputJson => $composableBuilder(
    column: $table.inputJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenInput => $composableBuilder(
    column: $table.tokenInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenOutput => $composableBuilder(
    column: $table.tokenOutput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $AiToolCallsOrderingComposer
    extends Composer<_$AppDatabase, AiToolCalls> {
  $AiToolCallsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usageWindowId => $composableBuilder(
    column: $table.usageWindowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolName => $composableBuilder(
    column: $table.toolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputJson => $composableBuilder(
    column: $table.inputJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenInput => $composableBuilder(
    column: $table.tokenInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenOutput => $composableBuilder(
    column: $table.tokenOutput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AiToolCallsAnnotationComposer
    extends Composer<_$AppDatabase, AiToolCalls> {
  $AiToolCallsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get usageWindowId => $composableBuilder(
    column: $table.usageWindowId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get toolName =>
      $composableBuilder(column: $table.toolName, builder: (column) => column);

  GeneratedColumn<String> get inputJson =>
      $composableBuilder(column: $table.inputJson, builder: (column) => column);

  GeneratedColumn<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get tokenInput => $composableBuilder(
    column: $table.tokenInput,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tokenOutput => $composableBuilder(
    column: $table.tokenOutput,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $AiToolCallsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AiToolCalls,
          AiToolCall,
          $AiToolCallsFilterComposer,
          $AiToolCallsOrderingComposer,
          $AiToolCallsAnnotationComposer,
          $AiToolCallsCreateCompanionBuilder,
          $AiToolCallsUpdateCompanionBuilder,
          (AiToolCall, BaseReferences<_$AppDatabase, AiToolCalls, AiToolCall>),
          AiToolCall,
          PrefetchHooks Function()
        > {
  $AiToolCallsTableManager(_$AppDatabase db, AiToolCalls table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $AiToolCallsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $AiToolCallsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $AiToolCallsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> conversationId = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<String?> usageWindowId = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String> toolName = const Value.absent(),
                Value<String> inputJson = const Value.absent(),
                Value<String> resultJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int> tokenInput = const Value.absent(),
                Value<int> tokenOutput = const Value.absent(),
                Value<double> estimatedCost = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => AiToolCallsCompanion(
                id: id,
                conversationId: conversationId,
                messageId: messageId,
                usageWindowId: usageWindowId,
                tier: tier,
                toolName: toolName,
                inputJson: inputJson,
                resultJson: resultJson,
                createdAt: createdAt,
                model: model,
                tokenInput: tokenInput,
                tokenOutput: tokenOutput,
                estimatedCost: estimatedCost,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> conversationId = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<String?> usageWindowId = const Value.absent(),
                Value<String> tier = const Value.absent(),
                required String toolName,
                required String inputJson,
                required String resultJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int> tokenInput = const Value.absent(),
                Value<int> tokenOutput = const Value.absent(),
                Value<double> estimatedCost = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => AiToolCallsCompanion.insert(
                id: id,
                conversationId: conversationId,
                messageId: messageId,
                usageWindowId: usageWindowId,
                tier: tier,
                toolName: toolName,
                inputJson: inputJson,
                resultJson: resultJson,
                createdAt: createdAt,
                model: model,
                tokenInput: tokenInput,
                tokenOutput: tokenOutput,
                estimatedCost: estimatedCost,
                status: status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AiToolCallsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AiToolCalls,
      AiToolCall,
      $AiToolCallsFilterComposer,
      $AiToolCallsOrderingComposer,
      $AiToolCallsAnnotationComposer,
      $AiToolCallsCreateCompanionBuilder,
      $AiToolCallsUpdateCompanionBuilder,
      (AiToolCall, BaseReferences<_$AppDatabase, AiToolCalls, AiToolCall>),
      AiToolCall,
      PrefetchHooks Function()
    >;
typedef $AiUsageWindowsCreateCompanionBuilder =
    AiUsageWindowsCompanion Function({
      required String windowId,
      Value<String> tier,
      required DateTime startedAt,
      Value<DateTime?> resetsAt,
      Value<int> toolCallsUsed,
      Value<int> inputTokens,
      Value<int> outputTokens,
      Value<double> estimatedCost,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $AiUsageWindowsUpdateCompanionBuilder =
    AiUsageWindowsCompanion Function({
      Value<String> windowId,
      Value<String> tier,
      Value<DateTime> startedAt,
      Value<DateTime?> resetsAt,
      Value<int> toolCallsUsed,
      Value<int> inputTokens,
      Value<int> outputTokens,
      Value<double> estimatedCost,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $AiUsageWindowsFilterComposer
    extends Composer<_$AppDatabase, AiUsageWindows> {
  $AiUsageWindowsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get windowId => $composableBuilder(
    column: $table.windowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resetsAt => $composableBuilder(
    column: $table.resetsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $AiUsageWindowsOrderingComposer
    extends Composer<_$AppDatabase, AiUsageWindows> {
  $AiUsageWindowsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get windowId => $composableBuilder(
    column: $table.windowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resetsAt => $composableBuilder(
    column: $table.resetsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AiUsageWindowsAnnotationComposer
    extends Composer<_$AppDatabase, AiUsageWindows> {
  $AiUsageWindowsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get windowId =>
      $composableBuilder(column: $table.windowId, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resetsAt =>
      $composableBuilder(column: $table.resetsAt, builder: (column) => column);

  GeneratedColumn<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $AiUsageWindowsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AiUsageWindows,
          AiUsageWindow,
          $AiUsageWindowsFilterComposer,
          $AiUsageWindowsOrderingComposer,
          $AiUsageWindowsAnnotationComposer,
          $AiUsageWindowsCreateCompanionBuilder,
          $AiUsageWindowsUpdateCompanionBuilder,
          (
            AiUsageWindow,
            BaseReferences<_$AppDatabase, AiUsageWindows, AiUsageWindow>,
          ),
          AiUsageWindow,
          PrefetchHooks Function()
        > {
  $AiUsageWindowsTableManager(_$AppDatabase db, AiUsageWindows table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $AiUsageWindowsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $AiUsageWindowsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $AiUsageWindowsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> windowId = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> resetsAt = const Value.absent(),
                Value<int> toolCallsUsed = const Value.absent(),
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<double> estimatedCost = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiUsageWindowsCompanion(
                windowId: windowId,
                tier: tier,
                startedAt: startedAt,
                resetsAt: resetsAt,
                toolCallsUsed: toolCallsUsed,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                estimatedCost: estimatedCost,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String windowId,
                Value<String> tier = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> resetsAt = const Value.absent(),
                Value<int> toolCallsUsed = const Value.absent(),
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<double> estimatedCost = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiUsageWindowsCompanion.insert(
                windowId: windowId,
                tier: tier,
                startedAt: startedAt,
                resetsAt: resetsAt,
                toolCallsUsed: toolCallsUsed,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                estimatedCost: estimatedCost,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AiUsageWindowsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AiUsageWindows,
      AiUsageWindow,
      $AiUsageWindowsFilterComposer,
      $AiUsageWindowsOrderingComposer,
      $AiUsageWindowsAnnotationComposer,
      $AiUsageWindowsCreateCompanionBuilder,
      $AiUsageWindowsUpdateCompanionBuilder,
      (
        AiUsageWindow,
        BaseReferences<_$AppDatabase, AiUsageWindows, AiUsageWindow>,
      ),
      AiUsageWindow,
      PrefetchHooks Function()
    >;
typedef $AiConversationsCreateCompanionBuilder =
    AiConversationsCompanion Function({
      required String localId,
      required String title,
      Value<String?> summary,
      Value<String> contextMode,
      Value<int> messageCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> compactedAt,
      Value<int> rowid,
    });
typedef $AiConversationsUpdateCompanionBuilder =
    AiConversationsCompanion Function({
      Value<String> localId,
      Value<String> title,
      Value<String?> summary,
      Value<String> contextMode,
      Value<int> messageCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> compactedAt,
      Value<int> rowid,
    });

class $AiConversationsFilterComposer
    extends Composer<_$AppDatabase, AiConversations> {
  $AiConversationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextMode => $composableBuilder(
    column: $table.contextMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get compactedAt => $composableBuilder(
    column: $table.compactedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $AiConversationsOrderingComposer
    extends Composer<_$AppDatabase, AiConversations> {
  $AiConversationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextMode => $composableBuilder(
    column: $table.contextMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get compactedAt => $composableBuilder(
    column: $table.compactedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AiConversationsAnnotationComposer
    extends Composer<_$AppDatabase, AiConversations> {
  $AiConversationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get contextMode => $composableBuilder(
    column: $table.contextMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get compactedAt => $composableBuilder(
    column: $table.compactedAt,
    builder: (column) => column,
  );
}

class $AiConversationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AiConversations,
          AiConversation,
          $AiConversationsFilterComposer,
          $AiConversationsOrderingComposer,
          $AiConversationsAnnotationComposer,
          $AiConversationsCreateCompanionBuilder,
          $AiConversationsUpdateCompanionBuilder,
          (
            AiConversation,
            BaseReferences<_$AppDatabase, AiConversations, AiConversation>,
          ),
          AiConversation,
          PrefetchHooks Function()
        > {
  $AiConversationsTableManager(_$AppDatabase db, AiConversations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $AiConversationsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $AiConversationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $AiConversationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String> contextMode = const Value.absent(),
                Value<int> messageCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> compactedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCompanion(
                localId: localId,
                title: title,
                summary: summary,
                contextMode: contextMode,
                messageCount: messageCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                compactedAt: compactedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String title,
                Value<String?> summary = const Value.absent(),
                Value<String> contextMode = const Value.absent(),
                Value<int> messageCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> compactedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCompanion.insert(
                localId: localId,
                title: title,
                summary: summary,
                contextMode: contextMode,
                messageCount: messageCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                compactedAt: compactedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AiConversationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AiConversations,
      AiConversation,
      $AiConversationsFilterComposer,
      $AiConversationsOrderingComposer,
      $AiConversationsAnnotationComposer,
      $AiConversationsCreateCompanionBuilder,
      $AiConversationsUpdateCompanionBuilder,
      (
        AiConversation,
        BaseReferences<_$AppDatabase, AiConversations, AiConversation>,
      ),
      AiConversation,
      PrefetchHooks Function()
    >;
typedef $AiMessagesCreateCompanionBuilder =
    AiMessagesCompanion Function({
      Value<int> id,
      required String localId,
      required String conversationId,
      required String role,
      required String content,
      Value<String?> mode,
      Value<int> toolCallsUsed,
      Value<String?> error,
      required DateTime createdAt,
    });
typedef $AiMessagesUpdateCompanionBuilder =
    AiMessagesCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String> conversationId,
      Value<String> role,
      Value<String> content,
      Value<String?> mode,
      Value<int> toolCallsUsed,
      Value<String?> error,
      Value<DateTime> createdAt,
    });

class $AiMessagesFilterComposer extends Composer<_$AppDatabase, AiMessages> {
  $AiMessagesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $AiMessagesOrderingComposer extends Composer<_$AppDatabase, AiMessages> {
  $AiMessagesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AiMessagesAnnotationComposer
    extends Composer<_$AppDatabase, AiMessages> {
  $AiMessagesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get toolCallsUsed => $composableBuilder(
    column: $table.toolCallsUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $AiMessagesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AiMessages,
          AiMessage,
          $AiMessagesFilterComposer,
          $AiMessagesOrderingComposer,
          $AiMessagesAnnotationComposer,
          $AiMessagesCreateCompanionBuilder,
          $AiMessagesUpdateCompanionBuilder,
          (AiMessage, BaseReferences<_$AppDatabase, AiMessages, AiMessage>),
          AiMessage,
          PrefetchHooks Function()
        > {
  $AiMessagesTableManager(_$AppDatabase db, AiMessages table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $AiMessagesFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $AiMessagesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $AiMessagesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> mode = const Value.absent(),
                Value<int> toolCallsUsed = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AiMessagesCompanion(
                id: id,
                localId: localId,
                conversationId: conversationId,
                role: role,
                content: content,
                mode: mode,
                toolCallsUsed: toolCallsUsed,
                error: error,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                required String conversationId,
                required String role,
                required String content,
                Value<String?> mode = const Value.absent(),
                Value<int> toolCallsUsed = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime createdAt,
              }) => AiMessagesCompanion.insert(
                id: id,
                localId: localId,
                conversationId: conversationId,
                role: role,
                content: content,
                mode: mode,
                toolCallsUsed: toolCallsUsed,
                error: error,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AiMessagesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AiMessages,
      AiMessage,
      $AiMessagesFilterComposer,
      $AiMessagesOrderingComposer,
      $AiMessagesAnnotationComposer,
      $AiMessagesCreateCompanionBuilder,
      $AiMessagesUpdateCompanionBuilder,
      (AiMessage, BaseReferences<_$AppDatabase, AiMessages, AiMessage>),
      AiMessage,
      PrefetchHooks Function()
    >;
typedef $CommunityShareRecordsCreateCompanionBuilder =
    CommunityShareRecordsCompanion Function({
      Value<int> id,
      required String localId,
      Value<String?> sessionLocalId,
      Value<String?> shareId,
      Value<String?> publicUrl,
      required String payloadJson,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> sharedAt,
    });
typedef $CommunityShareRecordsUpdateCompanionBuilder =
    CommunityShareRecordsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String?> sessionLocalId,
      Value<String?> shareId,
      Value<String?> publicUrl,
      Value<String> payloadJson,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> sharedAt,
    });

class $CommunityShareRecordsFilterComposer
    extends Composer<_$AppDatabase, CommunityShareRecords> {
  $CommunityShareRecordsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareId => $composableBuilder(
    column: $table.shareId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicUrl => $composableBuilder(
    column: $table.publicUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sharedAt => $composableBuilder(
    column: $table.sharedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $CommunityShareRecordsOrderingComposer
    extends Composer<_$AppDatabase, CommunityShareRecords> {
  $CommunityShareRecordsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareId => $composableBuilder(
    column: $table.shareId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicUrl => $composableBuilder(
    column: $table.publicUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sharedAt => $composableBuilder(
    column: $table.sharedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CommunityShareRecordsAnnotationComposer
    extends Composer<_$AppDatabase, CommunityShareRecords> {
  $CommunityShareRecordsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shareId =>
      $composableBuilder(column: $table.shareId, builder: (column) => column);

  GeneratedColumn<String> get publicUrl =>
      $composableBuilder(column: $table.publicUrl, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => column);
}

class $CommunityShareRecordsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CommunityShareRecords,
          CommunityShareRecord,
          $CommunityShareRecordsFilterComposer,
          $CommunityShareRecordsOrderingComposer,
          $CommunityShareRecordsAnnotationComposer,
          $CommunityShareRecordsCreateCompanionBuilder,
          $CommunityShareRecordsUpdateCompanionBuilder,
          (
            CommunityShareRecord,
            BaseReferences<
              _$AppDatabase,
              CommunityShareRecords,
              CommunityShareRecord
            >,
          ),
          CommunityShareRecord,
          PrefetchHooks Function()
        > {
  $CommunityShareRecordsTableManager(
    _$AppDatabase db,
    CommunityShareRecords table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $CommunityShareRecordsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $CommunityShareRecordsOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $CommunityShareRecordsAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String?> sessionLocalId = const Value.absent(),
                Value<String?> shareId = const Value.absent(),
                Value<String?> publicUrl = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> sharedAt = const Value.absent(),
              }) => CommunityShareRecordsCompanion(
                id: id,
                localId: localId,
                sessionLocalId: sessionLocalId,
                shareId: shareId,
                publicUrl: publicUrl,
                payloadJson: payloadJson,
                status: status,
                createdAt: createdAt,
                sharedAt: sharedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                Value<String?> sessionLocalId = const Value.absent(),
                Value<String?> shareId = const Value.absent(),
                Value<String?> publicUrl = const Value.absent(),
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> sharedAt = const Value.absent(),
              }) => CommunityShareRecordsCompanion.insert(
                id: id,
                localId: localId,
                sessionLocalId: sessionLocalId,
                shareId: shareId,
                publicUrl: publicUrl,
                payloadJson: payloadJson,
                status: status,
                createdAt: createdAt,
                sharedAt: sharedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $CommunityShareRecordsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CommunityShareRecords,
      CommunityShareRecord,
      $CommunityShareRecordsFilterComposer,
      $CommunityShareRecordsOrderingComposer,
      $CommunityShareRecordsAnnotationComposer,
      $CommunityShareRecordsCreateCompanionBuilder,
      $CommunityShareRecordsUpdateCompanionBuilder,
      (
        CommunityShareRecord,
        BaseReferences<
          _$AppDatabase,
          CommunityShareRecords,
          CommunityShareRecord
        >,
      ),
      CommunityShareRecord,
      PrefetchHooks Function()
    >;
typedef $ChallengeInvitesCreateCompanionBuilder =
    ChallengeInvitesCompanion Function({
      Value<int> id,
      required String localId,
      Value<String?> challengeId,
      required String title,
      required String metric,
      Value<double> targetValue,
      Value<String?> inviteUrl,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
    });
typedef $ChallengeInvitesUpdateCompanionBuilder =
    ChallengeInvitesCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String?> challengeId,
      Value<String> title,
      Value<String> metric,
      Value<double> targetValue,
      Value<String?> inviteUrl,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
    });

class $ChallengeInvitesFilterComposer
    extends Composer<_$AppDatabase, ChallengeInvites> {
  $ChallengeInvitesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inviteUrl => $composableBuilder(
    column: $table.inviteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ChallengeInvitesOrderingComposer
    extends Composer<_$AppDatabase, ChallengeInvites> {
  $ChallengeInvitesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inviteUrl => $composableBuilder(
    column: $table.inviteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ChallengeInvitesAnnotationComposer
    extends Composer<_$AppDatabase, ChallengeInvites> {
  $ChallengeInvitesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inviteUrl =>
      $composableBuilder(column: $table.inviteUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $ChallengeInvitesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ChallengeInvites,
          ChallengeInvite,
          $ChallengeInvitesFilterComposer,
          $ChallengeInvitesOrderingComposer,
          $ChallengeInvitesAnnotationComposer,
          $ChallengeInvitesCreateCompanionBuilder,
          $ChallengeInvitesUpdateCompanionBuilder,
          (
            ChallengeInvite,
            BaseReferences<_$AppDatabase, ChallengeInvites, ChallengeInvite>,
          ),
          ChallengeInvite,
          PrefetchHooks Function()
        > {
  $ChallengeInvitesTableManager(_$AppDatabase db, ChallengeInvites table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $ChallengeInvitesFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $ChallengeInvitesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $ChallengeInvitesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String?> challengeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<String?> inviteUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => ChallengeInvitesCompanion(
                id: id,
                localId: localId,
                challengeId: challengeId,
                title: title,
                metric: metric,
                targetValue: targetValue,
                inviteUrl: inviteUrl,
                status: status,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                Value<String?> challengeId = const Value.absent(),
                required String title,
                required String metric,
                Value<double> targetValue = const Value.absent(),
                Value<String?> inviteUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => ChallengeInvitesCompanion.insert(
                id: id,
                localId: localId,
                challengeId: challengeId,
                title: title,
                metric: metric,
                targetValue: targetValue,
                inviteUrl: inviteUrl,
                status: status,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ChallengeInvitesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ChallengeInvites,
      ChallengeInvite,
      $ChallengeInvitesFilterComposer,
      $ChallengeInvitesOrderingComposer,
      $ChallengeInvitesAnnotationComposer,
      $ChallengeInvitesCreateCompanionBuilder,
      $ChallengeInvitesUpdateCompanionBuilder,
      (
        ChallengeInvite,
        BaseReferences<_$AppDatabase, ChallengeInvites, ChallengeInvite>,
      ),
      ChallengeInvite,
      PrefetchHooks Function()
    >;
typedef $PersonalRecordsCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      required String localId,
      required String sportKey,
      required String recordKey,
      required String label,
      required String metric,
      required double value,
      required String unit,
      required String sessionLocalId,
      required DateTime achievedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $PersonalRecordsUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String> sportKey,
      Value<String> recordKey,
      Value<String> label,
      Value<String> metric,
      Value<double> value,
      Value<String> unit,
      Value<String> sessionLocalId,
      Value<DateTime> achievedAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $PersonalRecordsFilterComposer
    extends Composer<_$AppDatabase, PersonalRecords> {
  $PersonalRecordsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordKey => $composableBuilder(
    column: $table.recordKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $PersonalRecordsOrderingComposer
    extends Composer<_$AppDatabase, PersonalRecords> {
  $PersonalRecordsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordKey => $composableBuilder(
    column: $table.recordKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $PersonalRecordsAnnotationComposer
    extends Composer<_$AppDatabase, PersonalRecords> {
  $PersonalRecordsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get sportKey =>
      $composableBuilder(column: $table.sportKey, builder: (column) => column);

  GeneratedColumn<String> get recordKey =>
      $composableBuilder(column: $table.recordKey, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get sessionLocalId => $composableBuilder(
    column: $table.sessionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $PersonalRecordsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          PersonalRecords,
          PersonalRecord,
          $PersonalRecordsFilterComposer,
          $PersonalRecordsOrderingComposer,
          $PersonalRecordsAnnotationComposer,
          $PersonalRecordsCreateCompanionBuilder,
          $PersonalRecordsUpdateCompanionBuilder,
          (
            PersonalRecord,
            BaseReferences<_$AppDatabase, PersonalRecords, PersonalRecord>,
          ),
          PersonalRecord,
          PrefetchHooks Function()
        > {
  $PersonalRecordsTableManager(_$AppDatabase db, PersonalRecords table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $PersonalRecordsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $PersonalRecordsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $PersonalRecordsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> sportKey = const Value.absent(),
                Value<String> recordKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> sessionLocalId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                localId: localId,
                sportKey: sportKey,
                recordKey: recordKey,
                label: label,
                metric: metric,
                value: value,
                unit: unit,
                sessionLocalId: sessionLocalId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                required String sportKey,
                required String recordKey,
                required String label,
                required String metric,
                required double value,
                required String unit,
                required String sessionLocalId,
                required DateTime achievedAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                id: id,
                localId: localId,
                sportKey: sportKey,
                recordKey: recordKey,
                label: label,
                metric: metric,
                value: value,
                unit: unit,
                sessionLocalId: sessionLocalId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $PersonalRecordsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      PersonalRecords,
      PersonalRecord,
      $PersonalRecordsFilterComposer,
      $PersonalRecordsOrderingComposer,
      $PersonalRecordsAnnotationComposer,
      $PersonalRecordsCreateCompanionBuilder,
      $PersonalRecordsUpdateCompanionBuilder,
      (
        PersonalRecord,
        BaseReferences<_$AppDatabase, PersonalRecords, PersonalRecord>,
      ),
      PersonalRecord,
      PrefetchHooks Function()
    >;
typedef $TrainingPlansCreateCompanionBuilder =
    TrainingPlansCompanion Function({
      required String localId,
      required String planKey,
      required String title,
      required String sportKey,
      required String level,
      required DateTime startDate,
      required int weeks,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $TrainingPlansUpdateCompanionBuilder =
    TrainingPlansCompanion Function({
      Value<String> localId,
      Value<String> planKey,
      Value<String> title,
      Value<String> sportKey,
      Value<String> level,
      Value<DateTime> startDate,
      Value<int> weeks,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $TrainingPlansFilterComposer
    extends Composer<_$AppDatabase, TrainingPlans> {
  $TrainingPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planKey => $composableBuilder(
    column: $table.planKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $TrainingPlansOrderingComposer
    extends Composer<_$AppDatabase, TrainingPlans> {
  $TrainingPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planKey => $composableBuilder(
    column: $table.planKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportKey => $composableBuilder(
    column: $table.sportKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TrainingPlansAnnotationComposer
    extends Composer<_$AppDatabase, TrainingPlans> {
  $TrainingPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get planKey =>
      $composableBuilder(column: $table.planKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sportKey =>
      $composableBuilder(column: $table.sportKey, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get weeks =>
      $composableBuilder(column: $table.weeks, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $TrainingPlansTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          TrainingPlans,
          TrainingPlan,
          $TrainingPlansFilterComposer,
          $TrainingPlansOrderingComposer,
          $TrainingPlansAnnotationComposer,
          $TrainingPlansCreateCompanionBuilder,
          $TrainingPlansUpdateCompanionBuilder,
          (
            TrainingPlan,
            BaseReferences<_$AppDatabase, TrainingPlans, TrainingPlan>,
          ),
          TrainingPlan,
          PrefetchHooks Function()
        > {
  $TrainingPlansTableManager(_$AppDatabase db, TrainingPlans table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $TrainingPlansFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $TrainingPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $TrainingPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> planKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> sportKey = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> weeks = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingPlansCompanion(
                localId: localId,
                planKey: planKey,
                title: title,
                sportKey: sportKey,
                level: level,
                startDate: startDate,
                weeks: weeks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String planKey,
                required String title,
                required String sportKey,
                required String level,
                required DateTime startDate,
                required int weeks,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingPlansCompanion.insert(
                localId: localId,
                planKey: planKey,
                title: title,
                sportKey: sportKey,
                level: level,
                startDate: startDate,
                weeks: weeks,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TrainingPlansProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      TrainingPlans,
      TrainingPlan,
      $TrainingPlansFilterComposer,
      $TrainingPlansOrderingComposer,
      $TrainingPlansAnnotationComposer,
      $TrainingPlansCreateCompanionBuilder,
      $TrainingPlansUpdateCompanionBuilder,
      (
        TrainingPlan,
        BaseReferences<_$AppDatabase, TrainingPlans, TrainingPlan>,
      ),
      TrainingPlan,
      PrefetchHooks Function()
    >;
typedef $TrainingPlanWorkoutsCreateCompanionBuilder =
    TrainingPlanWorkoutsCompanion Function({
      Value<int> id,
      required String localId,
      required String planLocalId,
      required int weekIndex,
      required int dayIndex,
      required DateTime scheduledDate,
      required String title,
      required String workoutType,
      Value<int> targetDurationMinutes,
      Value<double> targetDistanceMeters,
      Value<String> intensity,
      Value<String> status,
      Value<String?> notes,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $TrainingPlanWorkoutsUpdateCompanionBuilder =
    TrainingPlanWorkoutsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String> planLocalId,
      Value<int> weekIndex,
      Value<int> dayIndex,
      Value<DateTime> scheduledDate,
      Value<String> title,
      Value<String> workoutType,
      Value<int> targetDurationMinutes,
      Value<double> targetDistanceMeters,
      Value<String> intensity,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $TrainingPlanWorkoutsFilterComposer
    extends Composer<_$AppDatabase, TrainingPlanWorkouts> {
  $TrainingPlanWorkoutsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planLocalId => $composableBuilder(
    column: $table.planLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetDistanceMeters => $composableBuilder(
    column: $table.targetDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $TrainingPlanWorkoutsOrderingComposer
    extends Composer<_$AppDatabase, TrainingPlanWorkouts> {
  $TrainingPlanWorkoutsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planLocalId => $composableBuilder(
    column: $table.planLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetDistanceMeters => $composableBuilder(
    column: $table.targetDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TrainingPlanWorkoutsAnnotationComposer
    extends Composer<_$AppDatabase, TrainingPlanWorkouts> {
  $TrainingPlanWorkoutsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get planLocalId => $composableBuilder(
    column: $table.planLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekIndex =>
      $composableBuilder(column: $table.weekIndex, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetDistanceMeters => $composableBuilder(
    column: $table.targetDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $TrainingPlanWorkoutsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          TrainingPlanWorkouts,
          TrainingPlanWorkout,
          $TrainingPlanWorkoutsFilterComposer,
          $TrainingPlanWorkoutsOrderingComposer,
          $TrainingPlanWorkoutsAnnotationComposer,
          $TrainingPlanWorkoutsCreateCompanionBuilder,
          $TrainingPlanWorkoutsUpdateCompanionBuilder,
          (
            TrainingPlanWorkout,
            BaseReferences<
              _$AppDatabase,
              TrainingPlanWorkouts,
              TrainingPlanWorkout
            >,
          ),
          TrainingPlanWorkout,
          PrefetchHooks Function()
        > {
  $TrainingPlanWorkoutsTableManager(
    _$AppDatabase db,
    TrainingPlanWorkouts table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $TrainingPlanWorkoutsFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $TrainingPlanWorkoutsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $TrainingPlanWorkoutsAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> planLocalId = const Value.absent(),
                Value<int> weekIndex = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<DateTime> scheduledDate = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> workoutType = const Value.absent(),
                Value<int> targetDurationMinutes = const Value.absent(),
                Value<double> targetDistanceMeters = const Value.absent(),
                Value<String> intensity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TrainingPlanWorkoutsCompanion(
                id: id,
                localId: localId,
                planLocalId: planLocalId,
                weekIndex: weekIndex,
                dayIndex: dayIndex,
                scheduledDate: scheduledDate,
                title: title,
                workoutType: workoutType,
                targetDurationMinutes: targetDurationMinutes,
                targetDistanceMeters: targetDistanceMeters,
                intensity: intensity,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                required String planLocalId,
                required int weekIndex,
                required int dayIndex,
                required DateTime scheduledDate,
                required String title,
                required String workoutType,
                Value<int> targetDurationMinutes = const Value.absent(),
                Value<double> targetDistanceMeters = const Value.absent(),
                Value<String> intensity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TrainingPlanWorkoutsCompanion.insert(
                id: id,
                localId: localId,
                planLocalId: planLocalId,
                weekIndex: weekIndex,
                dayIndex: dayIndex,
                scheduledDate: scheduledDate,
                title: title,
                workoutType: workoutType,
                targetDurationMinutes: targetDurationMinutes,
                targetDistanceMeters: targetDistanceMeters,
                intensity: intensity,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TrainingPlanWorkoutsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      TrainingPlanWorkouts,
      TrainingPlanWorkout,
      $TrainingPlanWorkoutsFilterComposer,
      $TrainingPlanWorkoutsOrderingComposer,
      $TrainingPlanWorkoutsAnnotationComposer,
      $TrainingPlanWorkoutsCreateCompanionBuilder,
      $TrainingPlanWorkoutsUpdateCompanionBuilder,
      (
        TrainingPlanWorkout,
        BaseReferences<
          _$AppDatabase,
          TrainingPlanWorkouts,
          TrainingPlanWorkout
        >,
      ),
      TrainingPlanWorkout,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $HealthRecordsTableManager get healthRecords =>
      $HealthRecordsTableManager(_db, _db.healthRecords);
  $SyncLogsTableManager get syncLogs =>
      $SyncLogsTableManager(_db, _db.syncLogs);
  $ActivitySessionsTableManager get activitySessions =>
      $ActivitySessionsTableManager(_db, _db.activitySessions);
  $ActivityEventsTableManager get activityEvents =>
      $ActivityEventsTableManager(_db, _db.activityEvents);
  $ActivityPointsTableManager get activityPoints =>
      $ActivityPointsTableManager(_db, _db.activityPoints);
  $ActivitySummariesTableManager get activitySummaries =>
      $ActivitySummariesTableManager(_db, _db.activitySummaries);
  $OfflineMapRegionsTableManager get offlineMapRegions =>
      $OfflineMapRegionsTableManager(_db, _db.offlineMapRegions);
  $SavedRoutesTableManager get savedRoutes =>
      $SavedRoutesTableManager(_db, _db.savedRoutes);
  $DailySummariesTableManager get dailySummaries =>
      $DailySummariesTableManager(_db, _db.dailySummaries);
  $AiToolCallsTableManager get aiToolCalls =>
      $AiToolCallsTableManager(_db, _db.aiToolCalls);
  $AiUsageWindowsTableManager get aiUsageWindows =>
      $AiUsageWindowsTableManager(_db, _db.aiUsageWindows);
  $AiConversationsTableManager get aiConversations =>
      $AiConversationsTableManager(_db, _db.aiConversations);
  $AiMessagesTableManager get aiMessages =>
      $AiMessagesTableManager(_db, _db.aiMessages);
  $CommunityShareRecordsTableManager get communityShareRecords =>
      $CommunityShareRecordsTableManager(_db, _db.communityShareRecords);
  $ChallengeInvitesTableManager get challengeInvites =>
      $ChallengeInvitesTableManager(_db, _db.challengeInvites);
  $PersonalRecordsTableManager get personalRecords =>
      $PersonalRecordsTableManager(_db, _db.personalRecords);
  $TrainingPlansTableManager get trainingPlans =>
      $TrainingPlansTableManager(_db, _db.trainingPlans);
  $TrainingPlanWorkoutsTableManager get trainingPlanWorkouts =>
      $TrainingPlanWorkoutsTableManager(_db, _db.trainingPlanWorkouts);
}
