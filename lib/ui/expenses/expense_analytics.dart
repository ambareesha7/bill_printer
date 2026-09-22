import 'package:bill_printer/data/database.dart';
import 'package:flutter/material.dart';

class ExpenseBreakdown {
  const ExpenseBreakdown({required this.amount, required this.count});

  final int amount;
  final int count;
}

Map<String, int> expenseCategoryTotals(List<Expense> expenses) {
  final totals = <String, int>{};
  for (final expense in expenses) {
    totals.update(
      expense.category,
      (value) => value + expense.amount,
      ifAbsent: () => expense.amount,
    );
  }
  return totals;
}

Map<String, ExpenseBreakdown> expenseItemTotals(List<Expense> expenses) {
  final totals = <String, ExpenseBreakdown>{};
  for (final expense in expenses) {
    final current = totals[expense.title];
    totals[expense.title] = ExpenseBreakdown(
      amount: (current?.amount ?? 0) + expense.amount,
      count: (current?.count ?? 0) + 1,
    );
  }
  return totals;
}

List<Expense> expensesInRange(List<Expense> expenses, DateTimeRange range) {
  final start = DateTime(range.start.year, range.start.month, range.start.day);
  final end = DateTime(
    range.end.year,
    range.end.month,
    range.end.day,
    23,
    59,
    59,
  );
  return expenses
      .where(
        (expense) =>
            !expense.spentAt.isBefore(start) && !expense.spentAt.isAfter(end),
      )
      .toList();
}
