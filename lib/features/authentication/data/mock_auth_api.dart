import 'dart:convert';
import 'dart:math';
import '../../../core/data/mock_api_client.dart';

/// Mock Authentication API
/// يحاكي عمليات تسجيل الدخول والتوكنات والصلاحيات
class MockAuthApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Users Database
  final Map<String, MockUser> _users = {
    'admin@codit.gold': MockUser(
      id: 'user_001',
      username: 'admin@codit.gold',
      password: 'Admin@123', // في الحقيقة يجب أن يكون hash
      role: 'admin',
      branchId: 'branch_main',
      fullName: 'أحمد محمد',
      permissions: ['all'],
    ),
    'manager@codit.gold': MockUser(
      id: 'user_002',
      username: 'manager@codit.gold',
      password: 'Manager@123',
      role: 'branch_manager',
      branchId: 'branch_main',
      fullName: 'محمد علي',
      permissions: ['sales', 'installments', 'approvals', 'monitoring'],
    ),
    'cashier@codit.gold': MockUser(
      id: 'user_003',
      username: 'cashier@codit.gold',
      password: 'Cashier@123',
      role: 'cashier',
      branchId: 'branch_main',
      fullName: 'فاطمة حسن',
      permissions: ['sales'],
    ),
  };

  // Active Sessions (في الحقيقة يجب أن تكون في database/cache)
  final Map<String, MockSession> _sessions = {};

  /// تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    await _client.post(
      '/auth/login',
      body: {'username': username, 'password': password, 'device_id': deviceId},
    );

    // التحقق من بيانات الاعتماد
    final user = _users[username];
    if (user == null || user.password != password) {
      throw MockNetworkException('اسم المستخدم أو كلمة المرور غير صحيحة');
    }

    // إنشاء Session جديدة
    final sessionId = _generateSessionId();
    final accessToken = _generateToken();
    final refreshToken = _generateToken(isRefresh: true);

    _sessions[sessionId] = MockSession(
      sessionId: sessionId,
      userId: user.id,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      deviceId: deviceId,
    );

    return {
      'success': true,
      'data': {
        'session_id': sessionId,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': 3600,
        'token_type': 'Bearer',
        'user': user.toJson(),
      },
    };
  }

  /// تسجيل الخروج
  Future<Map<String, dynamic>> logout(String sessionId) async {
    await _client.post('/auth/logout');

    _sessions.remove(sessionId);

    return {'success': true, 'message': 'تم تسجيل الخروج بنجاح'};
  }

  /// تحديث التوكن (Refresh Token)
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
    required String sessionId,
  }) async {
    await _client.post('/auth/refresh', body: {'refresh_token': refreshToken});

    final session = _sessions[sessionId];
    if (session == null || session.refreshToken != refreshToken) {
      throw MockNetworkException('التوكن غير صالح');
    }

    // إنشاء توكن جديد
    final newAccessToken = _generateToken();
    final newRefreshToken = _generateToken(isRefresh: true);

    _sessions[sessionId] = session.copyWith(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );

    return {
      'success': true,
      'data': {
        'access_token': newAccessToken,
        'refresh_token': newRefreshToken,
        'expires_in': 3600,
      },
    };
  }

  /// التحقق من التوكن
  Future<Map<String, dynamic>> verifyToken(String token) async {
    await _client.post('/auth/verify', body: {'token': token});

    // البحث عن session بهذا التوكن
    final session = _sessions.values.firstWhere(
      (s) => s.accessToken == token,
      orElse: () => throw MockNetworkException('التوكن غير صالح'),
    );

    // التحقق من انتهاء الصلاحية
    if (session.expiresAt.isBefore(DateTime.now())) {
      throw MockNetworkException('انتهت صلاحية التوكن');
    }

    final user = _users.values.firstWhere((u) => u.id == session.userId);

    return {
      'success': true,
      'data': {'valid': true, 'user': user.toJson()},
    };
  }

  /// الحصول على الصلاحيات
  Future<Map<String, dynamic>> getPermissions(String userId) async {
    await _client.get('/auth/permissions/$userId');

    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw MockNetworkException('المستخدم غير موجود'),
    );

    return {
      'success': true,
      'data': {'permissions': user.permissions, 'role': user.role},
    };
  }

  /// تغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _client.post(
      '/auth/change-password',
      body: {
        'user_id': userId,
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );

    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw MockNetworkException('المستخدم غير موجود'),
    );

    if (user.password != oldPassword) {
      throw MockNetworkException('كلمة المرور القديمة غير صحيحة');
    }

    // تحديث كلمة المرور (في الحقيقة يجب أن تكون hash)
    _users[user.username] = user.copyWith(password: newPassword);

    return {'success': true, 'message': 'تم تغيير كلمة المرور بنجاح'};
  }

  /// محاكاة Token Expiry لأغراض الاختبار
  void expireSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session != null) {
      _sessions[sessionId] = session.copyWith(
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
    }
  }

  // Helper Methods
  String _generateSessionId() {
    return 'sess_${_random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  String _generateToken({bool isRefresh = false}) {
    final prefix = isRefresh ? 'rt_' : 'at_';
    final randomBytes = List.generate(32, (_) => _random.nextInt(256));
    return prefix + base64Url.encode(randomBytes);
  }
}

/// Mock User Model
class MockUser {
  final String id;
  final String username;
  final String password;
  final String role;
  final String branchId;
  final String fullName;
  final List<String> permissions;

  MockUser({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.branchId,
    required this.fullName,
    required this.permissions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'role': role,
    'branch_id': branchId,
    'full_name': fullName,
    'permissions': permissions,
  };

  MockUser copyWith({
    String? id,
    String? username,
    String? password,
    String? role,
    String? branchId,
    String? fullName,
    List<String>? permissions,
  }) {
    return MockUser(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      branchId: branchId ?? this.branchId,
      fullName: fullName ?? this.fullName,
      permissions: permissions ?? this.permissions,
    );
  }
}

/// Mock Session Model
class MockSession {
  final String sessionId;
  final String userId;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String deviceId;

  MockSession({
    required this.sessionId,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.deviceId,
  });

  MockSession copyWith({
    String? sessionId,
    String? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? deviceId,
  }) {
    return MockSession(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
