import 'dart:developer';

import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/bank_account/bank_account_model.dart';
import '../bill_views/providers/bill_provider.dart';
import 'app_colors.dart';

debugLog(dynamic value, {Object? error, String tag = ''}) {
  if (kDebugMode) {
    log("$tag: ${value.toString()}", error: error);
  }
}

DateTime dateTimeNow() => DateTime.now();

String dateFormat(DateTime date) =>
    DateFormat("dd-MM-yyyy hh:mm aaa").format(date);

String monthFormat(DateTime date) => DateFormat("MMM-yyyy").format(date);

String getYearMonthDay(DateTime date) => DateFormat("yyyy-MM-dd").format(date);

({DateTime startDate, DateTime lastDate}) getDatesOfMonth(DateTime date) {
  int lastDay = DateUtils.getDaysInMonth(date.year, date.month);

  DateTime startDate = DateTime(date.year, date.month, 1);
  DateTime lastDate = DateTime(date.year, date.month, lastDay);
  // debugLog(startDate);
  // debugLog(lastDate);
  return (startDate: startDate, lastDate: lastDate);
}

String capitalize(String text) {
  return "${text.substring(0, 1).toUpperCase()}${text.substring(1)}";
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

Future<BankAccountModel?> checkBankAC(BuildContext context) async {
  List<BankAccountModel> bankAccounts = await dbUtils.parseBankAccounts();
  if (bankAccounts.isEmpty) {
    UIUtils.showSnackBar(
      // ignore: use_build_context_synchronously
      context: context,
      text: "Please add bank account to generate QR code",
      bgColor: AppColors.red,
    );
    return null;
  } else {
    BankAccountModel primAccount = getPrimeryUPI(bankAccounts);
    return primAccount;
  }
}

BankAccountModel getPrimeryUPI(List<BankAccountModel> bankAccounts) {
  return bankAccounts.firstWhere(
    (el) => el.isPrime,
    orElse: () => bankAccounts.first,
  );
}
