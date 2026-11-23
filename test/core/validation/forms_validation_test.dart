import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phone Validation Tests', () {
    String? validatePhone(String? value) {
      if (value == null || value.isEmpty) {
        return 'رقم الهاتف مطلوب';
      }
      
      final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
      
      if (cleanPhone.length < 10) {
        return 'رقم الهاتف قصير جداً (على الأقل 10 أرقام)';
      }
      
      if (cleanPhone.length > 15) {
        return 'رقم الهاتف طويل جداً (حد أقصى 15 رقم)';
      }
      
      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(cleanPhone)) {
        return 'رقم الهاتف غير صحيح';
      }
      
      return null;
    }

    test('empty phone should return error', () {
      expect(validatePhone(''), isNotNull);
      expect(validatePhone(null), isNotNull);
    });

    test('valid phone numbers should pass', () {
      expect(validatePhone('1234567890'), isNull);
      expect(validatePhone('12345678901'), isNull);
      expect(validatePhone('+1234567890'), isNull);
      expect(validatePhone('123-456-7890'), isNull);
      expect(validatePhone('(123) 456-7890'), isNull);
    });

    test('short phone should return error', () {
      expect(validatePhone('123'), isNotNull);
      expect(validatePhone('123456789'), isNotNull);
    });

    test('long phone should return error', () {
      expect(validatePhone('1234567890123456'), isNotNull);
    });

    test('invalid characters should be removed and validated', () {
      expect(validatePhone('123-456-7890'), isNull);
      expect(validatePhone('(123) 456-7890'), isNull);
      expect(validatePhone('+1 (123) 456-7890'), isNull);
    });
  });

  group('Password Validation Tests', () {
    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'كلمة المرور مطلوبة';
      }
      
      if (value.length < 6) {
        return 'كلمة المرور قصيرة جداً (على الأقل 6 أحرف)';
      }
      
      if (value.length > 50) {
        return 'كلمة المرور طويلة جداً (حد أقصى 50 حرف)';
      }
      
      if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
        return 'يجب أن تحتوي على حرف واحد على الأقل';
      }
      
      if (!RegExp(r'\d').hasMatch(value)) {
        return 'يجب أن تحتوي على رقم واحد على الأقل';
      }
      
      return null;
    }

    test('empty password should return error', () {
      expect(validatePassword(''), isNotNull);
      expect(validatePassword(null), isNotNull);
    });

    test('valid passwords should pass', () {
      expect(validatePassword('Pass123'), isNull);
      expect(validatePassword('MyPassword1'), isNull);
      expect(validatePassword('test1234'), isNull);
      expect(validatePassword('ABC123def'), isNull);
    });

    test('short password should return error', () {
      expect(validatePassword('Pa1'), isNotNull);
      expect(validatePassword('12345'), isNotNull);
    });

    test('long password should return error', () {
      final longPass = 'A' * 51 + '1';
      expect(validatePassword(longPass), isNotNull);
    });

    test('password without letters should return error', () {
      expect(validatePassword('123456'), isNotNull);
      expect(validatePassword('12345678'), isNotNull);
    });

    test('password without numbers should return error', () {
      expect(validatePassword('Password'), isNotNull);
      expect(validatePassword('ABCDEFGH'), isNotNull);
    });

    test('password with letters and numbers should pass', () {
      expect(validatePassword('Password1'), isNull);
      expect(validatePassword('test123'), isNull);
      expect(validatePassword('ABC123'), isNull);
    });
  });

  group('OTP Validation Tests', () {
    String? validateOTP(String? value) {
      if (value == null || value.isEmpty) {
        return 'رمز التحقق مطلوب';
      }
      
      if (value.length != 6) {
        return 'رمز التحقق يجب أن يكون 6 أرقام';
      }
      
      if (!RegExp(r'^\d{6}$').hasMatch(value)) {
        return 'رمز التحقق يجب أن يحتوي على أرقام فقط';
      }
      
      return null;
    }

    test('empty OTP should return error', () {
      expect(validateOTP(''), isNotNull);
      expect(validateOTP(null), isNotNull);
    });

    test('valid OTP should pass', () {
      expect(validateOTP('123456'), isNull);
      expect(validateOTP('000000'), isNull);
      expect(validateOTP('999999'), isNull);
    });

    test('short OTP should return error', () {
      expect(validateOTP('123'), isNotNull);
      expect(validateOTP('12345'), isNotNull);
    });

    test('long OTP should return error', () {
      expect(validateOTP('1234567'), isNotNull);
      expect(validateOTP('12345678'), isNotNull);
    });

    test('OTP with letters should return error', () {
      expect(validateOTP('12345A'), isNotNull);
      expect(validateOTP('ABC123'), isNotNull);
    });

    test('OTP with special characters should return error', () {
      expect(validateOTP('12345!'), isNotNull);
      expect(validateOTP('123-456'), isNotNull);
    });
  });
}
