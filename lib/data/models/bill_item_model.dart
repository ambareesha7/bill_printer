import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_item_model.freezed.dart';
part 'bill_item_model.g.dart';

@freezed
abstract class BillItemModel with _$BillItemModel {
  const factory BillItemModel({
    required String name,
    required int quantity,
    required int rate,
  }) = _BillItemModel;

  factory BillItemModel.fromJson(Map<String, Object?> json) =>
      _$BillItemModelFromJson(json);
}
