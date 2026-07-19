import 'package:bill_printer/app_router.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/providers/auth_provider.dart';
import '../widgets/bill_header_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomeView> {
  List navList = [
    RouterPaths.category.name,
    RouterPaths.bankAccount.name,
    RouterPaths.reportsMain.name,
    RouterPaths.signUp.name,
    RouterPaths.users.name,
    RouterPaths.printer.name,
    RouterPaths.checklists.name,

    // const Icon(Icons.info_outline),
    RouterPaths.about.name,
    RouterPaths.shop.name,
  ];

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = ref.watch(isUserLoggedInProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            BillHeaderWidget(),
            SizedBox(height: 15),
            ListTile(
              onTap: () {
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
              title: Center(
                child: Text(capitalize(RouterPaths.createBill.name)),
              ),
              shape: Border.all(color: Colors.tealAccent),
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
                      debugLog(name, tag: "Current Path");
                      context.push("/$name");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
