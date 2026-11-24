// ignore_for_file: unused_import, argument_type_not_assignable, extra_positional_arguments, undefined_named_parameter
// DEPRECATED: Use new auth structure in lib/features/auth/
// @dart=2.19

import 'package:codit/core/errors/exceptions.dart';
import 'package:codit/core/network/session_controller.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:codit/features/authentication/domain/auth_session.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository(this._dio, this._storage, this._session);

  final Dio _dio;
  final SecureStorageService _storage;
  final SessionController _session;

  Future<AuthSession> login({
    required String username,
    required String phone,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'username': username,
        'phone': phone,
        'password': password,
      },
    );
    return AuthSession(
      step: AuthStep.otp,
      challengeId: res.data?['challenge_id'] as String?,
    );
  }

  Future<AuthSession> verifyOtp(String otp, AuthSession current) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/otp',
      data: {'otp': otp, 'challenge_id': current.challengeId},
    );
    final needsDevice = res.data?['device_trusted'] == false;
    return current.copyWith(
      step: needsDevice ? AuthStep.device : AuthStep.device,
    );
  }

  Future<AuthSession> verifyDevice() async {
    final res = await _dio.post<Map<String, dynamic>>('/auth/device', data: {});
    final data = res.data!;
    final gen = data['session_generation'] as int;
    await _storage.saveSession(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      sessionGeneration: gen,
    );
    _session.bumpSessionOnLogin(gen);
    await _session.loadGeneration();
    return AuthSession(
      step: AuthStep.authenticated,
      accessToken: data['access_token'] as String,
      accountId: data['account_id'] as String,
      shopName: data['shop_name'] as String,
      userName: data['user_name'] as String,
    );
  }

  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } catch (_) {}
    await _session.invalidateSession();
  }

  Future<bool> authorizeResource(String resourceId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/notifications/$resourceId',
    );
    return res.data?['allowed'] == true;
  }

  Future<void> restoreSession() async {
    final token = await _storage.accessToken;
    if (token == null) return;
    final res = await _dio.get<Map<String, dynamic>>('/auth/session');
    final data = res.data;
    if (data == null) throw AuthException();
    await _session.loadGeneration();
  }
}