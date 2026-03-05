import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bill_printer/data/services/file_service.dart';
import 'package:intl/intl.dart';

final exportedFilesProvider = FutureProvider<List<File>>((ref) async {
  final fileService = FileService.instance;
  final files = await fileService.getExportedFiles();
  return files.whereType<File>().toList()
    ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
});

class ExportedFilesViewer extends ConsumerWidget {
  const ExportedFilesViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(exportedFilesProvider);

    return filesAsync.when(
      data: (files) {
        if (files.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    'No exported files yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final fileName = file.path.split('/').last;
            final fileSize = file.lengthSync();
            final modified = file.lastModifiedSync();
            final isCSV = fileName.endsWith('.csv');

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    isCSV ? Icons.table_chart : Icons.data_object,
                    color: isCSV ? Colors.orange : Colors.blue,
                  ),
                  title: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Modified: ${DateFormat('yyyy-MM-dd HH:mm').format(modified)} • ${_formatFileSize(fileSize)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteFile(context, ref, file, fileName);
                      } else if (value == 'copy') {
                        _copyToClipboard(context, file);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'copy',
                            child: Row(
                              children: [
                                Icon(Icons.content_copy),
                                SizedBox(width: 8),
                                Text('Copy Path'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 10),
              Text(
                'Error loading files: $err',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteFile(
    BuildContext context,
    WidgetRef ref,
    File file,
    String fileName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FileService.instance.deleteFile(file);
                ref.invalidate(exportedFilesProvider);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File deleted successfully')),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting file: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, File file) {
    // Note: Requires flutter/services.dart for Clipboard
    // For now, just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('File path: ${file.path}')));
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}

/// Dialog to view exported files
class ExportedFilesDialog extends ConsumerWidget {
  const ExportedFilesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const SizedBox(),
            title: const Text('Exported Files'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Expanded(child: ExportedFilesViewer()),
        ],
      ),
    );
  }
}
