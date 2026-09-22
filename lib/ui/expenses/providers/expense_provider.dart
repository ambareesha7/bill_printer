import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseListProvider =
    NotifierProvider<ExpenseListNotifier, List<Expense>>(
      ExpenseListNotifier.new,
    );

class ExpenseListNotifier extends Notifier<List<Expense>> {
  final DBUtils dbUtils = DBUtils.instance;

  @override
  List<Expense> build() {
    load();
    return [];
  }

  Future<void> load({DateTime? startDate, DateTime? endDate}) async {
    state = await dbUtils.getExpenses(startDate: startDate, endDate: endDate);
  }

  Future<void> add({
    required String title,
    required String category,
    required int amount,
    required DateTime spentAt,
    String? notes,
    String? paymentReference,
  }) async {
    await dbUtils.insertExpense(
      title: title,
      category: category,
      amount: amount,
      spentAt: spentAt,
      notes: notes,
      paymentReference: paymentReference,
    );
    await load();
  }

  Future<void> edit({
    required String id,
    required String title,
    required String category,
    required int amount,
    required DateTime spentAt,
    String? notes,
    String? paymentReference,
  }) async {
    await dbUtils.updateExpense(
      id: id,
      title: title,
      category: category,
      amount: amount,
      spentAt: spentAt,
      notes: notes,
      paymentReference: paymentReference,
    );
    await load();
  }

  Future<void> remove(String id) async {
    await dbUtils.deleteExpense(id);
    await load();
  }
}
