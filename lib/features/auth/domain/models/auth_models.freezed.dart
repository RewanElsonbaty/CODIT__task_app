// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthTokens {

 String get accessToken; String get refreshToken; DateTime get expiresAt; String? get deviceId;
/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<AuthTokens> get copyWith => _$AuthTokensCopyWithImpl<AuthTokens>(this as AuthTokens, _$identity);

  /// Serializes this AuthTokens to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthTokens;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokens&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthTokens;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.expiresAt,_this.deviceId);
}

@override
String toString() {
  final _this = this as AuthTokens;
  return 'AuthTokens(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresAt: ${_this.expiresAt}, deviceId: ${_this.deviceId})';
}


}

/// @nodoc
abstract mixin class $AuthTokensCopyWith<$Res>  {
  factory $AuthTokensCopyWith(AuthTokens value, $Res Function(AuthTokens) _then) = _$AuthTokensCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt, String? deviceId
});




}
/// @nodoc
class _$AuthTokensCopyWithImpl<$Res>
    implements $AuthTokensCopyWith<$Res> {
  _$AuthTokensCopyWithImpl(this._self, this._then);

  final AuthTokens _self;
  final $Res Function(AuthTokens) _then;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,Object? deviceId = freezed,}) {
  return _then(AuthTokens(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthTokens].
extension AuthTokensPatterns on AuthTokens {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokens value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokens value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokens():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokens value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _AuthTokens():
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  DateTime expiresAt,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokens extends AuthTokens {
  const _AuthTokens({required this.accessToken, required this.refreshToken, required this.expiresAt, this.deviceId}): super._();
  factory _AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  DateTime expiresAt;
@override final  String? deviceId;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokensCopyWith<_AuthTokens> get copyWith => __$AuthTokensCopyWithImpl<_AuthTokens>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokensToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokens&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,expiresAt,deviceId);
}

@override
String toString() {
    return 'AuthTokens(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$AuthTokensCopyWith<$Res> implements $AuthTokensCopyWith<$Res> {
  factory _$AuthTokensCopyWith(_AuthTokens value, $Res Function(_AuthTokens) _then) = __$AuthTokensCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt, String? deviceId
});




}
/// @nodoc
class __$AuthTokensCopyWithImpl<$Res>
    implements _$AuthTokensCopyWith<$Res> {
  __$AuthTokensCopyWithImpl(this._self, this._then);

  final _AuthTokens _self;
  final $Res Function(_AuthTokens) _then;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,Object? deviceId = freezed,}) {
  return _then(_AuthTokens(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AuthUser {

 String get id; String get name; String get phone; String? get email; List<String> get roles; List<String> get permissions; String? get branchId; String? get branchName;
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserCopyWith<AuthUser> get copyWith => _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&const DeepCollectionEquality().equals(other.roles, _this.roles)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.branchName, _this.branchName) || other.branchName == _this.branchName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.email,const DeepCollectionEquality().hash(_this.roles),const DeepCollectionEquality().hash(_this.permissions),_this.branchId,_this.branchName);
}

@override
String toString() {
  final _this = this as AuthUser;
  return 'AuthUser(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email}, roles: ${_this.roles}, permissions: ${_this.permissions}, branchId: ${_this.branchId}, branchName: ${_this.branchName})';
}


}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res>  {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) = _$AuthUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String? email, List<String> roles, List<String> permissions, String? branchId, String? branchName
});




}
/// @nodoc
class _$AuthUserCopyWithImpl<$Res>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? roles = null,Object? permissions = null,Object? branchId = freezed,Object? branchName = freezed,}) {
  return _then(AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String? email,  List<String> roles,  List<String> permissions,  String? branchId,  String? branchName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.roles,_that.permissions,_that.branchId,_that.branchName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String? email,  List<String> roles,  List<String> permissions,  String? branchId,  String? branchName)  $default,) {final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.roles,_that.permissions,_that.branchId,_that.branchName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String? email,  List<String> roles,  List<String> permissions,  String? branchId,  String? branchName)?  $default,) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.roles,_that.permissions,_that.branchId,_that.branchName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUser implements AuthUser {
  const _AuthUser({required this.id, required this.name, required this.phone, this.email, required  List<String> roles, required  List<String> permissions, this.branchId, this.branchName}): _roles = roles,_permissions = permissions;
  factory _AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  String? email;
 final  List<String> _roles;
@override List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

 final  List<String> _permissions;
@override List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override final  String? branchId;
@override final  String? branchName;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserCopyWith<_AuthUser> get copyWith => __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.roles, _roles)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,email,const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_permissions),branchId,branchName);
}

