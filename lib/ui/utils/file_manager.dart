import 'dart:developer';
import 'dart:io';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FileManager {
  FileManager._private();
  static final FileManager _instance = FileManager._private();
  FileManager get instance => _instance;

  factory FileManager() {
    return _instance;
  }

  /// print all file names saved in the app folder
  Future<List> listExistingFiles() async {
    List filesList = [];
    var files = await getPlatformSpecificDirectory();
    var allFiles = files.listSync(recursive: true).toList();
    for (var e in allFiles.asMap().entries.toList()) {
      // String file = e.value.path;
      log('filePath ${e.key} ${e.value}');
      filesList.add(e);
    }
    return filesList;
  }

  Future<Directory> makeFolder({required String dirName}) async {
    Directory directory = await getPlatformSpecificDirectory();
    String dirName = 'exports';
    final subDir = Directory('${directory.path}/$dirName');
    bool dirExists = await subDir.exists();
    if (!dirExists) {
      await subDir.create(recursive: true);
      return subDir;
    } else {
      return subDir;
    }
  }

  Future<String?> get directoryPath async {
    var status = await Permission.storage.status;
    log(status.name, name: "Permission.storage.status");
    if (!status.isGranted) {
      // If not we will ask for permission first
      var newSt = await Permission.storage.request();
      log(newSt.name, name: "Permission.storage.request status");
      // await openAppSettings();
      return null;
    } else {
      Directory directory = await getPlatformSpecificDirectory();
      return directory.path;
    }
  }

  Future<Directory> getPlatformSpecificDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationSupportDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  Future<FileSystemEntity?> deleteFile({
    required String fullPath,
    bool recursive = false,
  }) async {
    try {
      var file = File(fullPath);
      if (file.existsSync()) {
        file.delete(recursive: recursive);
      }
      return file;
    } catch (e, st) {
      // Utils().showToast(text: 'Failed to delete the file');
      log('file deleting failed', error: e, stackTrace: st);
      return null;
    }
  }

  shareNDeleteFile() async {
    try {
      String newFilePath = "";
      final localFileManager = FileManager();

      Directory directory = await localFileManager.makeFolder(
        dirName: "exports",
      );
      var allFiles = directory.listSync(recursive: true).toList();
      for (var e in allFiles.asMap().entries.toList()) {
        var file = e.value;
        String extension = path.extension(file.path);
        debugLog('extension $extension');
        if (file.path.isNotEmpty &&
                extension.isNotEmpty &&
                extension.contains(".json") ||
            extension.contains(".csv")) {
          newFilePath = file.path;
        }
      }

      if (newFilePath.isNotEmpty) {
        UIUtils().shareFile(newFilePath, "saveData").then((
          ShareResult? result,
        ) {
          if (result != null) {
            for (var e in allFiles.asMap().entries.toList()) {
              localFileManager.deleteFile(fullPath: e.value.path);
            }
          }
        });
      }
    } catch (e) {
      debugLog(e, tag: "error2");
    }
  }

  Future<File> saveFileToTemp({
    required String fileName,
    required String content,
  }) async {
    try {
      Directory directory = await getPlatformSpecificDirectory();
      final exportsDir2 = await directory.createTemp("exports");

      final file = File('${exportsDir2.path}/$fileName');
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

  Future<ShareResult?> shareFile(File fi) async {
    try {
      ShareResult? result = await UIUtils().shareFile(fi.path, "saveData");
      return result;
    } catch (e) {
      debugLog(e, tag: "shareFile");
      return null;
    }
  }

  // askStoragePermission() async {
  //   await Permission.storage
  //       .onDeniedCallback(() {
  //         // Your code
  //       })
  //       .onGrantedCallback(() {
  //         // Your code
  //       })
  //       .onPermanentlyDeniedCallback(() {
  //         // Your code
  //       })
  //       .onRestrictedCallback(() {
  //         // Your code
  //       })
  //       .onLimitedCallback(() {
  //         // Your code
  //       })
  //       .onProvisionalCallback(() {
  //         // Your code
  //       })
  //       .request();
  // }
}
