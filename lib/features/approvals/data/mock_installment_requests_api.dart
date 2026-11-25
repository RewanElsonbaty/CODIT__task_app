import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../domain/installment_request_models.dart';
import '../../installments/data/mock_installments_api.dart';
import '../../notifications/data/mock_notifications_api.dart';

/// Mock API لطلبات التقسيط
/// 
/// يربط بين:
/// 1. المدير → يرسل طلب تقسيط
/// 2. المالك → يوافق/يرفض
/// 3. نظام الأقساط → يُضاف القسط الموافق عليه
class MockInstallmentRequestsApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();
  final MockInstallmentsApi _installmentsApi = MockInstallmentsApi();
  final MockNotificationsApi _notificationsApi = MockNotificationsApi();

  // قاعدة بيانات طلبات التقسيط
  final List<Map<String, dynamic>> _requests = [];
  
  // عداد لرقم الطلب
  int _requestCounter = 1000;

  MockInstallmentRequestsApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    final now = DateTime.now();
    
    _requests.addAll([
      // طلب معلق 1
      {
        'id': 'inst_req_001',
        'request_number': 'IR-2024-001',
        'customer_name': 'أحمد محمود السيد',
        'customer_id': 'CUST-001',
        'customer_phone': '01012345678',
        'national_id': '29501011234567',
        'invoice_id': 'INV-2024-123',
        'total_amount_piastres': 5000000, // 50,000 جنيه
        'down_payment_piastres': 1000000, // 10,000 جنيه
        'installment_amount_piastres': 500000, // 5,000 جنيه
        'number_of_installments': 8,
        'first_payment_date': now.add(const Duration(days: 30)).toIso8601String(),
        'payment_interval': 'monthly',
        'branch_id': 'branch_001',
        'branch_name': 'فرع المعادي',
        'requested_by': 'MGR-001',
        'requested_by_name': 'محمد أحمد - مدير الفرع',
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'status': 'pending',
        'notes': 'عميل دائم، سجل جيد في السداد',
        'version': 1,
      },
      
      // طلب معلق 2
      {
        'id': 'inst_req_002',
        'request_number': 'IR-2024-002',
        'customer_name': 'فاطمة حسن عبد الله',
        'customer_id': 'CUST-002',
        'customer_phone': '01123456789',
        'national_id': '28712051234568',
        'invoice_id': 'INV-2024-145',
        'total_amount_piastres': 8000000, // 80,000 جنيه
        'down_payment_piastres': 2000000, // 20,000 جنيه
        'installment_amount_piastres': 1000000, // 10,000 جنيه
        'number_of_installments': 6,
        'first_payment_date': now.add(const Duration(days: 15)).toIso8601String(),
        'payment_interval': 'monthly',
        'branch_id': 'branch_002',
        'branch_name': 'فرع مدينة نصر',
        'requested_by': 'MGR-002',
        'requested_by_name': 'سارة علي - مديرة الفرع',
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'status': 'pending',
        'notes': 'عميلة جديدة، الفاتورة كبيرة',
        'version': 1,
      },
      
      // طلب موافق عليه
      {
        'id': 'inst_req_003',
        'request_number': 'IR-2024-003',
        'customer_name': 'خالد عبد الرحمن',
        'customer_id': 'CUST-003',
        'customer_phone': '01234567890',
        'national_id': '29003151234569',
        'invoice_id': 'INV-2024-098',
        'total_amount_piastres': 3500000, // 35,000 جنيه
        'down_payment_piastres': 500000, // 5,000 جنيه
        'installment_amount_piastres': 500000, // 5,000 جنيه
        'number_of_installments': 6,
        'first_payment_date': now.add(const Duration(days: 20)).toIso8601String(),
        'payment_interval': 'monthly',
        'branch_id': 'branch_001',
        'branch_name': 'فرع المعادي',
        'requested_by': 'MGR-001',
        'requested_by_name': 'محمد أحمد - مدير الفرع',
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        'status': 'approved',
        'reviewed_by': 'OWNER-001',
        'reviewed_by_name': 'أحمد المالك',
        'reviewed_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'notes': 'عميل موثوق',
        'version': 2,
      },
      
      // طلب مرفوض
      {
        'id': 'inst_req_004',
        'request_number': 'IR-2024-004',
        'customer_name': 'نورا إبراهيم',
        'customer_id': 'CUST-004',
        'customer_phone': '01098765432',
        'national_id': '29112201234570',
        'invoice_id': 'INV-2024-156',
        'total_amount_piastres': 10000000, // 100,000 جنيه
        'down_payment_piastres': 1000000, // 10,000 جنيه
        'installment_amount_piastres': 1500000, // 15,000 جنيه
        'number_of_installments': 6,
        'first_payment_date': now.add(const Duration(days: 10)).toIso8601String(),
        'payment_interval': 'monthly',
        'branch_id': 'branch_003',
        'branch_name': 'فرع الزمالك',
        'requested_by': 'MGR-003',
        'requested_by_name': 'علي حسن - مدير الفرع',
        'created_at': now.subtract(const Duration(days: 3)).toIso8601String(),
        'status': 'rejected',
        'reviewed_by': 'OWNER-001',
        'reviewed_by_name': 'أحمد المالك',
        'reviewed_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        'rejection_reason': 'المبلغ كبير جدًا والعميلة جديدة، الدفعة الأولى غير كافية',
        'notes': 'عميلة جديدة، أول تعامل',
        'version': 2,
      },
      
      // طلب معلق 3 - تقسيط أسبوعي
      {
        'id': 'inst_req_005',
        'request_number': 'IR-2024-005',
        'customer_name': 'ياسمين محمد',
        'customer_id': 'CUST-005',
        'customer_phone': '01156789012',
        'national_id': '29206281234571',
        'invoice_id': 'INV-2024-167',
        'total_amount_piastres': 2000000, // 20,000 جنيه
        'down_payment_piastres': 500000, // 5,000 جنيه
        'installment_amount_piastres': 250000, // 2,500 جنيه
        'number_of_installments': 6,
        'first_payment_date': now.add(const Duration(days: 7)).toIso8601String(),
        'payment_interval': 'weekly',
        'branch_id': 'branch_002',
        'branch_name': 'فرع مدينة نصر',
        'requested_by': 'MGR-002',
        'requested_by_name': 'سارة علي - مديرة الفرع',
        'created_at': now.subtract(const Duration(minutes: 30)).toIso8601String(),
        'status': 'pending',
        'notes': 'تقسيط أسبوعي - عميلة موظفة',
        'version': 1,
      },
    ]);
    
    _requestCounter = 1005; // آخر رقم مستخدم + 1
  }

  /// إنشاء طلب تقسيط جديد (من المدير)
  Future<InstallmentRequest> createInstallmentRequest(
    CreateInstallmentRequest request,
  ) async {
    await _client.post(
      '/installment-requests',
      body: request.toJson(),
      canFail: true,
    );

    final requestId = 'inst_req_${_random.nextInt(999999).toString().padLeft(6, '0')}';
    final requestNumber = 'IR-2024-${_requestCounter.toString().padLeft(3, '0')}';
    _requestCounter++;

    final newRequest = {
      'id': requestId,
      'request_number': requestNumber,
      'customer_name': request.customerName,
      'customer_id': request.customerId,
      'customer_phone': request.customerPhone,
      'national_id': request.nationalId,
      'invoice_id': request.invoiceId,
      'total_amount_piastres': request.totalAmountPiastres,
      'down_payment_piastres': request.downPaymentPiastres,
      'installment_amount_piastres': request.installmentAmountPiastres,
      'number_of_installments': request.numberOfInstallments,
      'first_payment_date': request.firstPaymentDate.toIso8601String(),
      'payment_interval': request.paymentInterval,
      'branch_id': request.branchId,
      'branch_name': request.branchName,
      'requested_by': request.requestedBy,
      'requested_by_name': request.requestedByName,
      'created_at': DateTime.now().toIso8601String(),
      'status': 'pending',
      'notes': request.notes,
      'version': 1,
    };

    _requests.add(newRequest);

    // ✨ إرسال إشعار للمالك بطلب جديد
    try {
      await _notificationsApi.notifyInstallmentRequestCreated(
        ownerId: 'OWNER-001', // TODO: Get from system
        requestNumber: requestNumber,
        customerName: request.customerName,
        amount: request.totalAmountPiastres / 100,
        branchName: request.branchName,
        requestId: requestId,
      );
    } catch (e) {
      print('تحذير: فشل إرسال الإشعار: $e');
    }

    return InstallmentRequest.fromJson(newRequest);
  }

  /// الحصول على جميع طلبات التقسيط
  Future<List<InstallmentRequest>> getAllRequests({
    InstallmentRequestStatus? status,
    String? branchId,
  }) async {
    await _client.get('/installment-requests');

    var filtered = _requests;

    if (status != null) {
      filtered = filtered.where((r) => r['status'] == status.name).toList();
    }

    if (branchId != null) {
      filtered = filtered.where((r) => r['branch_id'] == branchId).toList();
    }

    // ترتيب: المعلقة أولاً، ثم حسب التاريخ
    filtered.sort((a, b) {
      if (a['status'] == 'pending' && b['status'] != 'pending') return -1;
      if (a['status'] != 'pending' && b['status'] == 'pending') return 1;

      final dateA = DateTime.parse(a['created_at'] as String);
      final dateB = DateTime.parse(b['created_at'] as String);
      return dateB.compareTo(dateA);
    });

    return filtered.map((r) => InstallmentRequest.fromJson(r)).toList();
  }

  /// الحصول على الطلبات المعلقة فقط (للمالك)
  Future<List<InstallmentRequest>> getPendingRequests() async {
    await _client.get('/installment-requests/pending');

    final pending = _requests.where((r) => r['status'] == 'pending').toList();

    // ترتيب حسب التاريخ (الأحدث أولاً)
    pending.sort((a, b) {
      final dateA = DateTime.parse(a['created_at'] as String);
      final dateB = DateTime.parse(b['created_at'] as String);
      return dateB.compareTo(dateA);
    });

    return pending.map((r) => InstallmentRequest.fromJson(r)).toList();
  }

  /// الحصول على تفاصيل طلب معين
  Future<InstallmentRequest> getRequestDetails(String requestId) async {
    await _client.get('/installment-requests/$requestId');

    final request = _requests.firstWhere(
      (r) => r['id'] == requestId,
      orElse: () => throw Exception('الطلب غير موجود'),
    );

    return InstallmentRequest.fromJson(request);
  }

  /// الموافقة على طلب تقسيط (من المالك فقط)
  Future<InstallmentRequest> approveRequest(
    InstallmentRequestDecision decision,
  ) async {
    await _client.post(
      '/installment-requests/${decision.requestId}/approve',
      body: decision.toJson(),
      canFail: true,
    );

    final request = _requests.firstWhere(
      (r) => r['id'] == decision.requestId,
      orElse: () => throw Exception('الطلب غير موجود'),
    );

    if (request['status'] != 'pending') {
      throw Exception('الطلب تمت معالجته بالفعل');
    }

    // تحديث الطلب
    request['status'] = 'approved';
    request['reviewed_by'] = decision.reviewedBy;
    request['reviewed_by_name'] = decision.reviewedByName;
    request['reviewed_at'] = decision.reviewedAt.toIso8601String();
    request['version'] = (request['version'] as int) + 1;

    // ✨ إضافة القسط لنظام الأقساط
    try {
      await _installmentsApi.createContractFromInstallmentRequest(
        requestId: request['id'] as String,
        requestNumber: request['request_number'] as String,
        customerId: request['customer_id'] as String,
        customerName: request['customer_name'] as String,
        customerPhone: request['customer_phone'] as String,
        nationalId: request['national_id'] as String,
        invoiceId: request['invoice_id'] as String,
        totalAmount: (request['total_amount_piastres'] as int) / 100,
        downPayment: (request['down_payment_piastres'] as int) / 100,
        installmentAmount: (request['installment_amount_piastres'] as int) / 100,
        numberOfInstallments: request['number_of_installments'] as int,
        firstPaymentDate: DateTime.parse(request['first_payment_date'] as String),
        paymentInterval: request['payment_interval'] as String,
        branchId: request['branch_id'] as String,
        branchName: request['branch_name'] as String,
      );
    } catch (e) {
      // في حالة فشل إضافة القسط، نسجل الخطأ لكن لا نلغي الموافقة
      print('تحذير: فشل إضافة القسط لنظام الأقساط: $e');
    }

    // ✨ إرسال إشعار للمدير بالموافقة
    try {
      await _notificationsApi.notifyInstallmentRequestApproved(
        managerId: request['requested_by'] as String,
        requestNumber: request['request_number'] as String,
        customerName: request['customer_name'] as String,
        requestId: request['id'] as String,
      );
    } catch (e) {
      print('تحذير: فشل إرسال إشعار الموافقة: $e');
    }

    return InstallmentRequest.fromJson(request);
  }

  /// رفض طلب تقسيط (من المالك فقط)
  Future<InstallmentRequest> rejectRequest(
    InstallmentRequestDecision decision,
  ) async {
    await _client.post(
      '/installment-requests/${decision.requestId}/reject',
      body: decision.toJson(),
      canFail: true,
    );

    final request = _requests.firstWhere(
      (r) => r['id'] == decision.requestId,
      orElse: () => throw Exception('الطلب غير موجود'),
    );

    if (request['status'] != 'pending') {
      throw Exception('الطلب تمت معالجته بالفعل');
    }

    if (!decision.approved && decision.rejectionReason == null) {
      throw Exception('يجب تحديد سبب الرفض');
    }

    // تحديث الطلب
    request['status'] = 'rejected';
    request['reviewed_by'] = decision.reviewedBy;
    request['reviewed_by_name'] = decision.reviewedByName;
    request['reviewed_at'] = decision.reviewedAt.toIso8601String();
    request['rejection_reason'] = decision.rejectionReason;
    request['version'] = (request['version'] as int) + 1;

    // ✨ إرسال إشعار للمدير بالرفض
    try {
      await _notificationsApi.notifyInstallmentRequestRejected(
        managerId: request['requested_by'] as String,
        requestNumber: request['request_number'] as String,
        customerName: request['customer_name'] as String,
        rejectionReason: decision.rejectionReason ?? 'لم يتم تحديد السبب',
        requestId: request['id'] as String,
      );
    } catch (e) {
      print('تحذير: فشل إرسال إشعار الرفض: $e');
    }

    return InstallmentRequest.fromJson(request);
  }

  /// إلغاء طلب (من المدير صاحب الطلب فقط)
  Future<InstallmentRequest> cancelRequest(
    String requestId,
    String cancelledBy,
  ) async {
    await _client.post(
      '/installment-requests/$requestId/cancel',
      body: {'cancelled_by': cancelledBy},
      canFail: true,
    );

    final request = _requests.firstWhere(
      (r) => r['id'] == requestId,
      orElse: () => throw Exception('الطلب غير موجود'),
    );

    if (request['status'] != 'pending') {
      throw Exception('لا يمكن إلغاء طلب تمت معالجته');
    }

    if (request['requested_by'] != cancelledBy) {
      throw Exception('فقط صاحب الطلب يمكنه إلغاؤه');
    }

    request['status'] = 'cancelled';
    request['cancelled_at'] = DateTime.now().toIso8601String();
    request['version'] = (request['version'] as int) + 1;

    return InstallmentRequest.fromJson(request);
  }

  /// الحصول على ملخص الطلبات
  Future<List<InstallmentRequestSummary>> getRequestsSummary({
    String? branchId,
  }) async {
    await _client.get('/installment-requests/summary');

    var filtered = _requests;

    if (branchId != null) {
      filtered = filtered.where((r) => r['branch_id'] == branchId).toList();
    }

    return filtered.map((r) => InstallmentRequestSummary.fromJson(r)).toList();
  }

  /// الحصول على إحصائيات طلبات التقسيط
  Future<Map<String, dynamic>> getStatistics({String? branchId}) async {
    await _client.get('/installment-requests/statistics');

    var filtered = _requests;
    if (branchId != null) {
      filtered = filtered.where((r) => r['branch_id'] == branchId).toList();
    }

    final total = filtered.length;
    final pending = filtered.where((r) => r['status'] == 'pending').length;
    final approved = filtered.where((r) => r['status'] == 'approved').length;
    final rejected = filtered.where((r) => r['status'] == 'rejected').length;
    final cancelled = filtered.where((r) => r['status'] == 'cancelled').length;

    // إجمالي المبالغ
    final totalAmount = filtered.fold<int>(
      0,
      (sum, r) => sum + (r['total_amount_piastres'] as int),
    );

    final approvedAmount = filtered
        .where((r) => r['status'] == 'approved')
        .fold<int>(
          0,
          (sum, r) => sum + (r['total_amount_piastres'] as int),
        );

    // متوسط وقت الموافقة
    final approvedRequests = filtered.where((r) => r['status'] == 'approved');
    double avgApprovalTimeHours = 0;

    if (approvedRequests.isNotEmpty) {
      final totalTime = approvedRequests.fold<int>(0, (sum, r) {
        final created = DateTime.parse(r['created_at'] as String);
        final reviewed = DateTime.parse(r['reviewed_at'] as String);
        return sum + reviewed.difference(created).inHours;
      });
      avgApprovalTimeHours = totalTime / approvedRequests.length;
    }

    return {
      'total': total,
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
      'cancelled': cancelled,
      'total_amount': totalAmount / 100,
      'approved_amount': approvedAmount / 100,
      'avg_approval_time_hours': avgApprovalTimeHours,
      'approval_rate': total > 0 ? (approved / total * 100) : 0,
    };
  }

  /// البحث في الطلبات
  Future<List<InstallmentRequest>> searchRequests(String query) async {
    await _client.get('/installment-requests/search?q=$query');

    final queryLower = query.toLowerCase();

    final results = _requests.where((r) {
      return (r['customer_name'] as String).toLowerCase().contains(queryLower) ||
          (r['customer_phone'] as String).contains(query) ||
          (r['national_id'] as String).contains(query) ||
          (r['invoice_id'] as String).toLowerCase().contains(queryLower) ||
          (r['request_number'] as String).toLowerCase().contains(queryLower);
    }).toList();

    return results.map((r) => InstallmentRequest.fromJson(r)).toList();
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _requests.clear();
    _requestCounter = 1000;
    _initializeMockData();
  }

  /// الحصول على عدد الطلبات المعلقة (للإشعارات)
  int getPendingCount() {
    return _requests.where((r) => r['status'] == 'pending').length;
  }
}

