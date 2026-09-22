import 'dart:io';

import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/services/expense_transfer_service.dart';
import 'package:bill_printer/ui/expenses/expense_analytics.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Expense _expense({
  required String id,
  required String title,
  required String category,
  required int amount,
  required DateTime spentAt,
}) {
  return Expense(
    id: id,
    title: title,
    category: category,
    amount: amount,
    notes: null,
    spentAt: spentAt,
    createdAt: spentAt,
    updatedAt: spentAt,
  );
}

void main() {
  group('expense analytics', () {
    final expenses = [
      _expense(
        id: '1',
        title: 'Fuel',
        category: 'Travel',
        amount: 500,
        spentAt: DateTime(2026, 9, 1),
      ),
      _expense(
        id: '2',
        title: 'Fuel',
        category: 'Travel',
        amount: 300,
        spentAt: DateTime(2026, 9, 2),
      ),
      _expense(
        id: '3',
        title: 'Rent',
        category: 'Office',
        amount: 2000,
        spentAt: DateTime(2026, 9, 3),
      ),
    ];

    test('groups category totals', () {
      expect(expenseCategoryTotals(expenses), {'Travel': 800, 'Office': 2000});
    });

    test('groups item totals with repeat count', () {
      final result = expenseItemTotals(expenses);

      expect(result['Fuel']?.amount, 800);
      expect(result['Fuel']?.count, 2);
      expect(result['Rent']?.amount, 2000);
      expect(result['Rent']?.count, 1);
    });

    test('filters expenses inclusively by calendar day', () {
      final result = expensesInRange(
        expenses,
        DateTimeRange(start: DateTime(2026, 9, 2), end: DateTime(2026, 9, 2)),
      );

      expect(result.map((expense) => expense.id), ['2']);
    });
  });

  group('expense database', () {
    late AppDatabase database;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() => database.close());

    test('supports create, read, update, and delete', () async {
      final spentAt = DateTime(2026, 9, 10);
      await database
          .into(database.expenses)
          .insert(
            ExpensesCompanion.insert(
              id: 'expense-1',
              title: 'Internet',
              category: 'Utilities',
              amount: 1200,
              spentAt: spentAt,
            ),
          );

      var result = await database.select(database.expenses).get();
      expect(result.single.title, 'Internet');
      expect(result.single.amount, 1200);

      await (database.update(
        database.expenses,
      )..where((table) => table.id.equals('expense-1'))).write(
        const ExpensesCompanion(
          title: Value('Internet Pro'),
          amount: Value(1500),
        ),
      );
      result = await database.select(database.expenses).get();
      expect(result.single.title, 'Internet Pro');
      expect(result.single.amount, 1500);

      await (database.delete(
        database.expenses,
      )..where((table) => table.id.equals('expense-1'))).go();
      expect(await database.select(database.expenses).get(), isEmpty);
    });
  });

  group('expense import validation', () {
    test('rejects malformed JSON', () async {
      final file = File('${Directory.systemTemp.path}/invalid_expenses.json');
      await file.writeAsString('{"not_expenses": []}');

      expect(
        await ExpenseTransferService.instance.importExpenses(file),
        isFalse,
      );
      await file.delete();
    });

    test('rejects an empty expense list', () async {
      final file = File('${Directory.systemTemp.path}/empty_expenses.json');
      await file.writeAsString('{"expenses": []}');

      expect(
        await ExpenseTransferService.instance.importExpenses(file),
        isFalse,
      );
      await file.delete();
    });
  });
}
