import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../../../core/errors/exceptions.dart';

/// Mock Branch Monitoring API
/// يحاكي مراقبة الفروع والمخزون والأداء
class MockMonitoringApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Branches Database
  final List<Map<String, dynamic>> _branches = [];

  // Mock Metrics Database (real-time data)
  final Map<String, List<Map<String, dynamic>>> _metricsHistory = {};

  MockMonitoringApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    _branches.addAll([
      {
        'id': 'branch_main',
        'name': 'الفرع الرئيسي - القاهرة',
        'code': 'CAI-001',
        'address': 'القاهرة - مصر الجديدة',
        'manager_id': 'user_002',
        'manager_name': 'محمد علي',
        'status': 'active',
        'opened_at': '08:00',
        'closes_at': '22:00',
      },
      {
        'id': 'branch_giza',
        'name': 'فرع الجيزة - المهندسين',
        'code': 'GIZ-001',
        'address': 'الجيزة - المهندسين',
        'manager_id': 'user_004',
        'manager_name': 'سارة أحمد',
        'status': 'active',
        'opened_at': '09:00',
        'closes_at': '21:00',
      },
    ]);

    // إنشاء بيانات تاريخية للـ metrics
    for (final branch in _branches) {
      final branchId = branch['id'] as String;
      _metricsHistory[branchId] = _generateMetricsHistory(branchId);
    }
  }

  /// توليد بيانات تاريخية للـ metrics
  List<Map<String, dynamic>> _generateMetricsHistory(String branchId) {
    final history = <Map<String, dynamic>>[];
    final now = DateTime.now();

    // آخر 24 ساعة - كل ساعة
    for (int i = 23; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));

      history.add({
        'timestamp': timestamp.toIso8601String(),
        'sales_count': _random.nextInt(20) + 5,
        'sales_total': (_random.nextDouble() * 50000) + 10000,
        'customers_count': _random.nextInt(30) + 10,
        'avg_transaction': (_random.nextDouble() * 5000) + 2000,
        'inventory_value': (_random.nextDouble() * 1000000) + 5000000,
        'active_users': _random.nextInt(5) + 2,
      });
    }

    return history;
  }

  /// الحصول على جميع الفروع
  Future<Map<String, dynamic>> getAllBranches() async {
    await _client.get('/branches');

    return {
      'success': true,
      'data': {'branches': _branches, 'total_count': _branches.length},
    };
  }

  /// الحصول على معلومات فرع معين
  Future<Map<String, dynamic>> getBranch(String branchId) async {
    await _client.get('/branches/$branchId');

    final branch = _branches.where((b) => b['id'] == branchId).firstOrNull;

    if (branch == null) {
      return {'success': false, 'error': 'الفرع غير موجود'};
    }

    return {'success': true, 'data': branch};
  }

  /// الحصول على metrics حية لفرع
  Future<Map<String, dynamic>> getLiveMetrics(String branchId) async {
    await _client.get('/branches/$branchId/metrics/live');

    final branch = _branches.where((b) => b['id'] == branchId).firstOrNull;

    if (branch == null) {
      throw MockNetworkException('الفرع غير موجود');
    }

    // توليد بيانات حية عشوائية (في الواقع تأتي من الخادم)
    final now = DateTime.now();
    final todayMetrics =
        _metricsHistory[branchId]?.where((m) {
          final timestamp = DateTime.parse(m['timestamp'] as String);
          return timestamp.day == now.day &&
              timestamp.month == now.month &&
              timestamp.year == now.year;
        }).toList() ??
        [];

    final todaySalesTotal = todayMetrics.fold<double>(
      0.0,
      (sum, m) => sum + (m['sales_total'] as double),
    );

    final todaySalesCount = todayMetrics.fold<int>(
      0,
      (sum, m) => sum + (m['sales_count'] as int),
    );

    return {
      'success': true,
      'data': {
        'branch_id': branchId,
        'timestamp': now.toIso8601String(),
        'today_sales_total': todaySalesTotal,
        'today_sales_count': todaySalesCount,
        'today_customers': todayMetrics.isEmpty
            ? 0
            : todayMetrics.last['customers_count'],
        'active_users': _random.nextInt(5) + 2,
        'inventory_value': (_random.nextDouble() * 1000000) + 5000000,
        'pending_approvals': _random.nextInt(10),
        'overdue_installments': _random.nextInt(5),
      },
    };
  }

  /// الحصول على الـ metrics التاريخية
  Future<Map<String, dynamic>> getMetricsHistory({
    required String branchId,
    required DateTime from,
    required DateTime to,
    String interval = 'hourly', // hourly, daily, weekly
  }) async {
    await _client.get(
      '/branches/$branchId/metrics/history',
      queryParams: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'interval': interval,
      },
    );

    final history = _metricsHistory[branchId];

    if (history == null) {
      throw MockNetworkException('الفرع غير موجود');
    }

    final filtered = history.where((m) {
      final timestamp = DateTime.parse(m['timestamp'] as String);
      return timestamp.isAfter(from) && timestamp.isBefore(to);
    }).toList();

    return {
      'success': true,
      'data': {'metrics': filtered, 'total_count': filtered.length},
    };
  }

  /// الحصول على أداء الفروع (مقارنة)
  Future<Map<String, dynamic>> getBranchesPerformance({
    required DateTime from,
    required DateTime to,
  }) async {
    await _client.get(
      '/branches/performance',
      queryParams: {'from': from.toIso8601String(), 'to': to.toIso8601String()},
    );

    final performance = <Map<String, dynamic>>[];

    for (final branch in _branches) {
      final branchId = branch['id'] as String;
      final history = _metricsHistory[branchId];

      if (history == null) continue;

      final filtered = history.where((m) {
        final timestamp = DateTime.parse(m['timestamp'] as String);
        return timestamp.isAfter(from) && timestamp.isBefore(to);
      }).toList();

      final totalSales = filtered.fold<double>(
        0.0,
        (sum, m) => sum + (m['sales_total'] as double),
      );

      final totalTransactions = filtered.fold<int>(
        0,
        (sum, m) => sum + (m['sales_count'] as int),
      );

      final avgTransaction = totalTransactions > 0
          ? totalSales / totalTransactions
          : 0.0;

      performance.add({
        'branch_id': branchId,
        'branch_name': branch['name'],
        'total_sales': totalSales,
        'total_transactions': totalTransactions,
        'avg_transaction': avgTransaction,
        'inventory_value': filtered.isNotEmpty
            ? filtered.last['inventory_value']
            : 0.0,
      });
    }

    // ترتيب حسب المبيعات
    performance.sort(
      (a, b) =>
          (b['total_sales'] as double).compareTo(a['total_sales'] as double),
    );

    return {
      'success': true,
      'data': {
        'performance': performance,
        'period_from': from.toIso8601String(),
        'period_to': to.toIso8601String(),
      },
    };
  }

  /// الحصول على المخزون حسب الفرع
  Future<Map<String, dynamic>> getBranchInventory(String branchId) async {
    await _client.get('/branches/$branchId/inventory');

    // توليد بيانات مخزون عشوائية
    final categories = ['خواتم', 'سلاسل', 'أساور', 'أقراط', 'دلايات'];
    final karats = ['21', '18', '24'];

    final inventory = <Map<String, dynamic>>[];

    for (final category in categories) {
      for (final karat in karats) {
        final count = _random.nextInt(50) + 10;
        final weight = (_random.nextDouble() * 1000) + 100;
        final value = (_random.nextDouble() * 500000) + 100000;

        inventory.add({
          'category': category,
          'karat': karat,
          'items_count': count,
          'total_weight_grams': weight,
          'total_value': value,
        });
      }
    }

    final totalValue = inventory.fold<double>(
      0.0,
      (sum, item) => sum + (item['total_value'] as double),
    );

    final totalWeight = inventory.fold<double>(
      0.0,
      (sum, item) => sum + (item['total_weight_grams'] as double),
    );

    return {
      'success': true,
      'data': {
        'branch_id': branchId,
        'inventory': inventory,
        'total_value': totalValue,
        'total_weight': totalWeight,
        'total_items': inventory.fold<int>(
          0,
          (sum, item) => sum + (item['items_count'] as int),
        ),
      },
    };
  }

  /// الحصول على المستخدمين النشطين في الفرع
  Future<Map<String, dynamic>> getActiveUsers(String branchId) async {
    await _client.get('/branches/$branchId/users/active');

    // توليد بيانات مستخدمين نشطين
    final activeUsers = [
      {
        'user_id': 'user_003',
        'name': 'فاطمة حسن',
        'role': 'cashier',
        'logged_in_at': DateTime.now()
            .subtract(const Duration(hours: 3))
            .toIso8601String(),
        'last_activity': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        'transactions_count': _random.nextInt(20) + 5,
      },
      {
        'user_id': 'user_005',
        'name': 'أحمد خالد',
        'role': 'cashier',
        'logged_in_at': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'last_activity': DateTime.now()
            .subtract(const Duration(minutes: 2))
            .toIso8601String(),
        'transactions_count': _random.nextInt(15) + 3,
      },
    ];

    return {
      'success': true,
      'data': {
        'branch_id': branchId,
        'active_users': activeUsers,
        'total_count': activeUsers.length,
      },
    };
  }

  /// الحصول على التنبيهات
  Future<Map<String, dynamic>> getAlerts({
    String? branchId,
    String? severity, // high, medium, low
  }) async {
    await _client.get(
      '/branches/alerts',
      queryParams: {
        if (branchId != null) 'branch_id': branchId,
        if (severity != null) 'severity': severity,
      },
    );

    // توليد تنبيهات عشوائية
    final alerts = [
      {
        'id': 'alert_001',
        'branch_id': 'branch_main',
        'type': 'low_inventory',
        'severity': 'high',
        'title': 'مخزون منخفض - خواتم عيار 21',
        'message': 'المخزون أقل من الحد الأدنى (5 قطع متبقية)',
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        'acknowledged': false,
      },
      {
        'id': 'alert_002',
        'branch_id': 'branch_giza',
        'type': 'overdue_payment',
        'severity': 'medium',
        'title': 'قسط متأخر - عقد #CONT-123',
        'message': 'قسط متأخر منذ 5 أيام',
        'created_at': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'acknowledged': false,
      },
    ];

    var filtered = alerts;

    if (branchId != null) {
      filtered = filtered.where((a) => a['branch_id'] == branchId).toList();
    }

    if (severity != null) {
      filtered = filtered.where((a) => a['severity'] == severity).toList();
    }

    return {
      'success': true,
      'data': {'alerts': filtered, 'total_count': filtered.length},
    };
  }

  /// تأكيد قراءة التنبيه
  Future<Map<String, dynamic>> acknowledgeAlert({
    required String alertId,
    required String userId,
  }) async {
    await _client.post(
      '/branches/alerts/$alertId/acknowledge',
      body: {'user_id': userId},
    );

    return {'success': true, 'message': 'تم تأكيد قراءة التنبيه'};
  }

  /// محاكاة تحديث حي للـ metrics (WebSocket simulation)
  Map<String, dynamic> simulateLiveUpdate(String branchId) {
    final now = DateTime.now();

    return {
      'event': 'metrics_update',
      'branch_id': branchId,
      'timestamp': now.toIso8601String(),
      'data': {
        'sales_count': _random.nextInt(3),
        'sales_total': (_random.nextDouble() * 5000) + 1000,
        'customers_count': _random.nextInt(2),
        'active_users': _random.nextInt(5) + 2,
      },
    };
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _branches.clear();
    _metricsHistory.clear();
    _initializeMockData();
  }
}

/// Extension لدعم firstOrNull
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
