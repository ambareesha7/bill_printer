import 'package:bill_printer/app_router.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/providers/auth_provider.dart';
import '../widgets/bill_header_widget.dart';
import '../widgets/nav_btn.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = ref.watch(isUserLoggedInProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BillHeaderWidget(),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (isLoggedIn) {
                  context.push("/${RouterPaths.createBill.name}");
                } else {
                  UIUtils.showSnackBar(
                    context: context,
                    text: "Please setup a User to create bills",
                  );
                  context.push("/${RouterPaths.signUp.name}");
                }
              },
              child: Text(capitalize(RouterPaths.createBill.name)),
            ),
            NavBtn(path: RouterPaths.category.name),
            NavBtn(path: RouterPaths.bankAccount.name),
            NavBtn(path: RouterPaths.reports.name),
            NavBtn(path: RouterPaths.signUp.name),
            NavBtn(path: RouterPaths.users.name),
          ],
        ),
      ),
    );
  }
}
