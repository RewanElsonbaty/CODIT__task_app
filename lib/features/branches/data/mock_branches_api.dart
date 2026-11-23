import 'dart:math';
import '../../../core/data/mock_api_client.dart';

/// Mock Branches API
/// يحاكي عمليات مراقبة الفروع والمبيعات والموظفين
class MockBranchesApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Branches Database
  final List<Map<String, dynamic>> _branches = [];

  MockBranchesApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    _branches.addAll([
      {
        'id': 'BR-001',
        'name': 'فرع المعادي',
        'address': 'شارع 9، المعادي، القاهرة',
        'manager': 'أحمد محمود',
        'phone': '0225123456',
        'today_sales': 125000.0,
        'today_transactions': 42,
        'active_employees': 8,
        'total_employees': 10,
        'status': 'نشط',
        'open_time': '09:00',
        'close_time': '21:00',
        'avg_rating': 4.5,
      },
      {
        'id': 'BR-002',
        'name': 'فرع مدينة نصر',
        'address': 'شارع عباس العقاد، مدينة نصر',
        'manager': 'سارة علي',
        'phone': '0222345678',
        'today_sales': 98000.0,
        'today_transactions': 35,
        'active_employees': 6,
        'total_employees': 8,
        'status': 'نشط',
        'open_time': '10:00',
        'close_time': '22:00',
        'avg_rating': 4.8,
      },
      {
        'id': 'BR-003',
        'name': 'فرع الإسكندرية',
        'address': 'شارع فؤاد، الإسكندرية',
        'manager': 'محمد حسن',
        'phone': '0334567890',
        'today_sales': 156000.0,
        'today_transactions': 58,
        'active_employees': 12,
        'total_employees': 12,
        'status': 'نشط',
        'open_time': '09:00',
        'close_time': '23:00',
        'avg_rating': 4.7,
      },
      {
        'id': 'BR-004',
        'name': 'فرع الزمالك',
        'address': 'شارع 26 يوليو، الزمالك',
        'manager': 'نور فتحي',
        'phone': '0227654321',
        'today_sales': 0.0,
        'today_transactions': 0,
        'active_employees': 0,
        'total_employees': 6,
        'status': 'مغلق',
        'open_time': '10:00',
        'close_time': '20:00',
        'avg_rating': 4.2,
      },
      {
        'id': 'BR-005',
        'name': 'فرع المهندسين',
        'address': 'شارع جامعة الدول العربية، المهندسين',
        'manager': 'خالد سعيد',
        'phone': '0223456789',
        'today_sales': 142000.0,
        'today_transactions': 48,
        'active_employees': 9,
        'total_employees': 10,
        'status': 'نشط',
        'open_time': '09:30',
        'close_time': '22:00',
        'avg_rating': 4.6,
      },
    ]);
  }

  /// الحصول على كل الفروع
  Future<List<Map<String, dynamic>>> getBranches() async {
    await _client.get('/branches');
    return _branches;
  }

  /// الحصول على فرع معين
  Future<Map<String, dynamic>?> getBranch(String branchId) async {
    await _client.get('/branches/$branchId');
    
    try {
      return _branches.firstWhere((b) => b['id'] == branchId);
    } catch (e) {
      return null;
    }
  }

  /// تحديث حالة فرع
  Future<void> updateBranchStatus(String branchId, String status) async {
    await _client.patch('/branches/$branchId/status', body: {'status': status});
    
    final branch = _branches.firstWhere((b) => b['id'] == branchId);
    branch['status'] = status;
  }

  /// الحصول على إحصائيات اليوم لكل الفروع
  Future<Map<String, dynamic>> getTodayStatistics() async {
    await _client.get('/branches/statistics/today');
    
    final activeBranches = _branches.where((b) => b['status'] == 'نشط').length;
    final totalSales = _branches.fold<double>(
      0.0,
      (sum, b) => sum + (b['today_sales'] as double),
    );
    final totalTransactions = _branches.fold<int>(
      0,
      (sum, b) => sum + (b['today_transactions'] as int),
    );
    
    return {
      'active_branches': activeBranches,
      'total_branches': _branches.length,
      'total_sales': totalSales,
      'total_transactions': totalTransactions,
    };
  }

  /// محاكاة تحديث بيانات الفرع (للـ refresh)
  Future<void> refreshBranchData(String branchId) async {
    await _client.post('/branches/$branchId/refresh');
    
    final branch = _branches.firstWhere((b) => b['id'] == branchId);
    
    // تحديث عشوائي للبيانات
    if (branch['status'] == 'نشط') {
      branch['today_sales'] = (branch['today_sales'] as double) + _random.nextInt(5000);
      branch['today_transactions'] = (branch['today_transactions'] as int) + _random.nextInt(3);
    }
  }
}
