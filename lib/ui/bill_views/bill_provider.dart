import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/data/models/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bill_provider.g.dart';

@riverpod
class BillList extends _$BillList {
  @override
  List<BillItemModel> build() {
    return [];
  }

  addItem(ProductModel item) {
    if (state.any((element) => element.name == item.name)) {
      state = _increaseQuantity(state, item);
    } else {
      state = [
        ...state,
        BillItemModel(
          name: item.name!,
          quantity: 1,
          rate: int.parse(item.price!),
        ),
      ];
    }
  }

  updateItemAtIndex(BillItemModel item) {
    List<BillItemModel> itemsList = [...state];
    if (itemsList.any((element) => element.name == item.name)) {
      int index = itemsList.indexWhere((e) => e.name == item.name);
      itemsList.insert(index, item);
    }
    state = itemsList;
  }

  removeItem(BillItemModel item) {
    List<BillItemModel> itemsList = [...state];
    if (itemsList.any((element) => element.name == item.name)) {
      int index = itemsList.indexWhere((e) => e.name == item.name);
      itemsList.removeAt(index);
    }
    state = itemsList;
  }

  clearItems() => state = [];

  getTotalQuantity(List<BillItemModel> items) {
    int totalQty = 0;
    for (var i in items) {
      totalQty += i.quantity;
    }
    return totalQty;
  }

  getTotalAmount(List<BillItemModel> items) {
    int totalAmount = 0;
    for (var i in items) {
      totalAmount += i.rate * i.quantity;
    }
    return totalAmount;
  }

  _increaseQuantity(List<BillItemModel> itemsList, ProductModel item) {
    List<BillItemModel> newItem = [];
    for (var i in itemsList) {
      if (i.name == item.name) {
        i = i.copyWith(quantity: i.quantity + 1);
      }
      newItem.add(i);
    }
    return newItem;
  }

  // decreaseQuantity(ProductModel item) {
  //   List<BillItemModel> itemsList = [...state];
  //   if (itemsList.any((element) => element.name == item.name)) {
  //     int index = itemsList.indexWhere((e) => e.name == item.name);
  //     if (itemsList[index].quantity > 1) {
  //       itemsList[index] = itemsList[index].copyWith(
  //         quantity: itemsList[index].quantity - 1,
  //       );
  //     }
  //   }
  //   state = itemsList;
  // }
}
