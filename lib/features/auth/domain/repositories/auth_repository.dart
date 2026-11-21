import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/auth_models.dart';

/// Authentication repository
abstract class AuthRepository {
  /// Login with phone and password
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  /// Verify OTP code
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(
    OtpVerificationRequest request,
  );

  /// Resend OTP code
  Future<Either<Failure, void>> resendOtp(ResendOtpRequest request);

  /// Verify device
  Future<Either<Failure, DeviceVerificationResponse>> verifyDevice(
    DeviceVerificationRequest request,
  );

  /// Refresh access token
  /// This should be called when access token expires
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken);

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Get current auth tokens from secure storage
  Future<AuthTokens?> getStoredTokens();

  /// Save tokens to secure storage
  Future<void> saveTokens(AuthTokens tokens);

  /// Clear tokens from secure storage
  Future<void> clearTokens();

  /// Get current user from secure storage
  Future<AuthUser?> getStoredUser();

  /// Save user to secure storage
  Future<void> saveUser(AuthUser user);

  /// Clear user from secure storage
  Future<void> clearUser();
}
