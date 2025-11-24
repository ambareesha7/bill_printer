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

String monthFormat(DateTime date) => DateFormat("MMMM-yyyy").format(date);

Widget navigateBtn({required BuildContext context, required Widget page}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    child: Text(page.toString()),
  );
}
