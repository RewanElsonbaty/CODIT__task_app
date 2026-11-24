import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../authentication/data/mock_auth_api.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of AuthRepository using MockAuthApi
/// This bridges the old MockAuthApi with the new Clean Architecture structure
class MockAuthRepository implements AuthRepository {
  final MockAuthApi _mockApi;
  final SecureStorageService _storage;

  // Storage keys
  static const String _keyUser = 'user_data';

  MockAuthRepository(this._mockApi, this._storage);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      debugPrint('[MockAuthRepository] Login for: ${request.username}');

      // Call MockAuthApi
      final response = await _mockApi.login(
        username: request.username,
        password: request.password,
        deviceId: request.deviceId ?? 'unknown',
      );

      if (response['success'] != true) {
        return Left(ServerFailure(
          message: response['message'] as String? ?? 'فشل تسجيل الدخول',
        ));
      }

      final data = response['data'] as Map<String, dynamic>;
      
      // Convert to new models
      final tokens = AuthTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        expiresAt: DateTime.now().add(
          Duration(seconds: data['expires_in'] as int? ?? 3600),
        ),
        deviceId: request.deviceId,
      );

      final userData = data['user'] as Map<String, dynamic>;
      final user = AuthUser(
        id: userData['id'] as String,
        name: userData['fullName'] as String? ?? userData['username'] as String,
        phone: request.phone,
        roles: [userData['role'] as String],
        permissions: (userData['permissions'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        branchId: userData['branchId'] as String?,
      );

      // Save tokens and user
      await saveTokens(tokens);
      await saveUser(user);

      return Right(LoginResponse(
        requiresOtp: false,
        requiresDeviceVerification: false,
        tokens: tokens,
        user: user,
      ));
    } catch (e, stackTrace) {
      debugPrint('[MockAuthRepository] Login error: $e');
      debugPrint('[MockAuthRepository] Stack trace: $stackTrace');
      return Left(ServerFailure(
        message: e.toString().contains('اسم المستخدم أو كلمة المرور')
            ? 'اسم المستخدم أو كلمة المرور غير صحيحة'
            : 'حدث خطأ أثناء تسجيل الدخول',
      ));
    }
  }

  @override
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(
    OtpVerificationRequest request,
  ) async {
    // For Mock, OTP is always successful
    // In real implementation, this would call the backend
    debugPrint('[MockAuthRepository] OTP verification (mock)');
    
    return Right(OtpVerificationResponse(
      requiresDeviceVerification: false,
      tokens: await getStoredTokens(),
      user: await getStoredUser(),
    ));
  }

  @override
  Future<Either<Failure, void>> resendOtp(ResendOtpRequest request) async {
    debugPrint('[MockAuthRepository] Resend OTP (mock)');
    return const Right(null);
  }

  @override
  Future<Either<Failure, DeviceVerificationResponse>> verifyDevice(
    DeviceVerificationRequest request,
  ) async {
    debugPrint('[MockAuthRepository] Device verification (mock)');
    
    return Right(DeviceVerificationResponse(
      verified: true,
      tokens: await getStoredTokens(),
      user: await getStoredUser(),
    ));
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken) async {
    try {
      debugPrint('[MockAuthRepository] Refresh token');
      
      // MockAuthApi.refreshToken requires named parameters
      // For mock, we'll use a dummy sessionId since we don't track it
      final response = await _mockApi.refreshToken(
        refreshToken: refreshToken,
        sessionId: 'mock_session',  // Mock session ID
      );
      
      if (response['success'] != true) {
        return Left(ServerFailure(message: 'فشل تجديد الجلسة'));
      }

      final data = response['data'] as Map<String, dynamic>;
      final tokens = AuthTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        expiresAt: DateTime.now().add(
          Duration(seconds: data['expires_in'] as int? ?? 3600),
        ),
      );

      await saveTokens(tokens);
      return Right(tokens);
    } catch (e) {
      debugPrint('[MockAuthRepository] Refresh token error: $e');
      return Left(ServerFailure(message: 'فشل تجديد الجلسة'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    debugPrint('[MockAuthRepository] Logout');
    await clearTokens();
    await clearUser();
    return const Right(null);
  }

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    debugPrint('[MockAuthRepository] Saving tokens');
    await _storage.save('access_token', tokens.accessToken);
    await _storage.save('refresh_token', tokens.refreshToken);
    await _storage.save('token_expires_at', tokens.expiresAt.toIso8601String());
    if (tokens.deviceId != null) {
      await _storage.save('device_id', tokens.deviceId!);
    }
  }

  @override
  Future<void> clearTokens() async {
    debugPrint('[MockAuthRepository] Clearing tokens');
    await _storage.delete('access_token');
    await _storage.delete('refresh_token');
    await _storage.delete('token_expires_at');
    await _storage.delete('device_id');
  }

  @override
  Future<void> saveUser(AuthUser user) async {
    debugPrint('[MockAuthRepository] Saving user: ${user.id}');
    final userData = {
      'id': user.id,
      'name': user.name,
      'phone': user.phone,
      'email': user.email,
      'roles': user.roles,
      'permissions': user.permissions,
      'branchId': user.branchId,
      'branchName': user.branchName,
    };
    await _storage.save(_keyUser, userData.toString());
  }

  @override
  Future<void> clearUser() async {
    debugPrint('[MockAuthRepository] Clearing user');
    await _storage.delete(_keyUser);
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    try {
      final accessToken = await _storage.get('access_token');
      final refreshToken = await _storage.get('refresh_token');
      final expiresAtStr = await _storage.get('token_expires_at');
      final deviceId = await _storage.get('device_id');

      if (accessToken == null || refreshToken == null || expiresAtStr == null) {
        return null;
      }

      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: DateTime.parse(expiresAtStr),
        deviceId: deviceId,
      );
    } catch (e) {
      debugPrint('[MockAuthRepository] Error getting tokens: $e');
      return null;
    }
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    try {
      final userDataStr = await _storage.get(_keyUser);
      if (userDataStr == null) return null;

      // Parse stored user data
      // Note: In real implementation, store as JSON
      // For now, return null and require re-login
      return null;
    } catch (e) {
      debugPrint('[MockAuthRepository] Error getting user: $e');
      return null;
    }
  }
}
