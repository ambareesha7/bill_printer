import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_receipt_model.freezed.dart';
part 'sale_receipt_model.g.dart';

@freezed
abstract class SaleReceiptModel with _$SaleReceiptModel {
  const factory SaleReceiptModel({
    String? id,
    String? customerName,
    String? preparedBy,
    String? paymentMode,
    String? paymentRef,
    List<BillItemModel>? billItems,
    int? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SaleReceiptModel;

  factory SaleReceiptModel.fromJson(Map<String, Object?> json) =>
      _$SaleReceiptModelFromJson(json);
}
