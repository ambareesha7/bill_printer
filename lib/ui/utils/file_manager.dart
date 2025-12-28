import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  FileManager._private();
  static final FileManager _instance = FileManager._private();
  FileManager get instance => _instance;

  factory FileManager() {
    return _instance;
  }

  /// print all file names saved in the app folder
  listExistingFiles() async {
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

  Future<String> makeDirectory({required String dirName}) async {
    final Directory directory = await getPlatformSpecificDirectory();
    final Directory newDir = await Directory(
      path.join(directory.path, dirName),
    ).create(recursive: true);
    return newDir.path;
  }

  Future<String?> get directoryPath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
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
      var file = await File(fullPath).delete(recursive: recursive);
      return file;
    } catch (e, st) {
      // Utils().showToast(text: 'Failed to delete the file');
      log('file deleting failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<String?> readJsonFile1({required File file}) async {
    String fileContent = '[]';
    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return fileContent;
      } catch (e) {
        // Utils().showToast(text: 'Failed to read the file', color: Colors.red);
        return null;
      }
    }

    return null;
  }

  // Future writeJsonFile(String storyList) async {
  //   File file = await storyJsonFile;
  //   var filePath = await file.writeAsString(storyList);
  //   // print('file write ...... ${filePath.path}');
  //   return filePath;
  // }

  Future<File?> writeJsonFile1({
    required dynamic contents,
    required File filePath,
  }) async {
    // File file = await _jsonFile;
    // print('file write ...... ${filePath.path}');
    try {
      return await filePath.writeAsString(contents);
    } catch (e) {
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
