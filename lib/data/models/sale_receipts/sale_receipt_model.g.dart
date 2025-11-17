// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleReceiptModel _$SaleReceiptModelFromJson(Map<String, dynamic> json) =>
    _SaleReceiptModel(
      id: json['id'] as String?,
      customerName: json['customerName'] as String?,
      preparedBy: json['preparedBy'] as String?,
      paymentMode: json['paymentMode'] as String?,
      paymentRef: json['paymentRef'] as String?,
      billItems: (json['billItems'] as List<dynamic>?)
          ?.map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SaleReceiptModelToJson(_SaleReceiptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'preparedBy': instance.preparedBy,
      'paymentMode': instance.paymentMode,
      'paymentRef': instance.paymentRef,
      'billItems': instance.billItems,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
