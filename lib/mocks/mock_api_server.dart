import 'package:codit/core/config/app_config.dart';
import 'package:codit/mocks/mock_data_factory.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:dio/dio.dart';

class MockApiServer {
  MockApiServer(this._scenarios, this._config)
      : _factory = MockDataFactory(),
        _decisions = {},
        _collections = {} {
    _accessToken = 'mock-access-1';
    _refreshToken = 'mock-refresh-1';
    _sessionGeneration = 1;
  }

  final MockScenarioController _scenarios;
  final AppConfig _config;
  final MockDataFactory _factory;

  final Map<String, Map<String, dynamic>> _decisions;
  final Map<String, Map<String, dynamic>> _collections;

  late String _accessToken;
  late String _refreshToken;
  int _sessionGeneration = 1;
  int _refreshCallCount = 0;
  String? _currentAccountId = 'shop-a';

  Future<Response<dynamic>?> handle(RequestOptions options) async {
    if (_scenarios.active == MockScenario.offline) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    if (_scenarios.delayMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: _scenarios.delayMs));
    }
    if (_scenarios.active == MockScenario.timeoutNext) {
      _scenarios.setScenario(MockScenario.none);
      throw DioException(requestOptions: options, type: DioExceptionType.connectionTimeout);
    }
    if (_scenarios.active == MockScenario.failNext) {
      _scenarios.setScenario(MockScenario.none);
      return _json(options, 400, {'message': 'mock failure'});
    }

    final path = options.path;
    final method = options.method.toUpperCase();

    if (path.contains('/auth/login') && method == 'POST') {
      return _json(options, 200, {
        'requires_otp': true,
        'challenge_id': 'ch-1',
      });
    }
    if (path.contains('/auth/otp') && method == 'POST') {
      final body = options.data as Map<String, dynamic>? ?? {};
      if (body['otp'] != _config.testOtp) {
        return _json(options, 400, {'message': 'رمز غير صحيح'});
      }
      return _json(options, 200, {
        'requires_device_verification': _scenarios.active == MockScenario.none,
        'device_trusted': false,
      });
    }
    if (path.contains('/auth/device') && method == 'POST') {
      return _completeAuth(options);
    }
    if (path.contains('/auth/refresh') && method == 'POST') {
      _refreshCallCount++;
      if (_scenarios.active == MockScenario.authFailRefresh) {
        return _json(options, 401, {'message': 'refresh failed'});
      }
      _accessToken = 'mock-access-refreshed-$_refreshCallCount';
      return _json(options, 200, {
        'access_token': _accessToken,
        'refresh_token': _refreshToken,
        'session_generation': _sessionGeneration,
      });
    }
    if (path.contains('/auth/logout') && method == 'POST') {
      _sessionGeneration++;
      _accessToken = '';
      return _json(options, 200, {'ok': true});
    }
    if (path.contains('/auth/session') && method == 'GET') {
      return _json(options, 200, _factory.session(_currentAccountId!));
    }

    final auth = options.headers['Authorization'] as String?;
    if (_scenarios.active == MockScenario.authExpireToken ||
        (auth != null && auth.contains('expired'))) {
      if (path.contains('/auth/refresh')) {
        // handled above
      } else {
        return _json(options, 401, {'message': 'token expired'});
      }
    }
    if (auth == null || !auth.contains('Bearer') || _accessToken.isEmpty) {
      if (!path.contains('/auth/')) {
        return _json(options, 401, {'message': 'unauthorized'});
      }
    }

    if (path.contains('/approvals') && method == 'GET' && !path.contains('/approvals/')) {
      // جلب قائمة الموافقات مع فلترة اختيارية
      final statusFilter = options.queryParameters['status'];
      var approvals = _factory.approvalList();
      
      if (statusFilter != null) {
        approvals = approvals
            .where((a) => a['status'] == statusFilter)
            .toList();
      }
      
      return _json(options, 200, {'approvals': approvals});
    }
    
    if (path == '/approvals/stats' && method == 'GET') {
      return _json(options, 200, _factory.approvalStats());
    }
    
    if (path.contains('/approvals/') && path.endsWith('/approve') && method == 'POST') {
      final id = path.split('/approvals/')[1].split('/approve')[0];
      return _handleApprovalDecision(options, id, true);
    }
    
   if (path.contains('/approvals/') && path.endsWith('/reject') && method == 'POST') {
      final id = path.split('/approvals/')[1].split('/reject')[0];
      return _handleApprovalDecision(options, id, false);
    }
    
    if (path.contains('/approvals/') && method == 'GET') {
      final id = path.split('/approvals/').last;
      return _json(options, 200, _factory.approvalDetail(id, _scenarios));
    }
    if (path.contains('/decision') && method == 'POST') {
      return _submitApprovalDecision(options);
    }
    if (path.contains('/decisions/') && method == 'GET') {
      final id = path.split('/decisions/').last;
      final stored = _decisions[id];
      if (stored == null) {
        return _json(options, 404, {'message': 'غير موجود'});
      }
      return _json(options, 200, stored);
    }

    if (path.contains('/customers/') && path.endsWith('/debts')) {
      final customerId = path.split('/customers/')[1].split('/')[0];
      return _json(options, 200, _factory.customerDebts(customerId));
    }
    if (path.contains('/collections') && method == 'POST') {
      return _submitCollection(options);
    }
    if (path.contains('/collections/') && method == 'GET') {
      final id = path.split('/collections/').last;
      return _json(options, 200, _collections[id] ?? {'status': 'unknown'});
    }

    if (path.contains('/products/') && method == 'GET') {
      final code = path.split('/products/').last;
      return _json(options, 200, _factory.product(code));
    }
    if (path.contains('/gold-products/search') && method == 'GET') {
      return _searchGoldProduct(options);
    }
    if (path.contains('/prices/snapshot')) {
      return _json(options, 200, _factory.priceSnapshot());
    }

    if (path.contains('/branches') && method == 'GET' && !path.contains('dashboard')) {
      return _json(options, 200, {'items': _factory.branches()});
    }
    if (path.contains('/dashboard/snapshot')) {
      final branch = options.queryParameters['branch_id'] ?? 'all';
      return _json(options, 200, _factory.dashboardSnapshot(branch));
    }
    if (path.contains('/dashboard')) {
      final branch = options.queryParameters['branch_id'] ?? 'all';
      
      // تأخير مختلف حسب الفرع لاختبار race conditions
      if (_scenarios.active == MockScenario.branchDelayResponse) {
        if (branch == 'BR-A') {
          await Future<void>.delayed(const Duration(seconds: 2));
        } else if (branch == 'BR-B') {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }
      
      return _json(options, 200, _factory.dashboard(branch));
    }

    if (path.contains('/notifications/')) {
      return _json(options, 200, {
        'type': 'approval_request',
        'resource_id': 'APR-1001',
        'allowed': true,
      });
    }

    return _json(options, 404, {'message': 'not found'});
  }

  Response<dynamic> _json(RequestOptions options, int status, Map<String, dynamic> data) {
    return Response(
      requestOptions: options,
      statusCode: status,
      data: data,
    );
  }

  Future<Response<dynamic>> _completeAuth(RequestOptions options) async {
    _accessToken = 'mock-access-$_sessionGeneration';
    _refreshToken = 'mock-refresh-$_sessionGeneration';
    return _json(options, 200, {
      'access_token': _accessToken,
      'refresh_token': _refreshToken,
      'session_generation': _sessionGeneration,
      'account_id': _currentAccountId,
      'shop_name': 'متجر الذهب',
      'user_name': 'المالك',
    });
  }

  Future<Response<dynamic>> _handleApprovalDecision(
    RequestOptions options,
    String requestId,
    bool approved,
  ) async {
    final body = options.data as Map<String, dynamic>;
    final idempotencyKey = body['idempotency_key'] as String;
    final requestVersion = body['request_version'] as int;

    // 1️⃣ التحقق من الـ idempotency - لو اتبعت من قبل نرجع نفس النتيجة
    if (_decisions.containsKey(idempotencyKey)) {
      return _json(options, 200, _decisions[idempotencyKey]!);
    }

    // 2️⃣ جلب تفاصيل الطلب
    final detail = _factory.approvalDetail(requestId, _scenarios);

    // 3️⃣ التحقق من الـ version
    if (detail['version'] != requestVersion) {
      return _json(options, 409, {
        'message': 'version conflict - تم تحديث الطلب من جهاز آخر',
        'latest_version': detail['version'],
        'current_status': detail['status'],
      });
    }

    // 4️⃣ التحقق من الحالة - لازم يكون pending
    if (detail['status'] != 'pending') {
      return _json(options, 409, {
        'message': 'الطلب تم معالجته من قبل',
        'current_status': detail['status'],
      });
    }

    // 5️⃣ حفظ القرار
    final updatedDetail = Map<String, dynamic>.from(detail);
    updatedDetail['status'] = approved ? 'approved' : 'rejected';
    updatedDetail['version'] = requestVersion + 1;
    updatedDetail['decided_at'] = DateTime.now().toIso8601String();
    updatedDetail['warning_message'] = null;

    _decisions[idempotencyKey] = updatedDetail;

    // 6️⃣ سيناريو: drop response لاختبار Unknown State
    if (_scenarios.shouldDropResponse) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'Connection lost after server processed',
      );
    }

    return _json(options, 200, updatedDetail);
  }

  Future<Response<dynamic>> _submitApprovalDecision(RequestOptions options) async {
    final body = options.data as Map<String, dynamic>;
    final decisionId = body['decision_id'] as String;
    final version = body['request_version'] as int;
    final requestId = body['request_id'] as String;

    if (_decisions.containsKey(decisionId)) {
      return _json(options, 200, _decisions[decisionId]!);
    }

    final detail = _factory.approvalDetail(requestId, _scenarios);
    if (detail['version'] != version) {
      return _json(options, 409, {
        'message': 'version conflict',
        'latest_version': detail['version'],
      });
    }
    if (_scenarios.active == MockScenario.approvalOtherDevice &&
        detail['status'] == 'approved') {
      return _json(options, 409, {'message': 'already decided', 'status': 'approved'});
    }

    final decision = {
      'decision_id': decisionId,
      'request_id': requestId,
      'status': body['decision_type'] == 'approve' ? 'approved' : 'rejected',
      'request_version': version,
      'employee_id_preserved': detail['employee_id'],
    };
    _decisions[decisionId] = decision;

    if (_scenarios.shouldDropResponse) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }

    return _json(options, 200, decision);
  }

  Future<Response<dynamic>> _submitCollection(RequestOptions options) async {
    final body = options.data as Map<String, dynamic>;
    final key = body['idempotency_key'] as String;
    if (_collections.containsKey(key)) {
      return _json(options, 200, _collections[key]!);
    }
    if (_scenarios.active == MockScenario.collectionInsufficientBalance) {
      return _json(options, 409, {
        'message': 'رصيد غير كافٍ',
        'server_balance_piastres': 100000,
      });
    }
    final confirmed = {
      'id': body['collection_id'],
      'status': 'confirmed',
      'idempotency_key': key,
    };
    _collections[key] = confirmed;

    if (_scenarios.active == MockScenario.collectionDropResponse) {
      _scenarios.setScenario(MockScenario.none);
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    return _json(options, 200, confirmed);
  }

  Future<Response<dynamic>> _searchGoldProduct(RequestOptions options) async {
    final code = options.queryParameters['code'] as String?;
    final barcode = options.queryParameters['barcode'] as String?;

    // Mock products database
    final products = [
      {
        'code': 'G001',
        'barcode': '1234567890123',
        'gross_mg': 4500,
        'stone_mg': 300,
        'karat': 21,
        'category': 'خاتم',
        'status': 'available',
      },
      {
        'code': 'G002',
        'barcode': '1234567890124',
        'gross_mg': 8000,
        'stone_mg': 0,
        'karat': 21,
        'category': 'سلسلة',
        'status': 'available',
      },
      {
        'code': 'G003',
        'barcode': null,
        'gross_mg': 15000,
        'stone_mg': 500,
        'karat': 18,
        'category': 'غوايش',
        'status': 'sold', // Already sold
      },
      {
        'code': 'G004',
        'barcode': '1234567890125',
        'gross_mg': 3200,
        'stone_mg': 100,
        'karat': 21,
        'category': 'حلق',
        'status': 'reserved', // Reserved
      },
    ];

    if (code != null) {
      final product = products.where((p) => p['code'] == code).firstOrNull;
      if (product == null) return _json(options, 404, {'message': 'المنتج غير موجود'});
      return _json(options, 200, product);
    }

    if (barcode != null) {
      final product = products.where((p) => p['barcode'] == barcode).firstOrNull;
      if (product == null) return _json(options, 404, {'message': 'المنتج غير موجود'});
      return _json(options, 200, product);
    }

    return _json(options, 400, {'message': 'يجب تحديد الكود أو الباركود'});
  }

  void switchAccount(String accountId) {
    _currentAccountId = accountId;
    _sessionGeneration++;
    _accessToken = 'mock-access-$accountId';
  }

  int get refreshCallCount => _refreshCallCount;
}