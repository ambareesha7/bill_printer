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

enum _DateRangeSelection {
  all,
  today,
  yesterday,
  thisWeek,
  thisMonth,
  lastMonth,
  custom,
}

class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView>
    with TickerProviderStateMixin {
  final int tabLength = 2;
  TabController? _tabController;
  String selectedWeek = "W1";
  int touchedIndex = -1;
  _DateRangeSelection selectedRangeSelection = _DateRangeSelection.thisMonth;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applyCurrentMonth();
    });
  }

  Future<void> _applyCurrentMonth() async {
    final now = DateTime.now();
    return await _applyDateRange(
      DateTimeRange(start: DateTime(now.year, now.month), end: now),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedMonth = ref.watch(weeklyDateProvider);
    ref.watch(weeklyReportProvider);
    ref.watch(dateRangeReportProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        centerTitle: true,
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
                child: Text("Date range"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
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
                                    .updateTransactions(date);
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              dateRange.startDate != null &&
                                      dateRange.endDate != null
                                  ? "${DateFormat('dd MMM yyyy').format(dateRange.startDate!)} - ${DateFormat('dd MMM yyyy').format(dateRange.endDate!)}"
                                  : selectedRangeSelection ==
                                        _DateRangeSelection.all
                                  ? "All records"
                                  : "Select a date range",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          IconButton(
                            tooltip: "Choose date range",
                            onPressed: _chooseDateRange,
                            icon: const Icon(Icons.date_range_outlined),
                          ),
                          if (dateRange.startDate != null &&
                              dateRange.endDate != null)
                            IconButton(
                              tooltip: "Clear date range",
                              onPressed: () {
                                ref
                                    .read(dateRangeProvider.notifier)
                                    .clearDateRange();
                                setState(() {
                                  selectedRangeSelection =
                                      _DateRangeSelection.all;
                                });
                                ref
                                    .read(dateRangeReportProvider.notifier)
                                    .getAllTransactions();
                                ref
                                    .read(appliedFiltersProvider.notifier)
                                    .updateAppliedFilters([]);
                              },
                              icon: const Icon(Icons.clear),
                            ),
                        ],
                      ),
                    ),
                    Expanded(child: ReportWidget(ReportType.dateRange)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseDateRange() async {
    final current = ref.read(dateRangeProvider);
    final selection = await showModalBottomSheet<_DateRangeSelection>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        var selected = selectedRangeSelection;
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Date range'),
                    trailing: IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: RadioGroup<_DateRangeSelection>(
                        groupValue: selected,
                        onChanged: (value) =>
                            setSheetState(() => selected = value!),
                        child: Column(
                          children: [
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('All records'),
                              value: _DateRangeSelection.all,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('Today'),
                              value: _DateRangeSelection.today,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('Yesterday'),
                              value: _DateRangeSelection.yesterday,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('This week'),
                              value: _DateRangeSelection.thisWeek,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('This month'),
                              value: _DateRangeSelection.thisMonth,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('Last month'),
                              value: _DateRangeSelection.lastMonth,
                            ),
                            RadioListTile<_DateRangeSelection>(
                              title: const Text('Custom'),
                              value: _DateRangeSelection.custom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || selection == null) return;
    setState(() => selectedRangeSelection = selection);

    if (selection == _DateRangeSelection.all) {
      ref.read(dateRangeProvider.notifier).clearDateRange();
      await ref.read(dateRangeReportProvider.notifier).getAllTransactions();
      ref.read(appliedFiltersProvider.notifier).updateAppliedFilters([]);
      return;
    }

    if (selection == _DateRangeSelection.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDateRange: current.startDate != null && current.endDate != null
            ? DateTimeRange(start: current.startDate!, end: current.endDate!)
            : DateTimeRange(
                start: DateTime(DateTime.now().year, DateTime.now().month),
                end: DateTime.now(),
              ),
      );
      if (picked != null && mounted) {
        await _applyDateRange(picked);
      }
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedRange = switch (selection) {
      _DateRangeSelection.all => throw StateError('All records handled above'),
      _DateRangeSelection.today => DateTimeRange(start: today, end: now),
      _DateRangeSelection.yesterday => DateTimeRange(
        start: today.subtract(const Duration(days: 1)),
        end: today.subtract(const Duration(milliseconds: 1)),
      ),
      _DateRangeSelection.thisWeek => DateTimeRange(
        start: today.subtract(Duration(days: today.weekday - 1)),
        end: now,
      ),
      _DateRangeSelection.thisMonth => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: now,
      ),
      _DateRangeSelection.lastMonth => DateTimeRange(
        start: DateTime(today.year, today.month - 1),
        end: DateTime(
          today.year,
          today.month,
          1,
        ).subtract(const Duration(milliseconds: 1)),
      ),
      _DateRangeSelection.custom => throw StateError('Custom range pending'),
    };
    await _applyDateRange(selectedRange);
  }

  Future<void> _applyDateRange(DateTimeRange range) async {
    final endOfDay = range.end
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));
    ref.read(dateRangeProvider.notifier).setDateRange(range.start, range.end);
    await ref
        .read(dateRangeReportProvider.notifier)
        .getDateRangeTransactions(range.start, endOfDay);
    if (!mounted) return;
    ref.read(appliedFiltersProvider.notifier).updateAppliedFilters([]);
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
