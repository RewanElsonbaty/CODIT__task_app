import 'package:codit/mocks/mock_scenario_controller.dart';

class MockDataFactory {
  Map<String, dynamic> session(String accountId) => {
        'account_id': accountId,
        'shop_name': accountId == 'shop-a' ? 'متجر أ' : 'متجر ب',
        'user_name': 'المالك',
      };

  List<Map<String, dynamic>> approvalList() => [
        {
          'id': 'APR-1001',
          'request_number': 'REQ-1001',
          'employee_name': 'أحمد محمد',
          'branch_name': 'فرع المعادي',
          'amount_piastres': 2500000,
          'reason': 'صرف لمورد - طلب عاجل',
          'created_at': DateTime.utc(2026, 1, 10, 14, 30).toIso8601String(),
          'status': 'pending',
        },
        {
          'id': 'APR-1002',
          'request_number': 'REQ-1002',
          'employee_name': 'سارة أحمد',
          'branch_name': 'فرع مدينة نصر',
          'amount_piastres': 500000,
          'reason': 'خصم على بيع الذهب',
          'created_at': DateTime.utc(2026, 1, 9, 10, 15).toIso8601String(),
          'status': 'approved',
        },
        {
          'id': 'APR-1003',
          'request_number': 'REQ-1003',
          'employee_name': 'محمد حسن',
          'branch_name': 'فرع الهرم',
          'amount_piastres': 1500000,
          'reason': 'مرتجع بضاعة',
          'created_at': DateTime.utc(2026, 1, 9, 16, 45).toIso8601String(),
          'status': 'rejected',
        },
        {
          'id': 'APR-1004',
          'request_number': 'REQ-1004',
          'employee_name': 'فاطمة علي',
          'branch_name': 'فرع المعادي',
          'amount_piastres': 800000,
          'reason': 'تعديل سعر قطعة ذهب',
          'created_at': DateTime.utc(2026, 1, 8, 12, 20).toIso8601String(),
          'status': 'pending',
        },
        {
          'id': 'APR-1005',
          'request_number': 'REQ-1005',
          'employee_name': 'خالد يوسف',
          'branch_name': 'فرع وسط البلد',
          'amount_piastres': 3000000,
          'reason': 'صرف نقدية لعملية شراء ذهب',
          'created_at': DateTime.utc(2026, 1, 7, 9, 0).toIso8601String(),
          'status': 'approved',
        },
      ];

  Map<String, dynamic> approvalDetail(
    String id,
    MockScenarioController scenarios,
  ) {
    var version = 3;
    var status = 'pending';
    String? warningMessage;
    
    if (scenarios.active == MockScenario.approvalVersionBump) {
      version = 4;
    }
    if (scenarios.active == MockScenario.approvalOtherDevice) {
      status = 'approved';
    }
    
    // إضافة تحذير للطلبات الكبيرة
    if (id == 'APR-1001' && status == 'pending') {
      warningMessage = 'المبلغ أكبر من الحد المسموح (25,000 ج.م). يُرجى التحقق من السبب.';
    }
    
    return {
      'id': id,
      'request_number': id.replaceAll('APR-', 'REQ-'),
      'version': version,
      'employee_id': 'EMP-${id.replaceAll('APR-', '')}',
      'employee_name': _getEmployeeNameById(id),
      'branch_id': 'BR-${id.replaceAll('APR-100', '')}',
      'branch_name': _getBranchNameById(id),
      'amount_piastres': _getAmountById(id),
      'reason': _getReasonById(id),
      'operation_details': {
        'type': 'cash_withdrawal',
        'category': 'supplier_payment',
        'notes': 'طلب عاجل - يُرجى المراجعة',
        'requested_by': _getEmployeeNameById(id),
        'requested_at': DateTime.utc(2026, 1, 10, 14, 30).toIso8601String(),
      },
      'created_at': DateTime.utc(2026, 1, 10, 14, 30).toIso8601String(),
      'status': status,
      'warning_message': warningMessage,
    };
  }
  
  Map<String, dynamic> approvalStats() => {
        'total': 5,
        'pending': 2,
        'approved': 2,
        'rejected': 1,
      };
  
