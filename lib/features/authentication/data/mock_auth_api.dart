import 'dart:convert';
import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../../../core/errors/exceptions.dart';

/// Mock Authentication API
/// يحاكي عمليات تسجيل الدخول والتوكنات والصلاحيات
class MockAuthApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Users Database - Static Authentication
  // الحسابات الأربعة الرئيسية
  final Map<String, MockUser> _users = {
    // ═══════════════════════════════════════════════════════════
    // 1️⃣ المالك (Owner) - الصلاحيات الكاملة
    // ═══════════════════════════════════════════════════════════
    'owner': MockUser(
      id: 'OWNER-001',
      username: 'owner',
      password: 'owner123',
      role: 'owner',
      branchId: null, // يمكنه الوصول لجميع الفروع
      fullName: 'أحمد محمد - مالك النظام',
      permissions: ['all'], // جميع الصلاحيات
    ),
    
    // ═══════════════════════════════════════════════════════════
    // 2️⃣ المدير (Manager) - إدارة الفرع + الموافقة والرفض
    // ═══════════════════════════════════════════════════════════
    'manager': MockUser(
      id: 'MGR-001',
      username: 'manager',
      password: 'manager123',
      role: 'manager',
      branchId: 'branch_001',
      fullName: 'محمد أحمد - مدير الفرع',
      permissions: [
        'installments',              // عرض الأقساط
        'create_installment_request', // إنشاء طلبات تقسيط
        'approvals',                 // عرض الموافقات
        'approve_requests',          // الموافقة على الطلبات ← جديد
        'reject_requests',           // رفض الطلبات ← جديد
        'staff_management',          // إدارة موظفي فرعه
        'branch_reports',            // تقارير فرعه
        'branch_monitoring',         // مراقبة فرعه
      ],
    ),
    
    // ═══════════════════════════════════════════════════════════
    // 3️⃣ الكاشير (Cashier) - المدفوعات فقط
    // ═══════════════════════════════════════════════════════════
    'cashier': MockUser(
      id: 'CASH-001',
      username: 'cashier',
      password: 'cashier123',
      role: 'cashier',
      branchId: 'branch_001',
      fullName: 'فاطمة حسن - كاشير',
      permissions: [
        'installments',         // عرض الأقساط
        'payments',            // استلام المدفوعات
        'installments_pos',    // نقطة البيع للأقساط
        'print_receipts',      // طباعة الإيصالات
      ],
    ),
    
    // ═══════════════════════════════════════════════════════════
    // 4️⃣ مدير الأقساط (Installments Manager) - المراقبة والتقارير
    // ═══════════════════════════════════════════════════════════
    'installments_manager': MockUser(
      id: 'INST-MGR-001',
      username: 'installments_manager',
      password: 'installments123',
      role: 'installments_manager',
      branchId: null, // يمكنه رؤية جميع الفروع
      fullName: 'خالد محمود - مدير الأقساط',
      permissions: [
        'installments',              // عرض الأقساط
        'installments_monitoring',   // مراقبة جميع الأقساط
        'installments_reports',      // تقارير الأقساط
        'overdue_tracking',         // متابعة المتأخرات
        'send_reminders',           // إرسال التذكيرات
      ],
    ),
    
    // ═══════════════════════════════════════════════════════════
    // Legacy/Backward Compatibility Users
    // ═══════════════════════════════════════════════════════════
    'admin': MockUser(
      id: 'user_admin_005',
      username: 'admin',
      password: 'admin123',
      role: 'owner',
      branchId: null,
      fullName: 'أحمد محمد - مالك النظام',
      permissions: ['all'],
    ),
    
    // Legacy email-based users (backward compatibility)
    'admin@codit.gold': MockUser(
      id: 'user_001',
      username: 'admin@codit.gold',
      password: 'Admin@123',
      role: 'admin',
      branchId: 'branch_main',
      fullName: 'أحمد محمد',
      permissions: ['all'],
    ),
    'manager@codit.gold': MockUser(
      id: 'user_003',
      username: 'manager@codit.gold',
      password: 'Manager@123',
      role: 'branch_manager',
      branchId: 'branch_main',
      fullName: 'محمد علي',
      permissions: ['sales', 'installments', 'approvals', 'monitoring'],
    ),
    'cashier@codit.gold': MockUser(
      id: 'user_004',
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
    try {
      await _client.post(
        '/auth/login',
        body: {'username': username, 'password': password, 'device_id': deviceId},
      );

      // التحقق من فراغ البيانات
      if (username.isEmpty || password.isEmpty) {
        throw ValidationException('الرجاء إدخال اسم المستخدم وكلمة المرور');
      }

      // التحقق من بيانات الاعتماد
      final user = _users[username];
      if (user == null) {
        throw NotFoundException('المستخدم غير موجود');
      }

      if (user.password != password) {
        throw AuthException('كلمة المرور غير صحيحة');
      }

      // التحقق من حالة الحساب (يمكن إضافة isActive)
      // if (!user.isActive) {
      //   throw UnauthorizedException('الحساب غير نشط، الرجاء التواصل مع الإدارة');
      // }

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
    } on ValidationException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } on AuthException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل الاتصال بخدمة المصادقة: ${e.toString()}');
    }
  }

  /// تسجيل الخروج
  Future<Map<String, dynamic>> logout(String sessionId) async {
    try {
      await _client.post('/auth/logout');

      // التحقق من وجود Session
      if (!_sessions.containsKey(sessionId)) {
        throw NotFoundException('الجلسة غير موجودة');
      }

      _sessions.remove(sessionId);

      return {'success': true, 'message': 'تم تسجيل الخروج بنجاح'};
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل في تسجيل الخروج: ${e.toString()}');
    }
  }

  /// تحديث التوكن (Refresh Token)
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
    required String sessionId,
  }) async {
    try {
      await _client.post('/auth/refresh', body: {'refresh_token': refreshToken});

      final session = _sessions[sessionId];
      if (session == null) {
        throw NotFoundException('الجلسة غير موجودة');
      }

      if (session.refreshToken != refreshToken) {
        throw AuthException('التوكن غير صالح');
      }

      // التحقق من انتهاء الصلاحية
      if (session.expiresAt.isBefore(DateTime.now())) {
        throw TimeoutException('انتهت صلاحية الجلسة');
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
    } on NotFoundException {
      rethrow;
    } on AuthException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل في تحديث التوكن: ${e.toString()}');
    }
  }

  /// التحقق من التوكن
  Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      await _client.post('/auth/verify', body: {'token': token});

      if (token.isEmpty) {
        throw ValidationException('التوكن مطلوب');
      }

      // البحث عن session بهذا التوكن
      MockSession? session;
      try {
        session = _sessions.values.firstWhere((s) => s.accessToken == token);
      } catch (e) {
        throw AuthException('التوكن غير صالح');
      }

      // التحقق من انتهاء الصلاحية
      if (session.expiresAt.isBefore(DateTime.now())) {
        throw TimeoutException('انتهت صلاحية التوكن');
      }

      final user = _users.values.firstWhere(
        (u) => u.id == session!.userId,
        orElse: () => throw NotFoundException('المستخدم غير موجود'),
      );

      return {
        'success': true,
        'data': {'valid': true, 'user': user.toJson()},
      };
    } on ValidationException {
      rethrow;
    } on AuthException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل في التحقق من التوكن: ${e.toString()}');
    }
  }

  /// الحصول على الصلاحيات
  Future<Map<String, dynamic>> getPermissions(String userId) async {
    try {
      await _client.get('/auth/permissions/$userId');

      if (userId.isEmpty) {
        throw ValidationException('معرف المستخدم مطلوب');
      }

      final user = _users.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw NotFoundException('المستخدم غير موجود'),
      );

      return {
        'success': true,
        'data': {'permissions': user.permissions, 'role': user.role},
      };
    } on ValidationException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل في تحميل الصلاحيات: ${e.toString()}');
    }
  }

  /// تغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _client.post(
        '/auth/change-password',
        body: {
          'user_id': userId,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      // التحقق من البيانات
      if (userId.isEmpty || oldPassword.isEmpty || newPassword.isEmpty) {
        throw ValidationException('جميع الحقول مطلوبة');
      }

      if (newPassword.length < 6) {
        throw ValidationException('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      if (oldPassword == newPassword) {
        throw ValidationException('كلمة المرور الجديدة يجب أن تكون مختلفة عن القديمة');
      }

      final user = _users.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw NotFoundException('المستخدم غير موجود'),
      );

      if (user.password != oldPassword) {
        throw AuthException('كلمة المرور القديمة غير صحيحة');
      }

      // تحديث كلمة المرور (في الحقيقة يجب أن تكون hash)
      _users[user.username] = user.copyWith(password: newPassword);

      return {'success': true, 'message': 'تم تغيير كلمة المرور بنجاح'};
    } on ValidationException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw MockNetworkException('فشل في تغيير كلمة المرور: ${e.toString()}');
    }
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
  final String? branchId; // ← nullable لأن المالك ومدير الأقساط لا ينتميان لفرع محدد
  final String fullName;
  final List<String> permissions;

  MockUser({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.branchId, // ← optional
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
