import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

debugLog(dynamic value, {Object? error, String tag = ''}) {
  if (kDebugMode) {
    log("$tag: ${value.toString()}", error: error);
  }
}

DateTime dateTimeNow() => DateTime.now();

String dateFormat(DateTime date) =>
    DateFormat("dd-MM-yyyy hh:mm aaa").format(date);

String monthFormat(DateTime date) => DateFormat("MMM-yyyy").format(date);

({DateTime startDate, DateTime lastDate}) getDatesOfMonth(DateTime date) {
  int lastDay = DateUtils.getDaysInMonth(date.year, date.month);

  DateTime startDate = DateTime(date.year, date.month, 1);
  DateTime lastDate = DateTime(date.year, date.month, lastDay);
  // debugLog(startDate);
  // debugLog(lastDate);
  return (startDate: startDate, lastDate: lastDate);
}

Widget navigateBtn({required BuildContext context, required Widget page}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    child: Text(page.toString()),
  );
}
