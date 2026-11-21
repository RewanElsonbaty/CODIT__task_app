// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalCollectionsTable extends LocalCollections
    with TableInfo<$LocalCollectionsTable, LocalCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPiastresMeta = const VerificationMeta(
    'amountPiastres',
  );
  @override
  late final GeneratedColumn<int> amountPiastres = GeneratedColumn<int>(
    'amount_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collectedAtMeta = const VerificationMeta(
    'collectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> collectedAt = GeneratedColumn<DateTime>(
    'collected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceSequenceMeta = const VerificationMeta(
    'deviceSequence',
  );
  @override
  late final GeneratedColumn<int> deviceSequence = GeneratedColumn<int>(
    'device_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    customerName,
    amountPiastres,
    paymentMethod,
    notes,
    collectedAt,
    deviceSequence,
    idempotencyKey,
    syncStatus,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('amount_piastres')) {
      context.handle(
        _amountPiastresMeta,
        amountPiastres.isAcceptableOrUnknown(
          data['amount_piastres']!,
          _amountPiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPiastresMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('collected_at')) {
      context.handle(
        _collectedAtMeta,
        collectedAt.isAcceptableOrUnknown(
          data['collected_at']!,
          _collectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectedAtMeta);
    }
    if (data.containsKey('device_sequence')) {
      context.handle(
        _deviceSequenceMeta,
        deviceSequence.isAcceptableOrUnknown(
          data['device_sequence']!,
          _deviceSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceSequenceMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      amountPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_piastres'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      collectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}collected_at'],
      )!,
      deviceSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_sequence'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $LocalCollectionsTable createAlias(String alias) {
    return $LocalCollectionsTable(attachedDatabase, alias);
  }
}

class LocalCollection extends DataClass implements Insertable<LocalCollection> {
  final String id;
  final String customerId;
  final String customerName;
  final int amountPiastres;
  final String paymentMethod;
  final String? notes;
  final DateTime collectedAt;
  final int deviceSequence;
  final String idempotencyKey;
  final String syncStatus;
  final String accountId;
  const LocalCollection({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amountPiastres,
    required this.paymentMethod,
    this.notes,
    required this.collectedAt,
    required this.deviceSequence,
    required this.idempotencyKey,
    required this.syncStatus,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['customer_name'] = Variable<String>(customerName);
    map['amount_piastres'] = Variable<int>(amountPiastres);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['collected_at'] = Variable<DateTime>(collectedAt);
    map['device_sequence'] = Variable<int>(deviceSequence);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['sync_status'] = Variable<String>(syncStatus);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  LocalCollectionsCompanion toCompanion(bool nullToAbsent) {
    return LocalCollectionsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      customerName: Value(customerName),
      amountPiastres: Value(amountPiastres),
      paymentMethod: Value(paymentMethod),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      collectedAt: Value(collectedAt),
      deviceSequence: Value(deviceSequence),
      idempotencyKey: Value(idempotencyKey),
      syncStatus: Value(syncStatus),
      accountId: Value(accountId),
    );
  }

  factory LocalCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCollection(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      amountPiastres: serializer.fromJson<int>(json['amountPiastres']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      collectedAt: serializer.fromJson<DateTime>(json['collectedAt']),
      deviceSequence: serializer.fromJson<int>(json['deviceSequence']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'amountPiastres': serializer.toJson<int>(amountPiastres),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'collectedAt': serializer.toJson<DateTime>(collectedAt),
      'deviceSequence': serializer.toJson<int>(deviceSequence),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  LocalCollection copyWith({
    String? id,
    String? customerId,
    String? customerName,
    int? amountPiastres,
    String? paymentMethod,
    Value<String?> notes = const Value.absent(),
    DateTime? collectedAt,
    int? deviceSequence,
    String? idempotencyKey,
    String? syncStatus,
    String? accountId,
  }) => LocalCollection(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    customerName: customerName ?? this.customerName,
    amountPiastres: amountPiastres ?? this.amountPiastres,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    notes: notes.present ? notes.value : this.notes,
    collectedAt: collectedAt ?? this.collectedAt,
    deviceSequence: deviceSequence ?? this.deviceSequence,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    syncStatus: syncStatus ?? this.syncStatus,
    accountId: accountId ?? this.accountId,
  );
  LocalCollection copyWithCompanion(LocalCollectionsCompanion data) {
    return LocalCollection(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amountPiastres: data.amountPiastres.present
          ? data.amountPiastres.value
          : this.amountPiastres,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      collectedAt: data.collectedAt.present
          ? data.collectedAt.value
          : this.collectedAt,
      deviceSequence: data.deviceSequence.present
          ? data.deviceSequence.value
          : this.deviceSequence,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCollection(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('amountPiastres: $amountPiastres, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('collectedAt: $collectedAt, ')
          ..write('deviceSequence: $deviceSequence, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    customerName,
    amountPiastres,
    paymentMethod,
    notes,
    collectedAt,
    deviceSequence,
    idempotencyKey,
    syncStatus,
    accountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCollection &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.amountPiastres == this.amountPiastres &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.collectedAt == this.collectedAt &&
          other.deviceSequence == this.deviceSequence &&
          other.idempotencyKey == this.idempotencyKey &&
          other.syncStatus == this.syncStatus &&
          other.accountId == this.accountId);
}

class LocalCollectionsCompanion extends UpdateCompanion<LocalCollection> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> customerName;
  final Value<int> amountPiastres;
  final Value<String> paymentMethod;
  final Value<String?> notes;
  final Value<DateTime> collectedAt;
  final Value<int> deviceSequence;
  final Value<String> idempotencyKey;
  final Value<String> syncStatus;
  final Value<String> accountId;
  final Value<int> rowid;
  const LocalCollectionsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amountPiastres = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.collectedAt = const Value.absent(),
    this.deviceSequence = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.accountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCollectionsCompanion.insert({
    required String id,
    required String customerId,
    required String customerName,
    required int amountPiastres,
    required String paymentMethod,
    this.notes = const Value.absent(),
    required DateTime collectedAt,
    required int deviceSequence,
    required String idempotencyKey,
    required String syncStatus,
    required String accountId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       customerName = Value(customerName),
       amountPiastres = Value(amountPiastres),
       paymentMethod = Value(paymentMethod),
       collectedAt = Value(collectedAt),
       deviceSequence = Value(deviceSequence),
       idempotencyKey = Value(idempotencyKey),
       syncStatus = Value(syncStatus),
       accountId = Value(accountId);
  static Insertable<LocalCollection> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<int>? amountPiastres,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<DateTime>? collectedAt,
    Expression<int>? deviceSequence,
    Expression<String>? idempotencyKey,
    Expression<String>? syncStatus,
    Expression<String>? accountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (amountPiastres != null) 'amount_piastres': amountPiastres,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (collectedAt != null) 'collected_at': collectedAt,
      if (deviceSequence != null) 'device_sequence': deviceSequence,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (accountId != null) 'account_id': accountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCollectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? customerName,
    Value<int>? amountPiastres,
    Value<String>? paymentMethod,
    Value<String?>? notes,
    Value<DateTime>? collectedAt,
    Value<int>? deviceSequence,
    Value<String>? idempotencyKey,
    Value<String>? syncStatus,
    Value<String>? accountId,
    Value<int>? rowid,
  }) {
    return LocalCollectionsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      amountPiastres: amountPiastres ?? this.amountPiastres,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      collectedAt: collectedAt ?? this.collectedAt,
      deviceSequence: deviceSequence ?? this.deviceSequence,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      syncStatus: syncStatus ?? this.syncStatus,
      accountId: accountId ?? this.accountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amountPiastres.present) {
      map['amount_piastres'] = Variable<int>(amountPiastres.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (collectedAt.present) {
      map['collected_at'] = Variable<DateTime>(collectedAt.value);
    }
    if (deviceSequence.present) {
      map['device_sequence'] = Variable<int>(deviceSequence.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('amountPiastres: $amountPiastres, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('collectedAt: $collectedAt, ')
          ..write('deviceSequence: $deviceSequence, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('accountId: $accountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDebtsTable extends LocalDebts
    with TableInfo<$LocalDebtsTable, LocalDebt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPiastresMeta = const VerificationMeta(
    'originalPiastres',
  );
  @override
  late final GeneratedColumn<int> originalPiastres = GeneratedColumn<int>(
    'original_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingPiastresMeta = const VerificationMeta(
    'remainingPiastres',
  );
  @override
  late final GeneratedColumn<int> remainingPiastres = GeneratedColumn<int>(
    'remaining_piastres',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    originalPiastres,
    remainingPiastres,
    dueDate,
    status,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDebt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('original_piastres')) {
      context.handle(
        _originalPiastresMeta,
        originalPiastres.isAcceptableOrUnknown(
          data['original_piastres']!,
          _originalPiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPiastresMeta);
    }
    if (data.containsKey('remaining_piastres')) {
      context.handle(
        _remainingPiastresMeta,
        remainingPiastres.isAcceptableOrUnknown(
          data['remaining_piastres']!,
          _remainingPiastresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingPiastresMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDebt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDebt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      originalPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_piastres'],
      )!,
      remainingPiastres: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_piastres'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $LocalDebtsTable createAlias(String alias) {
    return $LocalDebtsTable(attachedDatabase, alias);
  }
}

class LocalDebt extends DataClass implements Insertable<LocalDebt> {
  final String id;
  final String customerId;
  final int originalPiastres;
  final int remainingPiastres;
  final DateTime dueDate;
  final String status;
  final String accountId;
  const LocalDebt({
    required this.id,
    required this.customerId,
    required this.originalPiastres,
    required this.remainingPiastres,
    required this.dueDate,
    required this.status,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['original_piastres'] = Variable<int>(originalPiastres);
    map['remaining_piastres'] = Variable<int>(remainingPiastres);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['status'] = Variable<String>(status);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  LocalDebtsCompanion toCompanion(bool nullToAbsent) {
    return LocalDebtsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      originalPiastres: Value(originalPiastres),
      remainingPiastres: Value(remainingPiastres),
      dueDate: Value(dueDate),
      status: Value(status),
      accountId: Value(accountId),
    );
  }

  factory LocalDebt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDebt(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      originalPiastres: serializer.fromJson<int>(json['originalPiastres']),
      remainingPiastres: serializer.fromJson<int>(json['remainingPiastres']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'originalPiastres': serializer.toJson<int>(originalPiastres),
      'remainingPiastres': serializer.toJson<int>(remainingPiastres),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(status),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  LocalDebt copyWith({
    String? id,
    String? customerId,
    int? originalPiastres,
    int? remainingPiastres,
    DateTime? dueDate,
    String? status,
    String? accountId,
  }) => LocalDebt(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    originalPiastres: originalPiastres ?? this.originalPiastres,
    remainingPiastres: remainingPiastres ?? this.remainingPiastres,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    accountId: accountId ?? this.accountId,
  );
  LocalDebt copyWithCompanion(LocalDebtsCompanion data) {
    return LocalDebt(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      originalPiastres: data.originalPiastres.present
          ? data.originalPiastres.value
          : this.originalPiastres,
      remainingPiastres: data.remainingPiastres.present
          ? data.remainingPiastres.value
          : this.remainingPiastres,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDebt(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('originalPiastres: $originalPiastres, ')
          ..write('remainingPiastres: $remainingPiastres, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    originalPiastres,
    remainingPiastres,
    dueDate,
    status,
    accountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDebt &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.originalPiastres == this.originalPiastres &&
          other.remainingPiastres == this.remainingPiastres &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.accountId == this.accountId);
}

class LocalDebtsCompanion extends UpdateCompanion<LocalDebt> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<int> originalPiastres;
  final Value<int> remainingPiastres;
  final Value<DateTime> dueDate;
  final Value<String> status;
  final Value<String> accountId;
  final Value<int> rowid;
  const LocalDebtsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.originalPiastres = const Value.absent(),
    this.remainingPiastres = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDebtsCompanion.insert({
    required String id,
    required String customerId,
    required int originalPiastres,
    required int remainingPiastres,
    required DateTime dueDate,
    required String status,
    required String accountId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       originalPiastres = Value(originalPiastres),
       remainingPiastres = Value(remainingPiastres),
       dueDate = Value(dueDate),
       status = Value(status),
       accountId = Value(accountId);
  static Insertable<LocalDebt> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? originalPiastres,
    Expression<int>? remainingPiastres,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<String>? accountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (originalPiastres != null) 'original_piastres': originalPiastres,
      if (remainingPiastres != null) 'remaining_piastres': remainingPiastres,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (accountId != null) 'account_id': accountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDebtsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<int>? originalPiastres,
    Value<int>? remainingPiastres,
    Value<DateTime>? dueDate,
    Value<String>? status,
    Value<String>? accountId,
    Value<int>? rowid,
  }) {
    return LocalDebtsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      originalPiastres: originalPiastres ?? this.originalPiastres,
      remainingPiastres: remainingPiastres ?? this.remainingPiastres,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (originalPiastres.present) {
      map['original_piastres'] = Variable<int>(originalPiastres.value);
    }
    if (remainingPiastres.present) {
      map['remaining_piastres'] = Variable<int>(remainingPiastres.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDebtsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('originalPiastres: $originalPiastres, ')
          ..write('remainingPiastres: $remainingPiastres, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceSequenceMeta = const VerificationMeta(
    'deviceSequence',
  );
  @override
  late final GeneratedColumn<int> deviceSequence = GeneratedColumn<int>(
    'device_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationType,
    payloadJson,
    deviceSequence,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
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
    if (data.containsKey('device_sequence')) {
      context.handle(
        _deviceSequenceMeta,
        deviceSequence.isAcceptableOrUnknown(
          data['device_sequence']!,
          _deviceSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceSequenceMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      deviceSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_sequence'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String operationType;
  final String payloadJson;
  final int deviceSequence;
  final String accountId;
  const SyncQueueData({
    required this.id,
    required this.operationType,
    required this.payloadJson,
    required this.deviceSequence,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation_type'] = Variable<String>(operationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['device_sequence'] = Variable<int>(deviceSequence);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operationType: Value(operationType),
      payloadJson: Value(payloadJson),
      deviceSequence: Value(deviceSequence),
      accountId: Value(accountId),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      deviceSequence: serializer.fromJson<int>(json['deviceSequence']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'deviceSequence': serializer.toJson<int>(deviceSequence),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? operationType,
    String? payloadJson,
    int? deviceSequence,
    String? accountId,
  }) => SyncQueueData(
    id: id ?? this.id,
    operationType: operationType ?? this.operationType,
    payloadJson: payloadJson ?? this.payloadJson,
    deviceSequence: deviceSequence ?? this.deviceSequence,
    accountId: accountId ?? this.accountId,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      deviceSequence: data.deviceSequence.present
          ? data.deviceSequence.value
          : this.deviceSequence,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('deviceSequence: $deviceSequence, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, operationType, payloadJson, deviceSequence, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.deviceSequence == this.deviceSequence &&
          other.accountId == this.accountId);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> operationType;
  final Value<String> payloadJson;
  final Value<int> deviceSequence;
  final Value<String> accountId;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.deviceSequence = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operationType,
    required String payloadJson,
    required int deviceSequence,
    required String accountId,
  }) : operationType = Value(operationType),
       payloadJson = Value(payloadJson),
       deviceSequence = Value(deviceSequence),
       accountId = Value(accountId);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<int>? deviceSequence,
    Expression<String>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (deviceSequence != null) 'device_sequence': deviceSequence,
      if (accountId != null) 'account_id': accountId,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? operationType,
    Value<String>? payloadJson,
    Value<int>? deviceSequence,
    Value<String>? accountId,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      deviceSequence: deviceSequence ?? this.deviceSequence,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (deviceSequence.present) {
      map['device_sequence'] = Variable<int>(deviceSequence.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('deviceSequence: $deviceSequence, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $DeviceMetaTable extends DeviceMeta
    with TableInfo<$DeviceMetaTable, DeviceMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceMetaData> instance, {
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
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DeviceMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $DeviceMetaTable createAlias(String alias) {
    return $DeviceMetaTable(attachedDatabase, alias);
  }
}

class DeviceMetaData extends DataClass implements Insertable<DeviceMetaData> {
  final String key;
  final String value;
  const DeviceMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DeviceMetaCompanion toCompanion(bool nullToAbsent) {
    return DeviceMetaCompanion(key: Value(key), value: Value(value));
  }

  factory DeviceMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DeviceMetaData copyWith({String? key, String? value}) =>
      DeviceMetaData(key: key ?? this.key, value: value ?? this.value);
  DeviceMetaData copyWithCompanion(DeviceMetaCompanion data) {
    return DeviceMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class DeviceMetaCompanion extends UpdateCompanion<DeviceMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DeviceMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DeviceMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return DeviceMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoldDraftsTable extends GoldDrafts
    with TableInfo<$GoldDraftsTable, GoldDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoldDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, payloadJson, updatedAt, accountId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gold_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoldDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoldDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoldDraft(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $GoldDraftsTable createAlias(String alias) {
    return $GoldDraftsTable(attachedDatabase, alias);
  }
}

class GoldDraft extends DataClass implements Insertable<GoldDraft> {
  final String id;
  final String payloadJson;
  final DateTime updatedAt;
  final String accountId;
  const GoldDraft({
    required this.id,
    required this.payloadJson,
    required this.updatedAt,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  GoldDraftsCompanion toCompanion(bool nullToAbsent) {
    return GoldDraftsCompanion(
      id: Value(id),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
      accountId: Value(accountId),
    );
  }

  factory GoldDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoldDraft(
      id: serializer.fromJson<String>(json['id']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  GoldDraft copyWith({
    String? id,
    String? payloadJson,
    DateTime? updatedAt,
    String? accountId,
  }) => GoldDraft(
    id: id ?? this.id,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
    accountId: accountId ?? this.accountId,
  );
  GoldDraft copyWithCompanion(GoldDraftsCompanion data) {
    return GoldDraft(
      id: data.id.present ? data.id.value : this.id,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoldDraft(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payloadJson, updatedAt, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoldDraft &&
          other.id == this.id &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt &&
          other.accountId == this.accountId);
}

class GoldDraftsCompanion extends UpdateCompanion<GoldDraft> {
  final Value<String> id;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<String> accountId;
  final Value<int> rowid;
  const GoldDraftsCompanion({
    this.id = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.accountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoldDraftsCompanion.insert({
    required String id,
    required String payloadJson,
    required DateTime updatedAt,
    required String accountId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt),
       accountId = Value(accountId);
  static Insertable<GoldDraft> custom({
    Expression<String>? id,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<String>? accountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (accountId != null) 'account_id': accountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoldDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<String>? accountId,
    Value<int>? rowid,
  }) {
    return GoldDraftsCompanion(
      id: id ?? this.id,
      payloadJson: payloadJson ?? this.payloadJson,
      updatedAt: updatedAt ?? this.updatedAt,
      accountId: accountId ?? this.accountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoldDraftsCompanion(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('accountId: $accountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BranchSnapshotsTable extends BranchSnapshots
    with TableInfo<$BranchSnapshotsTable, BranchSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta = const VerificationMeta(
    'scopeKey',
  );
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
    'scope_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    scopeKey,
    payloadJson,
    lastSequence,
    updatedAt,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branch_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BranchSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(
        _scopeKeyMeta,
        scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
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
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSequenceMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey};
  @override
  BranchSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BranchSnapshot(
      scopeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_key'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $BranchSnapshotsTable createAlias(String alias) {
    return $BranchSnapshotsTable(attachedDatabase, alias);
  }
}

class BranchSnapshot extends DataClass implements Insertable<BranchSnapshot> {
  final String scopeKey;
  final String payloadJson;
  final int lastSequence;
  final DateTime updatedAt;
  final String accountId;
  const BranchSnapshot({
    required this.scopeKey,
    required this.payloadJson,
    required this.lastSequence,
    required this.updatedAt,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['payload_json'] = Variable<String>(payloadJson);
    map['last_sequence'] = Variable<int>(lastSequence);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  BranchSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BranchSnapshotsCompanion(
      scopeKey: Value(scopeKey),
      payloadJson: Value(payloadJson),
      lastSequence: Value(lastSequence),
      updatedAt: Value(updatedAt),
      accountId: Value(accountId),
    );
  }

  factory BranchSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BranchSnapshot(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'lastSequence': serializer.toJson<int>(lastSequence),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  BranchSnapshot copyWith({
    String? scopeKey,
    String? payloadJson,
    int? lastSequence,
    DateTime? updatedAt,
    String? accountId,
  }) => BranchSnapshot(
    scopeKey: scopeKey ?? this.scopeKey,
    payloadJson: payloadJson ?? this.payloadJson,
    lastSequence: lastSequence ?? this.lastSequence,
    updatedAt: updatedAt ?? this.updatedAt,
    accountId: accountId ?? this.accountId,
  );
  BranchSnapshot copyWithCompanion(BranchSnapshotsCompanion data) {
    return BranchSnapshot(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BranchSnapshot(')
          ..write('scopeKey: $scopeKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(scopeKey, payloadJson, lastSequence, updatedAt, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BranchSnapshot &&
          other.scopeKey == this.scopeKey &&
          other.payloadJson == this.payloadJson &&
          other.lastSequence == this.lastSequence &&
          other.updatedAt == this.updatedAt &&
          other.accountId == this.accountId);
}

class BranchSnapshotsCompanion extends UpdateCompanion<BranchSnapshot> {
  final Value<String> scopeKey;
  final Value<String> payloadJson;
  final Value<int> lastSequence;
  final Value<DateTime> updatedAt;
  final Value<String> accountId;
  final Value<int> rowid;
  const BranchSnapshotsCompanion({
    this.scopeKey = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.lastSequence = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.accountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BranchSnapshotsCompanion.insert({
    required String scopeKey,
    required String payloadJson,
    required int lastSequence,
    required DateTime updatedAt,
    required String accountId,
    this.rowid = const Value.absent(),
  }) : scopeKey = Value(scopeKey),
       payloadJson = Value(payloadJson),
       lastSequence = Value(lastSequence),
       updatedAt = Value(updatedAt),
       accountId = Value(accountId);
  static Insertable<BranchSnapshot> custom({
    Expression<String>? scopeKey,
    Expression<String>? payloadJson,
    Expression<int>? lastSequence,
    Expression<DateTime>? updatedAt,
    Expression<String>? accountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (lastSequence != null) 'last_sequence': lastSequence,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (accountId != null) 'account_id': accountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BranchSnapshotsCompanion copyWith({
    Value<String>? scopeKey,
    Value<String>? payloadJson,
    Value<int>? lastSequence,
    Value<DateTime>? updatedAt,
    Value<String>? accountId,
    Value<int>? rowid,
  }) {
    return BranchSnapshotsCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      payloadJson: payloadJson ?? this.payloadJson,
      lastSequence: lastSequence ?? this.lastSequence,
      updatedAt: updatedAt ?? this.updatedAt,
      accountId: accountId ?? this.accountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchSnapshotsCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('accountId: $accountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingApprovalDecisionsTable extends PendingApprovalDecisions
    with TableInfo<$PendingApprovalDecisionsTable, PendingApprovalDecision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingApprovalDecisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _decisionIdMeta = const VerificationMeta(
    'decisionId',
  );
  @override
  late final GeneratedColumn<String> decisionId = GeneratedColumn<String>(
    'decision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestIdMeta = const VerificationMeta(
    'requestId',
  );
  @override
  late final GeneratedColumn<String> requestId = GeneratedColumn<String>(
    'request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestVersionMeta = const VerificationMeta(
    'requestVersion',
  );
  @override
  late final GeneratedColumn<int> requestVersion = GeneratedColumn<int>(
    'request_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decisionTypeMeta = const VerificationMeta(
    'decisionType',
  );
  @override
  late final GeneratedColumn<String> decisionType = GeneratedColumn<String>(
    'decision_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    decisionId,
    requestId,
    requestVersion,
    decisionType,
    status,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_approval_decisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingApprovalDecision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('decision_id')) {
      context.handle(
        _decisionIdMeta,
        decisionId.isAcceptableOrUnknown(data['decision_id']!, _decisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_decisionIdMeta);
    }
    if (data.containsKey('request_id')) {
      context.handle(
        _requestIdMeta,
        requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta),
      );
    } else if (isInserting) {
      context.missing(_requestIdMeta);
    }
    if (data.containsKey('request_version')) {
      context.handle(
        _requestVersionMeta,
        requestVersion.isAcceptableOrUnknown(
          data['request_version']!,
          _requestVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestVersionMeta);
    }
    if (data.containsKey('decision_type')) {
      context.handle(
        _decisionTypeMeta,
        decisionType.isAcceptableOrUnknown(
          data['decision_type']!,
          _decisionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_decisionTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {decisionId};
  @override
  PendingApprovalDecision map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingApprovalDecision(
      decisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decision_id'],
      )!,
      requestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_id'],
      )!,
      requestVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}request_version'],
      )!,
      decisionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decision_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $PendingApprovalDecisionsTable createAlias(String alias) {
    return $PendingApprovalDecisionsTable(attachedDatabase, alias);
  }
}

class PendingApprovalDecision extends DataClass
    implements Insertable<PendingApprovalDecision> {
  final String decisionId;
  final String requestId;
  final int requestVersion;
  final String decisionType;
  final String status;
  final String accountId;
  const PendingApprovalDecision({
    required this.decisionId,
    required this.requestId,
    required this.requestVersion,
    required this.decisionType,
    required this.status,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['decision_id'] = Variable<String>(decisionId);
    map['request_id'] = Variable<String>(requestId);
    map['request_version'] = Variable<int>(requestVersion);
    map['decision_type'] = Variable<String>(decisionType);
    map['status'] = Variable<String>(status);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  PendingApprovalDecisionsCompanion toCompanion(bool nullToAbsent) {
    return PendingApprovalDecisionsCompanion(
      decisionId: Value(decisionId),
      requestId: Value(requestId),
      requestVersion: Value(requestVersion),
      decisionType: Value(decisionType),
      status: Value(status),
      accountId: Value(accountId),
    );
  }

  factory PendingApprovalDecision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingApprovalDecision(
      decisionId: serializer.fromJson<String>(json['decisionId']),
      requestId: serializer.fromJson<String>(json['requestId']),
      requestVersion: serializer.fromJson<int>(json['requestVersion']),
      decisionType: serializer.fromJson<String>(json['decisionType']),
      status: serializer.fromJson<String>(json['status']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'decisionId': serializer.toJson<String>(decisionId),
      'requestId': serializer.toJson<String>(requestId),
      'requestVersion': serializer.toJson<int>(requestVersion),
      'decisionType': serializer.toJson<String>(decisionType),
      'status': serializer.toJson<String>(status),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  PendingApprovalDecision copyWith({
    String? decisionId,
    String? requestId,
    int? requestVersion,
    String? decisionType,
    String? status,
    String? accountId,
  }) => PendingApprovalDecision(
    decisionId: decisionId ?? this.decisionId,
    requestId: requestId ?? this.requestId,
    requestVersion: requestVersion ?? this.requestVersion,
    decisionType: decisionType ?? this.decisionType,
    status: status ?? this.status,
    accountId: accountId ?? this.accountId,
  );
  PendingApprovalDecision copyWithCompanion(
    PendingApprovalDecisionsCompanion data,
  ) {
    return PendingApprovalDecision(
      decisionId: data.decisionId.present
          ? data.decisionId.value
          : this.decisionId,
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      requestVersion: data.requestVersion.present
          ? data.requestVersion.value
          : this.requestVersion,
      decisionType: data.decisionType.present
          ? data.decisionType.value
          : this.decisionType,
      status: data.status.present ? data.status.value : this.status,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingApprovalDecision(')
          ..write('decisionId: $decisionId, ')
          ..write('requestId: $requestId, ')
          ..write('requestVersion: $requestVersion, ')
          ..write('decisionType: $decisionType, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    decisionId,
    requestId,
    requestVersion,
    decisionType,
    status,
    accountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingApprovalDecision &&
          other.decisionId == this.decisionId &&
          other.requestId == this.requestId &&
          other.requestVersion == this.requestVersion &&
          other.decisionType == this.decisionType &&
          other.status == this.status &&
          other.accountId == this.accountId);
}

class PendingApprovalDecisionsCompanion
    extends UpdateCompanion<PendingApprovalDecision> {
  final Value<String> decisionId;
  final Value<String> requestId;
  final Value<int> requestVersion;
  final Value<String> decisionType;
  final Value<String> status;
  final Value<String> accountId;
  final Value<int> rowid;
  const PendingApprovalDecisionsCompanion({
    this.decisionId = const Value.absent(),
    this.requestId = const Value.absent(),
    this.requestVersion = const Value.absent(),
    this.decisionType = const Value.absent(),
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingApprovalDecisionsCompanion.insert({
    required String decisionId,
    required String requestId,
    required int requestVersion,
    required String decisionType,
    required String status,
    required String accountId,
    this.rowid = const Value.absent(),
  }) : decisionId = Value(decisionId),
       requestId = Value(requestId),
       requestVersion = Value(requestVersion),
       decisionType = Value(decisionType),
       status = Value(status),
       accountId = Value(accountId);
  static Insertable<PendingApprovalDecision> custom({
    Expression<String>? decisionId,
    Expression<String>? requestId,
    Expression<int>? requestVersion,
    Expression<String>? decisionType,
    Expression<String>? status,
    Expression<String>? accountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (decisionId != null) 'decision_id': decisionId,
      if (requestId != null) 'request_id': requestId,
      if (requestVersion != null) 'request_version': requestVersion,
      if (decisionType != null) 'decision_type': decisionType,
      if (status != null) 'status': status,
      if (accountId != null) 'account_id': accountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingApprovalDecisionsCompanion copyWith({
    Value<String>? decisionId,
    Value<String>? requestId,
    Value<int>? requestVersion,
    Value<String>? decisionType,
    Value<String>? status,
    Value<String>? accountId,
    Value<int>? rowid,
  }) {
    return PendingApprovalDecisionsCompanion(
      decisionId: decisionId ?? this.decisionId,
      requestId: requestId ?? this.requestId,
      requestVersion: requestVersion ?? this.requestVersion,
      decisionType: decisionType ?? this.decisionType,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (decisionId.present) {
      map['decision_id'] = Variable<String>(decisionId.value);
    }
    if (requestId.present) {
      map['request_id'] = Variable<String>(requestId.value);
    }
    if (requestVersion.present) {
      map['request_version'] = Variable<int>(requestVersion.value);
    }
    if (decisionType.present) {
      map['decision_type'] = Variable<String>(decisionType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingApprovalDecisionsCompanion(')
          ..write('decisionId: $decisionId, ')
          ..write('requestId: $requestId, ')
          ..write('requestVersion: $requestVersion, ')
          ..write('decisionType: $decisionType, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalCollectionsTable localCollections = $LocalCollectionsTable(
    this,
  );
  late final $LocalDebtsTable localDebts = $LocalDebtsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $DeviceMetaTable deviceMeta = $DeviceMetaTable(this);
  late final $GoldDraftsTable goldDrafts = $GoldDraftsTable(this);
  late final $BranchSnapshotsTable branchSnapshots = $BranchSnapshotsTable(
    this,
  );
  late final $PendingApprovalDecisionsTable pendingApprovalDecisions =
      $PendingApprovalDecisionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localCollections,
    localDebts,
    syncQueue,
    deviceMeta,
    goldDrafts,
    branchSnapshots,
    pendingApprovalDecisions,
  ];
}

typedef $$LocalCollectionsTableCreateCompanionBuilder =
    LocalCollectionsCompanion Function({
      required String id,
      required String customerId,
      required String customerName,
      required int amountPiastres,
      required String paymentMethod,
      Value<String?> notes,
      required DateTime collectedAt,
      required int deviceSequence,
      required String idempotencyKey,
      required String syncStatus,
      required String accountId,
      Value<int> rowid,
    });
typedef $$LocalCollectionsTableUpdateCompanionBuilder =
    LocalCollectionsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> customerName,
      Value<int> amountPiastres,
      Value<String> paymentMethod,
      Value<String?> notes,
      Value<DateTime> collectedAt,
      Value<int> deviceSequence,
      Value<String> idempotencyKey,
      Value<String> syncStatus,
      Value<String> accountId,
      Value<int> rowid,
    });

class $$LocalCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCollectionsTable> {
  $$LocalCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCollectionsTable> {
  $$LocalCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCollectionsTable> {
  $$LocalCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPiastres => $composableBuilder(
    column: $table.amountPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$LocalCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCollectionsTable,
          LocalCollection,
          $$LocalCollectionsTableFilterComposer,
          $$LocalCollectionsTableOrderingComposer,
          $$LocalCollectionsTableAnnotationComposer,
          $$LocalCollectionsTableCreateCompanionBuilder,
          $$LocalCollectionsTableUpdateCompanionBuilder,
          (
            LocalCollection,
            BaseReferences<
              _$AppDatabase,
              $LocalCollectionsTable,
              LocalCollection
            >,
          ),
          LocalCollection,
          PrefetchHooks Function()
        > {
  $$LocalCollectionsTableTableManager(
    _$AppDatabase db,
    $LocalCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<int> amountPiastres = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> collectedAt = const Value.absent(),
                Value<int> deviceSequence = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCollectionsCompanion(
                id: id,
                customerId: customerId,
                customerName: customerName,
                amountPiastres: amountPiastres,
                paymentMethod: paymentMethod,
                notes: notes,
                collectedAt: collectedAt,
                deviceSequence: deviceSequence,
                idempotencyKey: idempotencyKey,
                syncStatus: syncStatus,
                accountId: accountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String customerName,
                required int amountPiastres,
                required String paymentMethod,
                Value<String?> notes = const Value.absent(),
                required DateTime collectedAt,
                required int deviceSequence,
                required String idempotencyKey,
                required String syncStatus,
                required String accountId,
                Value<int> rowid = const Value.absent(),
              }) => LocalCollectionsCompanion.insert(
                id: id,
                customerId: customerId,
                customerName: customerName,
                amountPiastres: amountPiastres,
                paymentMethod: paymentMethod,
                notes: notes,
                collectedAt: collectedAt,
                deviceSequence: deviceSequence,
                idempotencyKey: idempotencyKey,
                syncStatus: syncStatus,
                accountId: accountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalCollectionsTable, LocalCollection>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalCollectionsTable,
                    LocalCollection
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCollectionsTable,
      LocalCollection,
      $$LocalCollectionsTableFilterComposer,
      $$LocalCollectionsTableOrderingComposer,
      $$LocalCollectionsTableAnnotationComposer,
      $$LocalCollectionsTableCreateCompanionBuilder,
      $$LocalCollectionsTableUpdateCompanionBuilder,
      (
        LocalCollection,
        BaseReferences<_$AppDatabase, $LocalCollectionsTable, LocalCollection>,
      ),
      LocalCollection,
      PrefetchHooks Function()
    >;
typedef $$LocalDebtsTableCreateCompanionBuilder =
    LocalDebtsCompanion Function({
      required String id,
      required String customerId,
      required int originalPiastres,
      required int remainingPiastres,
      required DateTime dueDate,
      required String status,
      required String accountId,
      Value<int> rowid,
    });
typedef $$LocalDebtsTableUpdateCompanionBuilder =
    LocalDebtsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<int> originalPiastres,
      Value<int> remainingPiastres,
      Value<DateTime> dueDate,
      Value<String> status,
      Value<String> accountId,
      Value<int> rowid,
    });

class $$LocalDebtsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalPiastres => $composableBuilder(
    column: $table.originalPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingPiastres => $composableBuilder(
    column: $table.remainingPiastres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalPiastres => $composableBuilder(
    column: $table.originalPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingPiastres => $composableBuilder(
    column: $table.remainingPiastres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalPiastres => $composableBuilder(
    column: $table.originalPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingPiastres => $composableBuilder(
    column: $table.remainingPiastres,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$LocalDebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDebtsTable,
          LocalDebt,
          $$LocalDebtsTableFilterComposer,
          $$LocalDebtsTableOrderingComposer,
          $$LocalDebtsTableAnnotationComposer,
          $$LocalDebtsTableCreateCompanionBuilder,
          $$LocalDebtsTableUpdateCompanionBuilder,
          (
            LocalDebt,
            BaseReferences<_$AppDatabase, $LocalDebtsTable, LocalDebt>,
          ),
          LocalDebt,
          PrefetchHooks Function()
        > {
  $$LocalDebtsTableTableManager(_$AppDatabase db, $LocalDebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<int> originalPiastres = const Value.absent(),
                Value<int> remainingPiastres = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDebtsCompanion(
                id: id,
                customerId: customerId,
                originalPiastres: originalPiastres,
                remainingPiastres: remainingPiastres,
                dueDate: dueDate,
                status: status,
                accountId: accountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required int originalPiastres,
                required int remainingPiastres,
                required DateTime dueDate,
                required String status,
                required String accountId,
                Value<int> rowid = const Value.absent(),
              }) => LocalDebtsCompanion.insert(
                id: id,
                customerId: customerId,
                originalPiastres: originalPiastres,
                remainingPiastres: remainingPiastres,
                dueDate: dueDate,
                status: status,
                accountId: accountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalDebtsTable, LocalDebt>(table),
                  BaseReferences<_$AppDatabase, $LocalDebtsTable, LocalDebt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDebtsTable,
      LocalDebt,
      $$LocalDebtsTableFilterComposer,
      $$LocalDebtsTableOrderingComposer,
      $$LocalDebtsTableAnnotationComposer,
      $$LocalDebtsTableCreateCompanionBuilder,
      $$LocalDebtsTableUpdateCompanionBuilder,
      (LocalDebt, BaseReferences<_$AppDatabase, $LocalDebtsTable, LocalDebt>),
      LocalDebt,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String operationType,
      required String payloadJson,
      required int deviceSequence,
      required String accountId,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> operationType,
      Value<String> payloadJson,
      Value<int> deviceSequence,
      Value<String> accountId,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
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

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deviceSequence => $composableBuilder(
    column: $table.deviceSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> deviceSequence = const Value.absent(),
                Value<String> accountId = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                operationType: operationType,
                payloadJson: payloadJson,
                deviceSequence: deviceSequence,
                accountId: accountId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operationType,
                required String payloadJson,
                required int deviceSequence,
                required String accountId,
              }) => SyncQueueCompanion.insert(
                id: id,
                operationType: operationType,
                payloadJson: payloadJson,
                deviceSequence: deviceSequence,
                accountId: accountId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$DeviceMetaTableCreateCompanionBuilder =
    DeviceMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$DeviceMetaTableUpdateCompanionBuilder =
    DeviceMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$DeviceMetaTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableFilterComposer({
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

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableOrderingComposer({
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

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DeviceMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceMetaTable,
          DeviceMetaData,
          $$DeviceMetaTableFilterComposer,
          $$DeviceMetaTableOrderingComposer,
          $$DeviceMetaTableAnnotationComposer,
          $$DeviceMetaTableCreateCompanionBuilder,
          $$DeviceMetaTableUpdateCompanionBuilder,
          (
            DeviceMetaData,
            BaseReferences<_$AppDatabase, $DeviceMetaTable, DeviceMetaData>,
          ),
          DeviceMetaData,
          PrefetchHooks Function()
        > {
  $$DeviceMetaTableTableManager(_$AppDatabase db, $DeviceMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => DeviceMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceMetaTable, DeviceMetaData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeviceMetaTable,
                    DeviceMetaData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceMetaTable,
      DeviceMetaData,
      $$DeviceMetaTableFilterComposer,
      $$DeviceMetaTableOrderingComposer,
      $$DeviceMetaTableAnnotationComposer,
      $$DeviceMetaTableCreateCompanionBuilder,
      $$DeviceMetaTableUpdateCompanionBuilder,
      (
        DeviceMetaData,
        BaseReferences<_$AppDatabase, $DeviceMetaTable, DeviceMetaData>,
      ),
      DeviceMetaData,
      PrefetchHooks Function()
    >;
typedef $$GoldDraftsTableCreateCompanionBuilder =
    GoldDraftsCompanion Function({
      required String id,
      required String payloadJson,
      required DateTime updatedAt,
      required String accountId,
      Value<int> rowid,
    });
typedef $$GoldDraftsTableUpdateCompanionBuilder =
    GoldDraftsCompanion Function({
      Value<String> id,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<String> accountId,
      Value<int> rowid,
    });

class $$GoldDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $GoldDraftsTable> {
  $$GoldDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoldDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoldDraftsTable> {
  $$GoldDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoldDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoldDraftsTable> {
  $$GoldDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$GoldDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoldDraftsTable,
          GoldDraft,
          $$GoldDraftsTableFilterComposer,
          $$GoldDraftsTableOrderingComposer,
          $$GoldDraftsTableAnnotationComposer,
          $$GoldDraftsTableCreateCompanionBuilder,
          $$GoldDraftsTableUpdateCompanionBuilder,
          (
            GoldDraft,
            BaseReferences<_$AppDatabase, $GoldDraftsTable, GoldDraft>,
          ),
          GoldDraft,
          PrefetchHooks Function()
        > {
  $$GoldDraftsTableTableManager(_$AppDatabase db, $GoldDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoldDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoldDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoldDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoldDraftsCompanion(
                id: id,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                accountId: accountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payloadJson,
                required DateTime updatedAt,
                required String accountId,
                Value<int> rowid = const Value.absent(),
              }) => GoldDraftsCompanion.insert(
                id: id,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                accountId: accountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoldDraftsTable, GoldDraft>(table),
                  BaseReferences<_$AppDatabase, $GoldDraftsTable, GoldDraft>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoldDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoldDraftsTable,
      GoldDraft,
      $$GoldDraftsTableFilterComposer,
      $$GoldDraftsTableOrderingComposer,
      $$GoldDraftsTableAnnotationComposer,
      $$GoldDraftsTableCreateCompanionBuilder,
      $$GoldDraftsTableUpdateCompanionBuilder,
      (GoldDraft, BaseReferences<_$AppDatabase, $GoldDraftsTable, GoldDraft>),
      GoldDraft,
      PrefetchHooks Function()
    >;
typedef $$BranchSnapshotsTableCreateCompanionBuilder =
    BranchSnapshotsCompanion Function({
      required String scopeKey,
      required String payloadJson,
      required int lastSequence,
      required DateTime updatedAt,
      required String accountId,
      Value<int> rowid,
    });
typedef $$BranchSnapshotsTableUpdateCompanionBuilder =
    BranchSnapshotsCompanion Function({
      Value<String> scopeKey,
      Value<String> payloadJson,
      Value<int> lastSequence,
      Value<DateTime> updatedAt,
      Value<String> accountId,
      Value<int> rowid,
    });

class $$BranchSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BranchSnapshotsTable> {
  $$BranchSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
    column: $table.scopeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BranchSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchSnapshotsTable> {
  $$BranchSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
    column: $table.scopeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BranchSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchSnapshotsTable> {
  $$BranchSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$BranchSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BranchSnapshotsTable,
          BranchSnapshot,
          $$BranchSnapshotsTableFilterComposer,
          $$BranchSnapshotsTableOrderingComposer,
          $$BranchSnapshotsTableAnnotationComposer,
          $$BranchSnapshotsTableCreateCompanionBuilder,
          $$BranchSnapshotsTableUpdateCompanionBuilder,
          (
            BranchSnapshot,
            BaseReferences<
              _$AppDatabase,
              $BranchSnapshotsTable,
              BranchSnapshot
            >,
          ),
          BranchSnapshot,
          PrefetchHooks Function()
        > {
  $$BranchSnapshotsTableTableManager(
    _$AppDatabase db,
    $BranchSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> scopeKey = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BranchSnapshotsCompanion(
                scopeKey: scopeKey,
                payloadJson: payloadJson,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                accountId: accountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scopeKey,
                required String payloadJson,
                required int lastSequence,
                required DateTime updatedAt,
                required String accountId,
                Value<int> rowid = const Value.absent(),
              }) => BranchSnapshotsCompanion.insert(
                scopeKey: scopeKey,
                payloadJson: payloadJson,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                accountId: accountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BranchSnapshotsTable, BranchSnapshot>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BranchSnapshotsTable,
                    BranchSnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BranchSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BranchSnapshotsTable,
      BranchSnapshot,
      $$BranchSnapshotsTableFilterComposer,
      $$BranchSnapshotsTableOrderingComposer,
      $$BranchSnapshotsTableAnnotationComposer,
      $$BranchSnapshotsTableCreateCompanionBuilder,
      $$BranchSnapshotsTableUpdateCompanionBuilder,
      (
        BranchSnapshot,
        BaseReferences<_$AppDatabase, $BranchSnapshotsTable, BranchSnapshot>,
      ),
      BranchSnapshot,
      PrefetchHooks Function()
    >;
typedef $$PendingApprovalDecisionsTableCreateCompanionBuilder =
    PendingApprovalDecisionsCompanion Function({
      required String decisionId,
      required String requestId,
      required int requestVersion,
      required String decisionType,
      required String status,
      required String accountId,
      Value<int> rowid,
    });
typedef $$PendingApprovalDecisionsTableUpdateCompanionBuilder =
    PendingApprovalDecisionsCompanion Function({
      Value<String> decisionId,
      Value<String> requestId,
      Value<int> requestVersion,
      Value<String> decisionType,
      Value<String> status,
      Value<String> accountId,
      Value<int> rowid,
    });

class $$PendingApprovalDecisionsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingApprovalDecisionsTable> {
  $$PendingApprovalDecisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get decisionId => $composableBuilder(
    column: $table.decisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestId => $composableBuilder(
    column: $table.requestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requestVersion => $composableBuilder(
    column: $table.requestVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decisionType => $composableBuilder(
    column: $table.decisionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingApprovalDecisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingApprovalDecisionsTable> {
  $$PendingApprovalDecisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get decisionId => $composableBuilder(
    column: $table.decisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestId => $composableBuilder(
    column: $table.requestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requestVersion => $composableBuilder(
    column: $table.requestVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decisionType => $composableBuilder(
    column: $table.decisionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingApprovalDecisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingApprovalDecisionsTable> {
  $$PendingApprovalDecisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get decisionId => $composableBuilder(
    column: $table.decisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestId =>
      $composableBuilder(column: $table.requestId, builder: (column) => column);

  GeneratedColumn<int> get requestVersion => $composableBuilder(
    column: $table.requestVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get decisionType => $composableBuilder(
    column: $table.decisionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$PendingApprovalDecisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingApprovalDecisionsTable,
          PendingApprovalDecision,
          $$PendingApprovalDecisionsTableFilterComposer,
          $$PendingApprovalDecisionsTableOrderingComposer,
          $$PendingApprovalDecisionsTableAnnotationComposer,
          $$PendingApprovalDecisionsTableCreateCompanionBuilder,
          $$PendingApprovalDecisionsTableUpdateCompanionBuilder,
          (
            PendingApprovalDecision,
            BaseReferences<
              _$AppDatabase,
              $PendingApprovalDecisionsTable,
              PendingApprovalDecision
            >,
          ),
          PendingApprovalDecision,
          PrefetchHooks Function()
        > {
  $$PendingApprovalDecisionsTableTableManager(
    _$AppDatabase db,
    $PendingApprovalDecisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingApprovalDecisionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingApprovalDecisionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingApprovalDecisionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> decisionId = const Value.absent(),
                Value<String> requestId = const Value.absent(),
                Value<int> requestVersion = const Value.absent(),
                Value<String> decisionType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingApprovalDecisionsCompanion(
                decisionId: decisionId,
                requestId: requestId,
                requestVersion: requestVersion,
                decisionType: decisionType,
                status: status,
                accountId: accountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String decisionId,
                required String requestId,
                required int requestVersion,
                required String decisionType,
                required String status,
                required String accountId,
                Value<int> rowid = const Value.absent(),
              }) => PendingApprovalDecisionsCompanion.insert(
                decisionId: decisionId,
                requestId: requestId,
                requestVersion: requestVersion,
                decisionType: decisionType,
                status: status,
                accountId: accountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PendingApprovalDecisionsTable,
                    PendingApprovalDecision
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingApprovalDecisionsTable,
                    PendingApprovalDecision
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingApprovalDecisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingApprovalDecisionsTable,
      PendingApprovalDecision,
      $$PendingApprovalDecisionsTableFilterComposer,
      $$PendingApprovalDecisionsTableOrderingComposer,
      $$PendingApprovalDecisionsTableAnnotationComposer,
      $$PendingApprovalDecisionsTableCreateCompanionBuilder,
      $$PendingApprovalDecisionsTableUpdateCompanionBuilder,
      (
        PendingApprovalDecision,
        BaseReferences<
          _$AppDatabase,
          $PendingApprovalDecisionsTable,
          PendingApprovalDecision
        >,
      ),
      PendingApprovalDecision,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalCollectionsTableTableManager get localCollections =>
      $$LocalCollectionsTableTableManager(_db, _db.localCollections);
  $$LocalDebtsTableTableManager get localDebts =>
      $$LocalDebtsTableTableManager(_db, _db.localDebts);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$DeviceMetaTableTableManager get deviceMeta =>
      $$DeviceMetaTableTableManager(_db, _db.deviceMeta);
  $$GoldDraftsTableTableManager get goldDrafts =>
      $$GoldDraftsTableTableManager(_db, _db.goldDrafts);
  $$BranchSnapshotsTableTableManager get branchSnapshots =>
      $$BranchSnapshotsTableTableManager(_db, _db.branchSnapshots);
  $$PendingApprovalDecisionsTableTableManager get pendingApprovalDecisions =>
      $$PendingApprovalDecisionsTableTableManager(
        _db,
        _db.pendingApprovalDecisions,
      );
}
