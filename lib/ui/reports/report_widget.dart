import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/reports/filters_panel.dart';
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
    final List<SaleReceiptModel> allTransactions = ref.watch(
      (reportType == ReportType.monthly)
          ? monthlyReportProvider
          : yearlyReportProvider,
    );
    List<String> availableFilters = ref.watch(filtersListProvider);
    List<String> appliedFilters = ref.watch(appliedFiltersProvider);
    Future.delayed(Duration(seconds: 1), () async {});

    // Filter transactions based on applied filters
    final List<SaleReceiptModel> transList = _filterTransactions(
      allTransactions,
      appliedFilters,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer(
              builder: (context, ref, child) {
                int totalAmount = getTotalAmount(transList);
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
                      ref
                          .read(appliedFiltersProvider.notifier)
                          .updateAppliedFilters([]);
                    }
                  });
                },
                label: Text(selectedMonth),
                icon: Icon(Icons.unfold_more_sharp),
                iconAlignment: IconAlignment.end,
              ),
            // Filter Button with Badge showing active filters
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                appliedFilters = ref.watch(appliedFiltersProvider);
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(filtersListProvider.notifier)
                            .updateFilters(allTransactions);
                        availableFilters = ref.watch(filtersListProvider);
                        debugLog(
                          availableFilters.length,
                          tag: "availableFilters",
                        );

                        showDialog(
                          context: context,
                          builder: (context) => FiltersPanel(
                            availableFilters: availableFilters,
                            reportType: reportType,
                            onApplyFilters: (selectedFilters) {
                              ref
                                  .read(appliedFiltersProvider.notifier)
                                  .updateAppliedFilters(selectedFilters);
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.filter_alt),
                    ),
                    if (appliedFilters.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            appliedFilters.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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

  // List<String> getFilterNames(List<SaleReceiptModel> transList) {
  //   List<String> filters = [];
  //   for (var i in transList) {
  //     if (i.paymentMode != null && i.paymentMode!.isNotEmpty) {
  //       filters.add(i.paymentMode!);
  //     }
  //     if (i.paymentRef != null && i.paymentRef!.isNotEmpty) {
  //       String ss = i.paymentRef!.split(",").first.split("=").last;
  //       filters.add(ss);
  //     }
  //   }
  //   filters = filters.toSet().toList();
  //   filters.sort();
  //   return filters;
  // }

  List<Widget> renderSubItems(List<BillItemModel>? items) {
    List<Widget> list = [];
    if (items == null) [];
    for (BillItemModel i in items ?? []) {
      list.add(
        Wrap(
          children: [
            Text("${i.name} ", style: TextStyle(color: AppColors.blueGrey)),
            Text("Qty: "),
            Text("${i.quantity} ", style: TextStyle(color: AppColors.blueGrey)),
            Text("Rate: "),
            Text("${i.rate} ", style: TextStyle(color: AppColors.blueGrey)),
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

  List<SaleReceiptModel> _filterTransactions(
    List<SaleReceiptModel> transactions,
    List<String> appliedFilters,
  ) {
    if (appliedFilters.isEmpty) return transactions;

    return transactions.where((transaction) {
      // Check payment mode
      if (transaction.paymentMode != null &&
          appliedFilters.contains(transaction.paymentMode)) {
        return true;
      }

      // Check bank reference
      if (transaction.paymentRef != null &&
          transaction.paymentRef!.isNotEmpty) {
        String bankRef = transaction.paymentRef!
            .split(",")
            .first
            .split("=")
            .last;
        if (appliedFilters.contains(bankRef)) {
          return true;
        }
      }

      return false;
    }).toList();
  }
}

List<PopupMenuItem<String>> renderFilters(List<String> list) {
  List<PopupMenuItem<String>> items = [
    PopupMenuItem(
      value: "Reset",
      child: Row(
        children: [
          SizedBox(width: 8),
          Text("Reset", style: TextStyle(color: AppColors.orange)),
        ],
      ),
    ),
  ];
  for (var i in list) {
    items.add(
      PopupMenuItem(
        value: i,
        child: Row(children: [SizedBox(width: 8), Text(i)]),
      ),
    );
  }
  return items;
}

// List<SaleReceiptModel> filterItems({
//   required List<SaleReceiptModel> list,
//   required List<String> filterItems,
// }) {
//   List<SaleReceiptModel> transList = [];
//   for (var i in list) {
//     if (i.paymentMode != null &&
//         filterItems.contains(i.paymentMode?.toLowerCase())) {
//       transList.add(i);
//     } else if (i.paymentRef != null && i.paymentRef!.isNotEmpty) {
//       String ss = i.paymentRef!.split(",").first.split("=").last;
//       if (filterItems.contains(ss.toLowerCase())) {
//         transList.add(i);
//       }
//     }
//   }
//   return transList;
// }