@override
String toString() {
    return 'AuthUser(id: $id, name: $name, phone: $phone, email: $email, roles: $roles, permissions: $permissions, branchId: $branchId, branchName: $branchName)';
}


}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) = __$AuthUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String? email, List<String> roles, List<String> permissions, String? branchId, String? branchName
});




}
/// @nodoc
class __$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? roles = null,Object? permissions = null,Object? branchId = freezed,Object? branchName = freezed,}) {
  return _then(_AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LoginRequest {

 String get username; String get phone; String get password; String? get deviceId; String? get deviceName;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginRequest;
  return Object.hash(runtimeType,_this.username,_this.phone,_this.password,_this.deviceId,_this.deviceName);
}

@override
String toString() {
  final _this = this as LoginRequest;
  return 'LoginRequest(username: ${_this.username}, phone: ${_this.phone}, password: ${_this.password}, deviceId: ${_this.deviceId}, deviceName: ${_this.deviceName})';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String username, String phone, String password, String? deviceId, String? deviceName
});




}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? phone = null,Object? password = null,Object? deviceId = freezed,Object? deviceName = freezed,}) {
  return _then(LoginRequest(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String phone,  String password,  String? deviceId,  String? deviceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.username,_that.phone,_that.password,_that.deviceId,_that.deviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String phone,  String password,  String? deviceId,  String? deviceName)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.username,_that.phone,_that.password,_that.deviceId,_that.deviceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String phone,  String password,  String? deviceId,  String? deviceName)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.username,_that.phone,_that.password,_that.deviceId,_that.deviceName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest implements LoginRequest {
  const _LoginRequest({required this.username, required this.phone, required this.password, this.deviceId, this.deviceName});
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String username;
@override final  String phone;
@override final  String password;
@override final  String? deviceId;
@override final  String? deviceName;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.username, username) || other.username == username)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,username,phone,password,deviceId,deviceName);
}

@override
String toString() {
    return 'LoginRequest(username: $username, phone: $phone, password: $password, deviceId: $deviceId, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String username, String phone, String password, String? deviceId, String? deviceName
});




}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? phone = null,Object? password = null,Object? deviceId = freezed,Object? deviceName = freezed,}) {
  return _then(_LoginRequest(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LoginResponse {

 bool get requiresOtp; bool get requiresDeviceVerification; String? get sessionId; String? get deviceVerificationId; AuthTokens? get tokens; AuthUser? get user;
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseCopyWith<LoginResponse> get copyWith => _$LoginResponseCopyWithImpl<LoginResponse>(this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponse&&(identical(other.requiresOtp, _this.requiresOtp) || other.requiresOtp == _this.requiresOtp)&&(identical(other.requiresDeviceVerification, _this.requiresDeviceVerification) || other.requiresDeviceVerification == _this.requiresDeviceVerification)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.deviceVerificationId, _this.deviceVerificationId) || other.deviceVerificationId == _this.deviceVerificationId)&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginResponse;
  return Object.hash(runtimeType,_this.requiresOtp,_this.requiresDeviceVerification,_this.sessionId,_this.deviceVerificationId,_this.tokens,_this.user);
}

@override
String toString() {
  final _this = this as LoginResponse;
  return 'LoginResponse(requiresOtp: ${_this.requiresOtp}, requiresDeviceVerification: ${_this.requiresDeviceVerification}, sessionId: ${_this.sessionId}, deviceVerificationId: ${_this.deviceVerificationId}, tokens: ${_this.tokens}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res>  {
  factory $LoginResponseCopyWith(LoginResponse value, $Res Function(LoginResponse) _then) = _$LoginResponseCopyWithImpl;
@useResult
$Res call({
 bool requiresOtp, bool requiresDeviceVerification, String? sessionId, String? deviceVerificationId, AuthTokens? tokens, AuthUser? user
});


$AuthTokensCopyWith<$Res>? get tokens;$AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiresOtp = null,Object? requiresDeviceVerification = null,Object? sessionId = freezed,Object? deviceVerificationId = freezed,Object? tokens = freezed,Object? user = freezed,}) {
  return _then(LoginResponse(
requiresOtp: null == requiresOtp ? _self.requiresOtp : requiresOtp // ignore: cast_nullable_to_non_nullable
as bool,requiresDeviceVerification: null == requiresDeviceVerification ? _self.requiresDeviceVerification : requiresDeviceVerification // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,deviceVerificationId: freezed == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String?,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,
  ));
}
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginResponse].
extension LoginResponsePatterns on LoginResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool requiresOtp,  bool requiresDeviceVerification,  String? sessionId,  String? deviceVerificationId,  AuthTokens? tokens,  AuthUser? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.requiresOtp,_that.requiresDeviceVerification,_that.sessionId,_that.deviceVerificationId,_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool requiresOtp,  bool requiresDeviceVerification,  String? sessionId,  String? deviceVerificationId,  AuthTokens? tokens,  AuthUser? user)  $default,) {final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that.requiresOtp,_that.requiresDeviceVerification,_that.sessionId,_that.deviceVerificationId,_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool requiresOtp,  bool requiresDeviceVerification,  String? sessionId,  String? deviceVerificationId,  AuthTokens? tokens,  AuthUser? user)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.requiresOtp,_that.requiresDeviceVerification,_that.sessionId,_that.deviceVerificationId,_that.tokens,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponse implements LoginResponse {
  const _LoginResponse({required this.requiresOtp, required this.requiresDeviceVerification, this.sessionId, this.deviceVerificationId, this.tokens, this.user});
  factory _LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

@override final  bool requiresOtp;
@override final  bool requiresDeviceVerification;
@override final  String? sessionId;
@override final  String? deviceVerificationId;
@override final  AuthTokens? tokens;
@override final  AuthUser? user;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseCopyWith<_LoginResponse> get copyWith => __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponse&&(identical(other.requiresOtp, requiresOtp) || other.requiresOtp == requiresOtp)&&(identical(other.requiresDeviceVerification, requiresDeviceVerification) || other.requiresDeviceVerification == requiresDeviceVerification)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deviceVerificationId, deviceVerificationId) || other.deviceVerificationId == deviceVerificationId)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requiresOtp,requiresDeviceVerification,sessionId,deviceVerificationId,tokens,user);
}

