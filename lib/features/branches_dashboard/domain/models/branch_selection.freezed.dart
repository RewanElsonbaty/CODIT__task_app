// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
BranchSelection _$BranchSelectionFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'all':
          return AllBranches.fromJson(
            json
          );
                case 'specific':
          return SpecificBranch.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'BranchSelection',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$BranchSelection {



  /// Serializes this BranchSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchSelection);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BranchSelection()';
}


}

/// @nodoc
class $BranchSelectionCopyWith<$Res>  {
$BranchSelectionCopyWith(BranchSelection _, $Res Function(BranchSelection) __);
}


/// Adds pattern-matching-related methods to [BranchSelection].
extension BranchSelectionPatterns on BranchSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AllBranches value)?  all,TResult Function( SpecificBranch value)?  specific,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AllBranches() when all != null:
return all(_that);case SpecificBranch() when specific != null:
return specific(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AllBranches value)  all,required TResult Function( SpecificBranch value)  specific,}){
final _that = this;
switch (_that) {
case AllBranches():
return all(_that);case SpecificBranch():
return specific(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AllBranches value)?  all,TResult? Function( SpecificBranch value)?  specific,}){
final _that = this;
switch (_that) {
case AllBranches() when all != null:
return all(_that);case SpecificBranch() when specific != null:
return specific(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function( String branchId,  String branchName)?  specific,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AllBranches() when all != null:
return all();case SpecificBranch() when specific != null:
return specific(_that.branchId,_that.branchName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function( String branchId,  String branchName)  specific,}) {final _that = this;
switch (_that) {
case AllBranches():
return all();case SpecificBranch():
return specific(_that.branchId,_that.branchName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function( String branchId,  String branchName)?  specific,}) {final _that = this;
switch (_that) {
case AllBranches() when all != null:
return all();case SpecificBranch() when specific != null:
return specific(_that.branchId,_that.branchName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class AllBranches implements BranchSelection {
  const AllBranches({ String? $type}): $type = $type ?? 'all';
  factory AllBranches.fromJson(Map<String, dynamic> json) => _$AllBranchesFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$AllBranchesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AllBranches);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BranchSelection.all()';
}


}




/// @nodoc
@JsonSerializable()

class SpecificBranch implements BranchSelection {
  const SpecificBranch({required this.branchId, required this.branchName,  String? $type}): $type = $type ?? 'specific';
  factory SpecificBranch.fromJson(Map<String, dynamic> json) => _$SpecificBranchFromJson(json);

 final  String branchId;
 final  String branchName;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BranchSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecificBranchCopyWith<SpecificBranch> get copyWith => _$SpecificBranchCopyWithImpl<SpecificBranch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecificBranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecificBranch&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,branchId,branchName);
}

@override
String toString() {
    return 'BranchSelection.specific(branchId: $branchId, branchName: $branchName)';
}


}

/// @nodoc
abstract mixin class $SpecificBranchCopyWith<$Res> implements $BranchSelectionCopyWith<$Res> {
  factory $SpecificBranchCopyWith(SpecificBranch value, $Res Function(SpecificBranch) _then) = _$SpecificBranchCopyWithImpl;
@useResult
$Res call({
 String branchId, String branchName
});




}
/// @nodoc
class _$SpecificBranchCopyWithImpl<$Res>
    implements $SpecificBranchCopyWith<$Res> {
  _$SpecificBranchCopyWithImpl(this._self, this._then);

  final SpecificBranch _self;
  final $Res Function(SpecificBranch) _then;

/// Create a copy of BranchSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? branchName = null,}) {
  return _then(SpecificBranch(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BranchInfo {

 String get id; String get name; bool get isActive;
/// Create a copy of BranchInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchInfoCopyWith<BranchInfo> get copyWith => _$BranchInfoCopyWithImpl<BranchInfo>(this as BranchInfo, _$identity);

  /// Serializes this BranchInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BranchInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BranchInfo;
  return Object.hash(runtimeType,_this.id,_this.name,_this.isActive);
}

@override
String toString() {
  final _this = this as BranchInfo;
  return 'BranchInfo(id: ${_this.id}, name: ${_this.name}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $BranchInfoCopyWith<$Res>  {
  factory $BranchInfoCopyWith(BranchInfo value, $Res Function(BranchInfo) _then) = _$BranchInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isActive
});




}
/// @nodoc
class _$BranchInfoCopyWithImpl<$Res>
    implements $BranchInfoCopyWith<$Res> {
  _$BranchInfoCopyWithImpl(this._self, this._then);

  final BranchInfo _self;
  final $Res Function(BranchInfo) _then;

/// Create a copy of BranchInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isActive = null,}) {
  return _then(BranchInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchInfo].
extension BranchInfoPatterns on BranchInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchInfo value)  $default,){
final _that = this;
switch (_that) {
case _BranchInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BranchInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchInfo() when $default != null:
return $default(_that.id,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _BranchInfo():
return $default(_that.id,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _BranchInfo() when $default != null:
return $default(_that.id,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchInfo implements BranchInfo {
  const _BranchInfo({required this.id, required this.name, required this.isActive});
  factory _BranchInfo.fromJson(Map<String, dynamic> json) => _$BranchInfoFromJson(json);

@override final  String id;
@override final  String name;
@override final  bool isActive;

/// Create a copy of BranchInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchInfoCopyWith<_BranchInfo> get copyWith => __$BranchInfoCopyWithImpl<_BranchInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,isActive);
}

@override
String toString() {
    return 'BranchInfo(id: $id, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$BranchInfoCopyWith<$Res> implements $BranchInfoCopyWith<$Res> {
  factory _$BranchInfoCopyWith(_BranchInfo value, $Res Function(_BranchInfo) _then) = __$BranchInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isActive
});




}
/// @nodoc
class __$BranchInfoCopyWithImpl<$Res>
    implements _$BranchInfoCopyWith<$Res> {
  __$BranchInfoCopyWithImpl(this._self, this._then);

  final _BranchInfo _self;
  final $Res Function(_BranchInfo) _then;

/// Create a copy of BranchInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isActive = null,}) {
  return _then(_BranchInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
