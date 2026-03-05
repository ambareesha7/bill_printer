# Quick Start Guide - Export & Import Features

## 🎯 For Users

### How to Export Receipts

1. **Navigate to Reports View**
   - Open the app and go to Reports section

2. **Click the Export Button**
   - Located in the action bar at the top of the Reports view

3. **Choose Your Export Format**
   - **CSV**: For Excel/Sheets spreadsheets
   - **JSON**: For backup/archiving

4. **Select Filter Type**
   - **All Receipts**: Export everything
   - **Date Range**: Select start and end dates
   - **Payment Mode**: Choose payment method (Cash, UPI, Card, etc.)

5. **Click Export**
   - File is automatically saved to your device
   - Success dialog shows file location

### How to Import Receipts

1. **Click the Import Button**
   - Located next to Export in the action bar

2. **Select Your File**
   - Choose a CSV or JSON file from your device

3. **Let the App Validate**
   - Format is automatically checked
   - Progress indicator shows import status

4. **Success!**
   - Receipts are added to your database
   - View is automatically updated

---

## 👨‍💻 For Developers

### Integration in Your Views

#### Option 1: Action Bar (Recommended)
```dart
import 'package:bill_printer/ui/reports/widgets/export_import_actions.dart';
import 'package:bill_printer/ui/reports/providers/export_import_provider.dart';

// In your widget
Column(
  children: [
    ExportImportActionBar(
      receipts: receiptsList,
      onImportComplete: () {
        ref.invalidate(saleReceiptsProvider);
      },
    ),
    // Your other content
  ],
)
```

#### Option 2: Floating Action Buttons
```dart
ExportImportFloatingActions(
  receipts: receiptsList,
  onImportComplete: () {
    ref.invalidate(saleReceiptsProvider);
  },
)
```

#### Option 3: Menu Button
```dart
ExportImportMenuButton(
  receipts: receiptsList,
  onImportComplete: () {
    ref.invalidate(saleReceiptsProvider);
  },
)
```

### Direct Service Usage

#### Export Service
```dart
import 'package:bill_printer/data/services/export_service.dart';

final exportService = ExportService.instance;

// Export all to CSV
final csvFile = await exportService.exportToCSV(receiptsList);

// Export by date range
final rangeFile = await exportService.exportByDateRangeToCSV(
  receiptsList,
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

// Export by payment mode
final pmFile = await exportService.exportByPaymentModeToCSV(
  receiptsList,
  'upi',
);
```

#### Import Service
```dart
import 'package:bill_printer/data/services/import_service.dart';

final importService = ImportService.instance;

// Import from CSV
final receipts = await importService.importFromCSV(file);

// Import from JSON
final receipts = await importService.importFromJSON(file);

// Validate format before import
final isValid = await importService.validateCSVFormat(file);
```

#### File Service
```dart
import 'package:bill_printer/data/services/file_service.dart';

final fileService = FileService.instance;

// Get export directory path
final path = await fileService.getExportDirectoryPath();

// Get list of exported files
final files = await fileService.getExportedFiles();

// Delete a file
await fileService.deleteFile(file);
```

### Using Providers

```dart
import 'package:bill_printer/ui/reports/providers/export_import_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Watch sale receipts
final receiptsAsync = ref.watch(saleReceiptsProvider);

// Watch export to CSV
final csvAsync = ref.watch(
  exportToCSVProvider(receiptsAsync.value ?? [])
);

// Watch import from file
final importAsync = ref.watch(
  importFromCSVProvider(selectedFile)
);
```

---

## 📁 File Structure

```
lib/
├── data/
│   ├── services/
│   │   ├── file_service.dart           # File operations
│   │   ├── export_service.dart         # Export logic
│   │   └── import_service.dart         # Import logic
│   └── ...
├── ui/
│   └── reports/
│       ├── providers/
│       │   └── export_import_provider.dart  # Riverpod providers
│       ├── widgets/
│       │   ├── export_dialog.dart           # Export UI
│       │   ├── import_dialog.dart           # Import UI
│       │   ├── export_import_actions.dart   # Action components
│       │   └── exported_files_viewer.dart   # File browser
│       ├── export_import_sample_view.dart   # Demo view
│       └── report_view.dart                 # Integration point
```

---

## 🔧 Configuration

### Change Default Export Location
```dart
// In FileService.saveFile()
final file = await _fileService.saveFile(
  fileName: 'custom_name.csv',
  content: csvContent,
  subDirectory: 'custom_exports',  // Change this
);
```

### Customize File Naming
```dart
final timestamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
final fileName = 'receipts_$timestamp.csv';

final file = await exportService.exportToCSV(
  receipts,
  customFileName: fileName,
);
```

---

## 🐛 Troubleshooting

### Export not showing file location
- Check if device has enough storage space
- Verify file system permissions

### Import fails with "Invalid format"
- Ensure file is actually CSV or JSON
- Check file encoding (should be UTF-8)
- Verify CSV header row is present

### Can't find exported files
- Check application documents directory
- On Android: /phone/%appName%/
- On iOS: Library/Application Documents/

---

## 📚 See Also

- Full documentation: `EXPORT_IMPORT_FEATURE.md`
- Implementation summary: `IMPLEMENTATION_SUMMARY.md`

---

## 💡 Tips

1. **CSV for Analysis**: Export to CSV when you want to analyze data in Excel
2. **JSON for Backup**: Use JSON export for reliable backups
3. **Date Range**: Perfect for monthly reports and reconciliation
4. **Payment Mode**: Use to categorize receipts by payment type
5. **Batch Operations**: Import can handle large files efficiently

---

## 📞 Support

For issues or feature requests:
1. Check the troubleshooting section above
2. Review error messages in the app
3. Check application logs

**Last Updated:** Feb 25, 2024
