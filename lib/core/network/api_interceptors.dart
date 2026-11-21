import 'package:codit/core/network/session_controller.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:codit/mocks/mock_api_server.dart';
import 'package:dio/dio.dart';

class MockRoutingInterceptor extends Interceptor {
  MockRoutingInterceptor(this._server);

  final MockApiServer _server;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final response = await _server.handle(options);
      if (response != null) {
        handler.resolve(response);
        return;
      }
    } on DioException catch (e) {
      handler.reject(e);
      return;
    }
    handler.next(options);
  }
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/otp') ||
        options.path.contains('/auth/device')) {
      handler.next(options);
      return;
    }
    final token = await _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required this.dio,
    required this.session,
    required this.storage,
    required this.onRefreshFailed,
  });

  final Dio dio;
  final SessionController session;
  final SecureStorageService storage;
  final void Function() onRefreshFailed;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }
    if (err.requestOptions.path.contains('/auth/refresh')) {
      onRefreshFailed();
      handler.next(err);
      return;
    }
    final refreshed = await session.refreshOnce((refreshToken) async {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      if (data == null) return false;
      await storage.saveSession(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        sessionGeneration: data['session_generation'] as int,
      );
      session.bumpSessionOnLogin(data['session_generation'] as int);
      return true;
    });
    if (!refreshed) {
      onRefreshFailed();
      handler.next(err);
      return;
    }
    final token = await storage.accessToken;
    final req = err.requestOptions;
    req.headers['Authorization'] = 'Bearer $token';
    try {
      final clone = await dio.fetch<dynamic>(req);
      handler.resolve(clone);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}