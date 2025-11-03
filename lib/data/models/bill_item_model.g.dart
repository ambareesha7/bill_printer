// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillItemModel _$BillItemModelFromJson(Map<String, dynamic> json) =>
    _BillItemModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      rate: (json['rate'] as num).toInt(),
    );

Map<String, dynamic> _$BillItemModelToJson(_BillItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'rate': instance.rate,
    };
