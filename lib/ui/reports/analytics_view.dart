import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/widgets/date_range_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AnalyticsView extends ConsumerStatefulWidget {
  const AnalyticsView({super.key});

  @override
  ConsumerState<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends ConsumerState<AnalyticsView> {
  late DateTime selectedDate;
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fromDate = DateTime.now().subtract(const Duration(days: 30));
    toDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      ref.read(monthlyReportProvider.notifier).updateTransactions(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyTransactions = ref.watch(monthlyReportProvider);
    final dateRange = ref.watch(dateRangeProvider);
    ref.watch(dateRangeReportProvider);
    ref.watch(monthlyReportProvider);
    bool dateRangeSet =
        (dateRange.startDate != null && dateRange.endDate != null);
    List<SaleReceiptModel> transactions = dateRangeSet
        ? ref.watch(dateRangeReportProvider)
        : ref.watch(monthlyReportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales Analytics'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
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
                                  .setDateRange(
                                    dateWithTime,
                                    dateRange.endDate,
                                  );
                              if (dateRange.endDate != null) {
                                await ref
                                    .read(dateRangeReportProvider.notifier)
                                    .getDateRangeTransactions(
                                      dateWithTime,
                                      dateRange.endDate!,
                                    );
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
                                  .setDateRange(
                                    dateRange.startDate,
                                    dateWithTime,
                                  );
                              if (dateRange.startDate != null) {
                                await ref
                                    .read(dateRangeReportProvider.notifier)
                                    .getDateRangeTransactions(
                                      dateRange.startDate!,
                                      dateWithTime,
                                    );
                              }
                            }
                          }
                        },
                        closeBtnFunc: () {
                          ref.read(dateRangeProvider.notifier).clearDateRange();
                          ref
                              .read(monthlyReportProvider.notifier)
                              .updateTransactions(selectedDate);
                        },
                      ),
                      if (!dateRangeSet)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "DateTime: ${getDateFormat(selectedDate)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.cyan,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildBillItemsCard(transactions),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Text(
                    'Sales Trend',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 300,
                child: _buildTimeSeriesChart(monthlyTransactions),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item-wise Breakdown',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildItemWiseBreakdown(transactions),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBillItemsCard(List<SaleReceiptModel> transactions) {
    final billCount = transactions.length;
    int itemCount = 0;
    int totalAmount = 0;
    for (var b in transactions) {
      if (b.billItems != null) {
        for (var it in b.billItems!) {
          itemCount += it.quantity;
        }
      }
      totalAmount += b.totalAmount ?? 0;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bills',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$billCount'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$itemCount'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$totalAmount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSeriesChart(List<SaleReceiptModel> transactions) {
    final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final end = DateTime(toDate.year, toDate.month, toDate.day);
    final days = end.difference(start).inDays + 1;

    final List<double> totals = List.generate(days, (_) => 0.0);
    for (var t in transactions) {
      if (t.createdAt == null) continue;
      final d = DateTime(
        t.createdAt!.year,
        t.createdAt!.month,
        t.createdAt!.day,
      );
      if (d.isBefore(start) || d.isAfter(end)) continue;
      final idx = d.difference(start).inDays;
      totals[idx] = totals[idx] + (t.totalAmount ?? 0);
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < totals.length; i++) {
      spots.add(FlSpot(i.toDouble(), totals[i]));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                color: Colors.blue,
                dotData: FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (spots.length > 5)
                      ? (spots.length / 5).floorToDouble()
                      : 1,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= days) return const SizedBox.shrink();
                    final d = start.add(Duration(days: idx));
                    return Text(
                      DateFormat('MM/dd').format(d),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: null),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _buildItemWiseBreakdown(List<SaleReceiptModel> transactions) {
    final Map<String, Map<String, int>> itemMap = {};

    for (var b in transactions) {
      if (b.billItems == null) continue;
      for (var it in b.billItems!) {
        final name = it.name;
        final qty = it.quantity;
        final revenue = it.quantity * it.rate;
        if (!itemMap.containsKey(name)) {
          itemMap[name] = {'qty': qty, 'revenue': revenue};
        } else {
          itemMap[name]!['qty'] = (itemMap[name]!['qty'] ?? 0) + qty;
          itemMap[name]!['revenue'] =
              (itemMap[name]!['revenue'] ?? 0) + revenue;
        }
      }
    }

    if (itemMap.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No items for selected date'),
      );
    }

    final sortedEntries = itemMap.entries.toList()
      ..sort((a, b) => b.value['revenue']!.compareTo(a.value['revenue']!));

    final rows = sortedEntries.map((e) {
      return ListTile(
        dense: true,
        title: Text(e.key),
        subtitle: Text('Qty: ${e.value['qty']}'),
        trailing: Text('${e.value['revenue']}'),
      );
    }).toList();

    return Column(children: rows);
  }

  String getDateFormat(date) => DateFormat('MMM dd, yyyy hh:mm a').format(date);
}
