import 'dart:convert';
import 'dart:io';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/data/services/file_service.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';

class ImportService {
  ImportService._internal();
  static ImportService get instance => _instance;
  static final ImportService _instance = ImportService._internal();

  final FileService _fileService = FileService.instance;

  /// Import sale receipts from CSV file
  Future<List<SaleReceiptModel>> importFromCSV(File file) async {
    try {
      final content = await _fileService.readFile(file: file);
      final lines = content.split('\n');

      if (lines.isEmpty) {
        throw Exception("CSV file is empty");
      }

      final receipts = <SaleReceiptModel>[];

      // Skip header row
      for (int i = 1; i < lines.length; i++) {
        if (lines[i].isEmpty) continue;

        final values = _parseCSVLine(lines[i]);
        if (values.length < 9) continue;

        try {
          final receipt = SaleReceiptModel(
            id: values[0].isNotEmpty ? values[0] : null,
            orederNo: values[1],
            customerName: values[2].isNotEmpty ? values[2] : null,
            preparedBy: values[3].isNotEmpty ? values[3] : null,
            paymentMode: values[4].isNotEmpty ? values[4] : 'cash',
            paymentRef: values[5].isNotEmpty ? values[5] : null,
            totalAmount: int.tryParse(values[6]) ?? 0,
            createdAt: _parseDateTime(values[7]),
            updatedAt: _parseDateTime(values[8]),
            billItems: [], // Items will be empty from CSV
          );
          receipts.add(receipt);
        } catch (e) {
          debugLog("Error parsing CSV row $i: $e");
          continue;
        }
      }

      debugLog("CSV import successful: ${receipts.length} receipts imported");
      return receipts;
    } catch (e) {
      debugLog("Error importing from CSV: $e");
      throw Exception("Failed to import from CSV: $e");
    }
  }

  /// Import sale receipts from JSON file
  Future<List<SaleReceiptModel>> importFromJSON(File file) async {
    try {
      final content = await _fileService.readFile(file: file);
      final jsonData = jsonDecode(content) as Map<String, dynamic>;

      if (!jsonData.containsKey('receipts')) {
        throw Exception("Invalid JSON format: missing 'receipts' key");
      }

      final receiptsData = jsonData['receipts'] as List<dynamic>;
      final receipts = <SaleReceiptModel>[];

      for (var data in receiptsData) {
        try {
          final receipt = SaleReceiptModel.fromJson(
            data as Map<String, dynamic>,
          );
          receipts.add(receipt);
        } catch (e) {
          debugLog("Error parsing JSON receipt: $e");
          continue;
        }
      }

      debugLog("JSON import successful: ${receipts.length} receipts imported");
      return receipts;
    } catch (e) {
      debugLog("Error importing from JSON: $e");
      throw Exception("Failed to import from JSON: $e");
    }
  }

  /// Parse a CSV line handling quoted values
  List<String> _parseCSVLine(String line) {
    final values = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        values.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    values.add(current.toString());
    return values;
  }

  /// Parse datetime string
  DateTime? _parseDateTime(String dateString) {
    try {
      if (dateString.isEmpty) return null;
      return DateTime.parse(dateString);
    } catch (e) {
      debugLog("Error parsing datetime: $e");
      return null;
    }
  }

  /// Validate CSV file format
  Future<bool> validateCSVFormat(File file) async {
    try {
      final content = await _fileService.readFile(file: file);
      final lines = content.split('\n');

      if (lines.isEmpty) return false;

      // Check header
      final header = lines[0];
      final expectedHeaders = [
        'ID',
        'Order No',
        'Customer Name',
        'Prepared By',
        'Payment Mode',
        'Payment Ref',
        'Total Amount',
        'Created At',
        'Updated At',
      ];

      final headerValues = header.split(',');
      return expectedHeaders.every(
        (expected) => headerValues.any((h) => h.contains(expected)),
      );
    } catch (e) {
      debugLog("Error validating CSV format: $e");
      return false;
    }
  }

  /// Validate JSON file format
  Future<bool> validateJSONFormat(File file) async {
    try {
      final content = await _fileService.readFile(file: file);
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
