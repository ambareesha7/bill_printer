import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/data/models/product_model.dart';
import 'package:bill_printer/ui/widgets/icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  updateItem(BillItemModel item) {
    List<BillItemModel> itemsList = [...state];
    if (itemsList.any((element) => element.name == item.name)) {
      int index = itemsList.indexWhere((e) => e.name == item.name);
      itemsList[index] = item;
    } else {
      itemsList.add(item);
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

  int getTotalAmount() {
    int totalAmount = 0;
    for (var i in state) {
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
}

@riverpod
class BillItem extends _$BillItem {
  @override
  BillItemModel build() {
    return BillItemModel(name: "", quantity: 0, rate: 0);
  }

  updateItem(BillItemModel item) {
    state = item;
  }

  updateName(String name) {
    state = state.copyWith(name: name);
  }

  updatePrice(int price) {
    state = state.copyWith(rate: price);
  }

  updateQty(int qty) {
    state = state.copyWith(quantity: qty);
  }

  itemUp() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  itemDown() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  // ignore: avoid_build_context_in_providers
  openItemDialog({required BuildContext context, required BillItemModel item}) {
    final TextEditingController nameEditController = TextEditingController();
    final TextEditingController qtyEditController = TextEditingController();
    final TextEditingController rateEditController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    updateItem(item);
    nameEditController.text = item.name;
    qtyEditController.text = item.quantity.toString();
    rateEditController.text = item.rate.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                BillItemModel newItem = ref.watch(billItemProvider);
                qtyEditController.text = state.quantity.toString();
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Edit bill item",
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.18,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            updateName(value);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Item name",
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        controller: nameEditController,
                      ),
                      SizedBox(height: 8),
                      // Qty and Rate widgets
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Qty"),
                              Row(
                                children: [
                                  IconBtn(
                                    icon: Icons.remove,
                                    highlightColor: Colors.orange,
                                    iconColor: Colors.white,
                                    bgColor: Colors.red,
                                    onTap: () {
                                      itemDown();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // Quantity
                                    child: Text(
                                      newItem.quantity.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconBtn(
                                    highlightColor: Colors.orange,
                                    iconColor: Colors.white,
                                    bgColor: Colors.green,
                                    onTap: () {
                                      itemUp();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Rate"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (value.isNotEmpty &&
                                        value.contains(RegExp(r'\D'))) {
                                      return "must be numbers";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (value.isNotEmpty &&
                                        !value.contains(RegExp(r'\D'))) {
                                      int qty = int.parse(value);
                                      updatePrice(qty);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Rate",
                                    errorMaxLines: 2,
                                    errorStyle: TextStyle(fontSize: 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: rateEditController,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${newItem.quantity * newItem.rate}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(billListProvider.notifier)
                                  .removeItem(newItem);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              "Remove",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (formKey.currentState!.validate()) {
                                ref
                                    .read(billListProvider.notifier)
                                    .updateItem(newItem);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),

                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
