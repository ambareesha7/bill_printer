import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/reports/filters_panel.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/date_range_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../data/models/bank_account/bank_account_model.dart';
import '../../data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/ui/printer/providers/printer_provider.dart';

import '../bill_views/providers/bill_provider.dart';

class ReportWidget extends ConsumerWidget {
  const ReportWidget(this.reportType, {super.key});
  final ReportType reportType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedMonth = monthFormat(ref.watch(monthlyDateProvider));
    final dateRange = ref.watch(dateRangeProvider);
    ref.watch(dateRangeReportProvider);
    ref.watch(printerProvider);
    DBUtils dbUtils = DBUtils.instance;

    // TODO: REMOVE MONTHLY REPORT IF IT IS POSSIBLE
    final List<SaleReceiptModel> allTransactions =
        (dateRange.startDate != null && dateRange.endDate != null)
        ? ref.watch(dateRangeReportProvider)
        : (reportType == ReportType.monthly)
        ? ref.watch(monthlyReportProvider)
        : ref.watch(yearlyReportProvider);

    List<String> availableFilters = ref.watch(filtersListProvider);
    List<String> appliedFilters = ref.watch(appliedFiltersProvider);

    // Filter transactions based on applied filters
    final List<SaleReceiptModel> transList = _filterTransactions(
      allTransactions,
      appliedFilters,
    );

    return Column(
      children: [
        // Date Range Selection (only show for custom date range reports)
        if (reportType == ReportType.yearly)
          DateRangeWidget(
            dateRange: dateRange,
            onFromDateSelect: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: dateRange.startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && context.mounted) {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    dateRange.startDate ?? DateTime.now(),
                  ),
                );
                if (pickedTime != null) {
                  final dateWithTime = pickedDate.copyWith(
                    hour: pickedTime.hour,
                    minute: pickedTime.minute,
                  );
                  ref
                      .read(dateRangeProvider.notifier)
                      .setDateRange(dateWithTime, dateRange.endDate);
                  if (dateRange.endDate != null) {
                    await ref
                        .read(dateRangeReportProvider.notifier)
                        .getDateRangeTransactions(
                          dateWithTime,
                          dateRange.endDate!,
                        );
                    ref
                        .read(appliedFiltersProvider.notifier)
                        .updateAppliedFilters([]);
                  }
                }
              }
            },
            onToDateSelect: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: dateRange.endDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && context.mounted) {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    dateRange.endDate ?? DateTime.now(),
                  ),
                );
                if (pickedTime != null) {
                  final dateWithTime = pickedDate.copyWith(
                    hour: pickedTime.hour,
                    minute: pickedTime.minute,
                  );
                  ref
                      .read(dateRangeProvider.notifier)
                      .setDateRange(dateRange.startDate, dateWithTime);
                  if (dateRange.startDate != null) {
                    await ref
                        .read(dateRangeReportProvider.notifier)
                        .getDateRangeTransactions(
                          dateRange.startDate!,
                          dateWithTime,
                        );
                    ref
                        .read(appliedFiltersProvider.notifier)
                        .updateAppliedFilters([]);
                  }
                }
              }
            },
            closeBtnFunc: () {
              ref.read(dateRangeProvider.notifier).clearDateRange();
              ref.read(yearlyReportProvider.notifier).getAllTransactions();
              ref
                  .read(appliedFiltersProvider.notifier)
                  .updateAppliedFilters([]);
            },
          ),
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
                          .updateTransactions(date);
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

                        if (context.mounted) {
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
                        }
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
        // Transactions view
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
                        Text(
                          "No: ${transaction.orderNo ?? ""}",
                          style: TextStyle(
                            color:
                                (transaction.paymentStatus !=
                                    PaymentStatus.received)
                                ? AppColors.red
                                : null,
                          ),
                        ),
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
                      Text("Unit ID: ${transaction.unitId ?? ""}"),
                      Text(
                        "PaymentStatus: ${capitalize(transaction.paymentStatus.name)}",
                        style: TextStyle(
                          color:
                              (transaction.paymentStatus !=
                                  PaymentStatus.received)
                              ? AppColors.red
                              : AppColors.green,
                        ),
                      ),
                      ...renderSubItems(subItems),
                      Wrap(
                        children: [
                          if (transaction.paymentStatus !=
                              PaymentStatus.received)
                            TextButton(
                              onPressed: () async {
                                UIUtils.confirmDialog(
                                  context: context,
                                  title: "Are you sure",
                                  subTitle: "You received the cash",
                                  rightBtnColor: AppColors.green,
                                  rightBtnName: "Yes",
                                  rightFun: () async {
                                    SaleReceiptModel trans = transaction
                                        .copyWith(
                                          paymentMode: PaymentMode.cash.name,
                                          paymentStatus: PaymentStatus.received,
                                        );
                                    // debugLog(trans);
                                    await dbUtils.updateSaleReceipt(
                                      saleReceipt: trans,
                                    );
                                  },
                                );
                              },
                              child: Text("Receive Cash"),
                            ),
                          if (transaction.paymentStatus !=
                              PaymentStatus.received)
                            IconButton(
                              onPressed: () async {
                                BankAccountModel? bankAccounts =
                                    await checkBankAC(context);

                                if (bankAccounts != null) {
                                  String payRef =
                                      "UPI=${bankAccounts.upiId},Name=${bankAccounts.name}";
                                  openQRcode(
                                    context: context,
                                    primAccount: bankAccounts,
                                    transaction: transaction,
                                    paidFunc: () async {
                                      SaleReceiptModel trans = transaction
                                          .copyWith(
                                            paymentMode: PaymentMode.upi.name,
                                            paymentStatus:
                                                PaymentStatus.received,
                                            paymentRef: payRef,
                                          );
                                      await dbUtils.updateSaleReceipt(
                                        saleReceipt: trans,
                                      );
                                    },
                                  );
                                }
                              },
                              icon: Icon(Icons.qr_code),
                            ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(printerProvider.notifier)
                                  .printBill(
                                    context: context,
                                    orderNo: transaction.orderNo,
                                    paymentMode: transaction.paymentMode,
                                    paymentStatus:
                                        (transaction.paymentStatus !=
                                            PaymentStatus.received)
                                        ? "Not Paid"
                                        : null,
                                    dateTime: dateFormat(
                                      transaction.createdAt!.toLocal(),
                                    ),
                                    itemsList: transaction.billItems ?? [],
                                    totalAmount: transaction.totalAmount
                                        .toString(),
                                    totalItems:
                                        (transaction.billItems?.length ?? 0)
                                            .toString(),
                                  );
                            },
                            icon: Icon(Icons.print),
                          ),
                          IconButton(
                            onPressed: () {
                              UIUtils.confirmDialog(
                                context: context,
                                subTitle: "Are you sure you want to delete",
                                title:
                                    "Order no: ${transaction.orderNo}\n${getItemNames(transaction.billItems)}",
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(6),
          child: Wrap(
            spacing: 2,
            children: [
              Text("${i.name} ", style: TextStyle(color: AppColors.blue)),
              Text("Qty: "),
              Text("${i.quantity} ", style: TextStyle(color: AppColors.blue)),
              Text("Rate: "),
              Text("${i.rate} ", style: TextStyle(color: AppColors.blue)),
              Text("Amount: "),
              Text(
                "₹${i.rate * i.quantity}",
                style: TextStyle(color: AppColors.blue),
              ),
            ],
          ),
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
