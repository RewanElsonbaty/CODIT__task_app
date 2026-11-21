import 'package:flutter/foundation.dart';

/// Logger آمن يمنع طباعة البيانات الحساسة (Tokens، Passwords، إلخ)
class SecureLogger {
  /// طباعة رسالة مع sanitization للبيانات الحساسة
  static void log(String message, {String? tag}) {
    if (!kDebugMode) return;
    
    final sanitized = sanitize(message);
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix$sanitized');
  }

  /// Error logging مع sanitization
  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    if (!kDebugMode) return;
    
    final sanitized = sanitize(message);
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix ERROR: $sanitized');
    
    if (error != null) {
      debugPrint('Error details: ${sanitize(error.toString())}');
    }
    
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }
  }

  /// Warning logging مع sanitization
  static void warn(String message, {String? tag}) {
    if (!kDebugMode) return;
    
    final sanitized = sanitize(message);
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix WARNING: $sanitized');
  }

  /// Info logging مع sanitization
  static void info(String message, {String? tag}) {
    if (!kDebugMode) return;
    
    final sanitized = sanitize(message);
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix INFO: $sanitized');
  }

  /// Sanitize البيانات الحساسة من الرسالة
  @visibleForTesting
  static String sanitize(String message) {
    var result = message;
    
    // Bearer tokens
    result = result.replaceAllMapped(
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false),
      (match) => 'Bearer [REDACTED]',
    );
    
    // Access tokens في JSON
    result = result.replaceAllMapped(
      RegExp(r'"access_token"\s*:\s*"[^"]*"', caseSensitive: false),
      (match) => '"access_token":"[REDACTED]"',
    );
    
    // Refresh tokens في JSON
    result = result.replaceAllMapped(
      RegExp(r'"refresh_token"\s*:\s*"[^"]*"', caseSensitive: false),
      (match) => '"refresh_token":"[REDACTED]"',
    );
    
    // Token field عام
    result = result.replaceAllMapped(
      RegExp(r'"token"\s*:\s*"[^"]*"', caseSensitive: false),
      (match) => '"token":"[REDACTED]"',
    );
    
    // Passwords
    result = result.replaceAllMapped(
      RegExp(r'"password"\s*:\s*"[^"]*"', caseSensitive: false),
      (match) => '"password":"[REDACTED]"',
    );
    
    // OTP codes
    result = result.replaceAllMapped(
      RegExp(r'"otp"\s*:\s*"[^"]*"', caseSensitive: false),
      (match) => '"otp":"[REDACTED]"',
    );
    
    // Credit card numbers (basic pattern)
    result = result.replaceAllMapped(
      RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b'),
      (match) => '[CARD-REDACTED]',
    );
    
    // Authorization headers
    result = result.replaceAllMapped(
      RegExp(r'Authorization\s*:\s*[^\s,}]+', caseSensitive: false),
      (match) => 'Authorization: [REDACTED]',
    );
    
    return result;
  }

  /// للاختبار - تحقق من أن الرسالة لا تحتوي على بيانات حساسة
  @visibleForTesting
  static bool isSafe(String message) {
    final patterns = [
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]{10,}', caseSensitive: false),
      RegExp(r'"access_token"\s*:\s*"[^"]{10,}"', caseSensitive: false),
      RegExp(r'"refresh_token"\s*:\s*"[^"]{10,}"', caseSensitive: false),
      RegExp(r'"password"\s*:\s*".+"', caseSensitive: false),
      RegExp(r'"otp"\s*:\s*"\d{4,}"', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      if (pattern.hasMatch(message)) {
        return false;
      }
    }
    
    return true;
  }
}
