// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchSummary {

 String get branchId; String get branchName; int get sequence; SalesSummary get sales; CashSummary get cash; GoldPrices get goldPrices; List<RecentOperation> get recentOperations; DateTime get lastUpdate;
/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchSummaryCopyWith<BranchSummary> get copyWith => _$BranchSummaryCopyWithImpl<BranchSummary>(this as BranchSummary, _$identity);

  /// Serializes this BranchSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BranchSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchSummary&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.branchName, _this.branchName) || other.branchName == _this.branchName)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.sales, _this.sales) || other.sales == _this.sales)&&(identical(other.cash, _this.cash) || other.cash == _this.cash)&&(identical(other.goldPrices, _this.goldPrices) || other.goldPrices == _this.goldPrices)&&const DeepCollectionEquality().equals(other.recentOperations, _this.recentOperations)&&(identical(other.lastUpdate, _this.lastUpdate) || other.lastUpdate == _this.lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BranchSummary;
  return Object.hash(runtimeType,_this.branchId,_this.branchName,_this.sequence,_this.sales,_this.cash,_this.goldPrices,const DeepCollectionEquality().hash(_this.recentOperations),_this.lastUpdate);
}

@override
String toString() {
  final _this = this as BranchSummary;
  return 'BranchSummary(branchId: ${_this.branchId}, branchName: ${_this.branchName}, sequence: ${_this.sequence}, sales: ${_this.sales}, cash: ${_this.cash}, goldPrices: ${_this.goldPrices}, recentOperations: ${_this.recentOperations}, lastUpdate: ${_this.lastUpdate})';
}


}

/// @nodoc
abstract mixin class $BranchSummaryCopyWith<$Res>  {
  factory $BranchSummaryCopyWith(BranchSummary value, $Res Function(BranchSummary) _then) = _$BranchSummaryCopyWithImpl;
@useResult
$Res call({
 String branchId, String branchName, int sequence, SalesSummary sales, CashSummary cash, GoldPrices goldPrices, List<RecentOperation> recentOperations, DateTime lastUpdate
});


$SalesSummaryCopyWith<$Res> get sales;$CashSummaryCopyWith<$Res> get cash;$GoldPricesCopyWith<$Res> get goldPrices;

}
/// @nodoc
class _$BranchSummaryCopyWithImpl<$Res>
    implements $BranchSummaryCopyWith<$Res> {
  _$BranchSummaryCopyWithImpl(this._self, this._then);

  final BranchSummary _self;
  final $Res Function(BranchSummary) _then;

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? branchName = null,Object? sequence = null,Object? sales = null,Object? cash = null,Object? goldPrices = null,Object? recentOperations = null,Object? lastUpdate = null,}) {
  return _then(BranchSummary(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as SalesSummary,cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as CashSummary,goldPrices: null == goldPrices ? _self.goldPrices : goldPrices // ignore: cast_nullable_to_non_nullable
as GoldPrices,recentOperations: null == recentOperations ? _self.recentOperations : recentOperations // ignore: cast_nullable_to_non_nullable
as List<RecentOperation>,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<$Res> get sales {
  
  return $SalesSummaryCopyWith<$Res>(_self.sales, (value) {
    return _then(_self.copyWith(sales: value));
  });
}/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<$Res> get cash {
  
  return $CashSummaryCopyWith<$Res>(_self.cash, (value) {
    return _then(_self.copyWith(cash: value));
  });
}/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoldPricesCopyWith<$Res> get goldPrices {
  
  return $GoldPricesCopyWith<$Res>(_self.goldPrices, (value) {
    return _then(_self.copyWith(goldPrices: value));
  });
}
}


/// Adds pattern-matching-related methods to [BranchSummary].
extension BranchSummaryPatterns on BranchSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchSummary value)  $default,){
final _that = this;
switch (_that) {
case _BranchSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String branchId,  String branchName,  int sequence,  SalesSummary sales,  CashSummary cash,  GoldPrices goldPrices,  List<RecentOperation> recentOperations,  DateTime lastUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
return $default(_that.branchId,_that.branchName,_that.sequence,_that.sales,_that.cash,_that.goldPrices,_that.recentOperations,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String branchId,  String branchName,  int sequence,  SalesSummary sales,  CashSummary cash,  GoldPrices goldPrices,  List<RecentOperation> recentOperations,  DateTime lastUpdate)  $default,) {final _that = this;
switch (_that) {
case _BranchSummary():
return $default(_that.branchId,_that.branchName,_that.sequence,_that.sales,_that.cash,_that.goldPrices,_that.recentOperations,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String branchId,  String branchName,  int sequence,  SalesSummary sales,  CashSummary cash,  GoldPrices goldPrices,  List<RecentOperation> recentOperations,  DateTime lastUpdate)?  $default,) {final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
return $default(_that.branchId,_that.branchName,_that.sequence,_that.sales,_that.cash,_that.goldPrices,_that.recentOperations,_that.lastUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchSummary implements BranchSummary {
  const _BranchSummary({required this.branchId, required this.branchName, required this.sequence, required this.sales, required this.cash, required this.goldPrices, required  List<RecentOperation> recentOperations, required this.lastUpdate}): _recentOperations = recentOperations;
  factory _BranchSummary.fromJson(Map<String, dynamic> json) => _$BranchSummaryFromJson(json);

@override final  String branchId;
@override final  String branchName;
@override final  int sequence;
@override final  SalesSummary sales;
@override final  CashSummary cash;
@override final  GoldPrices goldPrices;
 final  List<RecentOperation> _recentOperations;
@override List<RecentOperation> get recentOperations {
  if (_recentOperations is EqualUnmodifiableListView) return _recentOperations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentOperations);
}

@override final  DateTime lastUpdate;

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchSummaryCopyWith<_BranchSummary> get copyWith => __$BranchSummaryCopyWithImpl<_BranchSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchSummary&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.sales, sales) || other.sales == sales)&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.goldPrices, goldPrices) || other.goldPrices == goldPrices)&&const DeepCollectionEquality().equals(other.recentOperations, _recentOperations)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,branchId,branchName,sequence,sales,cash,goldPrices,const DeepCollectionEquality().hash(_recentOperations),lastUpdate);
}

