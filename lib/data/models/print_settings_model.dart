import 'package:freezed_annotation/freezed_annotation.dart';

part 'print_settings_model.freezed.dart';
part 'print_settings_model.g.dart';

@freezed
abstract class PrintSettingsModel with _$PrintSettingsModel {
  const factory PrintSettingsModel({
    int? id,
    String? businessName,
    String? placeAddress,
    String? headerText1,
    String? headerText2,
    String? gstNo,
    String? invoiceTitle,
    String? footerText1,
    String? footerText2,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PrintSettingsModel;

  factory PrintSettingsModel.fromJson(Map<String, Object?> json) =>
      _$PrintSettingsModelFromJson(json);
}
