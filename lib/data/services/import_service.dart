import 'dart:convert';
import 'dart:io';
import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';

class ImportService {
  ImportService._internal();
  static ImportService get instance => _instance;
  static final ImportService _instance = ImportService._internal();

  final FileManager _fileManager = FileManager().instance;

  Future<List<SaleReceipt>> importFromJSON(File file) async {
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
          final receipt = SaleReceipt.fromJson(data as Map<String, dynamic>);
          receipts.add(receipt);
        } catch (e) {
          debugLog("Error parsing JSON receipt: $e");
          continue;
        }
      }

      debugLog("JSON import successful: ${receipts.length} receipts imported");
      debugLog("JSON import successful: ${receipts.last}");
      return receipts;
    } catch (e) {
      debugLog("Error importing from JSON: $e");
      throw Exception("Failed to import from JSON: $e");
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
