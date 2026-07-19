import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

@freezed
abstract class ShopModel with _$ShopModel {
  const factory ShopModel({
    int? id,
    required String name,
    required String shopId,
    bool? isPrime,
    String? address,
    String? mapAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, Object?> json) =>
      _$ShopModelFromJson(json);
}
