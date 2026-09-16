// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrintSettingsModel _$PrintSettingsModelFromJson(Map<String, dynamic> json) =>
    _PrintSettingsModel(
      id: (json['id'] as num?)?.toInt(),
      businessName: json['businessName'] as String?,
      placeAddress: json['placeAddress'] as String?,
      headerText1: json['headerText1'] as String?,
      headerText2: json['headerText2'] as String?,
      gstNo: json['gstNo'] as String?,
      invoiceTitle: json['invoiceTitle'] as String?,
      footerText1: json['footerText1'] as String?,
      footerText2: json['footerText2'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PrintSettingsModelToJson(_PrintSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'placeAddress': instance.placeAddress,
      'headerText1': instance.headerText1,
      'headerText2': instance.headerText2,
      'gstNo': instance.gstNo,
      'invoiceTitle': instance.invoiceTitle,
      'footerText1': instance.footerText1,
      'footerText2': instance.footerText2,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
