import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../../../core/errors/exceptions.dart';

/// Mock Approvals API
/// يحاكي عمليات الموافقات والطلبات والمراجعات
class MockApprovalsApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Requests Database
  final List<Map<String, dynamic>> _requests = [];

  MockApprovalsApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    _requests.addAll([
      {
        'id': 'req_001',
        'type': 'price_override',
        'title': 'تعديل سعر القطعة #RING-001',
        'description': 'طلب خصم 15% على خاتم ذهب عيار 21',
        'metadata': {
          'product_id': 'prod_001',
          'original_price': 25000.0,
          'new_price': 21250.0,
          'discount_percentage': 15.0,
        },
        'requester_id': 'user_003',
        'requester_name': 'فاطمة حسن',
        'status': 'pending',
        'priority': 'high',
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'version': 1,
        'approvers': [
          {
            'user_id': 'user_002',
            'role': 'branch_manager',
            'status': 'pending',
          },
        ],
      },
      {
        'id': 'req_002',
        'type': 'return',
        'title': 'إرجاع قطعة - فاتورة #INV-123',
        'description': 'طلب إرجاع سلسلة ذهب بعد 3 أيام من الشراء',
        'metadata': {
          'invoice_id': 'inv_123',
          'product_id': 'prod_003',
          'amount': 48000.0,
          'reason': 'لا تناسب العميل',
        },
        'requester_id': 'user_003',
        'requester_name': 'فاطمة حسن',
        'status': 'approved',
        'priority': 'medium',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'version': 2,
        'approvers': [
          {
            'user_id': 'user_002',
            'role': 'branch_manager',
            'status': 'approved',
          },
        ],
        'approved_at': DateTime.now()
            .subtract(const Duration(hours: 20))
            .toIso8601String(),
        'approved_by': 'user_002',
      },
      {
        'id': 'req_003',
        'type': 'discount',
        'title': 'خصم على فاتورة #INV-456',
        'description': 'خصم 10% للعميل الدائم',
        'metadata': {
          'invoice_id': 'inv_456',
          'original_total': 100000.0,
          'discount_percentage': 10.0,
          'customer_id': 'cust_001',
        },
        'requester_id': 'user_003',
        'requester_name': 'فاطمة حسن',
        'status': 'rejected',
        'priority': 'low',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        'version': 2,
        'approvers': [
          {'user_id': 'user_001', 'role': 'admin', 'status': 'rejected'},
        ],
        'rejected_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'rejected_by': 'user_001',
        'rejection_reason': 'النسبة المطلوبة تتجاوز الحد المسموح',
      },
    ]);
  }

  /// إنشاء طلب موافقة جديد
  Future<Map<String, dynamic>> createApprovalRequest({
    required String type,
    required String title,
    required String description,
    required Map<String, dynamic> metadata,
    required String requesterId,
    required String requesterName,
    required String priority,
    required List<Map<String, String>> approvers,
  }) async {
    await _client.post(
      '/approvals/requests',
      body: {
        'type': type,
        'title': title,
        'description': description,
        'metadata': metadata,
        'requester_id': requesterId,
        'requester_name': requesterName,
        'priority': priority,
        'approvers': approvers,
      },
      canFail: true,
    );

    final requestId =
        'req_${_random.nextInt(999999).toString().padLeft(6, '0')}';

    final request = {
      'id': requestId,
      'type': type,
      'title': title,
      'description': description,
      'metadata': metadata,
      'requester_id': requesterId,
      'requester_name': requesterName,
      'status': 'pending',
      'priority': priority,
      'created_at': DateTime.now().toIso8601String(),
      'version': 1,
      'approvers': approvers.map((a) => {...a, 'status': 'pending'}).toList(),
    };

    _requests.add(request);

    return {'success': true, 'data': request};
  }

  /// الحصول على طلب معين
  Future<Map<String, dynamic>> getRequest(String requestId) async {
    await _client.get('/approvals/requests/$requestId');

    final request = _requests.where((r) => r['id'] == requestId).firstOrNull;

    if (request == null) {
      return {'success': false, 'error': 'الطلب غير موجود'};
    }

    return {'success': true, 'data': request};
  }

  /// الحصول على الطلبات المعلقة
  Future<Map<String, dynamic>> getPendingRequests({
    String? userId,
    String? type,
  }) async {
    await _client.get(
      '/approvals/requests/pending',
      queryParams: {
        if (userId != null) 'user_id': userId,
        if (type != null) 'type': type,
      },
    );

    var pending = _requests.where((r) => r['status'] == 'pending').toList();

    // تصفية حسب المستخدم (الطلبات التي تحتاج موافقته)
    if (userId != null) {
      pending = pending.where((r) {
        final approvers = r['approvers'] as List;
        return approvers.any(
          (a) => a['user_id'] == userId && a['status'] == 'pending',
        );
      }).toList();
    }

    // تصفية حسب النوع
    if (type != null) {
      pending = pending.where((r) => r['type'] == type).toList();
    }

    // ترتيب حسب الأولوية والتاريخ
    pending.sort((a, b) {
      final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
      final priorityA = priorityOrder[a['priority']] ?? 3;
      final priorityB = priorityOrder[b['priority']] ?? 3;

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      final dateA = DateTime.parse(a['created_at'] as String);
      final dateB = DateTime.parse(b['created_at'] as String);
      return dateB.compareTo(dateA); // الأحدث أولاً
    });

    return {
      'success': true,
      'data': {'requests': pending, 'total_count': pending.length},
    };
  }

  /// الحصول على كل الطلبات (للصفحة الرئيسية)
  Future<List<Map<String, dynamic>>> getApprovals() async {
    await _client.get('/approvals/requests');
    
    // ترتيب حسب التاريخ
    final sorted = List<Map<String, dynamic>>.from(_requests);
    sorted.sort((a, b) {
      final dateA = DateTime.parse(a['created_at'] as String);
      final dateB = DateTime.parse(b['created_at'] as String);
      return dateB.compareTo(dateA);
    });
    
    return sorted;
  }

  /// الموافقة على طلب (مبسطة للصفحة الجديدة)
  Future<void> approveRequest(String requestId) async {
    final request = _requests.firstWhere((r) => r['id'] == requestId);
    request['status'] = 'approved';
    request['approved_at'] = DateTime.now().toIso8601String();
  }

  /// رفض طلب (مبسطة للصفحة الجديدة)
  Future<void> rejectRequest(String requestId, String reason) async {
    final request = _requests.firstWhere((r) => r['id'] == requestId);
    request['status'] = 'rejected';
    request['rejected_at'] = DateTime.now().toIso8601String();
    request['rejection_reason'] = reason;
  }

  /// الموافقة على طلب (النسخة الأصلية)
  Future<Map<String, dynamic>> approveRequestFull({
    required String requestId,
    required String userId,
    String? notes,
  }) async {
    await _client.post(
      '/approvals/requests/$requestId/approve',
      body: {'user_id': userId, 'notes': notes},
      canFail: true,
    );

    final request = _requests.where((r) => r['id'] == requestId).firstOrNull;

    if (request == null) {
      throw MockNetworkException('الطلب غير موجود');
    }

    if (request['status'] != 'pending') {
      throw MockNetworkException('الطلب تمت معالجته بالفعل');
    }

    // تحديث حالة الموافق
    final approvers = request['approvers'] as List;
    final approverIndex = approvers.indexWhere((a) => a['user_id'] == userId);

    if (approverIndex == -1) {
      throw MockNetworkException('ليس لديك صلاحية الموافقة على هذا الطلب');
    }

    approvers[approverIndex]['status'] = 'approved';
    approvers[approverIndex]['approved_at'] = DateTime.now().toIso8601String();
    if (notes != null) {
      approvers[approverIndex]['notes'] = notes;
    }

    // إذا وافق جميع الموافقين، يتم الموافقة على الطلب
    final allApproved = approvers.every((a) => a['status'] == 'approved');
    if (allApproved) {
      request['status'] = 'approved';
      request['approved_at'] = DateTime.now().toIso8601String();
      request['approved_by'] = userId;
    }

    // زيادة رقم النسخة
    request['version'] = (request['version'] as int) + 1;

    return {
      'success': true,
      'data': {'request': request, 'all_approved': allApproved},
    };
  }

  /// رفض طلب (النسخة الكاملة)
  Future<Map<String, dynamic>> rejectRequestFull({
    required String requestId,
    required String userId,
    required String reason,
  }) async {
    await _client.post(
      '/approvals/requests/$requestId/reject',
      body: {'user_id': userId, 'reason': reason},
      canFail: true,
    );

    final request = _requests.where((r) => r['id'] == requestId).firstOrNull;

    if (request == null) {
      throw MockNetworkException('الطلب غير موجود');
    }

    if (request['status'] != 'pending') {
      throw MockNetworkException('الطلب تمت معالجته بالفعل');
    }

    // تحديث حالة الموافق
    final approvers = request['approvers'] as List;
    final approverIndex = approvers.indexWhere((a) => a['user_id'] == userId);

    if (approverIndex == -1) {
      throw MockNetworkException('ليس لديك صلاحية رفض هذا الطلب');
    }

    approvers[approverIndex]['status'] = 'rejected';
    approvers[approverIndex]['rejected_at'] = DateTime.now().toIso8601String();
    approvers[approverIndex]['notes'] = reason;

    // رفض واحد يرفض الطلب كله
    request['status'] = 'rejected';
    request['rejected_at'] = DateTime.now().toIso8601String();
    request['rejected_by'] = userId;
    request['rejection_reason'] = reason;

    // زيادة رقم النسخة
    request['version'] = (request['version'] as int) + 1;

    return {'success': true, 'data': request};
  }

  /// إلغاء طلب
  Future<Map<String, dynamic>> cancelRequest({
    required String requestId,
    required String userId,
    String? reason,
  }) async {
    await _client.post(
      '/approvals/requests/$requestId/cancel',
      body: {'user_id': userId, 'reason': reason},
      canFail: true,
    );

    final request = _requests.where((r) => r['id'] == requestId).firstOrNull;

    if (request == null) {
      throw MockNetworkException('الطلب غير موجود');
    }

    // يمكن للمُنشئ فقط الإلغاء
    if (request['requester_id'] != userId) {
      throw MockNetworkException('فقط منشئ الطلب يمكنه إلغاؤه');
    }

    if (request['status'] != 'pending') {
      throw MockNetworkException('لا يمكن إلغاء طلب تمت معالجته');
    }

    request['status'] = 'cancelled';
    request['cancelled_at'] = DateTime.now().toIso8601String();
    request['cancelled_by'] = userId;
    if (reason != null) {
      request['cancellation_reason'] = reason;
    }

    // زيادة رقم النسخة
    request['version'] = (request['version'] as int) + 1;

    return {'success': true, 'data': request};
  }

  /// الحصول على سجل الموافقات
  Future<Map<String, dynamic>> getApprovalHistory({
    required DateTime from,
    required DateTime to,
    String? status,
  }) async {
    await _client.get(
      '/approvals/history',
      queryParams: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        if (status != null) 'status': status,
      },
    );

    var filtered = _requests.where((r) {
      final createdAt = DateTime.parse(r['created_at'] as String);
      return createdAt.isAfter(from) && createdAt.isBefore(to);
    }).toList();

    if (status != null) {
      filtered = filtered.where((r) => r['status'] == status).toList();
    }

    return {
      'success': true,
      'data': {'requests': filtered, 'total_count': filtered.length},
    };
  }

  /// الحصول على إحصائيات الموافقات
  Future<Map<String, dynamic>> getStatistics() async {
    await _client.get('/approvals/statistics');

    final pending = _requests.where((r) => r['status'] == 'pending').length;
    final approved = _requests.where((r) => r['status'] == 'approved').length;
    final rejected = _requests.where((r) => r['status'] == 'rejected').length;
    final cancelled = _requests.where((r) => r['status'] == 'cancelled').length;

    // متوسط وقت الموافقة
    final approvedRequests = _requests.where((r) => r['status'] == 'approved');
    double avgApprovalTime = 0;

    if (approvedRequests.isNotEmpty) {
      final totalTime = approvedRequests.fold<int>(0, (sum, r) {
        final created = DateTime.parse(r['created_at'] as String);
        final approved = DateTime.parse(r['approved_at'] as String);
        return sum + approved.difference(created).inMinutes;
      });
      avgApprovalTime = totalTime / approvedRequests.length;
    }

    return {
      'success': true,
      'data': {
        'total_requests': _requests.length,
        'pending': pending,
        'approved': approved,
        'rejected': rejected,
        'cancelled': cancelled,
        'avg_approval_time_minutes': avgApprovalTime,
      },
    };
  }

  /// التحقق من وجود تعارض في النسخة (Optimistic Locking)
  bool checkVersionConflict(String requestId, int expectedVersion) {
    final request = _requests.where((r) => r['id'] == requestId).firstOrNull;
    if (request == null) return false;
    return request['version'] != expectedVersion;
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _requests.clear();
    _initializeMockData();
  }
}

/// Extension لدعم firstOrNull
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