@override
String toString() {
    return 'LoginResponse(requiresOtp: $requiresOtp, requiresDeviceVerification: $requiresDeviceVerification, sessionId: $sessionId, deviceVerificationId: $deviceVerificationId, tokens: $tokens, user: $user)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res> implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(_LoginResponse value, $Res Function(_LoginResponse) _then) = __$LoginResponseCopyWithImpl;
@override @useResult
$Res call({
 bool requiresOtp, bool requiresDeviceVerification, String? sessionId, String? deviceVerificationId, AuthTokens? tokens, AuthUser? user
});


@override $AuthTokensCopyWith<$Res>? get tokens;@override $AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiresOtp = null,Object? requiresDeviceVerification = null,Object? sessionId = freezed,Object? deviceVerificationId = freezed,Object? tokens = freezed,Object? user = freezed,}) {
  return _then(_LoginResponse(
requiresOtp: null == requiresOtp ? _self.requiresOtp : requiresOtp // ignore: cast_nullable_to_non_nullable
as bool,requiresDeviceVerification: null == requiresDeviceVerification ? _self.requiresDeviceVerification : requiresDeviceVerification // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,deviceVerificationId: freezed == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String?,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,
  ));
}

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$OtpVerificationRequest {

 String get sessionId; String get otp; String? get deviceId;
/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerificationRequestCopyWith<OtpVerificationRequest> get copyWith => _$OtpVerificationRequestCopyWithImpl<OtpVerificationRequest>(this as OtpVerificationRequest, _$identity);

  /// Serializes this OtpVerificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OtpVerificationRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerificationRequest&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.otp, _this.otp) || other.otp == _this.otp)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OtpVerificationRequest;
  return Object.hash(runtimeType,_this.sessionId,_this.otp,_this.deviceId);
}

@override
String toString() {
  final _this = this as OtpVerificationRequest;
  return 'OtpVerificationRequest(sessionId: ${_this.sessionId}, otp: ${_this.otp}, deviceId: ${_this.deviceId})';
}


}

