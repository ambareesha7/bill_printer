import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../data/models/sale_receipts/sale_receipt_model.dart';

class ReportWidget extends ConsumerWidget {
  const ReportWidget(this.reportType, {super.key});
  final ReportType reportType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedMonth = monthFormat(ref.watch(monthlyDateProvider));
    final List<SaleReceiptModel> transList = ref.watch(
      (reportType == ReportType.monthly)
          ? monthlyReportProvider
          : yearlyReportProvider,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer(
              builder: (context, ref, child) {
                int totalAmount = getTotalAmount(
                  ref.watch(
                    (reportType == ReportType.monthly)
                        ? monthlyReportProvider
                        : yearlyReportProvider,
                  ),
                );
                return Row(
                  children: [
                    Text("Total: "),
                    Text(
                      "₹$totalAmount",
                      style: TextStyle(color: AppColors.orange),
                    ),
                  ],
                );
              },
            ),
            if (reportType == ReportType.yearly)
              Text(
                "All transactions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (reportType == ReportType.monthly)
              TextButton.icon(
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    initialDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      ref.read(monthlyDateProvider.notifier).updateDate(date);
                      ref
                          .read(monthlyReportProvider.notifier)
                          .getMonthlyTransactions(date);
                    }
                  });
                },
                label: Text(selectedMonth),
                icon: Icon(Icons.unfold_more_sharp),
                iconAlignment: IconAlignment.end,
              ),
          ],
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              return ListView.builder(
                itemCount: transList.length,
                itemBuilder: (context, index) {
                  final transaction = transList.reversed.toList()[index];
                  final List<BillItemModel>? subItems = transaction.billItems;
                  return ExpansionTile(
                    title: Text(getItemNames(transaction.billItems)),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(dateFormat(transaction.createdAt!.toLocal())),
                        Text("No: ${transaction.orederNo ?? ""}"),
                        Text(
                          (transaction.paymentMode ?? "Cash").toUpperCase(),
                          style: TextStyle(color: AppColors.blue),
                        ),
                        Text(
                          "₹${transaction.totalAmount}",
                          style: TextStyle(color: AppColors.orange),
                        ),
                      ],
                    ),
                    collapsedIconColor: AppColors.blue,
                    backgroundColor: AppColors.gridLinesColor,
                    collapsedTextColor: AppColors.blueGrey,
                    collapsedShape: BeveledRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(5),
                      side: BorderSide(
                        color: AppColors.borderColor,
                        width: 0.5,
                      ),
                    ),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 8),
                    children: <Widget>[
                      if (transaction.preparedBy != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(("Created by: ")),
                                Text(
                                  (transaction.preparedBy ?? ""),
                                  style: TextStyle(color: AppColors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (transaction.paymentRef != null)
                        Text("Bank Ref: ${transaction.paymentRef ?? ""}"),
                      Text("ID: ${transaction.id ?? ""}"),
                      ...renderSubItems(subItems),
                      Wrap(
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // debugLog(transaction);
                          //   },
                          //   child: Text("Edit"),
                          // ),
                          IconButton(
                            onPressed: () {
                              UIUtils.confirmDialog(
                                context: context,
                                subTitle: "Are you sure you want to delete",
                                title:
                                    "Order no: ${transaction.orederNo}\n${getItemNames(transaction.billItems)}",
                                rightFun: () {
                                  ref
                                      .read(monthlyReportProvider.notifier)
                                      .delete(transaction.id!);
                                },
                              );
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> renderSubItems(List<BillItemModel>? items) {
    List<Widget> list = [];
    if (items == null) [];
    for (BillItemModel i in items ?? []) {
      list.add(
        Wrap(
          children: [
            Text("${i.name} ", style: TextStyle(color: AppColors.blueGrey)),
            Text("Rate: "),
            Text("${i.rate} ", style: TextStyle(color: AppColors.blueGrey)),
            Text("Qty: "),
            Text("${i.quantity} ", style: TextStyle(color: AppColors.blueGrey)),
            Text("Amount: "),
            Text(
              "₹${i.rate * i.quantity}",
              style: TextStyle(color: AppColors.blueGrey),
            ),
          ],
        ),
      );
    }
    return list;
  }

  String getItemNames(List<BillItemModel>? items) {
    if (items == null) return "";
    return items.map((i) => i.name).toList().join(", ");
  }
}
