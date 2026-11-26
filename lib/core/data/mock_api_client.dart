import 'dart:async';
import 'dart:math';
import '../errors/exceptions.dart';

/// Mock API Client - محاكاة الاتصال بالخادم
/// يستخدم في Development mode فقط
class MockApiClient {
  final Random _random = Random();
  final Duration _minDelay = const Duration(milliseconds: 200);
  final Duration _maxDelay = const Duration(milliseconds: 800);

  /// محاكاة الـ Network Latency
  Future<void> _simulateNetworkDelay() async {
    final delay =
        _minDelay.inMilliseconds +
        _random.nextInt(_maxDelay.inMilliseconds - _minDelay.inMilliseconds);
    await Future.delayed(Duration(milliseconds: delay));
  }

  /// محاكاة احتمالية حدوث خطأ في الشبكة
  void _simulateRandomNetworkError({double errorRate = 0.05}) {
    if (_random.nextDouble() < errorRate) {
      throw MockNetworkException('فشل الاتصال بالخادم');
    }
  }

  /// تنفيذ طلب GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool canFail = false,
  }) async {
    await _simulateNetworkDelay();
    if (canFail) _simulateRandomNetworkError();

    // Mock Response
    return {
      'success': true,
      'timestamp': DateTime.now().toIso8601String(),
      'data': null,
    };
  }

  /// تنفيذ طلب POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool canFail = false,
  }) async {
    await _simulateNetworkDelay();
    if (canFail) _simulateRandomNetworkError();

    return {
      'success': true,
      'timestamp': DateTime.now().toIso8601String(),
      'data': body,
    };
  }

  /// تنفيذ طلب PUT
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool canFail = false,
  }) async {
    await _simulateNetworkDelay();
    if (canFail) _simulateRandomNetworkError();

    return {
      'success': true,
      'timestamp': DateTime.now().toIso8601String(),
      'data': body,
    };
  }

  /// تنفيذ طلب PATCH
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool canFail = false,
  }) async {
    await _simulateNetworkDelay();
    if (canFail) _simulateRandomNetworkError();

    return {
      'success': true,
      'timestamp': DateTime.now().toIso8601String(),
      'data': body,
    };
  }

  /// تنفيذ طلب DELETE
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool canFail = false,
  }) async {
    await _simulateNetworkDelay();
    if (canFail) _simulateRandomNetworkError();

    return {'success': true, 'timestamp': DateTime.now().toIso8601String()};
  }
}
