// ignore_for_file: use_build_context_synchronously

import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/ui/shop/shop_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopView extends ConsumerStatefulWidget {
  const ShopView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopViewState();
}

class _ShopViewState extends ConsumerState<ShopView> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mapAddressController = TextEditingController();
  bool isPrime = false;
  final formKey = GlobalKey<FormState>();

  void _clearForm() {
    shopNameController.clear();
    shopIdController.clear();
    addressController.clear();
    mapAddressController.clear();
    isPrime = false;
  }

  void _showShopForm({required OperationType operationType, int? shopId}) {
    if (operationType == OperationType.edit && shopId != null) {
      final shops = ref.read(shopListProvider);
      final shop = shops.firstWhere((s) => s.id == shopId);
      shopNameController.text = shop.name;
      shopIdController.text = shop.shopId;
      addressController.text = shop.address ?? '';
      mapAddressController.text = shop.mapAddress ?? '';
      isPrime = shop.isPrime ?? false;
    } else {
      _clearForm();
    }


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${operationType.name.toUpperCase()} SHOP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Shop Name *",
                        hintText: "e.g. MoonLight1",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: shopNameController,

                      validator: (value) {
                        debugLog(value, tag: "validator");
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        } else if (value.length < 3) {
                          return "ID should be more then 2";
                        } else if (value.length > 100) {
                          return "ID should not be more then 100";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Shop ID
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: "Shop ID *",
                        hintText: "e.g. ML1",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: shopIdController,
                      onChanged: (value) {
                        debugLog(value, tag: "onChanged");
                      },
                      validator: (value) {
                        debugLog(value, tag: "validator");
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        } else if (value.length < 3) {
                          return "ID should be more then 2";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Business Address",
                        hintText: "Enter the full street address...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: addressController,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Map Address",
                        hintText: "Paste map URL or coordinates...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: mapAddressController,
                    ),
                    SizedBox(height: 15),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return SwitchListTile(
                          title: Text("Prime Status"),
                          subtitle: Text("Enable premium listing and features"),
                          value: isPrime,
                          onChanged: (value) {
                            setState(() {
                              isPrime = value;
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _clearForm();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          label: Text("Cancel"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (operationType == OperationType.add) {
                                String result = await ref
                                    .read(shopListProvider.notifier)
                                    .addShop(
                                      name: shopNameController.text,
                                      isPrime: isPrime,
                                      shopId: shopIdController.text,
                                      address: addressController.text.isEmpty
                                          ? null
                                          : addressController.text,
                                      mapAddress:
                                          mapAddressController.text.isEmpty
                                          ? null
                                          : mapAddressController.text,
                                    );
                                if (result.contains("Success")) {
                                  UIUtils.showSnackBar(
                                    context: context,
                                    text: "Shop created successfully!",
                                  );
                                } else {
                                  UIUtils.showSnackBar(
                                    context: context,
                                    text: "Error: $result",
                                    bgColor: AppColors.error1,
                                  );
                                }
                              } else if (operationType == OperationType.edit &&
                                  shopId != null) {
                                String result = await ref
                                    .read(shopListProvider.notifier)
                                    .updateShop(
                                      id: shopId,
                                      shopId: shopIdController.text,
                                      name: shopNameController.text,
                                      isPrime: isPrime,
                                      address: addressController.text.isEmpty
                                          ? null
                                          : addressController.text,
                                      mapAddress:
                                          mapAddressController.text.isEmpty
                                          ? null
                                          : mapAddressController.text,
                                    );
                                if (result.contains("Success")) {
                                  UIUtils.showSnackBar(
                                    context: context,
                                    text: "Shop Updated successfully!",
                                  );
                                } else {
                                  UIUtils.showSnackBar(
                                    context: context,
                                    text: "Error: $result",
                                    bgColor: AppColors.error1,
                                  );
                                }
                              }
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
    mapAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shops = ref.watch(shopListProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Shop Management"), elevation: 0),
      body: shops.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No shops yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Add your first shop to get started"),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showShopForm(operationType: OperationType.add);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Shop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Locations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  shop.name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (shop.isPrime ?? false)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: 8,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.pink1
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Prime",
                                                    style: TextStyle(
                                                      color: AppColors.pink1,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "ID: ${shop.shopId}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        if (shop.isPrime != null &&
                                            shop.isPrime != true)
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .panorama_fish_eye_outlined,
                                                  size: 18,
                                                  color: AppColors.pink1,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Make it Prime"),
                                              ],
                                            ),
                                            onTap: () {
                                              ref
                                                  .read(
                                                    shopListProvider.notifier,
                                                  )
                                                  .updateShop(
                                                    id: shop.id!,
                                                    shopId: shop.shopId,
                                                    isPrime: true,
                                                  );
                                            },
                                          ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 8),
                                              Text("Edit"),
                                            ],
                                          ),
                                          onTap: () {
                                            _showShopForm(
                                              operationType: OperationType.edit,
                                              shopId: shop.id,
                                            );
                                          },
                                        ),
                                        if (shop.isPrime != null &&
                                            shop.isPrime != true)
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Delete"),
                                              ],
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("Delete Shop?"),
                                                  content: Text(
                                                    "Are you sure you want to delete ${shop.name}?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        ref
                                                            .read(
                                                              shopListProvider
                                                                  .notifier,
                                                            )
                                                            .deleteShop(
                                                              shop.id!,
                                                            );
                                                        Navigator.pop(context);
                                                        UIUtils.showSnackBar(
                                                          context: context,
                                                          text:
                                                              "Shop deleted successfully!",
                                                        );
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (shop.address != null &&
                                    shop.address!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            shop.address!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (shop.createdAt != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Created: ${_formatDate(shop.createdAt!)}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "Updated: ${_formatDate(shop.updatedAt ?? shop.createdAt!)}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: shops.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                _showShopForm(operationType: OperationType.add);
              },
              backgroundColor: Colors.teal,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
