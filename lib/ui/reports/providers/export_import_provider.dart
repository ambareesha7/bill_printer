import 'dart:io';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/data/services/export_service.dart';
import 'package:bill_printer/data/services/import_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service providers
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService.instance;
});

final importServiceProvider = Provider<ImportService>((ref) {
  return ImportService.instance;
});

// Sale receipts provider
final saleReceiptsProvider = FutureProvider<List<SaleReceiptModel>>((
  ref,
) async {
  return await DBUtils.instance.getNParseSaleReceipts();
});

// Export functionality providers
final exportToCSVProvider =
    FutureProvider.family<File, List<SaleReceiptModel>?>((ref, receipts) async {
      if (receipts == null || receipts.isEmpty) {
        throw Exception("No receipts to export");
      }
      final exportService = ref.watch(exportServiceProvider);
      return await exportService.exportToCSV(receipts);
    });

final exportToJSONProvider =
    FutureProvider.family<File, List<SaleReceiptModel>?>((ref, receipts) async {
      if (receipts == null || receipts.isEmpty) {
        throw Exception("No receipts to export");
      }
      final exportService = ref.watch(exportServiceProvider);
      return await exportService.exportToJSON(receipts);
    });

final exportByDateRangeProvider =
    FutureProvider.family<
      File,
      ({List<SaleReceiptModel> receipts, DateTime startDate, DateTime endDate})
    >((ref, params) async {
      if (params.receipts.isEmpty) {
        throw Exception("No receipts to export");
      }
      final exportService = ref.watch(exportServiceProvider);
      return await exportService.exportByDateRangeToCSV(
        params.receipts,
        params.startDate,
        params.endDate,
      );
    });

final exportByPaymentModeProvider =
    FutureProvider.family<
      File,
      ({List<SaleReceiptModel> receipts, String paymentMode})
    >((ref, params) async {
      if (params.receipts.isEmpty) {
        throw Exception("No receipts to export");
      }
      final exportService = ref.watch(exportServiceProvider);
      return await exportService.exportByPaymentModeToCSV(
        params.receipts,
        params.paymentMode,
      );
    });

// Import functionality providers
class ImportResult {
  final List<SaleReceiptModel> receipts;
  final int successCount;
  final int failureCount;

  ImportResult({
    required this.receipts,
    required this.successCount,
    required this.failureCount,
  });
}

final importFromCSVProvider = FutureProvider.family<ImportResult, File>((
  ref,
  file,
) async {
  final importService = ref.watch(importServiceProvider);
  final isValid = await importService.validateCSVFormat(file);
  if (!isValid) {
    throw Exception("Invalid CSV format");
  }
  final receipts = await importService.importFromCSV(file);
  return ImportResult(
    receipts: receipts,
    successCount: receipts.length,
    failureCount: 0,
  );
});

final importFromJSONProvider = FutureProvider.family<ImportResult, File>((
  ref,
  file,
) async {
  final importService = ref.watch(importServiceProvider);
  final isValid = await importService.validateJSONFormat(file);
  if (!isValid) {
    throw Exception("Invalid JSON format");
  }
  final receipts = await importService.importFromJSON(file);
  return ImportResult(
    receipts: receipts,
    successCount: receipts.length,
    failureCount: 0,
  );
});

// Bulk import provider
final bulkImportProvider = FutureProvider.family<ImportResult, File>((
  ref,
  file,
) async {
  final importService = ref.watch(importServiceProvider);
  final fileName = file.path.toLowerCase();

  List<SaleReceiptModel> receipts = [];

  if (fileName.endsWith('.csv')) {
    final isValid = await importService.validateCSVFormat(file);
    if (!isValid) {
      throw Exception("Invalid CSV format");
    }
    receipts = await importService.importFromCSV(file);
  } else if (fileName.endsWith('.json')) {
    final isValid = await importService.validateJSONFormat(file);
    if (!isValid) {
      throw Exception("Invalid JSON format");
    }
    receipts = await importService.importFromJSON(file);
  } else {
    throw Exception("Unsupported file format. Please use CSV or JSON.");
  }

  return ImportResult(
    receipts: receipts,
    successCount: receipts.length,
    failureCount: 0,
  );
});

// Invalidate cache after import
void invalidateSaleReceiptsCache(WidgetRef ref) {
  ref.invalidate(saleReceiptsProvider);
}