@override
String toString() {
    return 'BranchSummary(branchId: $branchId, branchName: $branchName, sequence: $sequence, sales: $sales, cash: $cash, goldPrices: $goldPrices, recentOperations: $recentOperations, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class _$BranchSummaryCopyWith<$Res> implements $BranchSummaryCopyWith<$Res> {
  factory _$BranchSummaryCopyWith(_BranchSummary value, $Res Function(_BranchSummary) _then) = __$BranchSummaryCopyWithImpl;
@override @useResult
$Res call({
 String branchId, String branchName, int sequence, SalesSummary sales, CashSummary cash, GoldPrices goldPrices, List<RecentOperation> recentOperations, DateTime lastUpdate
});


@override $SalesSummaryCopyWith<$Res> get sales;@override $CashSummaryCopyWith<$Res> get cash;@override $GoldPricesCopyWith<$Res> get goldPrices;

}
/// @nodoc
class __$BranchSummaryCopyWithImpl<$Res>
    implements _$BranchSummaryCopyWith<$Res> {
  __$BranchSummaryCopyWithImpl(this._self, this._then);

  final _BranchSummary _self;
  final $Res Function(_BranchSummary) _then;

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? branchName = null,Object? sequence = null,Object? sales = null,Object? cash = null,Object? goldPrices = null,Object? recentOperations = null,Object? lastUpdate = null,}) {
  return _then(_BranchSummary(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as SalesSummary,cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as CashSummary,goldPrices: null == goldPrices ? _self.goldPrices : goldPrices // ignore: cast_nullable_to_non_nullable
as GoldPrices,recentOperations: null == recentOperations ? _self._recentOperations : recentOperations // ignore: cast_nullable_to_non_nullable
as List<RecentOperation>,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<$Res> get sales {
  
  return $SalesSummaryCopyWith<$Res>(_self.sales, (value) {
    return _then(_self.copyWith(sales: value));
  });
}/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<$Res> get cash {
  
  return $CashSummaryCopyWith<$Res>(_self.cash, (value) {
    return _then(_self.copyWith(cash: value));
  });
}/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoldPricesCopyWith<$Res> get goldPrices {
  
  return $GoldPricesCopyWith<$Res>(_self.goldPrices, (value) {
    return _then(_self.copyWith(goldPrices: value));
  });
}
}


/// @nodoc
mixin _$SalesSummary {

 int get totalSalesPiastres; int get invoicesCount; int get totalReturnsPiastres;
/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<SalesSummary> get copyWith => _$SalesSummaryCopyWithImpl<SalesSummary>(this as SalesSummary, _$identity);

  /// Serializes this SalesSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalesSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSummary&&(identical(other.totalSalesPiastres, _this.totalSalesPiastres) || other.totalSalesPiastres == _this.totalSalesPiastres)&&(identical(other.invoicesCount, _this.invoicesCount) || other.invoicesCount == _this.invoicesCount)&&(identical(other.totalReturnsPiastres, _this.totalReturnsPiastres) || other.totalReturnsPiastres == _this.totalReturnsPiastres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalesSummary;
  return Object.hash(runtimeType,_this.totalSalesPiastres,_this.invoicesCount,_this.totalReturnsPiastres);
}

@override
String toString() {
  final _this = this as SalesSummary;
  return 'SalesSummary(totalSalesPiastres: ${_this.totalSalesPiastres}, invoicesCount: ${_this.invoicesCount}, totalReturnsPiastres: ${_this.totalReturnsPiastres})';
}


}

/// @nodoc
abstract mixin class $SalesSummaryCopyWith<$Res>  {
  factory $SalesSummaryCopyWith(SalesSummary value, $Res Function(SalesSummary) _then) = _$SalesSummaryCopyWithImpl;
@useResult
$Res call({
 int totalSalesPiastres, int invoicesCount, int totalReturnsPiastres
});




}
/// @nodoc
class _$SalesSummaryCopyWithImpl<$Res>
    implements $SalesSummaryCopyWith<$Res> {
  _$SalesSummaryCopyWithImpl(this._self, this._then);

  final SalesSummary _self;
  final $Res Function(SalesSummary) _then;

/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSalesPiastres = null,Object? invoicesCount = null,Object? totalReturnsPiastres = null,}) {
  return _then(SalesSummary(
totalSalesPiastres: null == totalSalesPiastres ? _self.totalSalesPiastres : totalSalesPiastres // ignore: cast_nullable_to_non_nullable
as int,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,totalReturnsPiastres: null == totalReturnsPiastres ? _self.totalReturnsPiastres : totalReturnsPiastres // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesSummary].
extension SalesSummaryPatterns on SalesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSummary value)  $default,){
final _that = this;
switch (_that) {
case _SalesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalSalesPiastres,  int invoicesCount,  int totalReturnsPiastres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
return $default(_that.totalSalesPiastres,_that.invoicesCount,_that.totalReturnsPiastres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalSalesPiastres,  int invoicesCount,  int totalReturnsPiastres)  $default,) {final _that = this;
switch (_that) {
case _SalesSummary():
return $default(_that.totalSalesPiastres,_that.invoicesCount,_that.totalReturnsPiastres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalSalesPiastres,  int invoicesCount,  int totalReturnsPiastres)?  $default,) {final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
return $default(_that.totalSalesPiastres,_that.invoicesCount,_that.totalReturnsPiastres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesSummary implements SalesSummary {
  const _SalesSummary({required this.totalSalesPiastres, required this.invoicesCount, required this.totalReturnsPiastres});
  factory _SalesSummary.fromJson(Map<String, dynamic> json) => _$SalesSummaryFromJson(json);

@override final  int totalSalesPiastres;
@override final  int invoicesCount;
@override final  int totalReturnsPiastres;

/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSummaryCopyWith<_SalesSummary> get copyWith => __$SalesSummaryCopyWithImpl<_SalesSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSummary&&(identical(other.totalSalesPiastres, totalSalesPiastres) || other.totalSalesPiastres == totalSalesPiastres)&&(identical(other.invoicesCount, invoicesCount) || other.invoicesCount == invoicesCount)&&(identical(other.totalReturnsPiastres, totalReturnsPiastres) || other.totalReturnsPiastres == totalReturnsPiastres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalSalesPiastres,invoicesCount,totalReturnsPiastres);
}

@override
String toString() {
    return 'SalesSummary(totalSalesPiastres: $totalSalesPiastres, invoicesCount: $invoicesCount, totalReturnsPiastres: $totalReturnsPiastres)';
}


}

/// @nodoc
abstract mixin class _$SalesSummaryCopyWith<$Res> implements $SalesSummaryCopyWith<$Res> {
  factory _$SalesSummaryCopyWith(_SalesSummary value, $Res Function(_SalesSummary) _then) = __$SalesSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalSalesPiastres, int invoicesCount, int totalReturnsPiastres
});




}
/// @nodoc
class __$SalesSummaryCopyWithImpl<$Res>
    implements _$SalesSummaryCopyWith<$Res> {
  __$SalesSummaryCopyWithImpl(this._self, this._then);

  final _SalesSummary _self;
  final $Res Function(_SalesSummary) _then;

/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSalesPiastres = null,Object? invoicesCount = null,Object? totalReturnsPiastres = null,}) {
  return _then(_SalesSummary(
totalSalesPiastres: null == totalSalesPiastres ? _self.totalSalesPiastres : totalSalesPiastres // ignore: cast_nullable_to_non_nullable
as int,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,totalReturnsPiastres: null == totalReturnsPiastres ? _self.totalReturnsPiastres : totalReturnsPiastres // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CashSummary {

 int get availableCashPiastres; int get totalCollectionsPiastres;
/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<CashSummary> get copyWith => _$CashSummaryCopyWithImpl<CashSummary>(this as CashSummary, _$identity);

  /// Serializes this CashSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CashSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSummary&&(identical(other.availableCashPiastres, _this.availableCashPiastres) || other.availableCashPiastres == _this.availableCashPiastres)&&(identical(other.totalCollectionsPiastres, _this.totalCollectionsPiastres) || other.totalCollectionsPiastres == _this.totalCollectionsPiastres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CashSummary;
  return Object.hash(runtimeType,_this.availableCashPiastres,_this.totalCollectionsPiastres);
}

@override
String toString() {
  final _this = this as CashSummary;
  return 'CashSummary(availableCashPiastres: ${_this.availableCashPiastres}, totalCollectionsPiastres: ${_this.totalCollectionsPiastres})';
}


}

/// @nodoc
abstract mixin class $CashSummaryCopyWith<$Res>  {
  factory $CashSummaryCopyWith(CashSummary value, $Res Function(CashSummary) _then) = _$CashSummaryCopyWithImpl;
@useResult
$Res call({
 int availableCashPiastres, int totalCollectionsPiastres
});




}
/// @nodoc
class _$CashSummaryCopyWithImpl<$Res>
    implements $CashSummaryCopyWith<$Res> {
  _$CashSummaryCopyWithImpl(this._self, this._then);

  final CashSummary _self;
  final $Res Function(CashSummary) _then;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availableCashPiastres = null,Object? totalCollectionsPiastres = null,}) {
  return _then(CashSummary(
availableCashPiastres: null == availableCashPiastres ? _self.availableCashPiastres : availableCashPiastres // ignore: cast_nullable_to_non_nullable
as int,totalCollectionsPiastres: null == totalCollectionsPiastres ? _self.totalCollectionsPiastres : totalCollectionsPiastres // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSummary].
extension CashSummaryPatterns on CashSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSummary value)  $default,){
final _that = this;
switch (_that) {
case _CashSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int availableCashPiastres,  int totalCollectionsPiastres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
return $default(_that.availableCashPiastres,_that.totalCollectionsPiastres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int availableCashPiastres,  int totalCollectionsPiastres)  $default,) {final _that = this;
switch (_that) {
case _CashSummary():
return $default(_that.availableCashPiastres,_that.totalCollectionsPiastres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int availableCashPiastres,  int totalCollectionsPiastres)?  $default,) {final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
return $default(_that.availableCashPiastres,_that.totalCollectionsPiastres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSummary implements CashSummary {
  const _CashSummary({required this.availableCashPiastres, required this.totalCollectionsPiastres});
  factory _CashSummary.fromJson(Map<String, dynamic> json) => _$CashSummaryFromJson(json);

@override final  int availableCashPiastres;
@override final  int totalCollectionsPiastres;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSummaryCopyWith<_CashSummary> get copyWith => __$CashSummaryCopyWithImpl<_CashSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSummary&&(identical(other.availableCashPiastres, availableCashPiastres) || other.availableCashPiastres == availableCashPiastres)&&(identical(other.totalCollectionsPiastres, totalCollectionsPiastres) || other.totalCollectionsPiastres == totalCollectionsPiastres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,availableCashPiastres,totalCollectionsPiastres);
}

@override
String toString() {
    return 'CashSummary(availableCashPiastres: $availableCashPiastres, totalCollectionsPiastres: $totalCollectionsPiastres)';
}


}

/// @nodoc
abstract mixin class _$CashSummaryCopyWith<$Res> implements $CashSummaryCopyWith<$Res> {
  factory _$CashSummaryCopyWith(_CashSummary value, $Res Function(_CashSummary) _then) = __$CashSummaryCopyWithImpl;
@override @useResult
$Res call({
 int availableCashPiastres, int totalCollectionsPiastres
});




}
/// @nodoc
class __$CashSummaryCopyWithImpl<$Res>
    implements _$CashSummaryCopyWith<$Res> {
  __$CashSummaryCopyWithImpl(this._self, this._then);

  final _CashSummary _self;
  final $Res Function(_CashSummary) _then;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availableCashPiastres = null,Object? totalCollectionsPiastres = null,}) {
  return _then(_CashSummary(
availableCashPiastres: null == availableCashPiastres ? _self.availableCashPiastres : availableCashPiastres // ignore: cast_nullable_to_non_nullable
as int,totalCollectionsPiastres: null == totalCollectionsPiastres ? _self.totalCollectionsPiastres : totalCollectionsPiastres // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GoldPrices {

 int get karat18PricePerGramPiastres; int get karat21PricePerGramPiastres; int get karat24PricePerGramPiastres; DateTime get lastUpdated;
/// Create a copy of GoldPrices
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoldPricesCopyWith<GoldPrices> get copyWith => _$GoldPricesCopyWithImpl<GoldPrices>(this as GoldPrices, _$identity);

  /// Serializes this GoldPrices to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoldPrices;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoldPrices&&(identical(other.karat18PricePerGramPiastres, _this.karat18PricePerGramPiastres) || other.karat18PricePerGramPiastres == _this.karat18PricePerGramPiastres)&&(identical(other.karat21PricePerGramPiastres, _this.karat21PricePerGramPiastres) || other.karat21PricePerGramPiastres == _this.karat21PricePerGramPiastres)&&(identical(other.karat24PricePerGramPiastres, _this.karat24PricePerGramPiastres) || other.karat24PricePerGramPiastres == _this.karat24PricePerGramPiastres)&&(identical(other.lastUpdated, _this.lastUpdated) || other.lastUpdated == _this.lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoldPrices;
  return Object.hash(runtimeType,_this.karat18PricePerGramPiastres,_this.karat21PricePerGramPiastres,_this.karat24PricePerGramPiastres,_this.lastUpdated);
}

@override
String toString() {
  final _this = this as GoldPrices;
  return 'GoldPrices(karat18PricePerGramPiastres: ${_this.karat18PricePerGramPiastres}, karat21PricePerGramPiastres: ${_this.karat21PricePerGramPiastres}, karat24PricePerGramPiastres: ${_this.karat24PricePerGramPiastres}, lastUpdated: ${_this.lastUpdated})';
}


}

/// @nodoc
abstract mixin class $GoldPricesCopyWith<$Res>  {
  factory $GoldPricesCopyWith(GoldPrices value, $Res Function(GoldPrices) _then) = _$GoldPricesCopyWithImpl;
@useResult
$Res call({
 int karat18PricePerGramPiastres, int karat21PricePerGramPiastres, int karat24PricePerGramPiastres, DateTime lastUpdated
});




}
/// @nodoc
class _$GoldPricesCopyWithImpl<$Res>
    implements $GoldPricesCopyWith<$Res> {
  _$GoldPricesCopyWithImpl(this._self, this._then);

  final GoldPrices _self;
  final $Res Function(GoldPrices) _then;

/// Create a copy of GoldPrices
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? karat18PricePerGramPiastres = null,Object? karat21PricePerGramPiastres = null,Object? karat24PricePerGramPiastres = null,Object? lastUpdated = null,}) {
  return _then(GoldPrices(
karat18PricePerGramPiastres: null == karat18PricePerGramPiastres ? _self.karat18PricePerGramPiastres : karat18PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,karat21PricePerGramPiastres: null == karat21PricePerGramPiastres ? _self.karat21PricePerGramPiastres : karat21PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,karat24PricePerGramPiastres: null == karat24PricePerGramPiastres ? _self.karat24PricePerGramPiastres : karat24PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GoldPrices].
extension GoldPricesPatterns on GoldPrices {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoldPrices value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoldPrices() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoldPrices value)  $default,){
final _that = this;
switch (_that) {
case _GoldPrices():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoldPrices value)?  $default,){
final _that = this;
switch (_that) {
case _GoldPrices() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int karat18PricePerGramPiastres,  int karat21PricePerGramPiastres,  int karat24PricePerGramPiastres,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoldPrices() when $default != null:
return $default(_that.karat18PricePerGramPiastres,_that.karat21PricePerGramPiastres,_that.karat24PricePerGramPiastres,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int karat18PricePerGramPiastres,  int karat21PricePerGramPiastres,  int karat24PricePerGramPiastres,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _GoldPrices():
return $default(_that.karat18PricePerGramPiastres,_that.karat21PricePerGramPiastres,_that.karat24PricePerGramPiastres,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int karat18PricePerGramPiastres,  int karat21PricePerGramPiastres,  int karat24PricePerGramPiastres,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _GoldPrices() when $default != null:
return $default(_that.karat18PricePerGramPiastres,_that.karat21PricePerGramPiastres,_that.karat24PricePerGramPiastres,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoldPrices implements GoldPrices {
  const _GoldPrices({required this.karat18PricePerGramPiastres, required this.karat21PricePerGramPiastres, required this.karat24PricePerGramPiastres, required this.lastUpdated});
  factory _GoldPrices.fromJson(Map<String, dynamic> json) => _$GoldPricesFromJson(json);

@override final  int karat18PricePerGramPiastres;
@override final  int karat21PricePerGramPiastres;
@override final  int karat24PricePerGramPiastres;
@override final  DateTime lastUpdated;

/// Create a copy of GoldPrices
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoldPricesCopyWith<_GoldPrices> get copyWith => __$GoldPricesCopyWithImpl<_GoldPrices>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoldPricesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoldPrices&&(identical(other.karat18PricePerGramPiastres, karat18PricePerGramPiastres) || other.karat18PricePerGramPiastres == karat18PricePerGramPiastres)&&(identical(other.karat21PricePerGramPiastres, karat21PricePerGramPiastres) || other.karat21PricePerGramPiastres == karat21PricePerGramPiastres)&&(identical(other.karat24PricePerGramPiastres, karat24PricePerGramPiastres) || other.karat24PricePerGramPiastres == karat24PricePerGramPiastres)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,karat18PricePerGramPiastres,karat21PricePerGramPiastres,karat24PricePerGramPiastres,lastUpdated);
}

@override
String toString() {
    return 'GoldPrices(karat18PricePerGramPiastres: $karat18PricePerGramPiastres, karat21PricePerGramPiastres: $karat21PricePerGramPiastres, karat24PricePerGramPiastres: $karat24PricePerGramPiastres, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$GoldPricesCopyWith<$Res> implements $GoldPricesCopyWith<$Res> {
  factory _$GoldPricesCopyWith(_GoldPrices value, $Res Function(_GoldPrices) _then) = __$GoldPricesCopyWithImpl;
@override @useResult
$Res call({
 int karat18PricePerGramPiastres, int karat21PricePerGramPiastres, int karat24PricePerGramPiastres, DateTime lastUpdated
});




}
/// @nodoc
class __$GoldPricesCopyWithImpl<$Res>
    implements _$GoldPricesCopyWith<$Res> {
  __$GoldPricesCopyWithImpl(this._self, this._then);

  final _GoldPrices _self;
  final $Res Function(_GoldPrices) _then;

/// Create a copy of GoldPrices
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? karat18PricePerGramPiastres = null,Object? karat21PricePerGramPiastres = null,Object? karat24PricePerGramPiastres = null,Object? lastUpdated = null,}) {
  return _then(_GoldPrices(
karat18PricePerGramPiastres: null == karat18PricePerGramPiastres ? _self.karat18PricePerGramPiastres : karat18PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,karat21PricePerGramPiastres: null == karat21PricePerGramPiastres ? _self.karat21PricePerGramPiastres : karat21PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,karat24PricePerGramPiastres: null == karat24PricePerGramPiastres ? _self.karat24PricePerGramPiastres : karat24PricePerGramPiastres // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RecentOperation {

 String get id; OperationType get type; String get description; int get amountPiastres; DateTime get timestamp;
/// Create a copy of RecentOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentOperationCopyWith<RecentOperation> get copyWith => _$RecentOperationCopyWithImpl<RecentOperation>(this as RecentOperation, _$identity);

  /// Serializes this RecentOperation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecentOperation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentOperation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.amountPiastres, _this.amountPiastres) || other.amountPiastres == _this.amountPiastres)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecentOperation;
  return Object.hash(runtimeType,_this.id,_this.type,_this.description,_this.amountPiastres,_this.timestamp);
}

@override
String toString() {
  final _this = this as RecentOperation;
  return 'RecentOperation(id: ${_this.id}, type: ${_this.type}, description: ${_this.description}, amountPiastres: ${_this.amountPiastres}, timestamp: ${_this.timestamp})';
}


}

/// @nodoc
abstract mixin class $RecentOperationCopyWith<$Res>  {
  factory $RecentOperationCopyWith(RecentOperation value, $Res Function(RecentOperation) _then) = _$RecentOperationCopyWithImpl;
@useResult
$Res call({
 String id, OperationType type, String description, int amountPiastres, DateTime timestamp
});




}
/// @nodoc
class _$RecentOperationCopyWithImpl<$Res>
    implements $RecentOperationCopyWith<$Res> {
  _$RecentOperationCopyWithImpl(this._self, this._then);

  final RecentOperation _self;
  final $Res Function(RecentOperation) _then;

/// Create a copy of RecentOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amountPiastres = null,Object? timestamp = null,}) {
  return _then(RecentOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OperationType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountPiastres: null == amountPiastres ? _self.amountPiastres : amountPiastres // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentOperation].
extension RecentOperationPatterns on RecentOperation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentOperation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentOperation value)  $default,){
final _that = this;
switch (_that) {
case _RecentOperation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentOperation value)?  $default,){
final _that = this;
switch (_that) {
case _RecentOperation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  OperationType type,  String description,  int amountPiastres,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentOperation() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amountPiastres,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  OperationType type,  String description,  int amountPiastres,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _RecentOperation():
return $default(_that.id,_that.type,_that.description,_that.amountPiastres,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  OperationType type,  String description,  int amountPiastres,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RecentOperation() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amountPiastres,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentOperation implements RecentOperation {
  const _RecentOperation({required this.id, required this.type, required this.description, required this.amountPiastres, required this.timestamp});
  factory _RecentOperation.fromJson(Map<String, dynamic> json) => _$RecentOperationFromJson(json);

@override final  String id;
@override final  OperationType type;
@override final  String description;
@override final  int amountPiastres;
@override final  DateTime timestamp;

/// Create a copy of RecentOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentOperationCopyWith<_RecentOperation> get copyWith => __$RecentOperationCopyWithImpl<_RecentOperation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentOperationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amountPiastres, amountPiastres) || other.amountPiastres == amountPiastres)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,description,amountPiastres,timestamp);
}

@override
String toString() {
    return 'RecentOperation(id: $id, type: $type, description: $description, amountPiastres: $amountPiastres, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RecentOperationCopyWith<$Res> implements $RecentOperationCopyWith<$Res> {
  factory _$RecentOperationCopyWith(_RecentOperation value, $Res Function(_RecentOperation) _then) = __$RecentOperationCopyWithImpl;
@override @useResult
$Res call({
 String id, OperationType type, String description, int amountPiastres, DateTime timestamp
});




}
/// @nodoc
class __$RecentOperationCopyWithImpl<$Res>
    implements _$RecentOperationCopyWith<$Res> {
  __$RecentOperationCopyWithImpl(this._self, this._then);

  final _RecentOperation _self;
  final $Res Function(_RecentOperation) _then;

/// Create a copy of RecentOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amountPiastres = null,Object? timestamp = null,}) {
  return _then(_RecentOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OperationType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amountPiastres: null == amountPiastres ? _self.amountPiastres : amountPiastres // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BranchUpdate {

 String get branchId; int get sequence; DateTime get timestamp; SalesSummary? get sales; CashSummary? get cash; GoldPrices? get goldPrices; RecentOperation? get newOperation;
/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchUpdateCopyWith<BranchUpdate> get copyWith => _$BranchUpdateCopyWithImpl<BranchUpdate>(this as BranchUpdate, _$identity);

  /// Serializes this BranchUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BranchUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchUpdate&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.sales, _this.sales) || other.sales == _this.sales)&&(identical(other.cash, _this.cash) || other.cash == _this.cash)&&(identical(other.goldPrices, _this.goldPrices) || other.goldPrices == _this.goldPrices)&&(identical(other.newOperation, _this.newOperation) || other.newOperation == _this.newOperation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BranchUpdate;
  return Object.hash(runtimeType,_this.branchId,_this.sequence,_this.timestamp,_this.sales,_this.cash,_this.goldPrices,_this.newOperation);
}

@override
String toString() {
  final _this = this as BranchUpdate;
  return 'BranchUpdate(branchId: ${_this.branchId}, sequence: ${_this.sequence}, timestamp: ${_this.timestamp}, sales: ${_this.sales}, cash: ${_this.cash}, goldPrices: ${_this.goldPrices}, newOperation: ${_this.newOperation})';
}


}

/// @nodoc
abstract mixin class $BranchUpdateCopyWith<$Res>  {
  factory $BranchUpdateCopyWith(BranchUpdate value, $Res Function(BranchUpdate) _then) = _$BranchUpdateCopyWithImpl;
@useResult
$Res call({
 String branchId, int sequence, DateTime timestamp, SalesSummary? sales, CashSummary? cash, GoldPrices? goldPrices, RecentOperation? newOperation
});


$SalesSummaryCopyWith<$Res>? get sales;$CashSummaryCopyWith<$Res>? get cash;$GoldPricesCopyWith<$Res>? get goldPrices;$RecentOperationCopyWith<$Res>? get newOperation;

}
/// @nodoc
class _$BranchUpdateCopyWithImpl<$Res>
    implements $BranchUpdateCopyWith<$Res> {
  _$BranchUpdateCopyWithImpl(this._self, this._then);

  final BranchUpdate _self;
  final $Res Function(BranchUpdate) _then;

/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? sequence = null,Object? timestamp = null,Object? sales = freezed,Object? cash = freezed,Object? goldPrices = freezed,Object? newOperation = freezed,}) {
  return _then(BranchUpdate(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sales: freezed == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as SalesSummary?,cash: freezed == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as CashSummary?,goldPrices: freezed == goldPrices ? _self.goldPrices : goldPrices // ignore: cast_nullable_to_non_nullable
as GoldPrices?,newOperation: freezed == newOperation ? _self.newOperation : newOperation // ignore: cast_nullable_to_non_nullable
as RecentOperation?,
  ));
}
/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<$Res>? get sales {
    if (_self.sales == null) {
    return null;
  }

  return $SalesSummaryCopyWith<$Res>(_self.sales!, (value) {
    return _then(_self.copyWith(sales: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<$Res>? get cash {
    if (_self.cash == null) {
    return null;
  }

  return $CashSummaryCopyWith<$Res>(_self.cash!, (value) {
    return _then(_self.copyWith(cash: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoldPricesCopyWith<$Res>? get goldPrices {
    if (_self.goldPrices == null) {
    return null;
  }

  return $GoldPricesCopyWith<$Res>(_self.goldPrices!, (value) {
    return _then(_self.copyWith(goldPrices: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentOperationCopyWith<$Res>? get newOperation {
    if (_self.newOperation == null) {
    return null;
  }

  return $RecentOperationCopyWith<$Res>(_self.newOperation!, (value) {
    return _then(_self.copyWith(newOperation: value));
  });
}
}


/// Adds pattern-matching-related methods to [BranchUpdate].
extension BranchUpdatePatterns on BranchUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchUpdate value)  $default,){
final _that = this;
switch (_that) {
case _BranchUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _BranchUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String branchId,  int sequence,  DateTime timestamp,  SalesSummary? sales,  CashSummary? cash,  GoldPrices? goldPrices,  RecentOperation? newOperation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchUpdate() when $default != null:
return $default(_that.branchId,_that.sequence,_that.timestamp,_that.sales,_that.cash,_that.goldPrices,_that.newOperation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String branchId,  int sequence,  DateTime timestamp,  SalesSummary? sales,  CashSummary? cash,  GoldPrices? goldPrices,  RecentOperation? newOperation)  $default,) {final _that = this;
switch (_that) {
case _BranchUpdate():
return $default(_that.branchId,_that.sequence,_that.timestamp,_that.sales,_that.cash,_that.goldPrices,_that.newOperation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String branchId,  int sequence,  DateTime timestamp,  SalesSummary? sales,  CashSummary? cash,  GoldPrices? goldPrices,  RecentOperation? newOperation)?  $default,) {final _that = this;
switch (_that) {
case _BranchUpdate() when $default != null:
return $default(_that.branchId,_that.sequence,_that.timestamp,_that.sales,_that.cash,_that.goldPrices,_that.newOperation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchUpdate implements BranchUpdate {
  const _BranchUpdate({required this.branchId, required this.sequence, required this.timestamp, this.sales, this.cash, this.goldPrices, this.newOperation});
  factory _BranchUpdate.fromJson(Map<String, dynamic> json) => _$BranchUpdateFromJson(json);

@override final  String branchId;
@override final  int sequence;
@override final  DateTime timestamp;
@override final  SalesSummary? sales;
@override final  CashSummary? cash;
@override final  GoldPrices? goldPrices;
@override final  RecentOperation? newOperation;

/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchUpdateCopyWith<_BranchUpdate> get copyWith => __$BranchUpdateCopyWithImpl<_BranchUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchUpdate&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sales, sales) || other.sales == sales)&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.goldPrices, goldPrices) || other.goldPrices == goldPrices)&&(identical(other.newOperation, newOperation) || other.newOperation == newOperation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,branchId,sequence,timestamp,sales,cash,goldPrices,newOperation);
}

@override
String toString() {
    return 'BranchUpdate(branchId: $branchId, sequence: $sequence, timestamp: $timestamp, sales: $sales, cash: $cash, goldPrices: $goldPrices, newOperation: $newOperation)';
}


}

/// @nodoc
abstract mixin class _$BranchUpdateCopyWith<$Res> implements $BranchUpdateCopyWith<$Res> {
  factory _$BranchUpdateCopyWith(_BranchUpdate value, $Res Function(_BranchUpdate) _then) = __$BranchUpdateCopyWithImpl;
@override @useResult
$Res call({
 String branchId, int sequence, DateTime timestamp, SalesSummary? sales, CashSummary? cash, GoldPrices? goldPrices, RecentOperation? newOperation
});


@override $SalesSummaryCopyWith<$Res>? get sales;@override $CashSummaryCopyWith<$Res>? get cash;@override $GoldPricesCopyWith<$Res>? get goldPrices;@override $RecentOperationCopyWith<$Res>? get newOperation;

}
/// @nodoc
class __$BranchUpdateCopyWithImpl<$Res>
    implements _$BranchUpdateCopyWith<$Res> {
  __$BranchUpdateCopyWithImpl(this._self, this._then);

  final _BranchUpdate _self;
  final $Res Function(_BranchUpdate) _then;

/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? sequence = null,Object? timestamp = null,Object? sales = freezed,Object? cash = freezed,Object? goldPrices = freezed,Object? newOperation = freezed,}) {
  return _then(_BranchUpdate(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sales: freezed == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as SalesSummary?,cash: freezed == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as CashSummary?,goldPrices: freezed == goldPrices ? _self.goldPrices : goldPrices // ignore: cast_nullable_to_non_nullable
as GoldPrices?,newOperation: freezed == newOperation ? _self.newOperation : newOperation // ignore: cast_nullable_to_non_nullable
as RecentOperation?,
  ));
}

/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<$Res>? get sales {
    if (_self.sales == null) {
    return null;
  }

  return $SalesSummaryCopyWith<$Res>(_self.sales!, (value) {
    return _then(_self.copyWith(sales: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<$Res>? get cash {
    if (_self.cash == null) {
    return null;
  }

  return $CashSummaryCopyWith<$Res>(_self.cash!, (value) {
    return _then(_self.copyWith(cash: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoldPricesCopyWith<$Res>? get goldPrices {
    if (_self.goldPrices == null) {
    return null;
  }

  return $GoldPricesCopyWith<$Res>(_self.goldPrices!, (value) {
    return _then(_self.copyWith(goldPrices: value));
  });
}/// Create a copy of BranchUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentOperationCopyWith<$Res>? get newOperation {
    if (_self.newOperation == null) {
    return null;
  }

  return $RecentOperationCopyWith<$Res>(_self.newOperation!, (value) {
    return _then(_self.copyWith(newOperation: value));
  });
}
}

// dart format on
