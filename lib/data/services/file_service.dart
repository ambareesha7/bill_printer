import 'dart:io';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';

class FileService {
  FileService._internal();
  static FileService get instance => _instance;
  static final FileService _instance = FileService._internal();
  final localFileManager = FileManager();

  /// Get the documents directory where files will be saved
  Future<Directory> _getDocumentsDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      debugLog("Error getting documents directory: $e");
      throw Exception("Could not access documents directory");
    }
  }

  /// Get the Downloads directory where exported files will be visible to users
  Future<Directory?> getDownloadsDirectory1() async {
    try {
      return await getDownloadsDirectory();
    } catch (e) {
      debugLog("Error getting downloads directory: $e");
      // Fallback to documents directory if downloads is not available
      return null;
    }
  }

  /// Save data to a file in documents directory
  Future<File> saveFile1({
    required String fileName,
    required String content,
    String subDirectory = 'exports',
  }) async {
    try {
      final directory = await _getDocumentsDirectory();
      final subDir = Directory('${directory.path}/$subDirectory');

      if (!await subDir.exists()) {
        await subDir.create(recursive: true);
      }

      final file = File('${subDir.path}/$fileName');
      await file.writeAsString(content);

      debugLog("File saved successfully: ${file.path}");
      return file;
    } catch (e) {
      debugLog("Error saving file: $e");
      throw Exception("Failed to save file: $e");
    }
  }

  /// Save data to a file in Downloads directory (visible to users)
  /// Falls back to documents directory if Downloads is not available
  Future<File> saveFileToDownloads({
    required String fileName,
    required String content,
  }) async {
    try {
      // Directory? directory = await getDownloadsDirectory();
      Directory directory = await localFileManager
          .getPlatformSpecificDirectory();

      // Create downloads/exports subdirectory for organization
      final exportsDir = Directory('${directory.path}/exports');
      
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }

      final file = File('${exportsDir.path}/$fileName');
      await file.writeAsString(content);

      debugLog("File saved to downloads successfully: ${file.path}");
      return file;
    } catch (e) {
      debugLog("Error saving file to downloads: $e");
      throw Exception("Failed to save file to downloads: $e");
    }
  }

  /// Read data from a file
  Future<String> readFile({required File file}) async {
    try {
      if (!await file.exists()) {
        throw Exception("File does not exist");
      }
      final content = await file.readAsString();
      debugLog("File read successfully: ${file.path}");
      return content;
    } catch (e) {
      debugLog("Error reading file: $e");
      throw Exception("Failed to read file: $e");
    }
  }

  /// Get list of all exported files
  Future<List<FileSystemEntity>> getExportedFiles({
    String subDirectory = 'exports',
  }) async {
    try {
      final directory = await _getDocumentsDirectory();
      final subDir = Directory('${directory.path}/$subDirectory');

      if (!await subDir.exists()) {
        return [];
      }

      final files = subDir.listSync();
      return files;
    } catch (e) {
      debugLog("Error getting exported files: $e");
      return [];
    }
  }

  /// Delete a file
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        debugLog("File deleted successfully: ${file.path}");
      }
    } catch (e) {
      debugLog("Error deleting file: $e");
      throw Exception("Failed to delete file: $e");
    }
  }

  /// Get the export directory path
  Future<String> getExportDirectoryPath({
    String subDirectory = 'exports',
  }) async {
    try {
      final directory = await _getDocumentsDirectory();
      return '${directory.path}/$subDirectory';
    } catch (e) {
      debugLog("Error getting export directory path: $e");
      throw Exception("Could not get export directory path");
    }
  }
}
