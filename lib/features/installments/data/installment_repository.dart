import 'dart:convert';

import 'package:codit/core/database/app_database.dart';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/core/utils/id_generator.dart';
import 'package:codit/features/installments/domain/fifo_debt_allocator.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;

class InstallmentRepository {
  InstallmentRepository(
    this._dio,
    this._db,
    this._network,
    this._idGenerator, {
    required this.accountId,
  });

  final Dio _dio;
  final AppDatabase _db;
  final NetworkInfo _network;
  final IdGenerator _idGenerator;
  String accountId;

  /// جلب قائمة جميع العملاء مع مديونياتهم
  Future<List<CustomerDebt>> fetchAllCustomers() async {
    // في الواقع يجب أن تأتي من API
    // هنا نستخدم بيانات تجريبية
    final res = await _dio.get<List<dynamic>>('/customers/debts');
    return (res.data ?? [])
        .map((e) => CustomerDebt.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// جلب تفاصيل مديونية عميل محدد
  Future<Map<String, dynamic>> fetchCustomerDebts(String customerId) async {
    final res = await _dio.get<Map<String, dynamic>>('/customers/$customerId/debts');
    final data = res.data!;
    await _seedDebtsIfEmpty(customerId, data);
    return await _withLocalAdjustments(customerId, data);
  }

  Future<void> _seedDebtsIfEmpty(
    String customerId,
    Map<String, dynamic> server,
  ) async {
    final existing = await (_db.select(_db.localDebts)
          ..where((t) => t.customerId.equals(customerId)))
        .get();
    if (existing.isNotEmpty) return;
    final debts = server['debts'] as List<dynamic>;
    await _db.batch((b) {
      for (final d in debts) {
        final m = d as Map<String, dynamic>;
        b.insert(
          _db.localDebts,
          LocalDebtsCompanion.insert(
            id: m['id'] as String,
            customerId: customerId,
            originalPiastres: m['original_piastres'] as int,
            remainingPiastres: m['remaining_piastres'] as int,
            dueDate: DateTime.parse(m['due_date'] as String),
            status: m['status'] as String,
            accountId: accountId,
          ),
        );
      }
    });
  }

  Future<Map<String, dynamic>> _withLocalAdjustments(
    String customerId,
    Map<String, dynamic> server,
  ) async {
    final pending = await (_db.select(_db.localCollections)
          ..where((t) =>
              t.customerId.equals(customerId) &
              t.syncStatus.isNotIn(['confirmed'])))
        .get();
    final pendingSum =
        pending.fold<int>(0, (s, c) => s + c.amountPiastres);
    final serverOutstanding = server['server_outstanding_piastres'] as int;
    return {
      ...server,
      'local_pending_piastres': pendingSum,
      'max_collectible_piastres': serverOutstanding - pendingSum,
    };
  }

  Future<int> _nextDeviceSequence() async {
    const key = 'device_sequence';
    final row = await (_db.select(_db.deviceMeta)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    final current = int.tryParse(row?.value ?? '0') ?? 0;
    return current + 1;
  }

  Future<String> collectOffline({
    required String customerId,
    required String customerName,
    required int amountPiastres,
    required String paymentMethod,
    String? notes,
  }) async {
    if (amountPiastres <= 0) {
      throw ArgumentError('مبلغ غير صالح');
    }
    final debts = await (_db.select(_db.localDebts)
          ..where((t) => t.customerId.equals(customerId)))
        .get();
    final available = await fetchCustomerDebts(customerId);
    final max = available['max_collectible_piastres'] as int;
    if (amountPiastres > max) {
      throw ArgumentError('يتجاوز الحد المسموح للتحصيل');
    }

    final collectionId = _idGenerator.collectionId();
    final idempotencyKey = collectionId;
    final seq = await _nextDeviceSequence();
    final now = DateTime.now().toUtc();

    final ordered = [...debts]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final slices = ordered
        .map(
          (d) => DebtSlice(
            debtId: d.id,
            collectedPiastres: 0,
            remainingPiastres: d.remainingPiastres,
            status: d.status,
          ),
        )
        .toList();
    FifoDebtAllocator().allocate(debts: slices, paymentPiastres: amountPiastres);

    await _db.transaction(() async {
      await _db.into(_db.localCollections).insert(
            LocalCollectionsCompanion.insert(
              id: collectionId,
              customerId: customerId,
              customerName: customerName,
              amountPiastres: amountPiastres,
              paymentMethod: paymentMethod,
              notes: drift.Value(notes),
              collectedAt: now,
              deviceSequence: seq,
              idempotencyKey: idempotencyKey,
              syncStatus: 'saved_local',
              accountId: accountId,
            ),
          );
      for (final s in slices) {
        await (_db.update(_db.localDebts)..where((t) => t.id.equals(s.debtId))).write(
          LocalDebtsCompanion(
            remainingPiastres: drift.Value(s.remainingPiastres),
            status: drift.Value(s.status),
          ),
        );
      }
      await _db.into(_db.syncQueue).insert(
            SyncQueueCompanion.insert(
              operationType: 'collection',
              payloadJson: jsonEncode({
                'collection_id': collectionId,
                'customer_id': customerId,
                'amount_piastres': amountPiastres,
                'idempotency_key': idempotencyKey,
                'payment_method': paymentMethod,
              }),
              deviceSequence: seq,
              accountId: accountId,
            ),
          );
      await _db.into(_db.deviceMeta).insertOnConflictUpdate(
            DeviceMetaCompanion.insert(key: 'device_sequence', value: seq.toString()),
          );
    });

    if (await _network.isConnected) {
      await syncPending();
    }
    return collectionId;
  }

  /// قائمة العمليات المعلقة
  Future<List<Collection>> pendingCollections() async {
    final rows = await (_db.select(_db.localCollections)
          ..where((t) => t.syncStatus.isNotIn(['confirmed']))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.deviceSequence)]))
        .get();
    
    return rows.map((r) => Collection(
      id: r.id,
      customerId: r.customerId,
      customerName: r.customerName,
      amountPiastres: r.amountPiastres,
      paymentMethod: r.paymentMethod,
      notes: r.notes,
      collectedAt: r.collectedAt,
      deviceSequence: r.deviceSequence,
      idempotencyKey: r.idempotencyKey,
      syncStatus: r.syncStatus,
    )).toList();
  }

