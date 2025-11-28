import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/auth/providers/auth_provider.dart';
import 'package:bill_printer/ui/auth/sign_up_view.dart';
import 'package:bill_printer/ui/auth/users_view.dart';
import 'package:bill_printer/ui/bank_account/bank_account_view.dart';
import 'package:bill_printer/ui/bill_views/bill_view.dart';
import 'package:bill_printer/ui/category/category_view.dart';
import 'package:bill_printer/ui/reports/report_view.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/bill_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBUtils.db;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
      home: MyHomePage(),
      routes: {
        '/home': (context) => MyHomePage(),
        "/bill_view": (context) => BillView(),
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = ref.watch(isUserLoggedInProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BillHeaderWidget(),
            ElevatedButton(
              onPressed: () {
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BillView()),
                  );
                } else {
                  UIUtils.showSnackBar(
                    context: context,
                    text: "Please setup a User to create bills",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                }
              },
              child: Text(BillView().toString()),
            ),
            navigateBtn(context: context, page: CategoryView()),
            navigateBtn(context: context, page: BankAccountView()),
            navigateBtn(context: context, page: ReportView()),
            navigateBtn(context: context, page: SignUpView()),
            navigateBtn(context: context, page: UsersView()),
          ],
        ),
      ),
    );
  }
}
