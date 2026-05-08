import 'dart:convert';
import 'dart:io';
import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';

class ImportService {
  ImportService._internal();
  static ImportService get instance => _instance;
  static final ImportService _instance = ImportService._internal();

  final FileManager _fileManager = FileManager().instance;
  final DBUtils dbUtils = DBUtils.instance;

  Future<bool> importFromJSON(File file) async {
    try {
      final content = await _fileManager.readFile(file: file);
      final jsonData = jsonDecode(content) as Map<String, dynamic>;

      if (!jsonData.containsKey('receipts')) {
        throw Exception("Invalid JSON format: missing 'receipts' key");
      }

      final receiptsData = jsonData['receipts'] as List<dynamic>;
      final receipts = <SaleReceipt>[];

      for (var data in receiptsData) {
        try {
          SaleReceipt receipt = SaleReceipt.fromJson(
            data as Map<String, dynamic>,
          );
          // receipt = updatePayStatus(receipt);
          receipts.add(receipt);
        } catch (e, st) {
          debugLog("Error parsing JSON receipt: $e");
          debugLog(st, tag: "Stack Trace");
          continue;
        }
      }

      debugLog("JSON import successful: ${receipts.length} receipts imported");
      debugLog("Last item: ${receipts.last}");
      bool insert = await addImportedReceits(receipts);
      if (insert) {
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      debugLog("Error in importFromJSON: $e");
      debugLog(st, tag: "Stack Trace");

      return false;
    }
  }

  Future<bool> addImportedReceits(List<SaleReceipt> receipts) async {
    try {
      bool insert = await dbUtils.insertAllReceipts(receipts: receipts);
      return insert;
    } catch (e, st) {
      debugLog(e, tag: "error in addImportedReceits");
      debugLog(st, tag: "Stack trace");
      return false;
    }
  }

  /// Validate JSON file format
  Future<bool> validateJSONFormat(File file) async {
    try {
      final content = await _fileManager.readFile(file: file);
      final jsonData = jsonDecode(content);

      return jsonData is Map &&
          jsonData.containsKey('receipts') &&
          jsonData['receipts'] is List;
    } catch (e) {
      debugLog("Error validating JSON format: $e");
      return false;
    }
  }
}
