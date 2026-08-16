import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/shop_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_provider.g.dart';

@riverpod
class ShopList extends _$ShopList {
  @override
  List<ShopModel> build() {
    getShops();
    return [];
  }

  final DBUtils dbUtils = DBUtils.instance;

  Future<String> addShop({
    required String name,
    required String shopId,
    required bool isPrime,
    String? address,
    String? mapAddress,
  }) async {
    // getting shops list to check first time creating shop
    final shops = await getShops();
    String result = await dbUtils.insertShop(
      name: name,
      shopId: shopId,
      isPrime: isPrime,
      address: address,
      mapAddress: mapAddress,
    );
    Shop? shop = await dbUtils.getByShopId(shopId);
    if (isPrime) {
      if (shop != null) {
        updateShop(id: shop.id, shopId: shopId, isPrime: isPrime);
      }
    } else if (shops.isEmpty) {
      // if shops list has one item then we will make it as primery shop
      if (shop != null) {
        updateShop(id: shop.id, shopId: shopId, isPrime: true);
      }
    }
    await getShops();
    return result;
  }

  Future<List<ShopModel>> getShops() async {
    final shops = await dbUtils.getShops();
    List<ShopModel> shopModels = shops.map((e) {
      return ShopModel(
        id: e.id,
        name: e.name,
        shopId: e.shopId,
        isPrime: e.isPrime,
        address: e.address,
        mapAddress: e.mapAddress,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );
    }).toList();
    updateShops(shopModels);
    return shopModels;
  }

  Future<ShopModel> getPrimeShop() async {
    List<ShopModel> shops = await getShops();
    ShopModel s = shops.firstWhere(
      (e) => e.isPrime != null && e.isPrime!,
      orElse: () => shops.first,
    );
    return s;
  }

  void updateShops(List<ShopModel> shops) {
    state = [...shops];
  }

  Future<String> updateShop({
    required int id,
    required String shopId,
    String? name,
    bool? isPrime,
    String? address,
    String? mapAddress,
  }) async {
    String result = await dbUtils.updateShop(
      id: id,
      name: name,
      shopId: shopId,
      isPrime: isPrime,
      address: address,
      mapAddress: mapAddress,
    );
    if (isPrime != null && isPrime) {
      await dbUtils.updatePrimeShop(shopId, isPrime);
    }
    await getShops();
    return result;
  }

  Future<void> deleteShop(int id) async {
    await dbUtils.deleteShop(id);
    await getShops();
  }

  void clearShops() {
    state = [];
  }
}
