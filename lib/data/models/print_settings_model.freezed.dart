// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'print_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrintSettingsModel {

 int? get id; String? get businessName; String? get placeAddress; String? get headerText1; String? get headerText2; String? get gstNo; String? get invoiceTitle; String? get footerText1; String? get footerText2; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of PrintSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrintSettingsModelCopyWith<PrintSettingsModel> get copyWith => _$PrintSettingsModelCopyWithImpl<PrintSettingsModel>(this as PrintSettingsModel, _$identity);

  /// Serializes this PrintSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrintSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.placeAddress, placeAddress) || other.placeAddress == placeAddress)&&(identical(other.headerText1, headerText1) || other.headerText1 == headerText1)&&(identical(other.headerText2, headerText2) || other.headerText2 == headerText2)&&(identical(other.gstNo, gstNo) || other.gstNo == gstNo)&&(identical(other.invoiceTitle, invoiceTitle) || other.invoiceTitle == invoiceTitle)&&(identical(other.footerText1, footerText1) || other.footerText1 == footerText1)&&(identical(other.footerText2, footerText2) || other.footerText2 == footerText2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,placeAddress,headerText1,headerText2,gstNo,invoiceTitle,footerText1,footerText2,createdAt,updatedAt);

@override
String toString() {
  return 'PrintSettingsModel(id: $id, businessName: $businessName, placeAddress: $placeAddress, headerText1: $headerText1, headerText2: $headerText2, gstNo: $gstNo, invoiceTitle: $invoiceTitle, footerText1: $footerText1, footerText2: $footerText2, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PrintSettingsModelCopyWith<$Res>  {
  factory $PrintSettingsModelCopyWith(PrintSettingsModel value, $Res Function(PrintSettingsModel) _then) = _$PrintSettingsModelCopyWithImpl;
@useResult
$Res call({
 int? id, String? businessName, String? placeAddress, String? headerText1, String? headerText2, String? gstNo, String? invoiceTitle, String? footerText1, String? footerText2, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PrintSettingsModelCopyWithImpl<$Res>
    implements $PrintSettingsModelCopyWith<$Res> {
  _$PrintSettingsModelCopyWithImpl(this._self, this._then);

  final PrintSettingsModel _self;
  final $Res Function(PrintSettingsModel) _then;

/// Create a copy of PrintSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? businessName = freezed,Object? placeAddress = freezed,Object? headerText1 = freezed,Object? headerText2 = freezed,Object? gstNo = freezed,Object? invoiceTitle = freezed,Object? footerText1 = freezed,Object? footerText2 = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,businessName: freezed == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String?,placeAddress: freezed == placeAddress ? _self.placeAddress : placeAddress // ignore: cast_nullable_to_non_nullable
as String?,headerText1: freezed == headerText1 ? _self.headerText1 : headerText1 // ignore: cast_nullable_to_non_nullable
as String?,headerText2: freezed == headerText2 ? _self.headerText2 : headerText2 // ignore: cast_nullable_to_non_nullable
as String?,gstNo: freezed == gstNo ? _self.gstNo : gstNo // ignore: cast_nullable_to_non_nullable
as String?,invoiceTitle: freezed == invoiceTitle ? _self.invoiceTitle : invoiceTitle // ignore: cast_nullable_to_non_nullable
as String?,footerText1: freezed == footerText1 ? _self.footerText1 : footerText1 // ignore: cast_nullable_to_non_nullable
as String?,footerText2: freezed == footerText2 ? _self.footerText2 : footerText2 // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrintSettingsModel].
extension PrintSettingsModelPatterns on PrintSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrintSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrintSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrintSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _PrintSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrintSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PrintSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? businessName,  String? placeAddress,  String? headerText1,  String? headerText2,  String? gstNo,  String? invoiceTitle,  String? footerText1,  String? footerText2,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrintSettingsModel() when $default != null:
return $default(_that.id,_that.businessName,_that.placeAddress,_that.headerText1,_that.headerText2,_that.gstNo,_that.invoiceTitle,_that.footerText1,_that.footerText2,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? businessName,  String? placeAddress,  String? headerText1,  String? headerText2,  String? gstNo,  String? invoiceTitle,  String? footerText1,  String? footerText2,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PrintSettingsModel():
return $default(_that.id,_that.businessName,_that.placeAddress,_that.headerText1,_that.headerText2,_that.gstNo,_that.invoiceTitle,_that.footerText1,_that.footerText2,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? businessName,  String? placeAddress,  String? headerText1,  String? headerText2,  String? gstNo,  String? invoiceTitle,  String? footerText1,  String? footerText2,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PrintSettingsModel() when $default != null:
return $default(_that.id,_that.businessName,_that.placeAddress,_that.headerText1,_that.headerText2,_that.gstNo,_that.invoiceTitle,_that.footerText1,_that.footerText2,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrintSettingsModel implements PrintSettingsModel {
  const _PrintSettingsModel({this.id, this.businessName, this.placeAddress, this.headerText1, this.headerText2, this.gstNo, this.invoiceTitle, this.footerText1, this.footerText2, this.createdAt, this.updatedAt});
  factory _PrintSettingsModel.fromJson(Map<String, dynamic> json) => _$PrintSettingsModelFromJson(json);

@override final  int? id;
@override final  String? businessName;
@override final  String? placeAddress;
@override final  String? headerText1;
@override final  String? headerText2;
@override final  String? gstNo;
@override final  String? invoiceTitle;
@override final  String? footerText1;
@override final  String? footerText2;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of PrintSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrintSettingsModelCopyWith<_PrintSettingsModel> get copyWith => __$PrintSettingsModelCopyWithImpl<_PrintSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrintSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrintSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.placeAddress, placeAddress) || other.placeAddress == placeAddress)&&(identical(other.headerText1, headerText1) || other.headerText1 == headerText1)&&(identical(other.headerText2, headerText2) || other.headerText2 == headerText2)&&(identical(other.gstNo, gstNo) || other.gstNo == gstNo)&&(identical(other.invoiceTitle, invoiceTitle) || other.invoiceTitle == invoiceTitle)&&(identical(other.footerText1, footerText1) || other.footerText1 == footerText1)&&(identical(other.footerText2, footerText2) || other.footerText2 == footerText2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,placeAddress,headerText1,headerText2,gstNo,invoiceTitle,footerText1,footerText2,createdAt,updatedAt);

@override
String toString() {
  return 'PrintSettingsModel(id: $id, businessName: $businessName, placeAddress: $placeAddress, headerText1: $headerText1, headerText2: $headerText2, gstNo: $gstNo, invoiceTitle: $invoiceTitle, footerText1: $footerText1, footerText2: $footerText2, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PrintSettingsModelCopyWith<$Res> implements $PrintSettingsModelCopyWith<$Res> {
  factory _$PrintSettingsModelCopyWith(_PrintSettingsModel value, $Res Function(_PrintSettingsModel) _then) = __$PrintSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? businessName, String? placeAddress, String? headerText1, String? headerText2, String? gstNo, String? invoiceTitle, String? footerText1, String? footerText2, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PrintSettingsModelCopyWithImpl<$Res>
    implements _$PrintSettingsModelCopyWith<$Res> {
  __$PrintSettingsModelCopyWithImpl(this._self, this._then);

  final _PrintSettingsModel _self;
  final $Res Function(_PrintSettingsModel) _then;

/// Create a copy of PrintSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? businessName = freezed,Object? placeAddress = freezed,Object? headerText1 = freezed,Object? headerText2 = freezed,Object? gstNo = freezed,Object? invoiceTitle = freezed,Object? footerText1 = freezed,Object? footerText2 = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PrintSettingsModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,businessName: freezed == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String?,placeAddress: freezed == placeAddress ? _self.placeAddress : placeAddress // ignore: cast_nullable_to_non_nullable
as String?,headerText1: freezed == headerText1 ? _self.headerText1 : headerText1 // ignore: cast_nullable_to_non_nullable
as String?,headerText2: freezed == headerText2 ? _self.headerText2 : headerText2 // ignore: cast_nullable_to_non_nullable
as String?,gstNo: freezed == gstNo ? _self.gstNo : gstNo // ignore: cast_nullable_to_non_nullable
as String?,invoiceTitle: freezed == invoiceTitle ? _self.invoiceTitle : invoiceTitle // ignore: cast_nullable_to_non_nullable
as String?,footerText1: freezed == footerText1 ? _self.footerText1 : footerText1 // ignore: cast_nullable_to_non_nullable
as String?,footerText2: freezed == footerText2 ? _self.footerText2 : footerText2 // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
