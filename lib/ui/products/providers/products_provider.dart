import 'package:bill_printer/data/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/app_enums.dart';
import '../../../data/models/product_model.dart';

part 'products_provider.g.dart';

@riverpod
class Products extends _$Products {
  final DBUtils dbUtils = DBUtils.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController productEditController = TextEditingController();
  final TextEditingController priceEditController = TextEditingController();
  final TextEditingController priorityEditController = TextEditingController();

  @override
  List<ProductModel> build() {
    getProducts();
    return [];
  }

  Future<void> getProducts() async {
    final products = await dbUtils.getProducts();
    state = products
        .map(
          (p) => ProductModel(
            id: p.id,
            name: p.name,
            price: p.price,
            priority: p.priority,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
          ),
        )
        .toList();
  }

  // Create
  Future<void> addProduct({
    required String name,
    required String price,
    required int priority,
  }) async {
    await dbUtils.insertProduct(name: name, price: price, priority: priority);
    await getProducts(); // Refresh the list
  }

  // Update
  Future<void> updateProduct({
    required int id,
    String? name,
    String? price,
    int? priority,
  }) async {
    await dbUtils.updateProduct(
      id: id,
      name: name,
      price: price,
      priority: priority,
    );
    await getProducts(); // Refresh the list
  }

  // Delete
  Future<void> deleteProduct(int id) async {
    await dbUtils.deleteProduct(id);
    await getProducts(); // Refresh the list
  }

  clearTextEditingControllers() {
    productEditController.clear();
    priceEditController.clear();
    priorityEditController.clear();
  }

  openProductDialog({
    required BuildContext context,
    required OperationType operationType,
    ProductModel? product,
  }) {
    if (operationType == OperationType.edit) {
      productEditController.text = product?.name ?? "";
      priceEditController.text = product?.price ?? "0";
      priorityEditController.text = product?.priority?.toString() ?? "1";
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${operationType.name} Product".toUpperCase(),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Product name"),
                    textCapitalization: TextCapitalization.sentences,
                    controller: productEditController,
                  ),

                  SizedBox(height: 8),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.isNotEmpty && value.contains(RegExp(r'\D'))) {
                        return "must be numbers";
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Price"),
                    controller: priceEditController,
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Priority of listing",
                    ),
                    controller: priorityEditController,
                    keyboardType: TextInputType.numberWithOptions(),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.contains(RegExp(r'\D'))) {
                        return "must be numbers";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // clearTextEditingControllers();
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (formKey.currentState!.validate()) {
                            String name = productEditController.text;
                            String price = priceEditController.text;

                            int priority =
                                int.tryParse(priorityEditController.text) ?? 1;
                            if (operationType == OperationType.add) {
                              addProduct(
                                name: name,
                                price: price,
                                priority: priority,
                              );
                            } else if (operationType == OperationType.edit) {
                              updateProduct(
                                id: product!.id!,
                                name: name,
                                price: price,
                                priority: priority,
                              );
                            }
                            clearTextEditingControllers();
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.green[500],
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
