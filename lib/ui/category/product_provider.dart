import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/category_model.dart';
import 'package:bill_printer/data/models/product_model.dart';
import 'package:bill_printer/ui/category/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@riverpod
class ProductsList extends _$ProductsList {
  final DBUtils dbUtils = DBUtils.instance;

  @override
  List<ProductModel> build() {
    initializeProducts();
    return [];
  }

  // Initialize products from database
  Future<void> initializeProducts() async {
    final products = await dbUtils.getProducts();
    state = products
        .map(
          (p) => ProductModel(
            id: p.id,
            name: p.name,
            price: p.price,
            categoryId: p.categoryId,
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
    required int categoryId,
    required String price,
    required int priority,
  }) async {
    await dbUtils.insertProduct(
      name: name,
      categoryId: categoryId,
      price: price,
      priority: priority,
    );
    await initializeProducts(); // Refresh the list
  }

  // Read by category
  Future<void> getProductsByCategory(int categoryId) async {
    final products = await dbUtils.getProductsByCategory(categoryId);
    state = products
        .map(
          (p) => ProductModel(
            id: p.id,
            name: p.name,
            price: p.price,
            categoryId: p.categoryId,
            priority: p.priority,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
          ),
        )
        .toList();
  }

  // Update
  Future<void> updateProduct({
    required int id,
    String? name,
    int? categoryId,
    String? price,
    int? priority,
  }) async {
    await dbUtils.updateProduct(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      priority: priority,
    );
    await initializeProducts(); // Refresh the list
  }

  // Delete
  Future<void> deleteProduct(int id) async {
    await dbUtils.deleteProduct(id);
    await initializeProducts(); // Refresh the list
  }

  // Filter products
  void filterProducts(String query) {
    if (query.isEmpty) {
      initializeProducts();
      return;
    }

    state = state
        .where(
          (product) =>
              product.name!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Sort products
  void sortByName({bool ascending = true}) {
    state = List.from(state)
      ..sort(
        (a, b) =>
            ascending ? a.name!.compareTo(b.name!) : b.name!.compareTo(a.name!),
      );
  }

  //   void sortByPrice({bool ascending = true}) {
  //     state = List.from(state)
  //       ..sort(
  //         (a, b) => ascending
  //             ? double.parse(a.price).compareTo(double.parse(b.price))
  //             : double.parse(b.price).compareTo(double.parse(a.price)),
  //       );
  //   }
  final TextEditingController productEditController = TextEditingController();
  final TextEditingController priceEditController = TextEditingController();
  final TextEditingController priorityEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  clearTextEditingControllers() {
    productEditController.clear();
    priceEditController.clear();
    priorityEditController.clear();
  }

  openProductDialog({
    // ignore: avoid_build_context_in_providers
    required BuildContext context,
    required OperationType operationType,
    ProductModel? product,
  }) {
    CategoryModel? selectedCate;
    if (operationType == OperationType.edit) {
      final categoryList = ref.watch(categoryListProvider);
      productEditController.text = product?.name ?? "";
      priceEditController.text = product?.price ?? "0";
      priorityEditController.text = product?.priority?.toString() ?? "1";
      selectedCate = categoryList.firstWhere(
        (cate) => cate.id == product?.categoryId,
        // orElse: () => CategoryModel(name: ""),
      );
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // final tabIndex = ref.watch(tabIndexProvider);
        // String itemType = tabIndex == 0 ? "Category" : "Product";
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${operationType.name} Product",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      final categoryList = ref.watch(categoryListProvider);
                      print("cats............. $categoryList");
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Select category",
                        ),
                        validator: (value) =>
                            value == null ? "Select a category" : null,
                        initialValue: selectedCate,
                        onChanged: (value) {
                          selectedCate = value;
                        },
                        items: List.generate(
                          categoryList.length,
                          (index) => DropdownMenuItem(
                            value: categoryList[index],
                            // label: categoryList[index].name,
                            child: Text(categoryList[index].name),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
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
                          clearTextEditingControllers();
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            String name = productEditController.text;
                            String price = priceEditController.text;
                            int categoryId = selectedCate!.id!;

                            int priority =
                                int.tryParse(priorityEditController.text) ?? 1;

                            if (operationType == OperationType.add) {
                              addProduct(
                                name: name,
                                categoryId: categoryId,
                                price: price,
                                priority: priority,
                              );
                            } else if (operationType == OperationType.edit) {
                              updateProduct(
                                id: product!.id!,
                                name: name,
                                categoryId: categoryId,
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
