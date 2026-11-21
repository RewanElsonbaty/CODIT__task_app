// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Checking value)?  checking,TResult Function( _Loading value)?  loading,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _OtpRequired value)?  otpRequired,TResult Function( _DeviceVerificationRequired value)?  deviceVerificationRequired,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Checking() when checking != null:
return checking(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpRequired() when otpRequired != null:
return otpRequired(_that);case _DeviceVerificationRequired() when deviceVerificationRequired != null:
return deviceVerificationRequired(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Checking value)  checking,required TResult Function( _Loading value)  loading,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _OtpRequired value)  otpRequired,required TResult Function( _DeviceVerificationRequired value)  deviceVerificationRequired,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Checking():
return checking(_that);case _Loading():
return loading(_that);case _Unauthenticated():
return unauthenticated(_that);case _OtpRequired():
return otpRequired(_that);case _DeviceVerificationRequired():
return deviceVerificationRequired(_that);case _Authenticated():
return authenticated(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Checking value)?  checking,TResult? Function( _Loading value)?  loading,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _OtpRequired value)?  otpRequired,TResult? Function( _DeviceVerificationRequired value)?  deviceVerificationRequired,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Checking() when checking != null:
return checking(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpRequired() when otpRequired != null:
return otpRequired(_that);case _DeviceVerificationRequired() when deviceVerificationRequired != null:
return deviceVerificationRequired(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  checking,TResult Function()?  loading,TResult Function( NotificationPayload? pendingNavigation)?  unauthenticated,TResult Function( String sessionId,  String phone,  DateTime? otpResentAt)?  otpRequired,TResult Function( String deviceVerificationId)?  deviceVerificationRequired,TResult Function( AuthUser user,  AuthTokens tokens,  NotificationPayload? pendingNavigation)?  authenticated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Checking() when checking != null:
return checking();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.pendingNavigation);case _OtpRequired() when otpRequired != null:
return otpRequired(_that.sessionId,_that.phone,_that.otpResentAt);case _DeviceVerificationRequired() when deviceVerificationRequired != null:
return deviceVerificationRequired(_that.deviceVerificationId);case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.tokens,_that.pendingNavigation);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  checking,required TResult Function()  loading,required TResult Function( NotificationPayload? pendingNavigation)  unauthenticated,required TResult Function( String sessionId,  String phone,  DateTime? otpResentAt)  otpRequired,required TResult Function( String deviceVerificationId)  deviceVerificationRequired,required TResult Function( AuthUser user,  AuthTokens tokens,  NotificationPayload? pendingNavigation)  authenticated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Checking():
return checking();case _Loading():
return loading();case _Unauthenticated():
return unauthenticated(_that.pendingNavigation);case _OtpRequired():
return otpRequired(_that.sessionId,_that.phone,_that.otpResentAt);case _DeviceVerificationRequired():
return deviceVerificationRequired(_that.deviceVerificationId);case _Authenticated():
return authenticated(_that.user,_that.tokens,_that.pendingNavigation);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  checking,TResult? Function()?  loading,TResult? Function( NotificationPayload? pendingNavigation)?  unauthenticated,TResult? Function( String sessionId,  String phone,  DateTime? otpResentAt)?  otpRequired,TResult? Function( String deviceVerificationId)?  deviceVerificationRequired,TResult? Function( AuthUser user,  AuthTokens tokens,  NotificationPayload? pendingNavigation)?  authenticated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Checking() when checking != null:
return checking();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.pendingNavigation);case _OtpRequired() when otpRequired != null:
return otpRequired(_that.sessionId,_that.phone,_that.otpResentAt);case _DeviceVerificationRequired() when deviceVerificationRequired != null:
return deviceVerificationRequired(_that.deviceVerificationId);case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.tokens,_that.pendingNavigation);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.initial()';
}


}




/// @nodoc


class _Checking implements AuthState {
  const _Checking();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.checking()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.loading()';
}


}




/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated({this.pendingNavigation});
  

 final  NotificationPayload? pendingNavigation;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthenticatedCopyWith<_Unauthenticated> get copyWith => __$UnauthenticatedCopyWithImpl<_Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated&&(identical(other.pendingNavigation, pendingNavigation) || other.pendingNavigation == pendingNavigation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pendingNavigation);
}

@override
String toString() {
    return 'AuthState.unauthenticated(pendingNavigation: $pendingNavigation)';
}


}

/// @nodoc
abstract mixin class _$UnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$UnauthenticatedCopyWith(_Unauthenticated value, $Res Function(_Unauthenticated) _then) = __$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 NotificationPayload? pendingNavigation
});


