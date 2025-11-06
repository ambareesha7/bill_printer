import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/bill_views/providers/bill_provider.dart';
import 'package:bill_printer/ui/category/product_provider.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../data/models/bank_account/bank_account_model.dart';
import '../bank_account/bank_account_view.dart';

class BillView extends ConsumerStatefulWidget {
  const BillView({super.key});

  @override
  ConsumerState<BillView> createState() => _BillViewState();
}

class _BillViewState extends ConsumerState<BillView> {
  final double btnPadding = 4;
  final double bodyPadding = 8;
  DBUtils dbUtils = DBUtils.instance;
  @override
  Widget build(BuildContext context) {
    final itemHeadStyle = TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: Text("Itemwise Bill")),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(
          left: bodyPadding,
          right: bodyPadding,
          bottom: bodyPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Build Bill Table
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Container(
                    color: Colors.orange,
                    padding: const EdgeInsets.all(4),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text('TOTAL', style: itemHeadStyle),
                        ),
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
            buildCategories(),
            //======== build product cards =========
            Expanded(
              flex: 6,
              child: Consumer(
                builder: (context, ref, child) {
                  final productsList = ref.watch(productsListProvider);
                  return GridView.builder(
                    itemCount: productsList.length,
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

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
          AppBtn1(
            name: "QR Code",
            bgColor: Colors.green[400],
            onPressed: () async {
              List<BillItemModel> billItems = ref.watch(billListProvider);
              int amount = ref
                  .read(billListProvider.notifier)
                  .getTotalAmount(billItems);
              if (amount > 0) {
                List<BankAccountModel> bankAccounts = await dbUtils
                    .parseBankAccounts();
                if (bankAccounts.isEmpty) {
                  UIUtils.showSnackBar(
                    // ignore: use_build_context_synchronously
                    context: context,
                    text: "Please add bank account to generate QR code",
                    bgColor: Colors.red,
                  );
                } else {
                  BankAccountModel primAccount = getPrimeryUPI(bankAccounts);
                  _openQRcode(primAccount: primAccount, amount: amount);
                }
              } else {
                UIUtils.showSnackBar(
                  context: context,
                  text:
                      "Total amount is $amount, Please add some billable items to generate QR code",
                  bgColor: Colors.red,
                );
              }
            },
          ),
          AppBtn1(name: "Save", onPressed: () {}),
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.calculate),
                Text(
                  "Cals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            onPressed: () {
              _openCalculator();
            },
          ),
          AppBtn1(
            name: "Change bank",
            bgColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BankAccountView()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
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
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        label: Text(label, style: TextStyle(color: Colors.white)),
        backgroundColor: isSelected ? Colors.orange : Colors.grey[800],
      ),
    );
  }

  _openCalculator() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
          child: SimpleCalculator(
            theme: const CalculatorThemeData(equalColor: Colors.orange),
          ),
        );
      },
    );
  }

  BankAccountModel getPrimeryUPI(List<BankAccountModel> bankAccounts) {
    return bankAccounts.firstWhere(
      (el) => el.isPrime,
      orElse: () => bankAccounts.first,
    );
  }

  _openQRcode({
    required BankAccountModel primAccount,
    required int amount,
  }) async {
    String upi =
        "upi://pay?pa=${primAccount.upiId}&pn=${primAccount.name}&cu=INR&am=$amount";
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              PrettyQrView.data(
                data: upi,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(),
                  background: Colors.white,
                  quietZone: PrettyQrQuietZone.standart,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Bill amount: ₹$amount",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              AppBtn1(
                name: "Close",
                bgColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        visualDensity: VisualDensity(horizontal: -2, vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
        ),
      ),
      child: Text(name, style: TextStyle(color: textColor ?? Colors.white)),
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
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("Total"), Text(items), Text('₹$total')],
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
