import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/secure_storage_service.dart';

/// Implementation of AuthRepository using Dio for API calls
/// and SecureStorage for token management
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  // API endpoints
  static const String _loginEndpoint = '/auth/login';
  static const String _verifyOtpEndpoint = '/auth/verify-otp';
  static const String _resendOtpEndpoint = '/auth/resend-otp';
  static const String _verifyDeviceEndpoint = '/auth/verify-device';
  static const String _refreshTokenEndpoint = '/auth/refresh-token';
  static const String _logoutEndpoint = '/auth/logout';

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      debugPrint('[AuthRepository] Login attempt for: ${request.phone}');

      final response = await _dio.post(
        _loginEndpoint,
        data: request.toJson(),
      );

      debugPrint('[AuthRepository] Login response received');

      final loginResponse = LoginResponse.fromJson(response.data);

      // If tokens are returned directly, save them
      if (loginResponse.tokens != null) {
        debugPrint('[AuthRepository] Tokens received, saving...');
        await saveTokens(loginResponse.tokens!);
      }

      // If user is returned, save user
      if (loginResponse.user != null) {
        debugPrint('[AuthRepository] User received, saving...');
        await saveUser(loginResponse.user!);
      }

      return Right(loginResponse);
    } on DioException catch (e) {
      debugPrint('[AuthRepository] Login failed: ${e.message}');
      return Left(_handleDioError(e, 'فشل تسجيل الدخول'));
    } catch (e) {
      debugPrint('[AuthRepository] Unexpected error during login: $e');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(
    OtpVerificationRequest request,
  ) async {
    try {
      debugPrint('[AuthRepository] Verifying OTP...');

      final response = await _dio.post(
        _verifyOtpEndpoint,
        data: request.toJson(),
      );

      debugPrint('[AuthRepository] OTP verification response received');

      final otpResponse = OtpVerificationResponse.fromJson(response.data);

      // Save tokens if returned
      if (otpResponse.tokens != null) {
        debugPrint('[AuthRepository] Tokens received after OTP, saving...');
        await saveTokens(otpResponse.tokens!);
      }

      // Save user if returned
      if (otpResponse.user != null) {
        debugPrint('[AuthRepository] User received after OTP, saving...');
        await saveUser(otpResponse.user!);
      }

      return Right(otpResponse);
    } on DioException catch (e) {
      debugPrint('[AuthRepository] OTP verification failed: ${e.message}');
      return Left(_handleDioError(e, 'فشل التحقق من الرمز'));
    } catch (e) {
      debugPrint('[AuthRepository] Unexpected error during OTP verification: $e');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(ResendOtpRequest request) async {
    try {
      debugPrint('[AuthRepository] Resending OTP...');

      await _dio.post(
        _resendOtpEndpoint,
        data: request.toJson(),
      );

      debugPrint('[AuthRepository] OTP resent successfully');

      return const Right(null);
    } on DioException catch (e) {
      debugPrint('[AuthRepository] Resend OTP failed: ${e.message}');
      return Left(_handleDioError(e, 'فشل إعادة إرسال الرمز'));
    } catch (e) {
      debugPrint('[AuthRepository] Unexpected error during OTP resend: $e');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, DeviceVerificationResponse>> verifyDevice(
    DeviceVerificationRequest request,
  ) async {
    try {
      debugPrint('[AuthRepository] Verifying device...');

      final response = await _dio.post(
        _verifyDeviceEndpoint,
        data: request.toJson(),
      );

      debugPrint('[AuthRepository] Device verification response received');

      final deviceResponse =
          DeviceVerificationResponse.fromJson(response.data);

      // Save tokens if verification successful
      if (deviceResponse.verified && deviceResponse.tokens != null) {
        debugPrint(
            '[AuthRepository] Device verified, saving tokens...');
        await saveTokens(deviceResponse.tokens!);
      }

      // Save user if returned
      if (deviceResponse.user != null) {
        debugPrint(
            '[AuthRepository] User received after device verification, saving...');
        await saveUser(deviceResponse.user!);
      }

      return Right(deviceResponse);
    } on DioException catch (e) {
      debugPrint('[AuthRepository] Device verification failed: ${e.message}');
      return Left(_handleDioError(e, 'فشل التحقق من الجهاز'));
    } catch (e) {
      debugPrint(
          '[AuthRepository] Unexpected error during device verification: $e');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken(
    String refreshToken,
  ) async {
    try {
      debugPrint('[AuthRepository] Refreshing token...');

      final response = await _dio.post(
        _refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      debugPrint('[AuthRepository] Token refresh successful');

      final newTokens = AuthTokens.fromJson(response.data);

      // Save new tokens
      await saveTokens(newTokens);

      return Right(newTokens);
    } on DioException catch (e) {
      debugPrint('[AuthRepository] Token refresh failed: ${e.message}');

      // Clear tokens on refresh failure (session expired)
      await clearTokens();
      await clearUser();

      return Left(_handleDioError(e, 'انتهت صلاحية الجلسة'));
    } catch (e) {
      debugPrint('[AuthRepository] Unexpected error during token refresh: $e');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      debugPrint('[AuthRepository] Logging out...');

      // Try to call logout endpoint (best effort)
      try {
        await _dio.post(_logoutEndpoint);
        debugPrint('[AuthRepository] Logout endpoint called successfully');
      } catch (e) {
        // Ignore endpoint errors, we'll clear local data anyway
        debugPrint('[AuthRepository] Logout endpoint failed (ignored): $e');
      }

      // Clear local tokens and user
      await clearTokens();
      await clearUser();

      debugPrint('[AuthRepository] Logout completed');

      return const Right(null);
    } catch (e) {
      debugPrint('[AuthRepository] Unexpected error during logout: $e');
      // Even on error, clear local data
      await clearTokens();
      await clearUser();
      return const Right(null);
    }
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    try {
      return await _storage.getTokens();
    } catch (e) {
      debugPrint('[AuthRepository] Error reading stored tokens: $e');
      return null;
    }
  }

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    try {
      await _storage.saveTokens(tokens);
    } catch (e) {
      debugPrint('[AuthRepository] Error saving tokens: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _storage.clearTokens();
    } catch (e) {
      debugPrint('[AuthRepository] Error clearing tokens: $e');
      // Don't rethrow, we want to continue with logout
    }
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    try {
      return await _storage.getUser();
    } catch (e) {
      debugPrint('[AuthRepository] Error reading stored user: $e');
      return null;
    }
  }

  @override
  Future<void> saveUser(AuthUser user) async {
    try {
      await _storage.saveUser(user);
    } catch (e) {
      debugPrint('[AuthRepository] Error saving user: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _storage.clearUser();
    } catch (e) {
      debugPrint('[AuthRepository] Error clearing user: $e');
      // Don't rethrow, we want to continue with logout
    }
  }

  /// Handle Dio errors and convert to Failure
  Failure _handleDioError(DioException error, String defaultMessage) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure(message: 'انتهت مهلة الاتصال');
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
          message: 'لا يوجد اتصال بالإنترنت');
    }

    // Try to extract error message from response
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return ServerFailure(message: data['message'] as String);
      }
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return ServerFailure(message: data['error'] as String);
      }
    }

    return ServerFailure(message: defaultMessage);
  }
}