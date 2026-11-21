import 'package:codit/core/utils/secure_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureLogger Sanitization Tests', () {
    test('يمسح Bearer tokens', () {
      const input = 'Request with Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('Bearer [REDACTED]'));
      expect(output, isNot(contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9')));
    });

    test('يمسح access_token من JSON', () {
      const input = '{"access_token":"secret123token","user":"ahmed"}';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('"access_token":"[REDACTED]"'));
      expect(output, isNot(contains('secret123token')));
      expect(output, contains('"user":"ahmed"')); // يبقي البيانات الآمنة
    });

    test('يمسح refresh_token من JSON', () {
      const input = '{"refresh_token":"refresh_secret_456"}';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('"refresh_token":"[REDACTED]"'));
      expect(output, isNot(contains('refresh_secret_456')));
    });

    test('يمسح password', () {
      const input = '{"phone":"01234567890","password":"mySecretPass123"}';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('"password":"[REDACTED]"'));
      expect(output, isNot(contains('mySecretPass123')));
      expect(output, contains('"phone":"01234567890"')); // يبقي البيانات الآمنة
    });

    test('يمسح OTP codes', () {
      const input = 'OTP verification: {"otp":"123456"}';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('"otp":"[REDACTED]"'));
      expect(output, isNot(contains('123456')));
    });

    test('يمسح Authorization headers', () {
      const input = 'Headers: Authorization: Bearer token123';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('Authorization: [REDACTED]'));
      expect(output, isNot(contains('token123')));
    });

    test('يمسح أرقام البطاقات الائتمانية', () {
      const input = 'Card: 1234 5678 9012 3456';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('[CARD-REDACTED]'));
      expect(output, isNot(contains('1234 5678 9012 3456')));
    });

    test('يتعامل مع رسائل بدون بيانات حساسة', () {
      const input = 'User logged in successfully';
      final output = SecureLogger.sanitize(input);
      
      expect(output, equals(input)); // لا تغيير
    });

    test('يمسح multiple tokens في نفس الرسالة', () {
      const input = '''
        Login response: {
          "access_token": "access_secret",
          "refresh_token": "refresh_secret",
          "user": "ahmed"
        }
      ''';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('"access_token":"[REDACTED]"'));
      expect(output, contains('"refresh_token":"[REDACTED]"'));
      expect(output, contains('"user": "ahmed"')); // يبقي الآمن
      expect(output, isNot(contains('access_secret')));
      expect(output, isNot(contains('refresh_secret')));
    });

    test('case-insensitive للـ token fields', () {
      const input = '{"Access_Token":"secret123","REFRESH_TOKEN":"refresh456"}';
      final output = SecureLogger.sanitize(input);
      
      expect(output, contains('[REDACTED]'));
      expect(output, isNot(contains('secret123')));
      expect(output, isNot(contains('refresh456')));
    });
  });

  group('SecureLogger isSafe Tests', () {
    test('يرفض رسائل تحتوي على Bearer token', () {
      const input = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.long_token';
      expect(SecureLogger.isSafe(input), false);
    });

    test('يرفض رسائل تحتوي على access_token', () {
      const input = '{"access_token":"long_secret_token_here"}';
      expect(SecureLogger.isSafe(input), false);
    });

    test('يرفض رسائل تحتوي على password', () {
      const input = '{"password":"myPassword"}';
      expect(SecureLogger.isSafe(input), false);
    });

    test('يقبل رسائل آمنة', () {
      const input = 'User logged in successfully';
      expect(SecureLogger.isSafe(input), true);
    });

    test('يقبل رسائل مع بيانات عامة', () {
      const input = '{"user":"ahmed","phone":"01234567890"}';
      expect(SecureLogger.isSafe(input), true);
    });

    test('يرفض OTP codes', () {
      const input = '{"otp":"123456"}';
      expect(SecureLogger.isSafe(input), false);
    });
  });

  group('SecureLogger Integration Tests', () {
    test('يمسح سيناريو كامل من Login', () {
      const loginRequest = '''
        POST /auth/login
        Body: {"phone":"01234567890","password":"mySecretPass"}
      ''';
      
      final sanitized = SecureLogger.sanitize(loginRequest);
      
      expect(sanitized, contains('"password":"[REDACTED]"'));
      expect(sanitized, isNot(contains('mySecretPass')));
    });

    test('يمسح سيناريو كامل من Token Refresh', () {
      const refreshRequest = '''
        POST /auth/refresh
        Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test
        Body: {"refresh_token":"refresh_secret_456"}
        Response: {
          "access_token": "new_access_789",
          "refresh_token": "new_refresh_012"
        }
      ''';
      
      final sanitized = SecureLogger.sanitize(refreshRequest);
      
      expect(sanitized, contains('Authorization: [REDACTED]'));
      expect(sanitized, contains('"refresh_token":"[REDACTED]"'));
      expect(sanitized, contains('"access_token":"[REDACTED]"'));
      expect(sanitized, isNot(contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9')));
      expect(sanitized, isNot(contains('refresh_secret_456')));
      expect(sanitized, isNot(contains('new_access_789')));
      expect(sanitized, isNot(contains('new_refresh_012')));
    });

    test('يمسح سيناريو كامل من OTP', () {
      const otpRequest = '''
        POST /auth/otp
        Body: {"otp":"123456","challenge_id":"ch-123"}
      ''';
      
      final sanitized = SecureLogger.sanitize(otpRequest);
      
      expect(sanitized, contains('"otp":"[REDACTED]"'));
      expect(sanitized, contains('"challenge_id":"ch-123"')); // يبقي الآمن
      expect(sanitized, isNot(contains('123456')));
    });
  });
}
