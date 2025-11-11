// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_receipt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleReceiptModel {

 String? get id; String? get customerName; String? get preparedBy; List<BillItemModel>? get billItems; int? get totalAmount; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of SaleReceiptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReceiptModelCopyWith<SaleReceiptModel> get copyWith => _$SaleReceiptModelCopyWithImpl<SaleReceiptModel>(this as SaleReceiptModel, _$identity);

  /// Serializes this SaleReceiptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.preparedBy, preparedBy) || other.preparedBy == preparedBy)&&const DeepCollectionEquality().equals(other.billItems, billItems)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,preparedBy,const DeepCollectionEquality().hash(billItems),totalAmount,createdAt,updatedAt);

@override
String toString() {
  return 'SaleReceiptModel(id: $id, customerName: $customerName, preparedBy: $preparedBy, billItems: $billItems, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SaleReceiptModelCopyWith<$Res>  {
  factory $SaleReceiptModelCopyWith(SaleReceiptModel value, $Res Function(SaleReceiptModel) _then) = _$SaleReceiptModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? customerName, String? preparedBy, List<BillItemModel>? billItems, int? totalAmount, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$SaleReceiptModelCopyWithImpl<$Res>
    implements $SaleReceiptModelCopyWith<$Res> {
  _$SaleReceiptModelCopyWithImpl(this._self, this._then);

  final SaleReceiptModel _self;
  final $Res Function(SaleReceiptModel) _then;

/// Create a copy of SaleReceiptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerName = freezed,Object? preparedBy = freezed,Object? billItems = freezed,Object? totalAmount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,preparedBy: freezed == preparedBy ? _self.preparedBy : preparedBy // ignore: cast_nullable_to_non_nullable
as String?,billItems: freezed == billItems ? _self.billItems : billItems // ignore: cast_nullable_to_non_nullable
as List<BillItemModel>?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReceiptModel].
extension SaleReceiptModelPatterns on SaleReceiptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReceiptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReceiptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReceiptModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleReceiptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReceiptModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReceiptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? customerName,  String? preparedBy,  List<BillItemModel>? billItems,  int? totalAmount,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReceiptModel() when $default != null:
return $default(_that.id,_that.customerName,_that.preparedBy,_that.billItems,_that.totalAmount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? customerName,  String? preparedBy,  List<BillItemModel>? billItems,  int? totalAmount,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SaleReceiptModel():
return $default(_that.id,_that.customerName,_that.preparedBy,_that.billItems,_that.totalAmount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? customerName,  String? preparedBy,  List<BillItemModel>? billItems,  int? totalAmount,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SaleReceiptModel() when $default != null:
return $default(_that.id,_that.customerName,_that.preparedBy,_that.billItems,_that.totalAmount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReceiptModel implements SaleReceiptModel {
  const _SaleReceiptModel({this.id, this.customerName, this.preparedBy, final  List<BillItemModel>? billItems, this.totalAmount, this.createdAt, this.updatedAt}): _billItems = billItems;
  factory _SaleReceiptModel.fromJson(Map<String, dynamic> json) => _$SaleReceiptModelFromJson(json);

@override final  String? id;
@override final  String? customerName;
@override final  String? preparedBy;
 final  List<BillItemModel>? _billItems;
@override List<BillItemModel>? get billItems {
  final value = _billItems;
  if (value == null) return null;
  if (_billItems is EqualUnmodifiableListView) return _billItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? totalAmount;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of SaleReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReceiptModelCopyWith<_SaleReceiptModel> get copyWith => __$SaleReceiptModelCopyWithImpl<_SaleReceiptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReceiptModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.preparedBy, preparedBy) || other.preparedBy == preparedBy)&&const DeepCollectionEquality().equals(other._billItems, _billItems)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,preparedBy,const DeepCollectionEquality().hash(_billItems),totalAmount,createdAt,updatedAt);

@override
String toString() {
  return 'SaleReceiptModel(id: $id, customerName: $customerName, preparedBy: $preparedBy, billItems: $billItems, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SaleReceiptModelCopyWith<$Res> implements $SaleReceiptModelCopyWith<$Res> {
  factory _$SaleReceiptModelCopyWith(_SaleReceiptModel value, $Res Function(_SaleReceiptModel) _then) = __$SaleReceiptModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? customerName, String? preparedBy, List<BillItemModel>? billItems, int? totalAmount, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$SaleReceiptModelCopyWithImpl<$Res>
    implements _$SaleReceiptModelCopyWith<$Res> {
  __$SaleReceiptModelCopyWithImpl(this._self, this._then);

  final _SaleReceiptModel _self;
  final $Res Function(_SaleReceiptModel) _then;

/// Create a copy of SaleReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerName = freezed,Object? preparedBy = freezed,Object? billItems = freezed,Object? totalAmount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SaleReceiptModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,preparedBy: freezed == preparedBy ? _self.preparedBy : preparedBy // ignore: cast_nullable_to_non_nullable
as String?,billItems: freezed == billItems ? _self._billItems : billItems // ignore: cast_nullable_to_non_nullable
as List<BillItemModel>?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
