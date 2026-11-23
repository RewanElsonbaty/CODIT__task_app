import 'package:flutter_test/flutter_test.dart';
import 'package:codit/features/approvals/data/mock_approvals_api.dart';
import 'package:codit/core/data/mock_api_client.dart';

/// Critical Tests للـ Approvals
/// تشمل: Conflict Resolution, Version Tracking, Concurrent Updates
void main() {
  late MockApprovalsApi api;

  setUp(() {
    api = MockApprovalsApi();
  });

  group('Approvals Critical Tests', () {
    test('إنشاء طلب موافقة جديد', () async {
      final result = await api.createApprovalRequest(
        type: 'discount',
        title: 'خصم 5% على فاتورة',
        description: 'طلب خصم للعميل الدائم',
        metadata: {
          'invoice_id': 'inv_789',
          'discount_percentage': 5.0,
        },
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'medium',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
        ],
      );

      expect(result['success'], true);
      expect(result['data']['status'], 'pending');
      expect(result['data']['version'], 1);
    });

    test('Version Tracking: الموافقة تزيد رقم النسخة', () async {
      // 1. إنشاء طلب
      final createResult = await api.createApprovalRequest(
        type: 'price_override',
        title: 'تعديل سعر',
        description: 'خصم 10%',
        metadata: {'product_id': 'prod_001'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'high',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
        ],
      );

      final requestId = createResult['data']['id'] as String;
      final initialVersion = createResult['data']['version'] as int;
      expect(initialVersion, 1);

      // 2. الموافقة على الطلب
      final approveResult = await api.approveRequestFull(
        requestId: requestId,
        userId: 'user_002',
        notes: 'موافق',
      );

      final newVersion = approveResult['data']['request']['version'] as int;
      expect(newVersion, 2);
      expect(newVersion, initialVersion + 1);
    });

    test('Conflict Resolution: رفض محاولة تعديل نسخة قديمة', () async {
      // 1. إنشاء طلب
      final createResult = await api.createApprovalRequest(
        type: 'return',
        title: 'إرجاع منتج',
        description: 'إرجاع بعد 5 أيام',
        metadata: {'invoice_id': 'inv_999'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'medium',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
        ],
      );

      final requestId = createResult['data']['id'] as String;

      // 2. الموافقة الأولى (تزيد النسخة من 1 إلى 2)
      await api.approveRequestFull(
        requestId: requestId,
        userId: 'user_002',
      );

      // 3. محاولة تعديل بناءً على النسخة القديمة (1)
      final hasConflict = api.checkVersionConflict(requestId, 1);
      expect(hasConflict, true);

      // 4. التحقق من النسخة الحالية
      final getResult = await api.getRequest(requestId);
      expect(getResult['data']['version'], 2);
    });

    test('Optimistic Locking: تحديثات متزامنة', () async {
      // Scenario: مستخدمان يحاولان تعديل نفس الطلب في نفس الوقت
      
      // 1. إنشاء طلب يحتاج موافقة اثنين
      final createResult = await api.createApprovalRequest(
        type: 'discount',
        title: 'خصم كبير',
        description: 'خصم 20%',
        metadata: {'invoice_id': 'inv_777'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'high',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
          {'user_id': 'user_001', 'role': 'admin'},
        ],
      );

      final requestId = createResult['data']['id'] as String;

      // 2. المستخدم الأول يقرأ الطلب (version = 1)
      final read1 = await api.getRequest(requestId);
      final version1 = read1['data']['version'] as int;
      expect(version1, 1);

      // 3. المستخدم الثاني يقرأ الطلب (version = 1)
      final read2 = await api.getRequest(requestId);
      final version2 = read2['data']['version'] as int;
      expect(version2, 1);

      // 4. المستخدم الأول يوافق (version يصبح 2)
      await api.approveRequestFull(
        requestId: requestId,
        userId: 'user_002',
      );

      // 5. المستخدم الثاني يحاول الموافقة بناءً على version = 1
      // يجب اكتشاف التعارض
      final hasConflict = api.checkVersionConflict(requestId, version2);
      expect(hasConflict, true);

      // 6. المستخدم الثاني يعيد قراءة الطلب ويحاول مرة أخرى
      final reRead = await api.getRequest(requestId);
      final currentVersion = reRead['data']['version'] as int;
      expect(currentVersion, 2);

      final noConflict = api.checkVersionConflict(requestId, currentVersion);
      expect(noConflict, false);
    });

    test('Multi-Approver: موافقة جميع الموافقين تُكمل الطلب', () async {
      // 1. طلب يحتاج موافقة اثنين
      final createResult = await api.createApprovalRequest(
        type: 'price_override',
        title: 'تعديل سعر كبير',
        description: 'خصم 25%',
        metadata: {'product_id': 'prod_002'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'high',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
          {'user_id': 'user_001', 'role': 'admin'},
        ],
      );

      final requestId = createResult['data']['id'] as String;

      // 2. الموافقة الأولى - الحالة تبقى pending
      final approve1 = await api.approveRequestFull(
        requestId: requestId,
        userId: 'user_002',
      );

      expect(approve1['data']['request']['status'], 'pending');
      expect(approve1['data']['all_approved'], false);

      // 3. الموافقة الثانية - الحالة تصبح approved
      final approve2 = await api.approveRequestFull(
        requestId: requestId,
        userId: 'user_001',
      );

      expect(approve2['data']['request']['status'], 'approved');
      expect(approve2['data']['all_approved'], true);
    });

    test('Single Rejection: رفض واحد يرفض الطلب كله', () async {
      // 1. طلب يحتاج موافقة اثنين
      final createResult = await api.createApprovalRequest(
        type: 'return',
        title: 'إرجاع بعد أسبوع',
        description: 'إرجاع متأخر',
        metadata: {'invoice_id': 'inv_555'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'low',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
          {'user_id': 'user_001', 'role': 'admin'},
        ],
      );

      final requestId = createResult['data']['id'] as String;

      // 2. الرفض من المستخدم الأول
      final rejectResult = await api.rejectRequestFull(
        requestId: requestId,
        userId: 'user_002',
        reason: 'تجاوز المدة المسموحة',
      );

      // 3. الطلب يصبح مرفوض فوراً
      expect(rejectResult['data']['status'], 'rejected');
      expect(rejectResult['data']['rejection_reason'], 'تجاوز المدة المسموحة');

      // 4. المستخدم الثاني لا يستطيع الموافقة بعد الرفض
      expect(
        () => api.approveRequestFull(
          requestId: requestId,
          userId: 'user_001',
        ),
        throwsA(isA<MockNetworkException>()),
      );
    });

    test('Cancellation: المُنشئ فقط يستطيع الإلغاء', () async {
      // 1. إنشاء طلب
      final createResult = await api.createApprovalRequest(
        type: 'discount',
        title: 'خصم',
        description: 'خصم 5%',
        metadata: {'invoice_id': 'inv_888'},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'medium',
        approvers: [
          {'user_id': 'user_002', 'role': 'branch_manager'},
        ],
      );

      final requestId = createResult['data']['id'] as String;

      // 2. مستخدم آخر يحاول الإلغاء - يفشل
      expect(
        () => api.cancelRequest(
          requestId: requestId,
          userId: 'user_002',
          reason: 'لم يعد مطلوباً',
        ),
        throwsA(isA<MockNetworkException>()),
      );

      // 3. المُنشئ يلغي الطلب - ينجح
      final cancelResult = await api.cancelRequest(
        requestId: requestId,
        userId: 'user_003',
        reason: 'لم يعد مطلوباً',
      );

      expect(cancelResult['data']['status'], 'cancelled');
    });

    test('Priority Sorting: ترتيب الطلبات حسب الأولوية', () async {
      // 1. إنشاء طلبات بأولويات مختلفة
      await api.createApprovalRequest(
        type: 'discount',
        title: 'Low Priority',
        description: 'Test',
        metadata: {},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'low',
        approvers: [{'user_id': 'user_002', 'role': 'branch_manager'}],
      );

      await api.createApprovalRequest(
        type: 'discount',
        title: 'High Priority',
        description: 'Test',
        metadata: {},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'high',
        approvers: [{'user_id': 'user_002', 'role': 'branch_manager'}],
      );

      await api.createApprovalRequest(
        type: 'discount',
        title: 'Medium Priority',
        description: 'Test',
        metadata: {},
        requesterId: 'user_003',
        requesterName: 'فاطمة حسن',
        priority: 'medium',
        approvers: [{'user_id': 'user_002', 'role': 'branch_manager'}],
      );

      // 2. الحصول على الطلبات المعلقة
      final pendingResult = await api.getPendingRequests(userId: 'user_002');
      final requests = pendingResult['data']['requests'] as List;

      // 3. التحقق من الترتيب: high -> medium -> low
      expect(requests.length, greaterThanOrEqualTo(3));
      
      // البحث عن الطلبات التي أنشأناها
      final testRequests = requests
          .where((r) => r['title'].toString().contains('Priority'))
          .toList();
      
      expect(testRequests[0]['priority'], 'high');
      expect(testRequests[1]['priority'], 'medium');
      expect(testRequests[2]['priority'], 'low');
    });

    test('Statistics: إحصائيات دقيقة', () async {
      final stats = await api.getStatistics();

      expect(stats['success'], true);
      expect(stats['data']['total_requests'], greaterThan(0));
      expect(stats['data']['pending'], greaterThan(0));
      expect(stats['data']['approved'], greaterThan(0));
      expect(stats['data']['rejected'], greaterThan(0));
      expect(stats['data']['avg_approval_time_minutes'], greaterThanOrEqualTo(0));
    });
  });
}
