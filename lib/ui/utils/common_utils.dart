import 'dart:developer';

import 'package:flutter/foundation.dart';

debugLog(dynamic value, {Object? error, String tag = ''}) {
  if (kDebugMode) {
    log("$tag: ${value.toString()}", error: error);
  }
}

dateTimeNow() => DateTime.now();
