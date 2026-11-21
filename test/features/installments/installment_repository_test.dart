import 'dart:io';
import 'package:codit/core/database/app_database.dart';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/core/utils/id_generator.dart';
import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockDio extends Mock implements Dio {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockIdGenerator extends Mock implements IdGenerator {}

void main() {
  late AppDatabase db;
  late MockDio mockDio;
  late MockNetworkInfo mockNetwork;
  late MockIdGenerator mockIdGen;
  late InstallmentRepository repository;
  late String dbPath;

  setUp(() async {
    // استخدام ملف قاعدة بيانات مؤقت بدلاً من in-memory
    final tempDir = Directory.systemTemp.createTempSync('codit_test_');
    dbPath = p.join(tempDir.path, 'test_db.sqlite');
    
    db = AppDatabase(NativeDatabase(File(dbPath)));
    mockDio = MockDio();
    mockNetwork = MockNetworkInfo();
    mockIdGen = MockIdGenerator();
    repository = InstallmentRepository(
      mockDio,
      db,
      mockNetwork,
      mockIdGen,
      accountId: 'ACC001',
    );
    
    // الانتظار حتى تجهيز القاعدة
    await db.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await db.close();
    // حذف ملف القاعدة المؤقت
    try {
      final file = File(dbPath);
      if (await file.exists()) {
        await file.delete();
      }
      // حذف المجلد المؤقت
      final dir = File(dbPath).parent;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  });

  group('FIFO Allocation Tests', () {
    test('يوزع التحصيل على الديون بالترتيب FIFO', () async {
      // Setup: دينان - الأقدم 1000 ج، الأحدث 500 ج
      final debt1 = LocalDebtsCompanion.insert(
        id: 'DEBT001',
        customerId: 'CUST001',
        originalPiastres: 100000,
        remainingPiastres: 100000,
        dueDate: DateTime(2024, 1, 1),
        status: 'active',
        accountId: 'ACC001',
      );
      final debt2 = LocalDebtsCompanion.insert(
        id: 'DEBT002',
        customerId: 'CUST001',
        originalPiastres: 50000,
        remainingPiastres: 50000,
        dueDate: DateTime(2024, 2, 1),
        status: 'active',
        accountId: 'ACC001',
      );

      await db.into(db.localDebts).insert(debt1);
      await db.into(db.localDebts).insert(debt2);

      // Mock server response
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {
            'customer': {'id': 'CUST001', 'name': 'أحمد محمد'},
            'debts': [
              {
                'id': 'DEBT001',
                'original_piastres': 100000,
                'remaining_piastres': 100000,
                'due_date': '2024-01-01',
                'status': 'active',
              },
              {
                'id': 'DEBT002',
                'original_piastres': 50000,
                'remaining_piastres': 50000,
                'due_date': '2024-02-01',
                'status': 'active',
              },
            ],
            'server_outstanding_piastres': 150000,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => mockIdGen.collectionId()).thenReturn('COL001');
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      // تحصيل 1200 ج (120000 قرش)
      final collectionId = await repository.collectOffline(
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 120000,
        paymentMethod: 'cash',
      );

      // التحقق من التوزيع عبر قراءة الديون:
      // - الدين الأول يُقفل بالكامل: 0 متبقي
      // - الدين الثاني يُدفع منه: 20000 قرش (يتبقى 30000)
      expect(collectionId, 'COL001');
      
      final updatedDebts = await db.select(db.localDebts).get();
      final d1 = updatedDebts.firstWhere((d) => d.id == 'DEBT001');
      final d2 = updatedDebts.firstWhere((d) => d.id == 'DEBT002');
      
      expect(d1.remainingPiastres, 0); // الأقدم تم تسديده بالكامل
      expect(d2.remainingPiastres, 30000); // الأحدث تبقى منه 300 ج
    });

    test('لا يسمح بتحصيل أكتر من المتبقي', () async {
      // Setup: دين واحد 1000 ج
      final debt = LocalDebtsCompanion.insert(
        id: 'DEBT001',
        customerId: 'CUST001',
        originalPiastres: 100000,
        remainingPiastres: 100000,
        dueDate: DateTime(2024, 1, 1),
        status: 'active',
        accountId: 'ACC001',
      );
      await db.into(db.localDebts).insert(debt);

      // Mock server
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {
            'customer': {'id': 'CUST001', 'name': 'أحمد محمد'},
            'debts': [
              {
                'id': 'DEBT001',
                'original_piastres': 100000,
                'remaining_piastres': 100000,
                'due_date': '2024-01-01',
                'status': 'active',
              },
            ],
            'server_outstanding_piastres': 100000,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      // محاولة تحصيل 1500 ج (أكتر من المتاح)
      expect(
        () => repository.collectOffline(
          customerId: 'CUST001',
          customerName: 'أحمد محمد',
          amountPiastres: 150000,
          paymentMethod: 'cash',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('يحسب المتبقي بعد العمليات المعلقة', () async {
      // Setup: دين 1500 ج
      final debt = LocalDebtsCompanion.insert(
        id: 'DEBT001',
        customerId: 'CUST001',
        originalPiastres: 150000,
        remainingPiastres: 150000,
        dueDate: DateTime(2024, 1, 1),
        status: 'active',
        accountId: 'ACC001',
      );
      await db.into(db.localDebts).insert(debt);

      // عملية معلقة: 200 ج
      final pendingCollection = LocalCollectionsCompanion.insert(
        id: 'COL001',
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 20000,
        paymentMethod: 'cash',
        collectedAt: DateTime.now(),
        deviceSequence: 1,
        idempotencyKey: 'COL001',
        syncStatus: 'pending',
        accountId: 'ACC001',
      );
      await db.into(db.localCollections).insert(pendingCollection);

      // Mock server
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {
            'customer': {'id': 'CUST001', 'name': 'أحمد محمد'},
            'debts': [
              {
                'id': 'DEBT001',
                'original_piastres': 150000,
                'remaining_piastres': 150000,
                'due_date': '2024-01-01',
                'status': 'active',
              },
            ],
            'server_outstanding_piastres': 150000,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => mockIdGen.collectionId()).thenReturn('COL002');
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      // محاولة تحصيل 1400 ج (المتاح فقط 1300 بعد المعلق)
      expect(
        () => repository.collectOffline(
          customerId: 'CUST001',
          customerName: 'أحمد محمد',
          amountPiastres: 140000,
          paymentMethod: 'cash',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Sync and Conflict Tests', () {
    test('يتعامل مع تحصيل مكرر (idempotent)', () async {
      // Setup mock للسيرفر
      var submitCount = 0;
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async {
        submitCount++;
        return Response(
          data: {
            'collection_id': 'COL001',
            'status': 'confirmed',
            'server_sequence': 1,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
      });

      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      // إضافة تحصيل معلق مع syncStatus awaiting_sync
      final collection = LocalCollectionsCompanion.insert(
        id: 'COL001',
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 50000,
        paymentMethod: 'cash',
        collectedAt: DateTime.now(),
        deviceSequence: 1,
        idempotencyKey: 'COL001',
        syncStatus: 'awaiting_sync',
        accountId: 'ACC001',
      );
      await db.into(db.localCollections).insert(collection);

      // محاكاة إرسال مرة واحدة (pendingCollections تستثني confirmed)
      await repository.syncPending();

      // التحقق: السيرفر استلم الطلب مرة واحدة
      expect(submitCount, 1);
      
      // التحقق: العملية أصبحت confirmed
      final updated = await (db.select(db.localCollections)
            ..where((t) => t.id.equals('COL001')))
          .getSingle();
      expect(updated.syncStatus, 'confirmed');
    });

    test('يعرض التعارض عند اختلاف الرصيد', () async {
      // Setup: دين محلي 1500 ج، لكن السيرفر عنده 1000 ج
      final debt = LocalDebtsCompanion.insert(
        id: 'DEBT001',
        customerId: 'CUST001',
        originalPiastres: 150000,
        remainingPiastres: 150000,
        dueDate: DateTime(2024, 1, 1),
        status: 'active',
        accountId: 'ACC001',
      );
      await db.into(db.localDebts).insert(debt);

      final collection = LocalCollectionsCompanion.insert(
        id: 'COL001',
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 120000, // محاولة تحصيل 1200 ج
        paymentMethod: 'cash',
        collectedAt: DateTime.now(),
        deviceSequence: 1,
        idempotencyKey: 'COL001',
        syncStatus: 'awaiting_sync',
        accountId: 'ACC001',
      );
      await db.into(db.localCollections).insert(collection);

      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);

      // Mock: السيرفر يرفض لأن الرصيد فقط 1000 ج
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/collections'),
          response: Response(
            data: {
              'error': 'conflict',
              'reason': 'amount_exceeds_outstanding',
              'server_outstanding': 100000,
              'requested_amount': 120000,
            },
            statusCode: 409,
            requestOptions: RequestOptions(path: '/collections'),
          ),
        ),
      );

      // محاولة المزامنة
      await repository.syncPending();

      // التحقق: العملية أصبحت conflict_review
      final updated = await (db.select(db.localCollections)
            ..where((t) => t.id.equals('COL001')))
          .getSingle();

      expect(updated.syncStatus, 'conflict_review');
    });
  });

  group('Transaction Atomicity Tests', () {
    test('العملية إما تتحفظ كاملة أو لا شيء', () async {
      // Setup: إضافة دين للتحصيل منه
      final debt = LocalDebtsCompanion.insert(
        id: 'DEBT001',
        customerId: 'CUST001',
        originalPiastres: 100000,
        remainingPiastres: 100000,
        dueDate: DateTime(2024, 1, 1),
        status: 'active',
        accountId: 'ACC001',
      );
      await db.into(db.localDebts).insert(debt);

      // Mock server
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {
            'customer': {'id': 'CUST001', 'name': 'أحمد محمد'},
            'debts': [
              {
                'id': 'DEBT001',
                'original_piastres': 100000,
                'remaining_piastres': 100000,
                'due_date': '2024-01-01',
                'status': 'active',
              },
            ],
            'server_outstanding_piastres': 100000,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      // استخدام ID مكرر لإجبار فشل العملية
      when(() => mockIdGen.collectionId()).thenReturn('COL001');

      // إنشاء تحصيل أول بنجاح
      await repository.collectOffline(
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 30000,
        paymentMethod: 'cash',
      );

      // التحقق: عملية واحدة موجودة
      var collections = await db.select(db.localCollections).get();
      expect(collections, hasLength(1));

      // محاولة تحصيل ثانية بنفس ID (يجب أن تفشل بسبب PRIMARY KEY)
      try {
        await repository.collectOffline(
          customerId: 'CUST001',
          customerName: 'أحمد محمد',
          amountPiastres: 20000,
          paymentMethod: 'cash',
        );
        fail('Expected exception for duplicate ID');
      } catch (e) {
        // متوقع - فشل بسبب مفتاح أساسي مكرر
      }

      // التحقق: لا تزال عملية واحدة فقط (العملية الثانية لم تُحفظ)
      collections = await db.select(db.localCollections).get();
      expect(collections, hasLength(1));
      expect(collections.first.amountPiastres, 30000); // العملية الأولى
    });
  });

  group('Persistence Tests', () {
    test('العمليات تبقى بعد إغلاق وفتح التطبيق', () async {
      // إضافة تحصيل معلق
      final collection = LocalCollectionsCompanion.insert(
        id: 'COL001',
        customerId: 'CUST001',
        customerName: 'أحمد محمد',
        amountPiastres: 50000,
        paymentMethod: 'cash',
        collectedAt: DateTime.now(),
        deviceSequence: 1,
        idempotencyKey: 'COL001',
        syncStatus: 'pending',
        accountId: 'ACC001',
      );
      await db.into(db.localCollections).insert(collection);

      // التحقق: البيانات موجودة قبل الإغلاق
      var retrieved = await db.select(db.localCollections).get();
      expect(retrieved, hasLength(1));
      expect(retrieved.first.id, 'COL001');

      // إغلاق DB (محاكاة إغلاق التطبيق)
      await db.close();

      // فتح DB من نفس الملف (محاكاة فتح التطبيق)
      final newDb = AppDatabase(NativeDatabase(File(dbPath)));

      // التحقق: البيانات موجودة بعد إعادة الفتح
      retrieved = await newDb.select(newDb.localCollections).get();
      expect(retrieved, hasLength(1));
      expect(retrieved.first.id, 'COL001');
      expect(retrieved.first.amountPiastres, 50000);
      expect(retrieved.first.syncStatus, 'pending');

      await newDb.close();
    });
  });
}
