import 'package:bill_printer/ui/about/about_view.dart';
import 'package:bill_printer/ui/auth/sign_up_view.dart';
import 'package:bill_printer/ui/auth/users_view.dart';
import 'package:bill_printer/ui/bank_account/bank_account_view.dart';
import 'package:bill_printer/ui/bill_views/bill_view.dart';
import 'package:bill_printer/ui/category/category_view.dart';
import 'package:bill_printer/ui/home/home_view.dart';
import 'package:bill_printer/ui/printer/printer_view.dart';
import 'package:bill_printer/ui/reports/analytics_view.dart';
import 'package:bill_printer/ui/reports/report_view.dart';
import 'package:bill_printer/ui/checklists/checklists.dart';
import 'package:bill_printer/ui/shop/shop_view.dart';
import 'package:go_router/go_router.dart';

import 'ui/reports/reports_main_view.dart';

enum RouterPaths {
  createBill,
  category,
  bankAccount,
  reports,
  reportsMain,
  analytics,
  checklists,
  checklistDetails,
  signUp,
  users,
  about,
  printer,
  shop,
}

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => HomeView(), routes: []),
    GoRoute(
      path: "/${RouterPaths.createBill.name}",
      builder: (context, state) => BillView(),
    ),
    GoRoute(
      path: "/${RouterPaths.category.name}",
      builder: (context, state) => CategoryView(),
    ),
    GoRoute(
      path: "/${RouterPaths.bankAccount.name}",
      builder: (context, state) => BankAccountView(),
    ),
    GoRoute(
      path: "/${RouterPaths.reports.name}",
      builder: (context, state) => ReportView(),
    ),
    GoRoute(
      path: "/${RouterPaths.reportsMain.name}",
      builder: (context, state) => ReportsMainView(),
    ),
    GoRoute(
      path: "/${RouterPaths.analytics.name}",
      builder: (context, state) => AnalyticsView(),
    ),
    GoRoute(
      path: "/${RouterPaths.checklists.name}",
      builder: (context, state) => const ChecklistListView(),
    ),
    GoRoute(
      path: "/${RouterPaths.checklistDetails.name}/:id",
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ChecklistDetailView(checklistId: id ?? '');
      },
    ),
    GoRoute(
      path: "/${RouterPaths.signUp.name}",
      builder: (context, state) => SignUpView(),
    ),
    GoRoute(
      path: "/${RouterPaths.users.name}",
      builder: (context, state) => UsersView(),
    ),
    GoRoute(
      path: "/${RouterPaths.about.name}",
      builder: (context, state) => AboutView(),
    ),
    GoRoute(
      path: "/${RouterPaths.printer.name}",
      builder: (context, state) => PrinterView(),
    ),
    GoRoute(
      path: "/${RouterPaths.shop.name}",
      builder: (context, state) => ShopView(),
    ),
  ],
);
