import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/bank_account/bank_account_view.dart';
import 'package:bill_printer/ui/bill_views/bill_view.dart';
import 'package:bill_printer/ui/category/category_view.dart';
import 'package:bill_printer/ui/reports/report_view.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBUtils.db;
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bill Printer',
      theme: ThemeData.dark(),
      home: MyHomePage(title: "Bill printer"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              navigateBtn(context: context, page: BillView()),
              navigateBtn(context: context, page: CategoryView()),
              navigateBtn(context: context, page: BankAccountView()),
              navigateBtn(context: context, page: ReportView()),
            ],
          ),
        ),
      ),
    );
  }
}
