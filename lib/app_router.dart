import 'package:bill_printer/ui/auth/sign_up_view.dart';
import 'package:bill_printer/ui/auth/users_view.dart';
import 'package:bill_printer/ui/bank_account/bank_account_view.dart';
import 'package:bill_printer/ui/bill_views/bill_view.dart';
import 'package:bill_printer/ui/category/category_view.dart';
import 'package:bill_printer/ui/home/home_view.dart';
import 'package:bill_printer/ui/reports/report_view.dart';
import 'package:go_router/go_router.dart';

enum RouterPaths { createBill, category, bankAccount, reports, signUp, users }

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => HomeView(), routes: [
      ],
    ),
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
      path: "/${RouterPaths.signUp.name}",
      builder: (context, state) => SignUpView(),
    ),
    GoRoute(
      path: "/${RouterPaths.users.name}",
      builder: (context, state) => UsersView(),
    ),
  ],
);
