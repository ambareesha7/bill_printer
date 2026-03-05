import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:bill_printer/ui/reports/widgets/export_dialog.dart';
import 'package:bill_printer/ui/reports/widgets/import_dialog.dart';

/// Action bar widget containing export and import buttons
class ExportImportActionBar extends ConsumerWidget {
  final List<SaleReceiptModel> receipts;
  final Function()? onImportComplete;

  const ExportImportActionBar({
    super.key,
    required this.receipts,
    this.onImportComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ExportDialog(receipts: receipts),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ImportDialog(
                    onImportSuccess: (importedReceipts) {
                      onImportComplete?.call();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.upload),
              label: const Text('Import'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating action buttons version for compact UI
class ExportImportFloatingActions extends ConsumerWidget {
  final List<SaleReceiptModel> receipts;
  final Function()? onImportComplete;

  const ExportImportFloatingActions({
    super.key,
    required this.receipts,
    this.onImportComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'export',
            tooltip: 'Export Sale Receipts',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ExportDialog(receipts: receipts),
              );
            },
            child: const Icon(Icons.download),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'import',
            tooltip: 'Import Sale Receipts',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ImportDialog(
                  onImportSuccess: (importedReceipts) {
                    onImportComplete?.call();
                  },
                ),
              );
            },
            child: const Icon(Icons.upload),
          ),
        ],
      ),
    );
  }
}

/// Menu button version for toolbar
class ExportImportMenuButton extends ConsumerWidget {
  final List<SaleReceiptModel> receipts;
  final Function()? onImportComplete;

  const ExportImportMenuButton({
    super.key,
    required this.receipts,
    this.onImportComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'export') {
          showDialog(
            context: context,
            builder: (context) => ExportDialog(receipts: receipts),
          );
        } else if (value == 'import') {
          showDialog(
            context: context,
            builder: (context) => ImportDialog(
              onImportSuccess: (importedReceipts) {
                onImportComplete?.call();
              },
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'export',
          child: Row(
            children: [
              Icon(Icons.download),
              SizedBox(width: 10),
              Text('Export'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'import',
          child: Row(
            children: [Icon(Icons.upload), SizedBox(width: 10), Text('Import')],
          ),
        ),
      ],
    );
  }
}
