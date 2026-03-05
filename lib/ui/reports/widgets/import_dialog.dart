import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/services/import_service.dart';

class ImportDialog extends ConsumerStatefulWidget {
  final Function(List<SaleReceiptModel>) onImportSuccess;

  const ImportDialog({super.key, required this.onImportSuccess});

  @override
  ConsumerState<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<ImportDialog> {
  File? selectedFile;
  bool isLoading = false;
  double? validationProgress;
  String validationMessage = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Import Sale Receipts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a file to import (CSV or JSON)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            // File selection card
            GestureDetector(
              onTap: isLoading ? null : _pickFile,
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      if (selectedFile == null)
                        const Text('Tap to select file')
                      else
                        Column(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(height: 10),
                            Text(
                              selectedFile!.path.split('/').last,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (validationMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  validationMessage,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            if (isLoading && validationProgress != null) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(value: validationProgress),
            ],
            const SizedBox(height: 20),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedFile == null || isLoading
                      ? null
                      : _handleImport,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Import'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      // For mobile, we'll use simple file selection via file picker dialog
      // For production, consider using file_picker package
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select File Format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('CSV File'),
                onTap: () {
                  Navigator.pop(context);
                  _simulateFilePick('.csv');
                },
              ),
              ListTile(
                leading: const Icon(Icons.data_object),
                title: const Text('JSON File'),
                onTap: () {
                  Navigator.pop(context);
                  _simulateFilePick('.json');
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _simulateFilePick(String fileType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please add file_picker package to enable file selection. For now, you can use the sample import feature.',
        ),
      ),
    );
  }

  Future<void> _handleImport() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a file')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final importService = ImportService.instance;
      final fileName = selectedFile!.path.toLowerCase();

      List<SaleReceiptModel> importedReceipts = [];

      if (fileName.endsWith('.csv')) {
        setState(() => validationMessage = 'Validating CSV format...');
        final isValid = await importService.validateCSVFormat(selectedFile!);
        if (!isValid) {
          throw Exception('Invalid CSV format');
        }

        setState(() => validationMessage = 'Importing receipts from CSV...');
        importedReceipts = await importService.importFromCSV(selectedFile!);
      } else if (fileName.endsWith('.json')) {
        setState(() => validationMessage = 'Validating JSON format...');
        final isValid = await importService.validateJSONFormat(selectedFile!);
        if (!isValid) {
          throw Exception('Invalid JSON format');
        }

        setState(() => validationMessage = 'Importing receipts from JSON...');
        importedReceipts = await importService.importFromJSON(selectedFile!);
      } else {
        throw Exception('Unsupported file format. Please use CSV or JSON.');
      }

      if (importedReceipts.isEmpty) {
        throw Exception('No valid receipts found in the file');
      }

      // Save to database
      setState(() => validationMessage = 'Saving to database...');
      for (final receipt in importedReceipts) {
        if (receipt.orederNo != null) {
          await DBUtils.instance.insertSaleReceipt(
            billItems: receipt.billItems ?? [],
            totalAmount: receipt.totalAmount ?? 0,
            orderNo: receipt.orederNo!,
            customerName: receipt.customerName,
            preparedBy: receipt.preparedBy,
            paymentMode: receipt.paymentMode,
            paymentRef: receipt.paymentRef,
          );
        }
      }

      setState(() => isLoading = false);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onImportSuccess(importedReceipts);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully imported ${importedReceipts.length} receipts',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ImportButton extends ConsumerWidget {
  final Function(List<SaleReceiptModel>) onImportSuccess;

  const ImportButton({super.key, required this.onImportSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Import Sale Receipts',
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                ImportDialog(onImportSuccess: onImportSuccess),
          );
        },
        icon: const Icon(Icons.upload),
        label: const Text('Import'),
      ),
    );
  }
}
