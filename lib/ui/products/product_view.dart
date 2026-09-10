import 'dart:io';

import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/services/product_transfer_service.dart';
import 'package:bill_printer/ui/products/providers/products_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/grid_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Products"), centerTitle: true),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            label: Text("Export"),
            onPressed: () => exportProducts(context, products),
            icon: const Icon(Icons.upload),
          ),
          TextButton.icon(
            label: Text("Import"),
            onPressed: () => importProducts(context),
            icon: const Icon(Icons.download),
          ),
          FloatingActionButton(
            onPressed: () {
              ref
                  .read(productsProvider.notifier)
                  .openProductDialog(
                    context: context,
                    operationType: OperationType.add,
                  );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [ElevatedButton(onPressed: () {}, child: Text("All"))],
          ),
          Expanded(
            child: GridView.builder(
              itemCount: products.length,
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return GridCard(
                  text: products[index].name ?? "",
                  price: products[index].price ?? "0",
                  editFunc: () {
                    if (products[index].id != null) {
                      ref
                          .read(productsProvider.notifier)
                          .openProductDialog(
                            context: context,
                            operationType: OperationType.edit,
                            product: products[index],
                          );
                    }
                  },
                  deleteFunc: () {
                    UIUtils.confirmDialog(
                      context: context,
                      title: "Are you sure",
                      subTitle: "${products[index].name}",
                      rightFun: () {
                        ref
                            .read(productsProvider.notifier)
                            .deleteProduct(products[index].id!);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportProducts(BuildContext context, products) async {
    try {
      final file = await ProductTransferService.instance.exportProducts(
        products,
      );
      final result = await FileManager().shareFile(file);
      if (!context.mounted || result == null) return;
      UIUtils.showSnackBar(
        context: context,
        text: result.status == ShareResultStatus.success
            ? "Products exported successfully"
            : "Product export was cancelled",
      );
    } catch (_) {
      if (!context.mounted) return;
      UIUtils.showSnackBar(
        context: context,
        text: "Something went wrong while exporting products",
        bgColor: AppColors.red,
      );
    }
  }

  Future<void> importProducts(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );
    if (!context.mounted ||
        result == null ||
        result.files.isEmpty ||
        result.files.first.path == null) {
      return;
    }

    final imported = await ProductTransferService.instance.importProducts(
      File(result.files.first.path!),
    );
    if (!context.mounted) return;
    if (imported) {
      await ref.read(productsProvider.notifier).refreshProducts();
    }
    if (!context.mounted) return;
    UIUtils.showSnackBar(
      context: context,
      text: imported
          ? "Products imported successfully"
          : "Something went wrong while importing products",
      bgColor: imported ? null : AppColors.red,
    );
  }
}