$NotificationPayloadCopyWith<$Res>? get pendingNavigation;

}
/// @nodoc
class __$UnauthenticatedCopyWithImpl<$Res>
    implements _$UnauthenticatedCopyWith<$Res> {
  __$UnauthenticatedCopyWithImpl(this._self, this._then);

  final _Unauthenticated _self;
  final $Res Function(_Unauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pendingNavigation = freezed,}) {
  return _then(_Unauthenticated(
pendingNavigation: freezed == pendingNavigation ? _self.pendingNavigation : pendingNavigation // ignore: cast_nullable_to_non_nullable
as NotificationPayload?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPayloadCopyWith<$Res>? get pendingNavigation {
    if (_self.pendingNavigation == null) {
    return null;
  }

  return $NotificationPayloadCopyWith<$Res>(_self.pendingNavigation!, (value) {
    return _then(_self.copyWith(pendingNavigation: value));
  });
}
}

/// @nodoc


class _OtpRequired implements AuthState {
  const _OtpRequired({required this.sessionId, required this.phone, this.otpResentAt});
  

 final  String sessionId;
 final  String phone;
 final  DateTime? otpResentAt;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpRequiredCopyWith<_OtpRequired> get copyWith => __$OtpRequiredCopyWithImpl<_OtpRequired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpRequired&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpResentAt, otpResentAt) || other.otpResentAt == otpResentAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,phone,otpResentAt);
}

@override
String toString() {
    return 'AuthState.otpRequired(sessionId: $sessionId, phone: $phone, otpResentAt: $otpResentAt)';
}


}

/// @nodoc
abstract mixin class _$OtpRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$OtpRequiredCopyWith(_OtpRequired value, $Res Function(_OtpRequired) _then) = __$OtpRequiredCopyWithImpl;
@useResult
$Res call({
 String sessionId, String phone, DateTime? otpResentAt
});




}
/// @nodoc
class __$OtpRequiredCopyWithImpl<$Res>
    implements _$OtpRequiredCopyWith<$Res> {
  __$OtpRequiredCopyWithImpl(this._self, this._then);

  final _OtpRequired _self;
  final $Res Function(_OtpRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? phone = null,Object? otpResentAt = freezed,}) {
  return _then(_OtpRequired(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otpResentAt: freezed == otpResentAt ? _self.otpResentAt : otpResentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _DeviceVerificationRequired implements AuthState {
  const _DeviceVerificationRequired({required this.deviceVerificationId});
  

 final  String deviceVerificationId;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceVerificationRequiredCopyWith<_DeviceVerificationRequired> get copyWith => __$DeviceVerificationRequiredCopyWithImpl<_DeviceVerificationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceVerificationRequired&&(identical(other.deviceVerificationId, deviceVerificationId) || other.deviceVerificationId == deviceVerificationId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceVerificationId);
}

@override
String toString() {
    return 'AuthState.deviceVerificationRequired(deviceVerificationId: $deviceVerificationId)';
}


}

/// @nodoc
abstract mixin class _$DeviceVerificationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$DeviceVerificationRequiredCopyWith(_DeviceVerificationRequired value, $Res Function(_DeviceVerificationRequired) _then) = __$DeviceVerificationRequiredCopyWithImpl;
@useResult
$Res call({
 String deviceVerificationId
});




}
/// @nodoc
class __$DeviceVerificationRequiredCopyWithImpl<$Res>
    implements _$DeviceVerificationRequiredCopyWith<$Res> {
  __$DeviceVerificationRequiredCopyWithImpl(this._self, this._then);

  final _DeviceVerificationRequired _self;
  final $Res Function(_DeviceVerificationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceVerificationId = null,}) {
  return _then(_DeviceVerificationRequired(
deviceVerificationId: null == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated({required this.user, required this.tokens, this.pendingNavigation});
  

 final  AuthUser user;
 final  AuthTokens tokens;
 final  NotificationPayload? pendingNavigation;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.pendingNavigation, pendingNavigation) || other.pendingNavigation == pendingNavigation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,tokens,pendingNavigation);
}

@override
String toString() {
    return 'AuthState.authenticated(user: $user, tokens: $tokens, pendingNavigation: $pendingNavigation)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthUser user, AuthTokens tokens, NotificationPayload? pendingNavigation
});


$AuthUserCopyWith<$Res> get user;$AuthTokensCopyWith<$Res> get tokens;$NotificationPayloadCopyWith<$Res>? get pendingNavigation;

}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? tokens = null,Object? pendingNavigation = freezed,}) {
  return _then(_Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,pendingNavigation: freezed == pendingNavigation ? _self.pendingNavigation : pendingNavigation // ignore: cast_nullable_to_non_nullable
as NotificationPayload?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPayloadCopyWith<$Res>? get pendingNavigation {
    if (_self.pendingNavigation == null) {
    return null;
  }

  return $NotificationPayloadCopyWith<$Res>(_self.pendingNavigation!, (value) {
    return _then(_self.copyWith(pendingNavigation: value));
  });
}
}

/// @nodoc


class _Error implements AuthState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
