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
      paymentMode: json['paymentMode'] ?? PaymentMode.cash,
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
          PaymentStatus.receivable,
      paymentRef: json['paymentRef'] as String?,
      orderNo: json['orderNo'] as String?,
      unitId: json['unitId'] as String?,
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
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentRef': instance.paymentRef,
      'orderNo': instance.orderNo,
      'unitId': instance.unitId,
      'billItems': instance.billItems,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.receivable: 'receivable',
  PaymentStatus.received: 'received',
  PaymentStatus.outstanding: 'outstanding',
  PaymentStatus.loss: 'loss',
  PaymentStatus.partially: 'partially',
  PaymentStatus.none: 'none',
};
