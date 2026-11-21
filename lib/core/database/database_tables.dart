import 'package:drift/drift.dart';

class LocalCollections extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  TextColumn get customerName => text()();
  IntColumn get amountPiastres => integer()();
  TextColumn get paymentMethod => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get collectedAt => dateTime()();
  IntColumn get deviceSequence => integer()();
  TextColumn get idempotencyKey => text()();
  TextColumn get syncStatus => text()();
  TextColumn get accountId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalDebts extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  IntColumn get originalPiastres => integer()();
  IntColumn get remainingPiastres => integer()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text()();
  TextColumn get accountId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()();
  TextColumn get payloadJson => text()();
  IntColumn get deviceSequence => integer()();
  TextColumn get accountId => text()();
}

class DeviceMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class GoldDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get accountId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class BranchSnapshots extends Table {
  TextColumn get scopeKey => text()();
  TextColumn get payloadJson => text()();
  IntColumn get lastSequence => integer()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get accountId => text()();

  @override
  Set<Column> get primaryKey => {scopeKey};
}

class PendingApprovalDecisions extends Table {
  TextColumn get decisionId => text()();
  TextColumn get requestId => text()();
  IntColumn get requestVersion => integer()();
  TextColumn get decisionType => text()();
  TextColumn get status => text()();
  TextColumn get accountId => text()();

  @override
  Set<Column> get primaryKey => {decisionId};
}

class SentApprovalDecisions extends Table {
  TextColumn get idempotencyKey => text()();
  TextColumn get requestId => text()();
  IntColumn get requestVersion => integer()();
  BoolColumn get approved => boolean()();
  TextColumn get rejectionReason => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get accountId => text()();
  
  @override
  Set<Column> get primaryKey => {idempotencyKey};
}