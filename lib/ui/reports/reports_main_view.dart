import 'dart:io';

import 'package:bill_printer/app_router.dart';
import 'package:bill_printer/data/services/export_service.dart';
import 'package:bill_printer/data/services/import_service.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:bill_printer/ui/widgets/menu_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportsMainView extends ConsumerStatefulWidget {
  const ReportsMainView({super.key});

  @override
  ConsumerState<ReportsMainView> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<ReportsMainView> {
  List navList = [RouterPaths.reports.name, RouterPaths.analytics.name];
  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = ref.watch(isUserLoggedInProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Center(child: Icon(Icons.receipt, size: 80, color: Colors.green)),
          Text(
            capitalize(RouterPaths.reportsMain.name),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final exportService = ExportService.instance;
                  File file = await exportService.exportToJSON();
                  FileManager().shareFile(file);
                },
                icon: const Icon(Icons.upload),
                label: const Text('Export'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  File file;
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ["json"],
                      );

                  // The result will be null, if the user aborted the dialog
                  if (result != null) {
                    if (result.files.isNotEmpty) {
                      if (result.files.first.path != null) {
                        file = File(result.files.first.path!);
                        ImportService.instance.importFromJSON(file);
                      }
                    }
                  }
                },
                icon: const Icon(Icons.download),
                label: const Text('Import'),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              itemCount: navList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                var name = navList[index];
                return MenuItem(
                  name: navList[index],
                  onTap: () {
                    debugLog(name, tag: "name");
                    context.push("/$name");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
