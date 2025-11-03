// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillItemModel {

 String get name; int get quantity; int get rate;
/// Create a copy of BillItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillItemModelCopyWith<BillItemModel> get copyWith => _$BillItemModelCopyWithImpl<BillItemModel>(this as BillItemModel, _$identity);

  /// Serializes this BillItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,rate);

@override
String toString() {
  return 'BillItemModel(name: $name, quantity: $quantity, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $BillItemModelCopyWith<$Res>  {
  factory $BillItemModelCopyWith(BillItemModel value, $Res Function(BillItemModel) _then) = _$BillItemModelCopyWithImpl;
@useResult
$Res call({
 String name, int quantity, int rate
});




}
/// @nodoc
class _$BillItemModelCopyWithImpl<$Res>
    implements $BillItemModelCopyWith<$Res> {
  _$BillItemModelCopyWithImpl(this._self, this._then);

  final BillItemModel _self;
  final $Res Function(BillItemModel) _then;

/// Create a copy of BillItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,Object? rate = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BillItemModel].
extension BillItemModelPatterns on BillItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillItemModel value)  $default,){
final _that = this;
switch (_that) {
case _BillItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _BillItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int quantity,  int rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillItemModel() when $default != null:
return $default(_that.name,_that.quantity,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int quantity,  int rate)  $default,) {final _that = this;
switch (_that) {
case _BillItemModel():
return $default(_that.name,_that.quantity,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int quantity,  int rate)?  $default,) {final _that = this;
switch (_that) {
case _BillItemModel() when $default != null:
return $default(_that.name,_that.quantity,_that.rate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillItemModel implements BillItemModel {
  const _BillItemModel({required this.name, required this.quantity, required this.rate});
  factory _BillItemModel.fromJson(Map<String, dynamic> json) => _$BillItemModelFromJson(json);

@override final  String name;
@override final  int quantity;
@override final  int rate;

/// Create a copy of BillItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillItemModelCopyWith<_BillItemModel> get copyWith => __$BillItemModelCopyWithImpl<_BillItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,rate);

@override
String toString() {
  return 'BillItemModel(name: $name, quantity: $quantity, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$BillItemModelCopyWith<$Res> implements $BillItemModelCopyWith<$Res> {
  factory _$BillItemModelCopyWith(_BillItemModel value, $Res Function(_BillItemModel) _then) = __$BillItemModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int quantity, int rate
});




}
/// @nodoc
class __$BillItemModelCopyWithImpl<$Res>
    implements _$BillItemModelCopyWith<$Res> {
  __$BillItemModelCopyWithImpl(this._self, this._then);

  final _BillItemModel _self;
  final $Res Function(_BillItemModel) _then;

/// Create a copy of BillItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,Object? rate = null,}) {
  return _then(_BillItemModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
