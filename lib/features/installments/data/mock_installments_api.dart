import 'dart:math';
import '../../../core/data/mock_api_client.dart';

/// Mock Installments API
/// يحاكي عمليات الأقساط والعملاء والدفعات
class MockInstallmentsApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Contracts Database
  final List<Map<String, dynamic>> _contracts = [];

  // Mock Payments Database
  final List<Map<String, dynamic>> _payments = [];

  // Mock Customers Database
  final List<Map<String, dynamic>> _customers = [];

  MockInstallmentsApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    // عملاء تجريبيون
    _customers.addAll([
      {
        'id': 'cust_001',
        'name': 'أحمد محمود',
        'phone': '01012345678',
        'national_id': '29012011234567',
        'address': 'القاهرة - مصر الجديدة',
        'credit_score': 850,
        'total_debt': 50000.0,
        'overdue_debt': 0.0,
        'contracts_count': 2,
      },
      {
        'id': 'cust_002',
        'name': 'فاطمة أحمد',
        'phone': '01098765432',
        'national_id': '29502011234567',
        'address': 'الجيزة - المهندسين',
        'credit_score': 920,
        'total_debt': 75000.0,
        'overdue_debt': 5000.0,
        'contracts_count': 3,
      },
    ]);

    // عقود تجريبية
    _contracts.addAll([
      {
        'id': 'cont_001',
        'customer_id': 'cust_001',
        'invoice_id': 'inv_001',
        'total_amount': 100000.0,
        'down_payment': 50000.0,
        'remaining_amount': 50000.0,
        'monthly_installment': 5000.0,
        'installments_count': 10,
        'paid_installments': 0,
        'start_date': DateTime.now().toIso8601String(),
        'status': 'active',
        'interest_rate': 0.0,
        'late_fee_percentage': 5.0,
      },
      {
        'id': 'cont_002',
        'customer_id': 'cust_002',
        'invoice_id': 'inv_002',
        'total_amount': 150000.0,
        'down_payment': 75000.0,
        'remaining_amount': 75000.0,
        'monthly_installment': 7500.0,
        'installments_count': 10,
        'paid_installments': 8,
        'start_date': DateTime.now()
            .subtract(const Duration(days: 240))
            .toIso8601String(),
        'status': 'active',
        'interest_rate': 0.0,
        'late_fee_percentage': 5.0,
      },
    ]);
  }

  /// إنشاء عقد أقساط جديد
  Future<Map<String, dynamic>> createContract({
    required String customerId,
    required String invoiceId,
    required double totalAmount,
    required double downPayment,
    required int installmentsCount,
    required double interestRate,
    required double lateFeePercentage,
  }) async {
    await _client.post(
      '/installments/contracts',
      body: {
        'customer_id': customerId,
        'invoice_id': invoiceId,
        'total_amount': totalAmount,
        'down_payment': downPayment,
        'installments_count': installmentsCount,
        'interest_rate': interestRate,
        'late_fee_percentage': lateFeePercentage,
      },
      canFail: true,
    );

    final remainingAmount = totalAmount - downPayment;
    final monthlyInstallment = remainingAmount / installmentsCount;

    final contractId =
        'cont_${_random.nextInt(999999).toString().padLeft(6, '0')}';

    final contract = {
      'id': contractId,
      'customer_id': customerId,
      'invoice_id': invoiceId,
      'total_amount': totalAmount,
      'down_payment': downPayment,
      'remaining_amount': remainingAmount,
      'monthly_installment': monthlyInstallment,
      'installments_count': installmentsCount,
      'paid_installments': 0,
      'start_date': DateTime.now().toIso8601String(),
      'status': 'active',
      'interest_rate': interestRate,
      'late_fee_percentage': lateFeePercentage,
      'created_at': DateTime.now().toIso8601String(),
    };

    _contracts.add(contract);

    return {'success': true, 'data': contract};
  }

  /// الحصول على عقد معين
  Future<Map<String, dynamic>> getContract(String contractId) async {
    await _client.get('/installments/contracts/$contractId');

    final contract = _contracts.where((c) => c['id'] == contractId).firstOrNull;

    if (contract == null) {
      return {'success': false, 'error': 'العقد غير موجود'};
    }

    return {'success': true, 'data': contract};
  }

  /// الحصول على عقود عميل معين
  Future<Map<String, dynamic>> getCustomerContracts(String customerId) async {
    await _client.get('/installments/customers/$customerId/contracts');

    final contracts = _contracts
        .where((c) => c['customer_id'] == customerId)
        .toList();

    return {
      'success': true,
      'data': {'contracts': contracts, 'total_count': contracts.length},
    };
  }

  /// تسجيل دفعة
  Future<Map<String, dynamic>> recordPayment({
    required String contractId,
    required double amount,
    required String method,
    String? notes,
  }) async {
    await _client.post(
      '/installments/payments',
      body: {
        'contract_id': contractId,
        'amount': amount,
        'method': method,
        'notes': notes,
      },
      canFail: true,
    );

    final contract = _contracts.where((c) => c['id'] == contractId).firstOrNull;

    if (contract == null) {
      throw MockNetworkException('العقد غير موجود');
    }

    // إنشاء الدفعة
    final paymentId =
        'pay_${_random.nextInt(999999).toString().padLeft(6, '0')}';
    final payment = {
      'id': paymentId,
      'contract_id': contractId,
      'amount': amount,
      'method': method,
      'notes': notes,
      'paid_at': DateTime.now().toIso8601String(),
      'status': 'completed',
    };

    _payments.add(payment);

    // تحديث العقد
    final remainingAmount = (contract['remaining_amount'] as double) - amount;
    final paidInstallments = contract['paid_installments'] as int;

    contract['remaining_amount'] = remainingAmount;
    contract['paid_installments'] = paidInstallments + 1;

    if (remainingAmount <= 0) {
      contract['status'] = 'completed';
    }

    return {
      'success': true,
      'data': {
        'payment': payment,
        'remaining_amount': remainingAmount,
        'paid_installments': paidInstallments + 1,
      },
    };
  }

  /// الحصول على دفعات عقد معين
  Future<Map<String, dynamic>> getContractPayments(String contractId) async {
    await _client.get('/installments/contracts/$contractId/payments');

    final payments = _payments
        .where((p) => p['contract_id'] == contractId)
        .toList();

    final totalPaid = payments.fold<double>(
      0.0,
      (sum, payment) => sum + (payment['amount'] as double),
    );

    return {
      'success': true,
      'data': {
        'payments': payments,
        'total_count': payments.length,
        'total_paid': totalPaid,
      },
    };
  }

  /// الحصول على الأقساط المتأخرة
  Future<Map<String, dynamic>> getOverdueContracts() async {
    await _client.get('/installments/overdue');

    final now = DateTime.now();
    final overdueContracts = _contracts.where((contract) {
      if (contract['status'] != 'active') return false;

      final startDate = DateTime.parse(contract['start_date'] as String);
      final paidInstallments = contract['paid_installments'] as int;
      final monthsSinceStart = now.difference(startDate).inDays ~/ 30;

      // إذا كان عدد الأقساط المدفوعة أقل من الأشهر الفعلية = متأخر
      return paidInstallments < monthsSinceStart;
    }).toList();

    return {
      'success': true,
      'data': {
        'contracts': overdueContracts,
        'total_count': overdueContracts.length,
      },
    };
  }

  /// البحث عن عميل
  Future<Map<String, dynamic>> searchCustomer({
    String? name,
    String? phone,
    String? nationalId,
  }) async {
    await _client.get(
      '/customers/search',
      queryParams: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (nationalId != null) 'national_id': nationalId,
      },
    );

    var results = _customers;

    if (name != null) {
      results = results
          .where((c) => (c['name'] as String).contains(name))
          .toList();
    }

    if (phone != null) {
      results = results.where((c) => c['phone'] == phone).toList();
    }

    if (nationalId != null) {
      results = results.where((c) => c['national_id'] == nationalId).toList();
    }

    return {
      'success': true,
      'data': {'customers': results, 'total_count': results.length},
    };
  }

  /// إنشاء عميل جديد
  Future<Map<String, dynamic>> createCustomer({
    required String name,
    required String phone,
    required String nationalId,
    required String address,
  }) async {
    await _client.post(
      '/customers',
      body: {
        'name': name,
        'phone': phone,
        'national_id': nationalId,
        'address': address,
      },
      canFail: true,
    );

    // التحقق من عدم تكرار الرقم القومي
    final exists = _customers.any((c) => c['national_id'] == nationalId);

    if (exists) {
      throw MockNetworkException('الرقم القومي مسجل مسبقاً');
    }

    final customerId =
        'cust_${_random.nextInt(999999).toString().padLeft(6, '0')}';

    final customer = {
      'id': customerId,
      'name': name,
      'phone': phone,
      'national_id': nationalId,
      'address': address,
      'credit_score': 750,
      'total_debt': 0.0,
      'overdue_debt': 0.0,
      'contracts_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    };

    _customers.add(customer);

    return {'success': true, 'data': customer};
  }

  /// الحصول على إحصائيات الأقساط
  Future<Map<String, dynamic>> getStatistics() async {
    await _client.get('/installments/statistics');

    final activeContracts = _contracts
        .where((c) => c['status'] == 'active')
        .toList();

    final totalDebt = activeContracts.fold<double>(
      0.0,
      (sum, c) => sum + (c['remaining_amount'] as double),
    );

    final totalCollected = _payments.fold<double>(
      0.0,
      (sum, p) => sum + (p['amount'] as double),
    );

    return {
      'success': true,
      'data': {
        'total_contracts': _contracts.length,
        'active_contracts': activeContracts.length,
        'total_debt': totalDebt,
        'total_collected': totalCollected,
        'total_customers': _customers.length,
      },
    };
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _contracts.clear();
    _payments.clear();
    _customers.clear();
    _initializeMockData();
  }
}

/// Extension لدعم firstOrNull
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