/// @nodoc
abstract mixin class $OtpVerificationRequestCopyWith<$Res>  {
  factory $OtpVerificationRequestCopyWith(OtpVerificationRequest value, $Res Function(OtpVerificationRequest) _then) = _$OtpVerificationRequestCopyWithImpl;
@useResult
$Res call({
 String sessionId, String otp, String? deviceId
});




}
/// @nodoc
class _$OtpVerificationRequestCopyWithImpl<$Res>
    implements $OtpVerificationRequestCopyWith<$Res> {
  _$OtpVerificationRequestCopyWithImpl(this._self, this._then);

  final OtpVerificationRequest _self;
  final $Res Function(OtpVerificationRequest) _then;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? otp = null,Object? deviceId = freezed,}) {
  return _then(OtpVerificationRequest(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpVerificationRequest].
extension OtpVerificationRequestPatterns on OtpVerificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpVerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpVerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationRequest():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpVerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String otp,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that.sessionId,_that.otp,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String otp,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationRequest():
return $default(_that.sessionId,_that.otp,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String otp,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that.sessionId,_that.otp,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtpVerificationRequest implements OtpVerificationRequest {
  const _OtpVerificationRequest({required this.sessionId, required this.otp, this.deviceId});
  factory _OtpVerificationRequest.fromJson(Map<String, dynamic> json) => _$OtpVerificationRequestFromJson(json);

@override final  String sessionId;
@override final  String otp;
@override final  String? deviceId;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerificationRequestCopyWith<_OtpVerificationRequest> get copyWith => __$OtpVerificationRequestCopyWithImpl<_OtpVerificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpVerificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerificationRequest&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,otp,deviceId);
}

@override
String toString() {
    return 'OtpVerificationRequest(sessionId: $sessionId, otp: $otp, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$OtpVerificationRequestCopyWith<$Res> implements $OtpVerificationRequestCopyWith<$Res> {
  factory _$OtpVerificationRequestCopyWith(_OtpVerificationRequest value, $Res Function(_OtpVerificationRequest) _then) = __$OtpVerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String otp, String? deviceId
});




}
/// @nodoc
class __$OtpVerificationRequestCopyWithImpl<$Res>
    implements _$OtpVerificationRequestCopyWith<$Res> {
  __$OtpVerificationRequestCopyWithImpl(this._self, this._then);

  final _OtpVerificationRequest _self;
  final $Res Function(_OtpVerificationRequest) _then;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? otp = null,Object? deviceId = freezed,}) {
  return _then(_OtpVerificationRequest(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OtpVerificationResponse {

 bool get requiresDeviceVerification; AuthTokens? get tokens; AuthUser? get user; String? get deviceVerificationId;
/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerificationResponseCopyWith<OtpVerificationResponse> get copyWith => _$OtpVerificationResponseCopyWithImpl<OtpVerificationResponse>(this as OtpVerificationResponse, _$identity);

  /// Serializes this OtpVerificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OtpVerificationResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerificationResponse&&(identical(other.requiresDeviceVerification, _this.requiresDeviceVerification) || other.requiresDeviceVerification == _this.requiresDeviceVerification)&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.deviceVerificationId, _this.deviceVerificationId) || other.deviceVerificationId == _this.deviceVerificationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OtpVerificationResponse;
  return Object.hash(runtimeType,_this.requiresDeviceVerification,_this.tokens,_this.user,_this.deviceVerificationId);
}

@override
String toString() {
  final _this = this as OtpVerificationResponse;
  return 'OtpVerificationResponse(requiresDeviceVerification: ${_this.requiresDeviceVerification}, tokens: ${_this.tokens}, user: ${_this.user}, deviceVerificationId: ${_this.deviceVerificationId})';
}


}

/// @nodoc
abstract mixin class $OtpVerificationResponseCopyWith<$Res>  {
  factory $OtpVerificationResponseCopyWith(OtpVerificationResponse value, $Res Function(OtpVerificationResponse) _then) = _$OtpVerificationResponseCopyWithImpl;
@useResult
$Res call({
 bool requiresDeviceVerification, AuthTokens? tokens, AuthUser? user, String? deviceVerificationId
});


$AuthTokensCopyWith<$Res>? get tokens;$AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$OtpVerificationResponseCopyWithImpl<$Res>
    implements $OtpVerificationResponseCopyWith<$Res> {
  _$OtpVerificationResponseCopyWithImpl(this._self, this._then);

  final OtpVerificationResponse _self;
  final $Res Function(OtpVerificationResponse) _then;

/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiresDeviceVerification = null,Object? tokens = freezed,Object? user = freezed,Object? deviceVerificationId = freezed,}) {
  return _then(OtpVerificationResponse(
requiresDeviceVerification: null == requiresDeviceVerification ? _self.requiresDeviceVerification : requiresDeviceVerification // ignore: cast_nullable_to_non_nullable
as bool,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,deviceVerificationId: freezed == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [OtpVerificationResponse].
extension OtpVerificationResponsePatterns on OtpVerificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpVerificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpVerificationResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpVerificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationResponse():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpVerificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool requiresDeviceVerification,  AuthTokens? tokens,  AuthUser? user,  String? deviceVerificationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpVerificationResponse() when $default != null:
return $default(_that.requiresDeviceVerification,_that.tokens,_that.user,_that.deviceVerificationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool requiresDeviceVerification,  AuthTokens? tokens,  AuthUser? user,  String? deviceVerificationId)  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationResponse():
return $default(_that.requiresDeviceVerification,_that.tokens,_that.user,_that.deviceVerificationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool requiresDeviceVerification,  AuthTokens? tokens,  AuthUser? user,  String? deviceVerificationId)?  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationResponse() when $default != null:
return $default(_that.requiresDeviceVerification,_that.tokens,_that.user,_that.deviceVerificationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtpVerificationResponse implements OtpVerificationResponse {
  const _OtpVerificationResponse({required this.requiresDeviceVerification, this.tokens, this.user, this.deviceVerificationId});
  factory _OtpVerificationResponse.fromJson(Map<String, dynamic> json) => _$OtpVerificationResponseFromJson(json);

@override final  bool requiresDeviceVerification;
@override final  AuthTokens? tokens;
@override final  AuthUser? user;
@override final  String? deviceVerificationId;

/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerificationResponseCopyWith<_OtpVerificationResponse> get copyWith => __$OtpVerificationResponseCopyWithImpl<_OtpVerificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpVerificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerificationResponse&&(identical(other.requiresDeviceVerification, requiresDeviceVerification) || other.requiresDeviceVerification == requiresDeviceVerification)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.user, user) || other.user == user)&&(identical(other.deviceVerificationId, deviceVerificationId) || other.deviceVerificationId == deviceVerificationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requiresDeviceVerification,tokens,user,deviceVerificationId);
}

@override
String toString() {
    return 'OtpVerificationResponse(requiresDeviceVerification: $requiresDeviceVerification, tokens: $tokens, user: $user, deviceVerificationId: $deviceVerificationId)';
}


}

/// @nodoc
abstract mixin class _$OtpVerificationResponseCopyWith<$Res> implements $OtpVerificationResponseCopyWith<$Res> {
  factory _$OtpVerificationResponseCopyWith(_OtpVerificationResponse value, $Res Function(_OtpVerificationResponse) _then) = __$OtpVerificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool requiresDeviceVerification, AuthTokens? tokens, AuthUser? user, String? deviceVerificationId
});


@override $AuthTokensCopyWith<$Res>? get tokens;@override $AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$OtpVerificationResponseCopyWithImpl<$Res>
    implements _$OtpVerificationResponseCopyWith<$Res> {
  __$OtpVerificationResponseCopyWithImpl(this._self, this._then);

  final _OtpVerificationResponse _self;
  final $Res Function(_OtpVerificationResponse) _then;

/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiresDeviceVerification = null,Object? tokens = freezed,Object? user = freezed,Object? deviceVerificationId = freezed,}) {
  return _then(_OtpVerificationResponse(
requiresDeviceVerification: null == requiresDeviceVerification ? _self.requiresDeviceVerification : requiresDeviceVerification // ignore: cast_nullable_to_non_nullable
as bool,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,deviceVerificationId: freezed == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of OtpVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$DeviceVerificationRequest {

 String get deviceVerificationId; String get deviceId; String get deviceName;
/// Create a copy of DeviceVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceVerificationRequestCopyWith<DeviceVerificationRequest> get copyWith => _$DeviceVerificationRequestCopyWithImpl<DeviceVerificationRequest>(this as DeviceVerificationRequest, _$identity);

  /// Serializes this DeviceVerificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceVerificationRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceVerificationRequest&&(identical(other.deviceVerificationId, _this.deviceVerificationId) || other.deviceVerificationId == _this.deviceVerificationId)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceVerificationRequest;
  return Object.hash(runtimeType,_this.deviceVerificationId,_this.deviceId,_this.deviceName);
}

@override
String toString() {
  final _this = this as DeviceVerificationRequest;
  return 'DeviceVerificationRequest(deviceVerificationId: ${_this.deviceVerificationId}, deviceId: ${_this.deviceId}, deviceName: ${_this.deviceName})';
}


}

/// @nodoc
abstract mixin class $DeviceVerificationRequestCopyWith<$Res>  {
  factory $DeviceVerificationRequestCopyWith(DeviceVerificationRequest value, $Res Function(DeviceVerificationRequest) _then) = _$DeviceVerificationRequestCopyWithImpl;
@useResult
$Res call({
 String deviceVerificationId, String deviceId, String deviceName
});




}
/// @nodoc
class _$DeviceVerificationRequestCopyWithImpl<$Res>
    implements $DeviceVerificationRequestCopyWith<$Res> {
  _$DeviceVerificationRequestCopyWithImpl(this._self, this._then);

  final DeviceVerificationRequest _self;
  final $Res Function(DeviceVerificationRequest) _then;

/// Create a copy of DeviceVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceVerificationId = null,Object? deviceId = null,Object? deviceName = null,}) {
  return _then(DeviceVerificationRequest(
deviceVerificationId: null == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceVerificationRequest].
extension DeviceVerificationRequestPatterns on DeviceVerificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceVerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceVerificationRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceVerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeviceVerificationRequest():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceVerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceVerificationRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceVerificationId,  String deviceId,  String deviceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceVerificationRequest() when $default != null:
return $default(_that.deviceVerificationId,_that.deviceId,_that.deviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceVerificationId,  String deviceId,  String deviceName)  $default,) {final _that = this;
switch (_that) {
case _DeviceVerificationRequest():
return $default(_that.deviceVerificationId,_that.deviceId,_that.deviceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceVerificationId,  String deviceId,  String deviceName)?  $default,) {final _that = this;
switch (_that) {
case _DeviceVerificationRequest() when $default != null:
return $default(_that.deviceVerificationId,_that.deviceId,_that.deviceName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceVerificationRequest implements DeviceVerificationRequest {
  const _DeviceVerificationRequest({required this.deviceVerificationId, required this.deviceId, required this.deviceName});
  factory _DeviceVerificationRequest.fromJson(Map<String, dynamic> json) => _$DeviceVerificationRequestFromJson(json);

@override final  String deviceVerificationId;
@override final  String deviceId;
@override final  String deviceName;

/// Create a copy of DeviceVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceVerificationRequestCopyWith<_DeviceVerificationRequest> get copyWith => __$DeviceVerificationRequestCopyWithImpl<_DeviceVerificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceVerificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceVerificationRequest&&(identical(other.deviceVerificationId, deviceVerificationId) || other.deviceVerificationId == deviceVerificationId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceVerificationId,deviceId,deviceName);
}

@override
String toString() {
    return 'DeviceVerificationRequest(deviceVerificationId: $deviceVerificationId, deviceId: $deviceId, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class _$DeviceVerificationRequestCopyWith<$Res> implements $DeviceVerificationRequestCopyWith<$Res> {
  factory _$DeviceVerificationRequestCopyWith(_DeviceVerificationRequest value, $Res Function(_DeviceVerificationRequest) _then) = __$DeviceVerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String deviceVerificationId, String deviceId, String deviceName
});




}
/// @nodoc
class __$DeviceVerificationRequestCopyWithImpl<$Res>
    implements _$DeviceVerificationRequestCopyWith<$Res> {
  __$DeviceVerificationRequestCopyWithImpl(this._self, this._then);

  final _DeviceVerificationRequest _self;
  final $Res Function(_DeviceVerificationRequest) _then;

/// Create a copy of DeviceVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceVerificationId = null,Object? deviceId = null,Object? deviceName = null,}) {
  return _then(_DeviceVerificationRequest(
deviceVerificationId: null == deviceVerificationId ? _self.deviceVerificationId : deviceVerificationId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeviceVerificationResponse {

 bool get verified; AuthTokens? get tokens; AuthUser? get user;
/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceVerificationResponseCopyWith<DeviceVerificationResponse> get copyWith => _$DeviceVerificationResponseCopyWithImpl<DeviceVerificationResponse>(this as DeviceVerificationResponse, _$identity);

  /// Serializes this DeviceVerificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceVerificationResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceVerificationResponse&&(identical(other.verified, _this.verified) || other.verified == _this.verified)&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceVerificationResponse;
  return Object.hash(runtimeType,_this.verified,_this.tokens,_this.user);
}

@override
String toString() {
  final _this = this as DeviceVerificationResponse;
  return 'DeviceVerificationResponse(verified: ${_this.verified}, tokens: ${_this.tokens}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $DeviceVerificationResponseCopyWith<$Res>  {
  factory $DeviceVerificationResponseCopyWith(DeviceVerificationResponse value, $Res Function(DeviceVerificationResponse) _then) = _$DeviceVerificationResponseCopyWithImpl;
@useResult
$Res call({
 bool verified, AuthTokens? tokens, AuthUser? user
});


$AuthTokensCopyWith<$Res>? get tokens;$AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$DeviceVerificationResponseCopyWithImpl<$Res>
    implements $DeviceVerificationResponseCopyWith<$Res> {
  _$DeviceVerificationResponseCopyWithImpl(this._self, this._then);

  final DeviceVerificationResponse _self;
  final $Res Function(DeviceVerificationResponse) _then;

/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verified = null,Object? tokens = freezed,Object? user = freezed,}) {
  return _then(DeviceVerificationResponse(
verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,
  ));
}
/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceVerificationResponse].
extension DeviceVerificationResponsePatterns on DeviceVerificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceVerificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceVerificationResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceVerificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeviceVerificationResponse():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceVerificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceVerificationResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool verified,  AuthTokens? tokens,  AuthUser? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceVerificationResponse() when $default != null:
return $default(_that.verified,_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool verified,  AuthTokens? tokens,  AuthUser? user)  $default,) {final _that = this;
switch (_that) {
case _DeviceVerificationResponse():
return $default(_that.verified,_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool verified,  AuthTokens? tokens,  AuthUser? user)?  $default,) {final _that = this;
switch (_that) {
case _DeviceVerificationResponse() when $default != null:
return $default(_that.verified,_that.tokens,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceVerificationResponse implements DeviceVerificationResponse {
  const _DeviceVerificationResponse({required this.verified, this.tokens, this.user});
  factory _DeviceVerificationResponse.fromJson(Map<String, dynamic> json) => _$DeviceVerificationResponseFromJson(json);

@override final  bool verified;
@override final  AuthTokens? tokens;
@override final  AuthUser? user;

/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceVerificationResponseCopyWith<_DeviceVerificationResponse> get copyWith => __$DeviceVerificationResponseCopyWithImpl<_DeviceVerificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceVerificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceVerificationResponse&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,verified,tokens,user);
}

@override
String toString() {
    return 'DeviceVerificationResponse(verified: $verified, tokens: $tokens, user: $user)';
}


}

/// @nodoc
abstract mixin class _$DeviceVerificationResponseCopyWith<$Res> implements $DeviceVerificationResponseCopyWith<$Res> {
  factory _$DeviceVerificationResponseCopyWith(_DeviceVerificationResponse value, $Res Function(_DeviceVerificationResponse) _then) = __$DeviceVerificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool verified, AuthTokens? tokens, AuthUser? user
});


@override $AuthTokensCopyWith<$Res>? get tokens;@override $AuthUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$DeviceVerificationResponseCopyWithImpl<$Res>
    implements _$DeviceVerificationResponseCopyWith<$Res> {
  __$DeviceVerificationResponseCopyWithImpl(this._self, this._then);

  final _DeviceVerificationResponse _self;
  final $Res Function(_DeviceVerificationResponse) _then;

/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verified = null,Object? tokens = freezed,Object? user = freezed,}) {
  return _then(_DeviceVerificationResponse(
verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,tokens: freezed == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser?,
  ));
}

/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res>? get tokens {
    if (_self.tokens == null) {
    return null;
  }

  return $AuthTokensCopyWith<$Res>(_self.tokens!, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of DeviceVerificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$ResendOtpRequest {

 String get sessionId;
/// Create a copy of ResendOtpRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResendOtpRequestCopyWith<ResendOtpRequest> get copyWith => _$ResendOtpRequestCopyWithImpl<ResendOtpRequest>(this as ResendOtpRequest, _$identity);

  /// Serializes this ResendOtpRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResendOtpRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendOtpRequest&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResendOtpRequest;
  return Object.hash(runtimeType,_this.sessionId);
}

@override
String toString() {
  final _this = this as ResendOtpRequest;
  return 'ResendOtpRequest(sessionId: ${_this.sessionId})';
}


}

/// @nodoc
abstract mixin class $ResendOtpRequestCopyWith<$Res>  {
  factory $ResendOtpRequestCopyWith(ResendOtpRequest value, $Res Function(ResendOtpRequest) _then) = _$ResendOtpRequestCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$ResendOtpRequestCopyWithImpl<$Res>
    implements $ResendOtpRequestCopyWith<$Res> {
  _$ResendOtpRequestCopyWithImpl(this._self, this._then);

  final ResendOtpRequest _self;
  final $Res Function(ResendOtpRequest) _then;

/// Create a copy of ResendOtpRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,}) {
  return _then(ResendOtpRequest(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResendOtpRequest].
extension ResendOtpRequestPatterns on ResendOtpRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResendOtpRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResendOtpRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResendOtpRequest value)  $default,){
final _that = this;
switch (_that) {
case _ResendOtpRequest():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResendOtpRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ResendOtpRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResendOtpRequest() when $default != null:
return $default(_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId)  $default,) {final _that = this;
switch (_that) {
case _ResendOtpRequest():
return $default(_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId)?  $default,) {final _that = this;
switch (_that) {
case _ResendOtpRequest() when $default != null:
return $default(_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResendOtpRequest implements ResendOtpRequest {
  const _ResendOtpRequest({required this.sessionId});
  factory _ResendOtpRequest.fromJson(Map<String, dynamic> json) => _$ResendOtpRequestFromJson(json);

@override final  String sessionId;

/// Create a copy of ResendOtpRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResendOtpRequestCopyWith<_ResendOtpRequest> get copyWith => __$ResendOtpRequestCopyWithImpl<_ResendOtpRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResendOtpRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResendOtpRequest&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId);
}

@override
String toString() {
    return 'ResendOtpRequest(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$ResendOtpRequestCopyWith<$Res> implements $ResendOtpRequestCopyWith<$Res> {
  factory _$ResendOtpRequestCopyWith(_ResendOtpRequest value, $Res Function(_ResendOtpRequest) _then) = __$ResendOtpRequestCopyWithImpl;
@override @useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class __$ResendOtpRequestCopyWithImpl<$Res>
    implements _$ResendOtpRequestCopyWith<$Res> {
  __$ResendOtpRequestCopyWithImpl(this._self, this._then);

  final _ResendOtpRequest _self;
  final $Res Function(_ResendOtpRequest) _then;

/// Create a copy of ResendOtpRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(_ResendOtpRequest(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NotificationPayload {

 String get type; String get id; Map<String, dynamic>? get data;
/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPayloadCopyWith<NotificationPayload> get copyWith => _$NotificationPayloadCopyWithImpl<NotificationPayload>(this as NotificationPayload, _$identity);

  /// Serializes this NotificationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationPayload;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPayload&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.data, _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationPayload;
  return Object.hash(runtimeType,_this.type,_this.id,const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as NotificationPayload;
  return 'NotificationPayload(type: ${_this.type}, id: ${_this.id}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $NotificationPayloadCopyWith<$Res>  {
  factory $NotificationPayloadCopyWith(NotificationPayload value, $Res Function(NotificationPayload) _then) = _$NotificationPayloadCopyWithImpl;
@useResult
$Res call({
 String type, String id, Map<String, dynamic>? data
});




}
/// @nodoc
class _$NotificationPayloadCopyWithImpl<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  _$NotificationPayloadCopyWithImpl(this._self, this._then);

  final NotificationPayload _self;
  final $Res Function(NotificationPayload) _then;

/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? data = freezed,}) {
  return _then(NotificationPayload(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPayload].
extension NotificationPayloadPatterns on NotificationPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPayload value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPayload():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String id,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that.type,_that.id,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String id,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _NotificationPayload():
return $default(_that.type,_that.id,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String id,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that.type,_that.id,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPayload implements NotificationPayload {
  const _NotificationPayload({required this.type, required this.id,  Map<String, dynamic>? data}): _data = data;
  factory _NotificationPayload.fromJson(Map<String, dynamic> json) => _$NotificationPayloadFromJson(json);

@override final  String type;
@override final  String id;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPayloadCopyWith<_NotificationPayload> get copyWith => __$NotificationPayloadCopyWithImpl<_NotificationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPayload&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,id,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'NotificationPayload(type: $type, id: $id, data: $data)';
}


}

/// @nodoc
abstract mixin class _$NotificationPayloadCopyWith<$Res> implements $NotificationPayloadCopyWith<$Res> {
  factory _$NotificationPayloadCopyWith(_NotificationPayload value, $Res Function(_NotificationPayload) _then) = __$NotificationPayloadCopyWithImpl;
@override @useResult
$Res call({
 String type, String id, Map<String, dynamic>? data
});




}
/// @nodoc
class __$NotificationPayloadCopyWithImpl<$Res>
    implements _$NotificationPayloadCopyWith<$Res> {
  __$NotificationPayloadCopyWithImpl(this._self, this._then);

  final _NotificationPayload _self;
  final $Res Function(_NotificationPayload) _then;

/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? data = freezed,}) {
  return _then(_NotificationPayload(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
