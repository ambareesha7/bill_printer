import 'dart:convert';
import 'dart:io';
import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:intl/intl.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';

class ExportService {
  ExportService._internal();
  static ExportService get instance => _instance;
  static final ExportService _instance = ExportService._internal();

  final FileManager _fileManager = FileManager().instance;

  Future<File> exportToJSON({String? customFileName}) async {
    try {
      List<SaleReceipt> receipts = await DBUtils.instance.getAllSaleReceipts();
      final timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
      final fileName = customFileName ?? 'sale_receipts_$timestamp.json';

      final jsonData = {
        'export_date': DateTime.now().toIso8601String(),
        'total_receipts': receipts.length,
        'receipts': receipts.map((r) => r.toJson()).toList(),
      };

      final jsonContent = jsonEncode(jsonData);

      final file = await _fileManager.saveFileToTemp(
        fileName: fileName,
        content: jsonContent,
      );

      debugLog("JSON export successful: ${file.path}");
      return file;
    } catch (e) {
      debugLog("Error exporting to JSON: $e");
      throw Exception("Failed to export to JSON: $e");
    }
  }
}
