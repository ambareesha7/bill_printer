import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: get reports based selected date from DB
    final yearlyTransactions = ref.watch(yearlyReportProvider);

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
                      const Text(
                        'Select Date & Time for Item View',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  if (!mounted) return;
                                  setState(() {
                                    selectedDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      // pickedTime.hour,
                                      // pickedTime.minute,
                                    );
                                  });
                                }
                              },
                              icon: const Icon(Icons.event),
                              label: Text(
                                DateFormat(
                                  'MMM dd, yyyy hh:mm a',
                                ).format(selectedDate),
                                style: const TextStyle(fontSize: 12),
                              ),
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
              child: _buildBillItemsCard(yearlyTransactions),
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
                child: _buildTimeSeriesChart(yearlyTransactions),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Statistics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDailySalesStats(yearlyTransactions),
                ],
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
                  _buildItemWiseBreakdown(yearlyTransactions),
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
    final billsOnSelected = transactions
        .where(
          (t) => t.createdAt != null && isSameDay(t.createdAt!, selectedDate),
        )
        .toList();
    final billCount = billsOnSelected.length;
    int itemCount = 0;
    int totalAmount = 0;
    for (var b in billsOnSelected) {
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

  Widget _buildDailySalesStats(List<SaleReceiptModel> transactions) {
    final Map<String, int> map = {};
    for (var t in transactions) {
      if (t.createdAt == null) continue;
      final key = DateFormat('yMd').format(t.createdAt!);
      map[key] = (map[key] ?? 0) + (t.totalAmount ?? 0);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: entries.take(10).map((e) {
        return ListTile(
          dense: true,
          title: Text(e.key),
          trailing: Text('${e.value}'),
        );
      }).toList(),
    );
  }

  Widget _buildItemWiseBreakdown(List<SaleReceiptModel> transactions) {
    final Map<String, Map<String, int>> itemMap = {};
    final billsOnSelected = transactions
        .where(
          (t) => t.createdAt != null && isSameDay(t.createdAt!, selectedDate),
        )
        .toList();

    for (var b in billsOnSelected) {
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

    final rows = itemMap.entries.map((e) {
      return ListTile(
        dense: true,
        title: Text(e.key),
        subtitle: Text('Qty: ${e.value['qty']}'),
        trailing: Text('${e.value['revenue']}'),
      );
    }).toList();

    return Column(children: rows);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