  String _getEmployeeNameById(String id) {
    switch (id) {
      case 'APR-1001':
        return 'أحمد محمد';
      case 'APR-1002':
        return 'سارة أحمد';
      case 'APR-1003':
        return 'محمد حسن';
      case 'APR-1004':
        return 'فاطمة علي';
      case 'APR-1005':
        return 'خالد يوسف';
      default:
        return 'موظف غير معروف';
    }
  }
  
  String _getBranchNameById(String id) {
    switch (id) {
      case 'APR-1001':
      case 'APR-1004':
        return 'فرع المعادي';
      case 'APR-1002':
        return 'فرع مدينة نصر';
      case 'APR-1003':
        return 'فرع الهرم';
      case 'APR-1005':
        return 'فرع وسط البلد';
      default:
        return 'فرع غير معروف';
    }
  }
  
  int _getAmountById(String id) {
    switch (id) {
      case 'APR-1001':
        return 2500000; // 25,000 ج.م
      case 'APR-1002':
        return 500000;  // 5,000 ج.م
      case 'APR-1003':
        return 1500000; // 15,000 ج.م
      case 'APR-1004':
        return 800000;  // 8,000 ج.م
      case 'APR-1005':
        return 3000000; // 30,000 ج.م
      default:
        return 1000000;
    }
  }
  
  String _getReasonById(String id) {
    switch (id) {
      case 'APR-1001':
        return 'صرف لمورد - طلب عاجل';
      case 'APR-1002':
        return 'خصم على بيع الذهب';
      case 'APR-1003':
        return 'مرتجع بضاعة';
      case 'APR-1004':
        return 'تعديل سعر قطعة ذهب';
      case 'APR-1005':
        return 'صرف نقدية لعملية شراء ذهب';
      default:
        return 'غير محدد';
    }
  }

  Map<String, dynamic> customerDebts(String customerId) => {
        'customer_id': customerId,
        'customer_name': 'محمد علي',
        'customer_number': 'C-9001',
        'server_outstanding_piastres': 150000,
        'debts': [
          {
            'id': 'DEBT-1',
            'original_piastres': 100000,
            'remaining_piastres': 100000,
            'due_date': DateTime.utc(2025, 12, 1).toIso8601String(),
            'status': 'open',
          },
          {
            'id': 'DEBT-2',
            'original_piastres': 50000,
            'remaining_piastres': 50000,
            'due_date': DateTime.utc(2026, 1, 1).toIso8601String(),
            'status': 'open',
          },
        ],
      };

  Map<String, dynamic> product(String code) => {
        'id': 'PROD-1',
        'code': code,
        'name': 'خاتم ذهب',
        'gross_mg': 4500,
        'stone_mg': 300,
        'karat': 21,
        'price_per_gram_piastres': 420000,
        'workmanship_type': 'per_gram',
        'workmanship_piastres_per_gram': 12000,
        'discount_percent': '10',
        'status': 'available',
      };

  Map<String, dynamic> priceSnapshot() => {
        'timestamp': DateTime.utc(2026, 1, 15, 10).toIso8601String(),
        'gold_21_piastres_per_gram': 420000,
      };

  List<Map<String, dynamic>> branches() => [
        {'id': 'all', 'name': 'كل الفروع'},
        {'id': 'BR-A', 'name': 'فرع أ'},
        {'id': 'BR-B', 'name': 'فرع ب'},
        {'id': 'BR-C', 'name': 'فرع ج'},
      ];

  Map<String, dynamic> dashboard(String branchId) => {
        'branch_id': branchId,
        'sequence': branchId == 'BR-A' ? 102 : (branchId == 'BR-B' ? 57 : (branchId == 'BR-C' ? 89 : 250)),
        'event_id': 'EVT-$branchId-${branchId == 'BR-A' ? 102 : (branchId == 'BR-B' ? 57 : (branchId == 'BR-C' ? 89 : 250))}',
        'updated_at': DateTime.utc(2026, 1, 15, 12).toIso8601String(),
        'sales_total_piastres': branchId == 'BR-A' ? 10100000 : (branchId == 'BR-B' ? 8500000 : (branchId == 'BR-C' ? 6200000 : 24800000)),
        'sales_today_piastres': branchId == 'BR-A' ? 150000 : (branchId == 'BR-B' ? 120000 : (branchId == 'BR-C' ? 95000 : 365000)),
        'sales_count': branchId == 'BR-A' ? 42 : (branchId == 'BR-B' ? 35 : (branchId == 'BR-C' ? 28 : 105)),
        'cash_balance_piastres': branchId == 'BR-A' ? 500000 : (branchId == 'BR-B' ? 380000 : (branchId == 'BR-C' ? 290000 : 1170000)),
        'gold_prices': [
          {'karat': 21, 'piastres_per_gram': 420000},
          {'karat': 24, 'piastres_per_gram': 480000},
          {'karat': 18, 'piastres_per_gram': 360000},
        ],
        'operations': _getOperations(branchId),
      };

