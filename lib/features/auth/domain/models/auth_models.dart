import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// Authentication tokens with refresh capability
@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    String? deviceId,
  }) = _AuthTokens;

  const AuthTokens._();

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  /// Check if access token is expired or will expire soon (within 5 minutes)
  bool get isExpired {
    final now = DateTime.now();
    final buffer = Duration(minutes: 5);
    return now.isAfter(expiresAt.subtract(buffer));
  }

  /// Check if access token is still valid
  bool get isValid => !isExpired;
}

/// User authentication state
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String phone,
    String? email,
    required List<String> roles,
    required List<String> permissions,
    String? branchId,
    String? branchName,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

/// Login request
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    required String password,
    String? deviceId,
    String? deviceName,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Login response
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool requiresOtp,
    required bool requiresDeviceVerification,
    String? sessionId, // For OTP verification
    AuthTokens? tokens, // If no OTP required
    AuthUser? user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// OTP verification request
@freezed
class OtpVerificationRequest with _$OtpVerificationRequest {
  const factory OtpVerificationRequest({
    required String sessionId,
    required String otp,
    String? deviceId,
  }) = _OtpVerificationRequest;

  factory OtpVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationRequestFromJson(json);
}

/// OTP verification response
@freezed
class OtpVerificationResponse with _$OtpVerificationResponse {
  const factory OtpVerificationResponse({
    required bool requiresDeviceVerification,
    AuthTokens? tokens,
    AuthUser? user,
    String? deviceVerificationId,
  }) = _OtpVerificationResponse;

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationResponseFromJson(json);
}

/// Device verification request
@freezed
class DeviceVerificationRequest with _$DeviceVerificationRequest {
  const factory DeviceVerificationRequest({
    required String deviceVerificationId,
    required String deviceId,
    required String deviceName,
  }) = _DeviceVerificationRequest;

  factory DeviceVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceVerificationRequestFromJson(json);
}

/// Device verification response
@freezed
class DeviceVerificationResponse with _$DeviceVerificationResponse {
  const factory DeviceVerificationResponse({
    required bool verified,
    AuthTokens? tokens,
    AuthUser? user,
  }) = _DeviceVerificationResponse;

  factory DeviceVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceVerificationResponseFromJson(json);
}

/// Resend OTP request
@freezed
class ResendOtpRequest with _$ResendOtpRequest {
  const factory ResendOtpRequest({
    required String sessionId,
  }) = _ResendOtpRequest;

  factory ResendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpRequestFromJson(json);
}

/// Notification payload for deep linking
@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required String type, // 'approval_request', 'sale', etc.
    required String id, // Resource ID
    Map<String, dynamic>? data,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}
