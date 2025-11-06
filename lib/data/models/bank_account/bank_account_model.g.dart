// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BankAccountModel _$BankAccountModelFromJson(Map<String, dynamic> json) =>
    _BankAccountModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      isPrime: json['isPrime'] as bool? ?? false,
      upiId: json['upiId'] as String?,
      accountNumber: (json['accountNumber'] as num?)?.toInt(),
      ifsc: json['ifsc'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BankAccountModelToJson(_BankAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPrime': instance.isPrime,
      'upiId': instance.upiId,
      'accountNumber': instance.accountNumber,
      'ifsc': instance.ifsc,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
