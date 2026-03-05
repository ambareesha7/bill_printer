import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/ui/reports/providers/export_import_provider.dart';
import 'package:intl/intl.dart';

class ExportDialog extends ConsumerStatefulWidget {
  final List<SaleReceiptModel> receipts;

  const ExportDialog({super.key, required this.receipts});

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  String selectedFormat = 'csv'; // csv or json
  String selectedFilter = 'all'; // all, dateRange, paymentMode
  DateTime? startDate;
  DateTime? endDate;
  String selectedPaymentMode = 'cash';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Export Sale Receipts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Format selection
              const Text(
                'Export Format',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('CSV'),
                      value: 'csv',
                      groupValue: selectedFormat,
                      onChanged: (value) {
                        setState(() => selectedFormat = value!);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('JSON'),
                      value: 'json',
                      groupValue: selectedFormat,
                      onChanged: (value) {
                        setState(() => selectedFormat = value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Filter selection
              const Text(
                'Filter Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: const Text('Export All Receipts'),
                value: 'all',
                groupValue: selectedFilter,
                onChanged: (value) {
                  setState(() => selectedFilter = value!);
                },
              ),
              RadioListTile<String>(
                title: const Text('Export by Date Range'),
                value: 'dateRange',
                groupValue: selectedFilter,
                onChanged: (value) {
                  setState(() => selectedFilter = value!);
                },
              ),
              const SizedBox(height: 20),
              // Conditional UI based on filter selection
              if (selectedFilter == 'dateRange') ...[_buildDateRangeSelector()],
              const SizedBox(height: 20),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _handleExport,
                    child: const Text('Export'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date Range',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _selectStartDate,
                child: Text(
                  startDate == null
                      ? 'Start Date'
                      : DateFormat('yyyy-MM-dd').format(startDate!),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('to'),
            ),
            Expanded(
              child: TextButton(
                onPressed: _selectEndDate,
                child: Text(
                  endDate == null
                      ? 'End Date'
                      : DateFormat('yyyy-MM-dd').format(endDate!),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> _handleExport() async {
    try {
      // Validate date range if selected
      if (selectedFilter == 'dateRange') {
        if (startDate == null || endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select both start and end dates'),
            ),
          );
          return;
        }
        if (startDate!.isAfter(endDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Start date must be before end date')),
          );
          return;
        }
      }

      final exportService = ref.read(exportServiceProvider);

      if (selectedFilter == 'all') {
        if (selectedFormat == 'csv') {
          await exportService.exportToCSV(widget.receipts);
          showSharing();
          // _showSuccessDialog('receipts.csv', file.path);
        } else {
          await exportService.exportToJSON(widget.receipts);
          showSharing();
          // _showSuccessDialog('receipts.json', file.path);
        }
      } else if (selectedFilter == 'dateRange') {
        await exportService.exportByDateRangeToCSV(
          widget.receipts,
          startDate!,
          endDate!,
        );
        showSharing();
        // _showSuccessDialog(
        //   'receipts_${startDate!.toString().split(' ')[0]}_to_${endDate!.toString().split(' ')[0]}.csv',
        //   file.path,
        // );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }
}

showSharing() {
  FileManager().shareNDeleteFile();
}

class ExportButton extends ConsumerWidget {
  final List<SaleReceiptModel> receipts;

  const ExportButton({super.key, required this.receipts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ExportDialog(receipts: receipts),
        );
      },
      icon: const Icon(Icons.download),
      label: const Text('Export'),
    );
  }
}
