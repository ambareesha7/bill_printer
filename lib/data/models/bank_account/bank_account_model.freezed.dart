// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BankAccountModel {

 int? get id; String get name; int? get accountNumber; String? get ifsc; String? get upiId; String? get note; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of BankAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankAccountModelCopyWith<BankAccountModel> get copyWith => _$BankAccountModelCopyWithImpl<BankAccountModel>(this as BankAccountModel, _$identity);

  /// Serializes this BankAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.ifsc, ifsc) || other.ifsc == ifsc)&&(identical(other.upiId, upiId) || other.upiId == upiId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accountNumber,ifsc,upiId,note,createdAt,updatedAt);

@override
String toString() {
  return 'BankAccountModel(id: $id, name: $name, accountNumber: $accountNumber, ifsc: $ifsc, upiId: $upiId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BankAccountModelCopyWith<$Res>  {
  factory $BankAccountModelCopyWith(BankAccountModel value, $Res Function(BankAccountModel) _then) = _$BankAccountModelCopyWithImpl;
@useResult
$Res call({
 int? id, String name, int? accountNumber, String? ifsc, String? upiId, String? note, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BankAccountModelCopyWithImpl<$Res>
    implements $BankAccountModelCopyWith<$Res> {
  _$BankAccountModelCopyWithImpl(this._self, this._then);

  final BankAccountModel _self;
  final $Res Function(BankAccountModel) _then;

/// Create a copy of BankAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? accountNumber = freezed,Object? ifsc = freezed,Object? upiId = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as int?,ifsc: freezed == ifsc ? _self.ifsc : ifsc // ignore: cast_nullable_to_non_nullable
as String?,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BankAccountModel].
extension BankAccountModelPatterns on BankAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _BankAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  int? accountNumber,  String? ifsc,  String? upiId,  String? note,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankAccountModel() when $default != null:
return $default(_that.id,_that.name,_that.accountNumber,_that.ifsc,_that.upiId,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  int? accountNumber,  String? ifsc,  String? upiId,  String? note,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BankAccountModel():
return $default(_that.id,_that.name,_that.accountNumber,_that.ifsc,_that.upiId,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  int? accountNumber,  String? ifsc,  String? upiId,  String? note,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BankAccountModel() when $default != null:
return $default(_that.id,_that.name,_that.accountNumber,_that.ifsc,_that.upiId,_that.note,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankAccountModel implements BankAccountModel {
  const _BankAccountModel({this.id, required this.name, this.accountNumber, this.ifsc, this.upiId, this.note, this.createdAt, this.updatedAt});
  factory _BankAccountModel.fromJson(Map<String, dynamic> json) => _$BankAccountModelFromJson(json);

@override final  int? id;
@override final  String name;
@override final  int? accountNumber;
@override final  String? ifsc;
@override final  String? upiId;
@override final  String? note;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BankAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankAccountModelCopyWith<_BankAccountModel> get copyWith => __$BankAccountModelCopyWithImpl<_BankAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.ifsc, ifsc) || other.ifsc == ifsc)&&(identical(other.upiId, upiId) || other.upiId == upiId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accountNumber,ifsc,upiId,note,createdAt,updatedAt);

@override
String toString() {
  return 'BankAccountModel(id: $id, name: $name, accountNumber: $accountNumber, ifsc: $ifsc, upiId: $upiId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BankAccountModelCopyWith<$Res> implements $BankAccountModelCopyWith<$Res> {
  factory _$BankAccountModelCopyWith(_BankAccountModel value, $Res Function(_BankAccountModel) _then) = __$BankAccountModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, int? accountNumber, String? ifsc, String? upiId, String? note, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BankAccountModelCopyWithImpl<$Res>
    implements _$BankAccountModelCopyWith<$Res> {
  __$BankAccountModelCopyWithImpl(this._self, this._then);

  final _BankAccountModel _self;
  final $Res Function(_BankAccountModel) _then;

/// Create a copy of BankAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? accountNumber = freezed,Object? ifsc = freezed,Object? upiId = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BankAccountModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as int?,ifsc: freezed == ifsc ? _self.ifsc : ifsc // ignore: cast_nullable_to_non_nullable
as String?,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
