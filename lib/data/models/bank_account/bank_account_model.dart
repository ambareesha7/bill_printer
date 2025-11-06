import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account_model.freezed.dart';
part 'bank_account_model.g.dart';

@freezed
abstract class BankAccountModel with _$BankAccountModel {
  const factory BankAccountModel({
    int? id,
    required String name,
    int? accountNumber,
    String? ifsc,
    String? upiId,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BankAccountModel;

  factory BankAccountModel.fromJson(Map<String, Object?> json) =>
      _$BankAccountModelFromJson(json);
}
