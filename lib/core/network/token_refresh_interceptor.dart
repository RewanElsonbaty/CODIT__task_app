import 'dart:async';
import 'package:codit/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor للتعامل مع refresh token بذكاء
/// - طلب refresh واحد فقط للطلبات المتعددة
/// - إعادة محاولة واحدة فقط لكل طلب
/// - إنهاء الجلسة عند فشل refresh
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(
    this._dio,
    this._storage, {
    required this.onSessionExpired,
  });

  final Dio _dio;
  final SecureStorage _storage;
  final VoidCallback onSessionExpired;

  Future<String?>? _refreshFuture;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // فقط للـ 401 Unauthorized
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // تجنب infinite loop - كل طلب يعيد المحاولة مرة واحدة فقط
    if (err.requestOptions.extra['_retry'] == true) {
      return handler.next(err);
    }

    try {
      // محاولة الـ refresh
      final newToken = await _refreshTokenSafe();

      if (newToken == null) {
        // فشل الـ refresh - إنهاء الجلسة
        await _storage.clearAll();
        onSessionExpired();
        return handler.reject(err);
      }

      // إعادة المحاولة بالـ token الجديد
      final opts = Options(
        method: err.requestOptions.method,
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer $newToken',
        },
      );

      // علامة أن هذا retry
      err.requestOptions.extra['_retry'] = true;

      final response = await _dio.request<dynamic>(
        err.requestOptions.path,
        options: opts,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );

      return handler.resolve(response);
    } catch (e) {
      // أي خطأ في الـ refresh أو retry
      await _storage.clearAll();
      onSessionExpired();
      return handler.reject(err);
    }
  }

  /// Refresh مع ضمان طلب واحد فقط للمتعددين
  Future<String?> _refreshTokenSafe() async {
    // إذا يوجد refresh جاري، انتظر نتيجته
    if (_refreshFuture != null) {
      return await _refreshFuture;
    }

    // بدء refresh جديد
    _refreshFuture = _performRefresh();

    try {
      final token = await _refreshFuture;
      return token;
    } finally {
      // Reset للمرة القادمة
      _refreshFuture = null;
    }
  }

  Future<String?> _performRefresh() async {
    // التحقق من logout أثناء الـ refresh
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            // بدون Authorization header للـ refresh
          },
          extra: {
            '_skip_auth': true, // تخطي الـ interceptor لهذا الطلب
          },
        ),
      );

      final newAccessToken = response.data?['access_token'] as String?;
      final newRefreshToken = response.data?['refresh_token'] as String?;

      if (newAccessToken != null && newRefreshToken != null) {
        // التحقق مرة أخرى من عدم logout
        final stillLoggedIn = await _storage.getRefreshToken();
        if (stillLoggedIn == null) {
          // المستخدم عمل logout أثناء الـ refresh
          return null;
        }

        // حفظ الـ tokens الجديدة
        await _storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        return newAccessToken;
      }

      return null;
    } on DioException catch (e) {
      // Refresh token منتهي أو invalid
      if (e.response?.statusCode == 401) {
        return null;
      }
      rethrow;
    }
  }
}

/// Extension لتخطي الـ auth interceptor
extension RequestOptionsX on RequestOptions {
  bool get skipAuth => extra['_skip_auth'] == true;
}
