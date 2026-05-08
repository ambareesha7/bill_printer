import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/common_utils.dart';
part 'report_provider.g.dart';

@riverpod
class FiltersList extends _$FiltersList {
  @override
  List<String> build() {
    return [];
  }

  Future<void> updateFilters(List<SaleReceiptModel> transList) async {
    List<String> filters = await getFilters(transList);
    state = filters;
  }

  Future<List<String>> getFilters(List<SaleReceiptModel> transList) async {
    List<String> filters = await _getFilterNames(transList);
    debugLog(filters.length, tag: "getFilters");
    // state = [...filters];
    return filters;
  }

  Future<List<String>> _getFilterNames(List<SaleReceiptModel> transList) async {
    List<String> filters = [];
    for (var i in transList) {
      if (i.paymentMode != null && i.paymentMode!.isNotEmpty) {
        filters.add(i.paymentMode!);
      }
      if (i.paymentRef != null && i.paymentRef!.isNotEmpty) {
        String ss = i.paymentRef!.split(",").first.split("=").last;
        filters.add(ss);
      }
    }
    filters = filters.toSet().toList();
    filters.sort();
    debugLog(filters.length, tag: "_getFilterNames");
    return filters;
  }
}

@riverpod
class AppliedFilters extends _$AppliedFilters {
  @override
  List<String> build() {
    return [];
  }

  void updateAppliedFilters(List<String> filters) {
    state = [...filters];
  }
}

@riverpod
class YearlyReport extends _$YearlyReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    getAllTransactions();
    return [];
  }

  getAllTransactions() async {
    final List<SaleReceiptModel> saleTrans = await dbUtils
        .getNParseSaleReceipts();
    state = [...saleTrans];
  }
}

@riverpod
class DateRange extends _$DateRange {
  @override
  ({DateTime? startDate, DateTime? endDate}) build() {
    return (startDate: null, endDate: null);
  }

  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = (startDate: startDate, endDate: endDate);
  }

  void clearDateRange() {
    state = (startDate: null, endDate: null);
  }
}

@riverpod
class DateRangeReport extends _$DateRangeReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    return [];
  }

  getDateRangeTransactions(DateTime startDate, DateTime endDate) async {
    final List<SaleReceiptModel> transactions = await getReport2(
      startDate: startDate,
      endDate: endDate,
    );
    state = [...transactions];
  }
}

@riverpod
class MonthlyReport extends _$MonthlyReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    getAllTransactions();
    return [];
  }

  getAllTransactions() async {
    final List<SaleReceiptModel> saleTrans = await dbUtils
        .getNParseSaleReceipts();
    state = [...saleTrans];
  }

  updateTransactions(DateTime date) async {
    final n = await getMonthlyTransactions(date);
    state = [...n];
  }

  delete(String id) async {
    await dbUtils.deleteSaleReceipt(id);
    getAllTransactions();
  }
}

@riverpod
class WeeklyReport extends _$WeeklyReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    updateTransactions(DateTime(DateTime.now().year, DateTime.now().month, 1));
    return [];
  }

  updateTransactions(DateTime date) async {
    final n = await getMonthlyTransactions(date);
    state = [...n];
  }
}

@riverpod
class MonthlyDate extends _$MonthlyDate {
  @override
  DateTime build() {
    return DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  updateDate(DateTime date) {
    state = date;
  }
}

@riverpod
class WeeklyDate extends _$WeeklyDate {
  @override
  DateTime build() {
    return DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  updateDate(DateTime date) {
    state = date;
  }
}

int getTotalAmount(List<SaleReceiptModel> items) {
  int total = 0;
  for (var i in items) {
    total += i.totalAmount ?? 0;
  }
  return total;
}

String getFormattedDate(DateTime date) => DateFormat("yMd").format(date);

int getDayTotal(List<SaleReceiptModel> items, DateTime date) {
  // TODO: modify dateTime to show full day transactions
  String selectedDay = getFormattedDate(date);
  items = items
      .where((i) => getFormattedDate(i.createdAt!) == selectedDay)
      .toList();
  int total = 0;
  for (var i in items) {
    total += i.totalAmount ?? 0;
  }
  return total;
}

// Future<List<SaleReceiptModel>> getReport(DateTime date) async {
//   ({DateTime startDate, DateTime lastDate}) dates = getDatesOfMonth(date);
//   return await DBUtils.instance.getNParseReport(
//     startDate: dates.startDate,
//     lastDate: dates.lastDate,
//   );
// }

Future<List<SaleReceiptModel>> getReport2({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  return await DBUtils.instance.getNParseReport(
    startDate: startDate,
    lastDate: endDate,
  );
}

// Future<List<SaleReceiptModel>> getDayReport(DateTime date) async {
//   final List<SaleReceiptModel> l = await DBUtils.instance.getNParseReport(
//     startDate: date,
//     lastDate: date,
//   );
//   return l;
// }

Future<List<SaleReceiptModel>> getMonthlyTransactions(DateTime date) async {
  ({DateTime startDate, DateTime lastDate}) dates = getDatesOfMonth(date);
  // Extend lastDate to end of day to include all transactions on that day
  final endOfDay = dates.lastDate
      .add(const Duration(days: 1))
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
  return await getReport2(startDate: dates.startDate, endDate: endOfDay);
}

int getWeekDates({required String week, required DateTime date}) {
  int numOfDays = 0;
  final weekdayOfMonth = DateFormat("E").format(date);
  int w1 = addDaysToDate(day: weekdayOfMonth);
  int w2 = w1 + 7;
  int w3 = w2 + 7;
  int w4 = w3 + 7;
  int w5 = w4 + 7;
  switch (week.toLowerCase()) {
    case "w1":
      numOfDays += w1;
      break;
    case "w2":
      numOfDays += w2;
      break;
    case "w3":
      numOfDays += w3;
      break;
    case "w4":
      numOfDays += w4;
      break;
    case "w5":
      numOfDays += w5;
      break;
    default:
  }
  return numOfDays;
}

int addDaysToDate({required String day}) {
  int numOfDays = 0;
  switch (day.toLowerCase()) {
    case "sun":
      numOfDays += 7;
      break;
    case "mon":
      numOfDays += 6;
      break;
    case "tue":
      numOfDays += 5;
      break;
    case "wed":
      numOfDays += 4;
      break;
    case "thu":
      numOfDays += 3;
      break;
    case "fri":
      numOfDays += 2;
      break;
    case "sat":
      numOfDays += 1;
      break;

    default:
  }
  return numOfDays;
}

List<String> getWeeksInMonth(DateTime date) {
  int daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
  List<String> weeks = [];
  int numOfWeeks = 4;
  if (daysInMonth % numOfWeeks != 0) {
    numOfWeeks += 1;
  }
  List.generate(numOfWeeks, (index) => weeks.add("W${index + 1}"));
  return weeks;
}

List<SaleReceiptModel> getFilterNameList({
  required List<SaleReceiptModel> list,
  required List<String> filterItems,
}) {
  List<SaleReceiptModel> transList = [];
  for (var i in list) {
    if (i.paymentMode != null &&
        filterItems.contains(i.paymentMode?.toLowerCase())) {
      transList.add(i);
    } else if (i.paymentRef != null && i.paymentRef!.isNotEmpty) {
      String ss = i.paymentRef!.split(",").first.split("=").last;
      if (filterItems.contains(ss.toLowerCase())) {
        transList.add(i);
      }
    }
  }
  return transList;
}
