# Export & Import Feature Documentation

## Overview
The Export & Import feature allows users to backup, share, and manage sale receipts in multiple formats (CSV and JSON). This feature is fully integrated into the Reports view of the Bill Printer application.

## Features

### Export Functionality

#### 1. **Export All Receipts**
- Export entire database of sale receipts
- Available in both CSV and JSON formats
- Useful for complete backups and data analysis

#### 2. **Export by Date Range**
- Select a specific date range to export receipts
- Perfect for monthly or quarterly reports
- Only CSV format available for date range exports

#### 3. **Export by Payment Mode**
- Filter receipts by payment method (Cash, UPI, Card, Bank, Check)
- Useful for payment reconciliation
- Only CSV format available for payment mode exports

#### 4. **File Formats**

**CSV Format:**
- Compatible with Microsoft Excel, Google Sheets, and other spreadsheet applications
- Human-readable column structure
- Columns: ID, Order No, Customer Name, Prepared By, Payment Mode, Payment Ref, Total Amount, Created At, Updated At, Items Count
- Easy to edit and manipulate

**JSON Format:**
- Preserves all data including nested bill items
- Better for data preservation and backups
- Includes metadata (export date, total receipts count)
- Perfect for archival purposes

### Import Functionality

#### 1. **Import from CSV**
- Import receipts from CSV files
- Automatic format validation
- Select file and import with one click

#### 2. **Import from JSON**
- Restore receipts from JSON backups
- Preserves all details including bill items
- Full data recovery capability

#### 3. **Features**
- File format validation before import
- Progress indication during import
- Success notification with count of imported receipts
- Automatic database saving
- Error handling and reporting

## File Storage

### Export Location
All exported files are saved to the application's documents directory:
```
{ApplicationDocumentsDirectory}/exports/
```

### File Naming Convention
- **Default CSV:** `sale_receipts_YYYY_MM_DD_HHMMSS.csv`
- **Default JSON:** `sale_receipts_YYYY_MM_DD_HHMMSS.json`
- **Date Range CSV:** `sale_receipts_YYYY_MM_DD_to_YYYY_MM_DD.csv`
- **Payment Mode CSV:** `sale_receipts_{paymentMode}.csv`

## User Interface

### Export/Import Action Bar
Located at the top of the Reports view, providing quick access to:
- **Export Button**: Opens export dialog
- **Import Button**: Opens import dialog

### Export Dialog
- Select export format (CSV/JSON)
- Choose filter type:
  - All receipts
  - Date range (with date picker)
  - Payment mode (with dropdown)
- Confirmation dialog with file location

### Import Dialog
- File selection interface
- Format validation
- Progress indication
- Success/error notifications

## Usage Examples

### Example 1: Monthly Report Export
1. Open Reports view
2. Click Export button
3. Select CSV format
4. Choose "Export by Date Range"
5. Select month start and end dates
6. Click Export
7. File saved to documents directory

### Example 2: Backup Current Data
1. Open Reports view
2. Click Export button
3. Select JSON format
4. Choose "Export All Receipts"
5. Click Export
6. Save backup file location

### Example 3: Restore from Backup
1. Open Reports view
2. Click Import button
3. Select JSON backup file
4. Automatically validates format
5. Click Import
6. Receipts added to database

### Example 4: Payment Analysis
1. Open Reports view
2. Click Export button
3. Select CSV format
4. Choose "Export by Payment Mode"
5. Select payment mode (e.g., UPI)
6. Click Export
7. Analyze in Excel/Sheets

## Technical Details

### Service Architecture

**FileService** (`lib/data/services/file_service.dart`)
- Handles file I/O operations
- Directory management
- File deletion and listing

**ExportService** (`lib/data/services/export_service.dart`)
- Formats data for export
- Creates CSV/JSON files
- Implements filtering logic

**ImportService** (`lib/data/services/import_service.dart`)
- Parses CSV/JSON files
- Validates format
- Returns structured data

### Providers (`lib/ui/reports/providers/export_import_provider.dart`)
- `exportServiceProvider`: Export service instance
- `importServiceProvider`: Import service instance
- `saleReceiptsProvider`: Sale receipts data provider
- `exportToCSVProvider`: Export to CSV functionality
- `exportToJSONProvider`: Export to JSON functionality
- `exportByDateRangeProvider`: Date range export
- `exportByPaymentModeProvider`: Payment mode export
- `importFromCSVProvider`: CSV import functionality
- `importFromJSONProvider`: JSON import functionality

### UI Components

**ExportDialog** (`lib/ui/reports/widgets/export_dialog.dart`)
- Export options interface
- Date picker for range selection
- Dropdown for payment mode selection

**ImportDialog** (`lib/ui/reports/widgets/import_dialog.dart`)
- File selection interface
- Format validation
- Progress feedback

**ExportImportActionBar** (`lib/ui/reports/widgets/export_import_actions.dart`)
- Main UI component for export/import
- Available as action bar, floating buttons, or menu button

**ExportedFilesViewer** (`lib/ui/reports/widgets/exported_files_viewer.dart`)
- Browse previously exported files
- File deletion
- File size and modification date display

## Data Structure

### CSV Export Structure
```csv
ID,Order No,Customer Name,Prepared By,Payment Mode,Payment Ref,Total Amount,Created At,Updated At,Items Count
"id1","ORD001","John Doe","Admin","cash","","1500","2024-01-15T10:30:00.000Z","2024-01-15T10:30:00.000Z","2"
```

### JSON Export Structure
```json
{
  "export_date": "2024-01-15T10:30:00.000Z",
  "total_receipts": 1,
  "receipts": [
    {
      "id": "id1",
      "orederNo": "ORD001",
      "customerName": "John Doe",
      "preparedBy": "Admin",
      "paymentMode": "cash",
      "paymentRef": null,
      "totalAmount": 1500,
      "billItems": [...],
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

## Error Handling

### Export Errors
- Invalid filter criteria
- File system access issues
- Insufficient storage space

### Import Errors
- Invalid file format
- Corrupted data
- Missing required fields
- Duplicate entries

## Future Enhancements

- [ ] Excel format export with formatting
- [ ] PDF export with custom templates
- [ ] Cloud storage integration (Google Drive, Dropbox)
- [ ] Email export functionality
- [ ] Scheduled automatic backups
- [ ] Data validation and sanitization
- [ ] Batch import from multiple files
- [ ] Preview before import
- [ ] Undo import functionality
- [ ] Encryption for sensitive data

## Notes

- All exported files use standard timestamps
- File names include timestamps to prevent overwriting
- Imported data is validated before database insertion
- Cache is invalidated after successful import
- Files are stored locally on the device
- No data is sent to external servers (local backup only)

## Troubleshooting

### Export not working
- Check device storage space
- Verify application has file system permissions
- Check if no receipts exist in the database

### Import not working
- Verify file format (must be CSV or JSON)
- Ensure file is not corrupted
- Check date format in CSV (must be ISO 8601)

### Files not visible
- Check Documents directory path
- Verify file permissions
- Clear app cache and try again
