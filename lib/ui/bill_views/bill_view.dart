import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/bill_views/bill_provider.dart';
import 'package:bill_printer/ui/category/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillView extends ConsumerStatefulWidget {
  const BillView({super.key});

  @override
  ConsumerState<BillView> createState() => _BillViewState();
}

class _BillViewState extends ConsumerState<BillView> {
  final double btnPadding = 4;
  @override
  Widget build(BuildContext context) {
    final itemHeadStyle = TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: Text("Itemwise Bill")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildBillTable(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text('ITEM', style: itemHeadStyle),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('QTY', style: itemHeadStyle),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('RATE', style: itemHeadStyle),
                        ),
                        // Expanded(child: ),
                        Text('TOTAL', style: itemHeadStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ListView.builder(
                          itemCount: ref.watch(billListProvider).length,
                          itemBuilder: (context, index) {
                            return BillRow(
                              item: ref.watch(billListProvider)[index],
                              onTap: () {
                                ref.watch(billItemProvider);

                                ref
                                    .read(billItemProvider.notifier)
                                    .openItemDialog(
                                      context: context,
                                      item: ref.watch(billListProvider)[index],
                                    );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final billItems = ref.watch(billListProvider);
                return TotalSection(
                  items: ref
                      .read(billListProvider.notifier)
                      .getTotalQuantity(billItems)
                      .toString(),
                  total: ref
                      .read(billListProvider.notifier)
                      .getTotalAmount(billItems)
                      .toString(),
                );
              },
            ),
            _buildActionButtons(),
            _buildCategories(),

            // _buildProductGrid(),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final productsList = ref.watch(productsListProvider);
                  return GridView.builder(
                    itemCount: productsList.length,
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: productsList[index].name ?? "",
                        price: productsList[index].price ?? "0",

                        onTap: () {
                          ref
                              .read(billListProvider.notifier)
                              .addItem(productsList[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method after _buildBillTable()

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AppBtn1(
            name: "Clear",
            onPressed: () {
              ref.read(billListProvider.notifier).clearItems();
            },
            bgColor: Colors.red,
          ),
          SizedBox(width: btnPadding),
          AppBtn1(
            name: "Add Product",
            onPressed: () {
              ref
                  .read(productsListProvider.notifier)
                  .openProductDialog(
                    context: context,
                    operationType: OperationType.add,
                  );
            },
          ),
          SizedBox(width: btnPadding),
          AppBtn1(name: "Print", onPressed: () {}),
          AppBtn1(name: "Save", onPressed: () {}),
          SizedBox(width: btnPadding),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          1,
          (index) => _buildCategoryChip('ALL', isSelected: true),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.orange : Colors.grey[800],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.onTap,
  });

  final String name;
  final String price;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
              Text('₹$price', style: const TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBtn1 extends StatelessWidget {
  const AppBtn1({
    super.key,
    required this.name,
    this.onPressed,
    this.bgColor,
    this.textColor,
  });
  final String name;
  final void Function()? onPressed;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(name, style: TextStyle(color: textColor)),
    );
  }
}

class TotalSection extends StatelessWidget {
  const TotalSection({super.key, required this.items, required this.total});

  final String items;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total"),
          // SizedBox.expand(),
          Text(items),
          Text('₹$total'),
        ],
      ),
    );
  }
}

class BillRow extends StatelessWidget {
  const BillRow({super.key, required this.item, this.onTap});

  final BillItemModel item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
        ),
        child: Row(
          children: [
            Expanded(flex: 5, child: Text(item.name)),
            Expanded(flex: 2, child: Text("${item.quantity}")),
            Expanded(flex: 2, child: Text("${item.rate}")),
            Expanded(child: Text("${item.rate * item.quantity}")),
          ],
        ),
      ),
    );
  }
}
