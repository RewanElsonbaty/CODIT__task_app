// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BranchDashboardState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchDashboardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BranchDashboardState()';
}


}

/// @nodoc
class $BranchDashboardStateCopyWith<$Res>  {
$BranchDashboardStateCopyWith(BranchDashboardState _, $Res Function(BranchDashboardState) __);
}


/// Adds pattern-matching-related methods to [BranchDashboardState].
extension BranchDashboardStatePatterns on BranchDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Offline value)?  offline,TResult Function( _Error value)?  error,TResult Function( _Empty value)?  empty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Offline() when offline != null:
return offline(_that);case _Error() when error != null:
return error(_that);case _Empty() when empty != null:
return empty(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Offline value)  offline,required TResult Function( _Error value)  error,required TResult Function( _Empty value)  empty,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Offline():
return offline(_that);case _Error():
return error(_that);case _Empty():
return empty(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Offline value)?  offline,TResult? Function( _Error value)?  error,TResult? Function( _Empty value)?  empty,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Offline() when offline != null:
return offline(_that);case _Error() when error != null:
return error(_that);case _Empty() when empty != null:
return empty(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( BranchSummary summary)?  loaded,TResult Function( BranchSummary summary,  DateTime lastUpdate)?  offline,TResult Function( String message)?  error,TResult Function()?  empty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.summary);case _Offline() when offline != null:
return offline(_that.summary,_that.lastUpdate);case _Error() when error != null:
return error(_that.message);case _Empty() when empty != null:
return empty();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( BranchSummary summary)  loaded,required TResult Function( BranchSummary summary,  DateTime lastUpdate)  offline,required TResult Function( String message)  error,required TResult Function()  empty,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Loaded():
return loaded(_that.summary);case _Offline():
return offline(_that.summary,_that.lastUpdate);case _Error():
return error(_that.message);case _Empty():
return empty();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( BranchSummary summary)?  loaded,TResult? Function( BranchSummary summary,  DateTime lastUpdate)?  offline,TResult? Function( String message)?  error,TResult? Function()?  empty,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.summary);case _Offline() when offline != null:
return offline(_that.summary,_that.lastUpdate);case _Error() when error != null:
return error(_that.message);case _Empty() when empty != null:
return empty();case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements BranchDashboardState {
  const _Loading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BranchDashboardState.loading()';
}


}




/// @nodoc


class _Loaded implements BranchDashboardState {
  const _Loaded({required this.summary});
  

 final  BranchSummary summary;

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary);
}

@override
String toString() {
    return 'BranchDashboardState.loaded(summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $BranchDashboardStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 BranchSummary summary
});


$BranchSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? summary = null,}) {
  return _then(_Loaded(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BranchSummary,
  ));
}

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchSummaryCopyWith<$Res> get summary {
  
  return $BranchSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class _Offline implements BranchDashboardState {
  const _Offline({required this.summary, required this.lastUpdate});
  

 final  BranchSummary summary;
 final  DateTime lastUpdate;

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfflineCopyWith<_Offline> get copyWith => __$OfflineCopyWithImpl<_Offline>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offline&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary,lastUpdate);
}

@override
String toString() {
    return 'BranchDashboardState.offline(summary: $summary, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class _$OfflineCopyWith<$Res> implements $BranchDashboardStateCopyWith<$Res> {
  factory _$OfflineCopyWith(_Offline value, $Res Function(_Offline) _then) = __$OfflineCopyWithImpl;
@useResult
$Res call({
 BranchSummary summary, DateTime lastUpdate
});


$BranchSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$OfflineCopyWithImpl<$Res>
    implements _$OfflineCopyWith<$Res> {
  __$OfflineCopyWithImpl(this._self, this._then);

  final _Offline _self;
  final $Res Function(_Offline) _then;

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? lastUpdate = null,}) {
  return _then(_Offline(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BranchSummary,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchSummaryCopyWith<$Res> get summary {
  
  return $BranchSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class _Error implements BranchDashboardState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of BranchDashboardState
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
    return 'BranchDashboardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $BranchDashboardStateCopyWith<$Res> {
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

/// Create a copy of BranchDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Empty implements BranchDashboardState {
  const _Empty();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BranchDashboardState.empty()';
}


}




// dart format on
