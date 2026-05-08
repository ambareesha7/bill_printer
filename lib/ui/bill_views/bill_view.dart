// ignore_for_file: use_build_context_synchronously

import 'package:bill_printer/app_router.dart';
import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/data/models/users/user_model.dart';
import 'package:bill_printer/ui/auth/providers/auth_provider.dart';
import 'package:bill_printer/ui/bill_views/providers/bill_provider.dart';
import 'package:bill_printer/ui/bill_views/providers/order_num_provider.dart';
import 'package:bill_printer/ui/category/product_provider.dart';
import 'package:bill_printer/ui/printer/providers/printer_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../data/models/bank_account/bank_account_model.dart';
import '../widgets/nav_btn.dart';

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
    final user = ref.watch(authProvider);
    final orderNo = ref.watch(orderNumProvider);
    ref.watch(printerProvider);
    var listItems = ref.watch(tempBillListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoonLight Cafe"),
        centerTitle: true,
        actions: [NavBtn(path: RouterPaths.reports.name)],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(
          left: bodyPadding,
          right: bodyPadding,
          bottom: bodyPadding,
        ),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return Text(
                  "Order No: $orderNo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
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
                  items: getTotalQuantity(billItems).toString(),
                  total: ref
                      .read(billListProvider.notifier)
                      .getTotalAmount()
                      .toString(),
                );
              },
            ),
            if (user != null) _buildActionButtons(user),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AppBtn1(
                    name: "Print",
                    onPressed: () {
                      final billItems = ref.watch(billListProvider);
                      if (billItems.isEmpty) return;
                      ref
                          .read(printerProvider.notifier)
                          .printBill(
                            context: context,
                            orderNo: orderNo,
                            paymentStatus: "Not Paid",
                            dateTime: dateFormat(dateTimeNow()),
                            itemsList: billItems,
                            totalItems: getTotalQuantity(billItems).toString(),
                            totalAmount: ref
                                .read(billListProvider.notifier)
                                .getTotalAmount()
                                .toString(),
                          );
                    },
                  ),
                  AppBtn1(
                    name: "Add Product",
                    bgColor: AppColors.blue,
                    onPressed: () {
                      ref
                          .read(productsListProvider.notifier)
                          .openProductDialog(
                            context: context,
                            operationType: OperationType.add,
                          );
                    },
                  ),
                  AppBtn1(
                    name: "To Temp",
                    bgColor: AppColors.orange,
                    onPressed: () {
                      List<BillItemModel> item = ref.watch(billListProvider);
                      if (item.isNotEmpty) {
                        ref.read(tempBillListProvider.notifier).addOrder(item);
                        ref.read(billListProvider.notifier).clearItems();
                      }
                    },
                  ),
                  AppBtn1(
                    name: "Open Temp",
                    onPressed: () {
                      if (listItems.isEmpty) {
                        UIUtils.showSnackBar(
                          context: context,
                          text: "No items in temporary list",
                        );
                        return;
                      }
                      showAdaptiveDialog(
                        barrierLabel: "Temporary items",
                        barrierColor: AppColors.borderColor,
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog.fullscreen(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(Icons.arrow_downward),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    itemCount: listItems.length,
                                    itemBuilder: (context, index) {
                                      var item = listItems[index];
                                      return ListTile(
                                        title: Text(
                                          "${index + 1}, ${listItems[index].map((i) => i.name).toList().join(", ")}",
                                        ),
                                        tileColor: index % 2 == 0
                                            ? AppColors.blueGrey
                                            : AppColors.blue,
                                        onTap: () {
                                          ref
                                              .read(billListProvider.notifier)
                                              .clearItems();
                                          ref
                                              .read(billListProvider.notifier)
                                              .updateFromList(item);
                                          ref
                                              .read(
                                                tempBillListProvider.notifier,
                                              )
                                              .removeOrder(item);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  AppBtn1(
                    name: "Bill",
                    bgColor: AppColors.blueGrey,
                    onPressed: () async {
                      int amount = ref
                          .read(billListProvider.notifier)
                          .getTotalAmount();
                      if (amount > 0) {
                        saveNClearBill(
                          paymentMode: PaymentMode.others,
                          paymentStatus: PaymentStatus.receivable,
                          preparedBy: user?.fullName,
                          orderNo: orderNo,
                          print: true,
                        );
                      } else {
                        UIUtils.showSnackBar(
                          context: context,
                          text: "Please add some billable items",
                          bgColor: AppColors.red,
                        );
                      }
                    },
                  ),
                  AppBtn1(
                    name: "Bill No Print",
                    bgColor: AppColors.blueGrey,
                    onPressed: () async {
                      int amount = ref
                          .read(billListProvider.notifier)
                          .getTotalAmount();
                      if (amount > 0) {
                        saveNClearBill(
                          paymentMode: PaymentMode.others,
                          paymentStatus: PaymentStatus.receivable,
                          preparedBy: user?.fullName,
                          orderNo: orderNo,
                          print: false,
                        );
                      } else {
                        UIUtils.showSnackBar(
                          context: context,
                          text: "Please add some billable items",
                          bgColor: AppColors.red,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
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

  Widget _buildActionButtons(UserModel user) {
    String orderNo = ref.watch(orderNumProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AppBtn1(
            name: "Clear",
            onPressed: () {
              ref.read(billListProvider.notifier).clearItems();
            },
            bgColor: AppColors.red,
          ),

          SizedBox(width: btnPadding),
          AppBtn1(
            name: "QR Code",
            bgColor: Colors.green[400],
            onPressed: () async {
              int amount = ref.read(billListProvider.notifier).getTotalAmount();
              if (amount > 0) {
                BankAccountModel? bankAccount = await checkBankAC(context);
                if (bankAccount != null) {
                  _openQRcode(
                    primAccount: bankAccount,
                    amount: amount,
                    preparedBy: user.fullName,
                    orderNo: orderNo,
                  );
                }
              } else {
                UIUtils.showSnackBar(
                  context: context,
                  text: "Please add some billable items to generate QR code",
                  bgColor: AppColors.red,
                );
              }
            },
          ),
          cashBtn(
            user: user,
            orderNo: orderNo,
            btnName: "Cash",
            billPrint: true,
            bgColor: AppColors.blue,
          ),
          cashBtn(
            user: user,
            orderNo: orderNo,
            btnName: "Cash no print",
            billPrint: false,
          ),
          AppBtn1(
            name: "Received in Bank",
            bgColor: AppColors.blueGrey,
            onPressed: () async {
              int amount = ref.read(billListProvider.notifier).getTotalAmount();
              if (amount > 0) {
                BankAccountModel? bankAccount = await checkBankAC(context);
                if (bankAccount != null) {
                  saveNClearBill(
                    paymentMode: PaymentMode.upi,
                    paymentStatus: PaymentStatus.received,
                    preparedBy: user.fullName,
                    orderNo: orderNo,
                    paymentRef: bankAccount.upiId,
                  );
                }
              } else {
                UIUtils.showSnackBar(
                  context: context,
                  text: "Please add some billable items",
                  bgColor: AppColors.red,
                );
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              visualDensity: VisualDensity(horizontal: -2, vertical: -2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
              ),
              backgroundColor: AppColors.purple,
            ),
            onPressed: () => _openCalculator(),
            child: Row(
              children: [
                Icon(Icons.calculate),
                Text("Cals", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          AppBtn1(
            name: "Change bank",
            onPressed: () {
              context.push("/${RouterPaths.bankAccount.name}");
            },
          ),
          AppBtn1(
            name: "Reset OrderNo",
            bgColor: AppColors.purple,
            onPressed: () {
              UIUtils.confirmDialog(
                context: context,
                title: "Reset Oreder Number",
                subTitle: "Are you sure",
                rightBtnName: "Reset",
                rightFun: () {
                  ref.read(orderNumProvider.notifier).resetOrderNo();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  AppBtn1 cashBtn({
    required UserModel user,
    required String orderNo,
    required String btnName,
    required bool billPrint,
    Color? bgColor,
  }) {
    return AppBtn1(
      name: btnName,
      bgColor: bgColor,
      onPressed: () {
        int amount = ref.read(billListProvider.notifier).getTotalAmount();
        if (amount > 0) {
          saveNClearBill(
            paymentMode: PaymentMode.cash,
            paymentStatus: PaymentStatus.received,
            preparedBy: user.fullName,
            orderNo: orderNo,
            print: billPrint,
          );
        } else {
          UIUtils.showSnackBar(
            context: context,
            text: "Please add some billable items",
            bgColor: AppColors.red,
          );
        }
      },
    );
  }

  saveNClearBill({
    required PaymentMode paymentMode,
    required PaymentStatus paymentStatus,
    required String orderNo,
    String? paymentRef,
    String? preparedBy,
    bool print = false,
  }) async {
    await ref
        .read(billListProvider.notifier)
        .saveOrder(
          paymentMode: paymentMode,
          paymentStatus: paymentStatus,
          orderNo: orderNo,
          paymentRef: paymentRef,
          preparedBy: preparedBy,
        );
    final billItems = ref.watch(billListProvider);
    String totalItems = getTotalQuantity(billItems).toString();
    String totalAmount = ref
        .read(billListProvider.notifier)
        .getTotalAmount()
        .toString();
    if (print && paymentStatus == PaymentStatus.received) {
      ref
          .read(printerProvider.notifier)
          .printBill(
            context: context,
            orderNo: orderNo,
            paymentMode: paymentMode.name,
            dateTime: dateFormat(dateTimeNow()),
            itemsList: billItems,
            totalItems: totalItems,
            totalAmount: totalAmount,
          );
    } else if (print && paymentStatus != PaymentStatus.received) {
      ref
          .read(printerProvider.notifier)
          .printBill(
            context: context,
            orderNo: orderNo,
            paymentMode: paymentMode.name,
            paymentStatus: "Not Paid",
            dateTime: dateFormat(dateTimeNow()),
            itemsList: billItems,
            totalItems: totalItems,
            totalAmount: totalAmount,
          );
    }
    ref.read(billListProvider.notifier).clearItems();
    ref.read(orderNumProvider.notifier).updateOrderNo();
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

  _openQRcode({
    required BankAccountModel primAccount,
    required int amount,
    required String orderNo,
    String? preparedBy,
  }) async {
    String upi =
        "upi://pay?pa=${primAccount.upiId}&pn=${primAccount.name}&cu=INR&am=$amount";
    String ref = "UPI=${primAccount.upiId},Name=${primAccount.name}";
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
              Text("UPI ID: ${primAccount.upiId}"),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bill amount: ", style: TextStyle(fontSize: 18)),
                    Text(
                      "₹$amount",
                      style: TextStyle(fontSize: 18, color: AppColors.orange),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppBtn1(
                    name: "Cancel",
                    bgColor: AppColors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  AppBtn1(
                    name: "Paid",
                    bgColor: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                      saveNClearBill(
                        paymentMode: PaymentMode.upi,
                        paymentStatus: PaymentStatus.received,
                        paymentRef: ref,
                        preparedBy: preparedBy,
                        orderNo: orderNo,
                        print: true,
                      );
                    },
                  ),
                  AppBtn1(
                    name: "Paid No print",
                    bgColor: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                      saveNClearBill(
                        paymentMode: PaymentMode.upi,
                        paymentStatus: PaymentStatus.received,
                        paymentRef: ref,
                        preparedBy: preparedBy,
                        orderNo: orderNo,
                        print: false,
                      );
                    },
                  ),
                ],
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
      color: AppColors.blueGrey,
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