  List<Map<String, dynamic>> _getOperations(String branchId) {
    if (branchId == 'all') {
      return [
        {
          'id': 'OP-1',
          'branch': 'فرع أ',
          'employee': 'أحمد محمد',
          'type': 'بيع ذهب',
          'amount_piastres': 350000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 45).toIso8601String(),
        },
        {
          'id': 'OP-2',
          'branch': 'فرع ب',
          'employee': 'سارة علي',
          'type': 'شراء ذهب',
          'amount_piastres': 280000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 30).toIso8601String(),
        },
        {
          'id': 'OP-3',
          'branch': 'فرع ج',
          'employee': 'محمود حسن',
          'type': 'بيع ذهب',
          'amount_piastres': 420000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 15).toIso8601String(),
        },
        {
          'id': 'OP-4',
          'branch': 'فرع أ',
          'employee': 'فاطمة خالد',
          'type': 'تحصيل قسط',
          'amount_piastres': 150000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 0).toIso8601String(),
        },
        {
          'id': 'OP-5',
          'branch': 'فرع ب',
          'employee': 'عمر سعيد',
          'type': 'بيع ذهب',
          'amount_piastres': 520000,
          'timestamp': DateTime.utc(2026, 1, 15, 10, 45).toIso8601String(),
        },
      ];
    } else if (branchId == 'BR-A') {
      return [
        {
          'id': 'OP-A1',
          'branch': 'فرع أ',
          'employee': 'أحمد محمد',
          'type': 'بيع ذهب',
          'amount_piastres': 350000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 45).toIso8601String(),
        },
        {
          'id': 'OP-A2',
          'branch': 'فرع أ',
          'employee': 'فاطمة خالد',
          'type': 'تحصيل قسط',
          'amount_piastres': 150000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 0).toIso8601String(),
        },
        {
          'id': 'OP-A3',
          'branch': 'فرع أ',
          'employee': 'يوسف عبدالله',
          'type': 'بيع ذهب',
          'amount_piastres': 480000,
          'timestamp': DateTime.utc(2026, 1, 15, 10, 30).toIso8601String(),
        },
      ];
    } else if (branchId == 'BR-B') {
      return [
        {
          'id': 'OP-B1',
          'branch': 'فرع ب',
          'employee': 'سارة علي',
          'type': 'شراء ذهب',
          'amount_piastres': 280000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 30).toIso8601String(),
        },
        {
          'id': 'OP-B2',
          'branch': 'فرع ب',
          'employee': 'عمر سعيد',
          'type': 'بيع ذهب',
          'amount_piastres': 520000,
          'timestamp': DateTime.utc(2026, 1, 15, 10, 45).toIso8601String(),
        },
      ];
    } else if (branchId == 'BR-C') {
      return [
        {
          'id': 'OP-C1',
          'branch': 'فرع ج',
          'employee': 'محمود حسن',
          'type': 'بيع ذهب',
          'amount_piastres': 420000,
          'timestamp': DateTime.utc(2026, 1, 15, 11, 15).toIso8601String(),
        },
        {
          'id': 'OP-C2',
          'branch': 'فرع ج',
          'employee': 'نور الدين',
          'type': 'تحصيل قسط',
          'amount_piastres': 95000,
          'timestamp': DateTime.utc(2026, 1, 15, 10, 20).toIso8601String(),
        },
      ];
    }
    return [];
  }

  Map<String, dynamic> dashboardSnapshot(String branchId) => dashboard(branchId);
}