  Future<void> syncPending() async {
    if (!await _network.isConnected) return;
    final pending = await pendingCollections();
    for (final c in pending) {
      try {
        await (_db.update(_db.localCollections)..where((t) => t.id.equals(c.id))).write(
          const LocalCollectionsCompanion(syncStatus: drift.Value('sending')),
        );
        final res = await _dio.post<Map<String, dynamic>>(
          '/collections',
          data: {
            'collection_id': c.id,
            'customer_id': c.customerId,
            'amount_piastres': c.amountPiastres,
            'idempotency_key': c.idempotencyKey,
            'payment_method': c.paymentMethod,
          },
        );
        if (res.data?['status'] == 'confirmed') {
          await (_db.update(_db.localCollections)..where((t) => t.id.equals(c.id))).write(
            const LocalCollectionsCompanion(syncStatus: drift.Value('confirmed')),
          );
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
          await (_db.update(_db.localCollections)..where((t) => t.id.equals(c.id))).write(
            const LocalCollectionsCompanion(syncStatus: drift.Value('conflict_review')),
          );
        } else if (e.type == DioExceptionType.connectionError) {
          await (_db.update(_db.localCollections)..where((t) => t.id.equals(c.id))).write(
            const LocalCollectionsCompanion(syncStatus: drift.Value('awaiting_sync')),
          );
        } else {
          await (_db.update(_db.localCollections)..where((t) => t.id.equals(c.id))).write(
            const LocalCollectionsCompanion(syncStatus: drift.Value('send_failed')),
          );
        }
      }
    }
  }

  /// حل تعارض مزامنة لعملية محددة
  Future<void> resolveConflict(String collectionId, ConflictResolutionAction action) async {
    switch (action) {
      case ConflictResolutionAction.retry:
        // إعادة المحاولة - نعيد الحالة لـ awaiting_sync
        await (_db.update(_db.localCollections)..where((t) => t.id.equals(collectionId)))
            .write(
          const LocalCollectionsCompanion(syncStatus: drift.Value('awaiting_sync')),
        );
        // محاولة المزامنة فوراً
        await syncPending();
        break;
        
      case ConflictResolutionAction.discardLocal:
        // حذف السجل المحلي
        await (_db.delete(_db.localCollections)..where((t) => t.id.equals(collectionId)))
            .go();
        break;
        
      case ConflictResolutionAction.reviewLater:
        // تجاهل - يبقى في conflict_review
        break;
    }
  }
}

/// إجراءات حل التعارض
enum ConflictResolutionAction {
  retry,        // إعادة محاولة المزامنة
  discardLocal, // حذف السجل المحلي
  reviewLater,  // تجاهل مؤقتاً
}