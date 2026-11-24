// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => _AuthTokens(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'deviceId': instance.deviceId,
    };

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  branchId: json['branchId'] as String?,
  branchName: json['branchName'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'roles': instance.roles,
  'permissions': instance.permissions,
  'branchId': instance.branchId,
  'branchName': instance.branchName,
};

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      username: json['username'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'phone': instance.phone,
      'password': instance.password,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
    };

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      requiresOtp: json['requiresOtp'] as bool,
      requiresDeviceVerification: json['requiresDeviceVerification'] as bool,
      sessionId: json['sessionId'] as String?,
      deviceVerificationId: json['deviceVerificationId'] as String?,
      tokens: json['tokens'] == null
          ? null
          : AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'requiresOtp': instance.requiresOtp,
      'requiresDeviceVerification': instance.requiresDeviceVerification,
      'sessionId': instance.sessionId,
      'deviceVerificationId': instance.deviceVerificationId,
      'tokens': instance.tokens,
      'user': instance.user,
    };

_OtpVerificationRequest _$OtpVerificationRequestFromJson(
  Map<String, dynamic> json,
) => _OtpVerificationRequest(
  sessionId: json['sessionId'] as String,
  otp: json['otp'] as String,
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$OtpVerificationRequestToJson(
  _OtpVerificationRequest instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'otp': instance.otp,
  'deviceId': instance.deviceId,
};

_OtpVerificationResponse _$OtpVerificationResponseFromJson(
  Map<String, dynamic> json,
) => _OtpVerificationResponse(
  requiresDeviceVerification: json['requiresDeviceVerification'] as bool,
  tokens: json['tokens'] == null
      ? null
      : AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
  deviceVerificationId: json['deviceVerificationId'] as String?,
);

Map<String, dynamic> _$OtpVerificationResponseToJson(
  _OtpVerificationResponse instance,
) => <String, dynamic>{
  'requiresDeviceVerification': instance.requiresDeviceVerification,
  'tokens': instance.tokens,
  'user': instance.user,
  'deviceVerificationId': instance.deviceVerificationId,
};

_DeviceVerificationRequest _$DeviceVerificationRequestFromJson(
  Map<String, dynamic> json,
) => _DeviceVerificationRequest(
  deviceVerificationId: json['deviceVerificationId'] as String,
  deviceId: json['deviceId'] as String,
  deviceName: json['deviceName'] as String,
);

Map<String, dynamic> _$DeviceVerificationRequestToJson(
  _DeviceVerificationRequest instance,
) => <String, dynamic>{
  'deviceVerificationId': instance.deviceVerificationId,
  'deviceId': instance.deviceId,
  'deviceName': instance.deviceName,
};

_DeviceVerificationResponse _$DeviceVerificationResponseFromJson(
  Map<String, dynamic> json,
) => _DeviceVerificationResponse(
  verified: json['verified'] as bool,
  tokens: json['tokens'] == null
      ? null
      : AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeviceVerificationResponseToJson(
  _DeviceVerificationResponse instance,
) => <String, dynamic>{
  'verified': instance.verified,
  'tokens': instance.tokens,
  'user': instance.user,
};

_ResendOtpRequest _$ResendOtpRequestFromJson(Map<String, dynamic> json) =>
    _ResendOtpRequest(sessionId: json['sessionId'] as String);

Map<String, dynamic> _$ResendOtpRequestToJson(_ResendOtpRequest instance) =>
    <String, dynamic>{'sessionId': instance.sessionId};

_NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    _NotificationPayload(
      type: json['type'] as String,
      id: json['id'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationPayloadToJson(
  _NotificationPayload instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'data': instance.data,
};
