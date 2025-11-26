import 'dart:math';

import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/ui/reports/report_widget.dart';
import 'package:bill_printer/ui/reports/pie_chart1.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../data/models/sale_receipts/sale_receipt_model.dart';

class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView>
    with TickerProviderStateMixin {
  final int tabLength = 3;
  TabController? _tabController;
  String selectedWeek = "W1";
  int touchedIndex = -1;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedMonth = ref.watch(weeklyDateProvider);
    ref.watch(weeklyReportProvider);
    ref.watch(monthlyReportProvider);
    ref.watch(monthlyDateProvider);
    ref.watch(yearlyReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) {},
          indicator: BoxDecoration(
            color: Colors.teal,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          splashBorderRadius: BorderRadius.circular(10),
          tabs: <Widget>[
            Tab(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Weekly"),
              ),
            ),
            Tab(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Monthly"),
              ),
            ),
            Tab(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Yearly"),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,

        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...renderWeekChip(selectedMonth),
                  TextButton.icon(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          ref
                              .read(weeklyDateProvider.notifier)
                              .updateDate(date);
                          selectedWeek = "W1";
                          ref
                              .read(weeklyReportProvider.notifier)
                              .getMonthlyTransactions(date);
                          setState(() {});
                        }
                      });
                    },
                    label: Text(monthFormat(selectedMonth)),
                    icon: Icon(Icons.unfold_more_sharp),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
              PieChart1(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final items = ref.watch(weeklyReportProvider);
                      return BarChart(
                        randomData(
                          items: items,
                          date: selectedMonth,
                          week: selectedWeek,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          ReportWidget(ReportType.monthly),
          ReportWidget(ReportType.yearly),
        ],
      ),
    );
  }

  List<Color> get availableColors => const <Color>[
    AppColors.purple,
    AppColors.yellow,
    AppColors.blue,
    AppColors.orange,
    AppColors.pink,
    AppColors.red,
  ];

  final Color barBackgroundColor = AppColors.white;

  final Color barColor = AppColors.white;
  final Color touchedBarColor = AppColors.green;

  List<Widget> renderWeekChip(DateTime date) {
    List<String> weeks = getWeeksInMonth(date);
    return List.generate(weeks.length, (int index) {
      String week = weeks[index];
      return FilterChip(
        visualDensity: VisualDensity(horizontal: -1),
        padding: EdgeInsets.all(4),
        label: Text(week),
        backgroundColor: selectedWeek == week ? Colors.teal : null,
        onSelected: (bool v) {
          selectedWeek = week;
          setState(() {});
        },
      );
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData randomData({
    required List<SaleReceiptModel> items,
    required DateTime date,
    required String week,
  }) {
    int numOfBars = 7;
    int days = getWeekDates(week: week, date: date) - 7;
    return BarChartData(
      barTouchData: const BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, m) {
              DateTime localDate = DateTime(
                date.year,
                date.month,
                days + v.toInt() + 1,
              );
              String weekDay = DateFormat(
                "E",
              ).format(localDate).substring(0, 1);
              String localDay = DateFormat("dd").format(localDate);
              return SideTitleWidget(
                meta: m,
                space: 15,
                child: Text("$weekDay-$localDay"),
              );
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => SizedBox(
              width: 60,
              child: Text(
                "₹${getDayTotal(items, DateTime(date.year, date.month, days + value.toInt() + 1))}",
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(numOfBars, (i) {
        int index = i + 1;
        final ss = getDayTotal(
          items,
          DateTime(date.year, date.month, days + index),
        );
        return makeGroupData(
          i,
          ss.toDouble(),
          barColor: availableColors[Random().nextInt(availableColors.length)],
          isTouched: i == touchedIndex,
        );
      }),
      gridData: const FlGridData(show: false),
    );
  }
}
