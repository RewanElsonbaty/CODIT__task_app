import 'package:codit/core/config/app_config.dart';
import 'package:codit/core/network/api_interceptors.dart';
import 'package:codit/core/network/session_controller.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:codit/mocks/mock_api_server.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({
    required AppConfig config,
    required MockApiServer mockServer,
    required SecureStorageService storage,
    required SessionController session,
    required void Function() onRefreshFailed,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: config.mockBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.addAll([
      MockRoutingInterceptor(mockServer),
      AuthInterceptor(storage),
      TokenRefreshInterceptor(
        dio: _dio,
        session: session,
        storage: storage,
        onRefreshFailed: onRefreshFailed,
      ),
    ]);
  }

  late final Dio _dio;
  Dio get dio => _dio;
}