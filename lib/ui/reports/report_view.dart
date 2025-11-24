import 'dart:math';

import 'package:bill_printer/ui/reports/monthly_report_widget.dart';
import 'package:bill_printer/ui/reports/pie_chart1.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
  String selectedMonth = monthFormat(DateTime.now());
  int currentMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
                  ...renderWeekChip(),
                  TextButton.icon(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        // selectableMonthPredicate: (DateTime val) =>
                        //     val.month < DateTime.now().month,
                        // selectableYearPredicate: (int year) =>
                        //     year > DateTime.now().year,
                      ).then((date) {
                        if (date != null) {
                          debugLog(date);
                          selectedMonth = DateFormat("MMM-yy").format(date);
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
              // BarChartSample1(),
              PieChart1(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BarChart(randomData()),
                ),
              ),
            ],
          ),
          MonthlyReportWidget(),
          Center(child: Text("yearly")),
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

  List<Widget> renderWeekChip() {
    List<String> weeks = ["W1", "W2", "W3", "W4"];
    return List.generate(weeks.length, (int index) {
      String week = weeks[index];
      return FilterChip(
        visualDensity: VisualDensity(horizontal: -1),
        padding: EdgeInsets.all(4),
        label: Text(week),
        backgroundColor: selectedWeek == week ? Colors.teal : null,
        onSelected: (bool v) {
          debugLog(week);
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
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(
    7,
    (i) => switch (i) {
      0 => makeGroupData(0, 5, isTouched: i == touchedIndex),
      1 => makeGroupData(1, 6.5, isTouched: i == touchedIndex),
      2 => makeGroupData(2, 5, isTouched: i == touchedIndex),
      3 => makeGroupData(3, 7.5, isTouched: i == touchedIndex),
      4 => makeGroupData(4, 9, isTouched: i == touchedIndex),
      5 => makeGroupData(5, 11.5, isTouched: i == touchedIndex),
      6 => makeGroupData(6, 6.5, isTouched: i == touchedIndex),
      _ => throw Error(),
    },
  );
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = switch (value.toInt()) {
      0 => 'M',
      1 => 'T',
      2 => 'W',
      3 => 'T',
      4 => 'F',
      5 => 'S',
      6 => 'S',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(text, style: style),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: const BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          Random().nextInt(15).toDouble() + 6,
          barColor: availableColors[Random().nextInt(availableColors.length)],
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }
}
