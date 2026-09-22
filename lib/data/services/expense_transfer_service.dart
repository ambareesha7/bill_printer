import 'dart:convert';
import 'dart:io';

import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:intl/intl.dart';

class ExpenseTransferService {
  ExpenseTransferService._internal();

  static final ExpenseTransferService instance =
      ExpenseTransferService._internal();

  final FileManager _fileManager = FileManager().instance;

  Future<File> exportExpenses({String? customFileName}) async {
    final expenses = await DBUtils.instance.getExpenses();
    final timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
    final content = jsonEncode({
      'format': 'bill_printer_expenses_v1',
      'export_date': DateTime.now().toIso8601String(),
      'total_expenses': expenses.length,
      'expenses': expenses.map((r) => r.toJson()).toList(),
    });

    return _fileManager.saveFileToTemp(
      fileName: customFileName ?? 'expenses_$timestamp.json',
      content: content,
    );
  }

  Future<bool> importExpenses(File file) async {
    try {
      final content = await _fileManager.readFile(file: file);
      final decoded = jsonDecode(content);
      if (decoded is! Map || decoded['expenses'] is! List) return false;

      final expenses = <Expense>[];
      for (var data in decoded['expenses'] as List<dynamic>) {
        try {
          Expense expens = Expense.fromJson(data as Map<String, dynamic>);

          expenses.add(expens);
        } catch (e, st) {
          debugLog("Error parsing JSON expens: $e");
          debugLog(st, tag: "Stack Trace");
          continue;
        }
      }
      return DBUtils.instance.insertAllExpenses(expenses);
    } catch (e, st) {
      debugLog("Error parsing JSON importExpenses: $e");
      debugLog(st, tag: "Stack Trace");

      return false;
    }
  }
}
