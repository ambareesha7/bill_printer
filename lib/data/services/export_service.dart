import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/data/services/file_service.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';

class ExportService {
  ExportService._internal();
  static ExportService get instance => _instance;
  static final ExportService _instance = ExportService._internal();

  final FileService _fileService = FileService.instance;

  /// Export sale receipts to CSV format
  Future<File> exportToCSV(
    List<SaleReceiptModel> receipts, {
    String? customFileName,
  }) async {
    try {
      final timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
      final fileName = customFileName ?? 'sale_receipts_$timestamp.csv';

      // Create CSV header
      final csvHeader =
          'ID,Order No,Customer Name,Prepared By,Payment Mode,Payment Ref,Total Amount,Created At,Updated At,Items Count';

      // Create CSV rows
      final csvRows = receipts
          .map((receipt) {
            final itemsCount = receipt.billItems?.length ?? 0;
            return '"${receipt.id}","${receipt.orederNo}","${receipt.customerName ?? ''}","${receipt.preparedBy ?? ''}","${receipt.paymentMode ?? 'cash'}","${receipt.paymentRef ?? ''}","${receipt.totalAmount ?? 0}","${receipt.createdAt ?? ''}","${receipt.updatedAt ?? ''}","$itemsCount"';
          })
          .join('\n');

      final csvContent = '$csvHeader\n$csvRows';

      final file = await _fileService.saveFileToDownloads(
        fileName: fileName,
        content: csvContent,
      );

      debugLog("CSV export successful: ${file.path}");
      return file;
    } catch (e) {
      debugLog("Error exporting to CSV: $e");
      throw Exception("Failed to export to CSV: $e");
    }
  }

  /// Export sale receipts to JSON format
  Future<File> exportToJSON(
    List<SaleReceiptModel> receipts, {
    String? customFileName,
  }) async {
    try {
      final timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
      final fileName = customFileName ?? 'sale_receipts_$timestamp.json';

      final jsonData = {
        'export_date': DateTime.now().toIso8601String(),
        'total_receipts': receipts.length,
        'receipts': receipts.map((r) => r.toJson()).toList(),
      };

      final jsonContent = jsonEncode(jsonData);

      final file = await _fileService.saveFileToDownloads(
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

  /// Export filtered sale receipts by date range to CSV
  Future<File> exportByDateRangeToCSV(
    List<SaleReceiptModel> receipts,
    DateTime startDate,
    DateTime endDate, {
    String? customFileName,
  }) async {
    try {
      final filteredReceipts = receipts
          .where(
            (receipt) =>
                receipt.createdAt != null &&
                receipt.createdAt!.isAfter(startDate) &&
                receipt.createdAt!.isBefore(endDate.add(Duration(days: 1))),
          )
          .toList();

      final timestamp = DateFormat('yyyy_MM_dd').format(startDate);
      final endTimestamp = DateFormat('yyyy_MM_dd').format(endDate);
      final fileName =
          customFileName ?? 'sale_receipts_${timestamp}_to_$endTimestamp.csv';

      // Create CSV header
      final csvHeader =
          'ID,Order No,Customer Name,Prepared By,Payment Mode,Payment Ref,Total Amount,Created At,Updated At,Items Count';

      // Create CSV rows
      final csvRows = filteredReceipts
          .map((receipt) {
            final itemsCount = receipt.billItems?.length ?? 0;
            return '"${receipt.id}","${receipt.orederNo}","${receipt.customerName ?? ''}","${receipt.preparedBy ?? ''}","${receipt.paymentMode ?? 'cash'}","${receipt.paymentRef ?? ''}","${receipt.totalAmount ?? 0}","${receipt.createdAt ?? ''}","${receipt.updatedAt ?? ''}","$itemsCount"';
          })
          .join('\n');

      final csvContent = '$csvHeader\n$csvRows';

      final file = await _fileService.saveFileToDownloads(
        fileName: fileName,
        content: csvContent,
      );

      debugLog(
        "CSV export by date range successful: ${file.path}, Records: ${filteredReceipts.length}",
      );
      return file;
    } catch (e) {
      debugLog("Error exporting by date range to CSV: $e");
      throw Exception("Failed to export by date range to CSV: $e");
    }
  }

  /// Export filtered sale receipts by payment mode to CSV
  Future<File> exportByPaymentModeToCSV(
    List<SaleReceiptModel> receipts,
    String paymentMode, {
    String? customFileName,
  }) async {
    try {
      final filteredReceipts = receipts
          .where((r) => (r.paymentMode ?? 'cash') == paymentMode)
          .toList();

      final fileName = customFileName ?? 'sale_receipts_$paymentMode.csv';

      // Create CSV header
      final csvHeader =
          'ID,Order No,Customer Name,Prepared By,Payment Mode,Payment Ref,Total Amount,Created At,Updated At,Items Count';

      // Create CSV rows
      final csvRows = filteredReceipts
          .map((receipt) {
            final itemsCount = receipt.billItems?.length ?? 0;
            return '"${receipt.id}","${receipt.orederNo}","${receipt.customerName ?? ''}","${receipt.preparedBy ?? ''}","${receipt.paymentMode ?? 'cash'}","${receipt.paymentRef ?? ''}","${receipt.totalAmount ?? 0}","${receipt.createdAt ?? ''}","${receipt.updatedAt ?? ''}","$itemsCount"';
          })
          .join('\n');

      final csvContent = '$csvHeader\n$csvRows';

      final file = await _fileService.saveFileToDownloads(
        fileName: fileName,
        content: csvContent,
      );

      debugLog(
        "CSV export by payment mode successful: ${file.path}, Payment Mode: $paymentMode, Records: ${filteredReceipts.length}",
      );
      return file;
    } catch (e) {
      debugLog("Error exporting by payment mode to CSV: $e");
      throw Exception("Failed to export by payment mode to CSV: $e");
    }
  }
}
