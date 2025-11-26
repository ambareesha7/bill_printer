import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/common_utils.dart';
part 'report_provider.g.dart';

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

  getMonthlyTransactions(DateTime date) async {
    final n = await getReport(date);
    state = [...n];
  }
}

@riverpod
class WeeklyReport extends _$WeeklyReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    getMonthlyTransactions(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
    );
    return [];
  }

  getMonthlyTransactions(DateTime date) async {
    final n = await getReport(date);
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

Future<List<SaleReceiptModel>> getReport(DateTime date) async {
  ({DateTime startDate, DateTime lastDate}) dates = getDatesOfMonth(date);
  return await DBUtils.instance.getNParseReport(
    startDate: dates.startDate,
    lastDate: dates.lastDate,
  );
}

Future<List<SaleReceiptModel>> getDayReport(DateTime date) async {
  final List<SaleReceiptModel> l = await DBUtils.instance.getNParseReport(
    startDate: date,
    lastDate: date,
  );
  return l;
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
    case "mon":
      numOfDays += 7;
      break;
    case "tue":
      numOfDays += 6;
      break;
    case "wed":
      numOfDays += 5;
      break;
    case "thu":
      numOfDays += 4;
      break;
    case "fri":
      numOfDays += 3;
      break;
    case "sat":
      numOfDays += 2;
      break;
    case "sun":
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
