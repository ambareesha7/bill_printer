import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MonthlyReportWidget extends ConsumerStatefulWidget {
  const MonthlyReportWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonthlyReportWidgetState();
}

class _MonthlyReportWidgetState extends ConsumerState<MonthlyReportWidget> {
  String selectedMonth = monthFormat(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer(
              builder: (context, ref, child) {
                int totalAmount = getTotalAmount(
                  ref.watch(monthlyReportProvider),
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
            TextButton.icon(
              onPressed: () {
                showMonthPicker(
                  context: context,
                  initialDate: DateTime.now(),
                ).then((date) {
                  if (date != null) {
                    debugLog(date);
                    selectedMonth = monthFormat(date);
                    setState(() {});
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
              final transList = ref.watch(monthlyReportProvider);
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
                        SizedBox(width: 4),
                        Text((transaction.paymentMode ?? "Cash").toUpperCase()),
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
                    children: <Widget>[...renderSubItems(subItems)],
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
      list.add(Text("${i.name} - ₹${i.rate * i.quantity}"));
    }
    return list;
  }

  String getItemNames(List<BillItemModel>? items) {
    if (items == null) return "";
    return items.map((i) => i.name).toList().join(", ");
  }
}
