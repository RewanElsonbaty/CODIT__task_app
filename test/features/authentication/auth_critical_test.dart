import 'package:flutter_test/flutter_test.dart';
import 'package:codit/features/authentication/data/mock_auth_api.dart';
import 'package:codit/core/data/mock_api_client.dart';

/// Critical Tests للـ Authentication
/// تشمل: Token Refresh, Session Expiry, Concurrent Sessions
void main() {
  late MockAuthApi api;

  setUp(() {
    api = MockAuthApi();
  });

  group('Authentication Critical Tests', () {
    test('تسجيل دخول ناجح يُنشئ session و tokens', () async {
      final result = await api.login(
        username: 'admin@codit.gold',
        password: 'Admin@123',
        deviceId: 'device_001',
      );

      expect(result['success'], true);
      expect(result['data']['access_token'], isNotNull);
      expect(result['data']['refresh_token'], isNotNull);
      expect(result['data']['session_id'], isNotNull);
      expect(result['data']['user']['id'], 'user_001');
    });

    test('تسجيل دخول بمعلومات خاطئة يفشل', () async {
      expect(
        () => api.login(
          username: 'wrong@codit.gold',
          password: 'WrongPass',
          deviceId: 'device_001',
        ),
        throwsA(isA<MockNetworkException>()),
      );
    });

    test('Token Refresh: تحديث التوكن بنجاح', () async {
      // 1. تسجيل الدخول
      final loginResult = await api.login(
        username: 'admin@codit.gold',
        password: 'Admin@123',
        deviceId: 'device_001',
      );

      final sessionId = loginResult['data']['session_id'] as String;
      final refreshToken = loginResult['data']['refresh_token'] as String;
      final oldAccessToken = loginResult['data']['access_token'] as String;

      // 2. تحديث التوكن
      final refreshResult = await api.refreshToken(
        refreshToken: refreshToken,
        sessionId: sessionId,
      );

      expect(refreshResult['success'], true);
      final newAccessToken = refreshResult['data']['access_token'] as String;
      final newRefreshToken = refreshResult['data']['refresh_token'] as String;

      // 3. التأكد من أن التوكنات الجديدة مختلفة
      expect(newAccessToken, isNot(equals(oldAccessToken)));
      expect(newRefreshToken, isNot(equals(refreshToken)));

      // 4. التحقق من أن التوكن الجديد صالح
      final verifyResult = await api.verifyToken(newAccessToken);
      expect(verifyResult['data']['valid'], true);
    });

    test('Token Refresh: توكن غير صالح يفشل', () async {
      expect(
        () => api.refreshToken(
          refreshToken: 'invalid_token',
          sessionId: 'invalid_session',
        ),
        throwsA(isA<MockNetworkException>()),
      );
    });

    test('Session Expiry: توكن منتهي الصلاحية يفشل في Verify', () async {
      // 1. تسجيل الدخول
      final loginResult = await api.login(
        username: 'cashier@codit.gold',
        password: 'Cashier@123',
        deviceId: 'device_002',
      );

      final sessionId = loginResult['data']['session_id'] as String;
      final accessToken = loginResult['data']['access_token'] as String;

      // 2. إنهاء صلاحية الـ session يدوياً
      api.expireSession(sessionId);

      // 3. التحقق من فشل Verify
      expect(
        () => api.verifyToken(accessToken),
        throwsA(isA<MockNetworkException>()),
      );
    });

    test('Concurrent Sessions: نفس المستخدم على devices مختلفة', () async {
      // 1. تسجيل دخول من device 1
      final result1 = await api.login(
        username: 'manager@codit.gold',
        password: 'Manager@123',
        deviceId: 'device_001',
      );

      // 2. تسجيل دخول من device 2
      final result2 = await api.login(
        username: 'manager@codit.gold',
        password: 'Manager@123',
        deviceId: 'device_002',
      );

      // 3. التأكد من أن كلاهما نجح
      expect(result1['success'], true);
      expect(result2['success'], true);

      // 4. التأكد من اختلاف الـ sessions
      expect(
        result1['data']['session_id'],
        isNot(equals(result2['data']['session_id'])),
      );

      // 5. التأكد من صلاحية كلا التوكنين
      final verify1 = await api.verifyToken(result1['data']['access_token']);
      final verify2 = await api.verifyToken(result2['data']['access_token']);

      expect(verify1['data']['valid'], true);
      expect(verify2['data']['valid'], true);
    });

    test('تسجيل الخروج يُبطل الـ session', () async {
      // 1. تسجيل الدخول
      final loginResult = await api.login(
        username: 'cashier@codit.gold',
        password: 'Cashier@123',
        deviceId: 'device_003',
      );

      final sessionId = loginResult['data']['session_id'] as String;
      final accessToken = loginResult['data']['access_token'] as String;

      // 2. التحقق من صلاحية التوكن
      final verifyBefore = await api.verifyToken(accessToken);
      expect(verifyBefore['data']['valid'], true);

      // 3. تسجيل الخروج
      await api.logout(sessionId);

      // 4. التحقق من فشل التوكن بعد Logout
      expect(
        () => api.verifyToken(accessToken),
        throwsA(isA<MockNetworkException>()),
      );
    });

    test('تغيير كلمة المرور بنجاح', () async {
      // 1. تسجيل الدخول بكلمة المرور القديمة
      final loginResult = await api.login(
        username: 'cashier@codit.gold',
        password: 'Cashier@123',
        deviceId: 'device_004',
      );

      final userId = loginResult['data']['user']['id'] as String;

      // 2. تغيير كلمة المرور
      final changeResult = await api.changePassword(
        userId: userId,
        oldPassword: 'Cashier@123',
        newPassword: 'NewPassword@123',
      );

      expect(changeResult['success'], true);

      // 3. تسجيل الخروج
      await api.logout(loginResult['data']['session_id']);

      // 4. محاولة تسجيل الدخول بكلمة المرور القديمة - يجب أن يفشل
      expect(
        () => api.login(
          username: 'cashier@codit.gold',
          password: 'Cashier@123',
          deviceId: 'device_005',
        ),
        throwsA(isA<MockNetworkException>()),
      );

      // 5. تسجيل الدخول بكلمة المرور الجديدة - يجب أن ينجح
      final loginNewResult = await api.login(
        username: 'cashier@codit.gold',
        password: 'NewPassword@123',
        deviceId: 'device_006',
      );

      expect(loginNewResult['success'], true);
    });

    test('الحصول على الصلاحيات حسب الدور', () async {
      // Admin - جميع الصلاحيات
      final adminPerms = await api.getPermissions('user_001');
      expect(adminPerms['data']['permissions'], contains('all'));
      expect(adminPerms['data']['role'], 'admin');

      // Branch Manager - صلاحيات محددة
      final managerPerms = await api.getPermissions('user_002');
      expect(managerPerms['data']['permissions'], contains('sales'));
      expect(managerPerms['data']['permissions'], contains('approvals'));
      expect(managerPerms['data']['role'], 'branch_manager');

      // Cashier - صلاحية المبيعات فقط
      final cashierPerms = await api.getPermissions('user_003');
      expect(cashierPerms['data']['permissions'], contains('sales'));
      expect(cashierPerms['data']['permissions'], hasLength(1));
      expect(cashierPerms['data']['role'], 'cashier');
    });
  });
}
