import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/ui/products/providers/products_provider.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(productsProvider.notifier)
              .openProductDialog(
                context: context,
                operationType: OperationType.add,
              );
        },
        // backgroundColor: Colors.teal,
        child: Icon(Icons.add),
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
}
