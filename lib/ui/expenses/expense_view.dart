import 'dart:io';

import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/services/expense_transfer_service.dart';
import 'package:bill_printer/ui/expenses/expense_analytics.dart';
import 'package:bill_printer/ui/expenses/providers/expense_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

enum _DateRangeSelection {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  lastMonth,
  custom,
}

class ExpenseView extends ConsumerStatefulWidget {
  const ExpenseView({super.key});

  @override
  ConsumerState<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends ConsumerState<ExpenseView> {
  DateTimeRange range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 29)),
    end: DateTime.now(),
  );

  final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
  final dateFormat = DateFormat('dd MMM yyyy');
  bool showItemwise = false;
  _DateRangeSelection selectedRangeSelection = _DateRangeSelection.custom;

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseListProvider);
    final visible = expensesInRange(expenses, range);
    final total = visible.fold<int>(0, (sum, expense) => sum + expense.amount);
    final categories = expenseCategoryTotals(visible);
    final items = expenseItemTotals(visible);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          // IconButton(
          //   tooltip: 'Export expenses',
          //   onPressed: _exportExpenses,
          //   icon: const Icon(Icons.upload_outlined),
          // ),
          // IconButton(
          //   tooltip: 'Import expenses',
          //   onPressed: _importExpenses,
          //   icon: const Icon(Icons.download_outlined),
          // ),
          IconButton(
            tooltip: 'Choose date range',
            onPressed: _chooseRange,
            icon: const Icon(Icons.date_range_outlined),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // IconButton(
          //   tooltip: 'Export expenses',
          //   onPressed: _exportExpenses,
          //   icon: const Icon(Icons.upload_outlined),
          // ),
          // IconButton(
          //   tooltip: 'Import expenses',
          //   onPressed: _importExpenses,
          //   icon: const Icon(Icons.download_outlined),
          // ),
          TextButton.icon(
            label: Text("Export"),
            onPressed: () {
              _exportExpenses();
            },
            icon: const Icon(Icons.upload),
          ),
          TextButton.icon(
            label: Text("Import"),
            onPressed: () {
              _importExpenses();
            },
            icon: const Icon(Icons.download),
          ),
          FloatingActionButton.extended(
            onPressed: () => _showExpenseEditor(),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(expenseListProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Text(
              '${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _buildSummary(total, visible.length),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('By category')),
                ButtonSegment(value: true, label: Text('By item')),
              ],
              selected: {showItemwise},
              onSelectionChanged: (selection) {
                setState(() => showItemwise = selection.first);
              },
            ),
            const SizedBox(height: 10),
            showItemwise
                ? _buildItemwiseCard(items, total)
                : _buildCategoryCard(categories, total),
            const SizedBox(height: 16),
            _buildTrendCard(visible),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${visible.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (visible.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No expenses in this period')),
                ),
              )
            else
              ...visible.map(_buildExpenseTile),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(int total, int count) {
    final average = count == 0 ? 0 : (total / count).round();
    return Row(
      children: [
        Expanded(
          child: _metric('Total spend', currency.format(total), Colors.teal),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _metric('Average', currency.format(average), Colors.orange),
        ),
        const SizedBox(width: 8),
        Expanded(child: _metric('Entries', '$count', Colors.blue)),
      ],
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, int> categories, int total) {
    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where money goes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (sorted.isEmpty)
              const Text('Add expenses to see category concentration.')
            else
              ...sorted.take(5).map((entry) {
                final share = total == 0 ? 0.0 : entry.value / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Text(
                            '${currency.format(entry.value)}  ${(share * 100).round()}%',
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(value: share, minHeight: 6),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemwiseCard(Map<String, ExpenseBreakdown> items, int total) {
    final sorted = items.entries.toList()
      ..sort((a, b) => b.value.amount.compareTo(a.value.amount));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item-wise spend',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (sorted.isEmpty)
              const Text('Add expenses to see item-level spending.')
            else
              ...sorted.take(10).map((entry) {
                final share = total == 0 ? 0.0 : entry.value.amount / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${currency.format(entry.value.amount)}  ${(share * 100).round()}%',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: share,
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.value.count} ${entry.value.count == 1 ? 'entry' : 'entries'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(List<Expense> expenses) {
    final days = range.end.difference(range.start).inDays + 1;
    final totals = List<double>.filled(days, 0);
    for (final expense in expenses) {
      final index =
          DateTime(
                expense.spentAt.year,
                expense.spentAt.month,
                expense.spentAt.day,
              )
              .difference(
                DateTime(range.start.year, range.start.month, range.start.day),
              )
              .inDays;
      if (index >= 0 && index < totals.length) totals[index] += expense.amount;
    }
    final maxY = totals.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily trend',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 170,
              child: BarChart(
                BarChartData(
                  maxY: maxY == 0 ? 100 : maxY * 1.2,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 ||
                              index >= days ||
                              index % ((days / 5).ceil()) != 0) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            DateFormat(
                              'd MMM',
                            ).format(range.start.add(Duration(days: index))),
                            style: const TextStyle(fontSize: 9),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var index = 0; index < totals.length; index++)
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: totals[index],
                            width: days > 20 ? 8 : 18,
                            color: Colors.teal,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTile(Expense expense) {
    final details = [
      '${expense.category}  •  ${dateFormat.format(expense.spentAt)}',
      if (expense.paymentReference?.isNotEmpty == true)
        'Payment ref: ${expense.paymentReference}',
      if (expense.notes?.isNotEmpty == true) expense.notes!,
    ].join('\n');
    return Card(
      child: ListTile(
        // leading: CircleAvatar(
        //   child: Text(expense.category.substring(0, 1).toUpperCase()),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title),
            Text(
              currency.format(expense.amount),
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        subtitle: Text(details),
        isThreeLine:
            expense.notes?.isNotEmpty == true ||
            expense.paymentReference?.isNotEmpty == true,
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            if (action == 'edit') _showExpenseEditor(expense);
            if (action == 'delete') _deleteExpense(expense);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseRange() async {
    final selection = await showModalBottomSheet<_DateRangeSelection>(
      context: context,
      builder: (context) {
        var selected = selectedRangeSelection;
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Date range'),
                    trailing: IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  RadioGroup<_DateRangeSelection>(
                    groupValue: selected,
                    onChanged: (value) =>
                        setSheetState(() => selected = value!),
                    child: Column(
                      children: [
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('Today'),
                          value: _DateRangeSelection.today,
                        ),
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('Yesterday'),
                          value: _DateRangeSelection.yesterday,
                        ),
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('This week'),
                          value: _DateRangeSelection.thisWeek,
                        ),
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('This month'),
                          value: _DateRangeSelection.thisMonth,
                        ),
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('Last month'),
                          value: _DateRangeSelection.lastMonth,
                        ),
                        RadioListTile<_DateRangeSelection>(
                          title: const Text('Custom'),
                          value: _DateRangeSelection.custom,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || selection == null) return;
    setState(() => selectedRangeSelection = selection);
    if (selection == _DateRangeSelection.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDateRange: range,
      );
      if (picked != null && mounted) setState(() => range = picked);
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedRange = switch (selection) {
      _DateRangeSelection.today => DateTimeRange(start: today, end: now),
      _DateRangeSelection.yesterday => DateTimeRange(
        start: today.subtract(const Duration(days: 1)),
        end: today.subtract(const Duration(milliseconds: 1)),
      ),
      _DateRangeSelection.thisWeek => DateTimeRange(
        start: today.subtract(Duration(days: today.weekday - 1)),
        end: now,
      ),
      _DateRangeSelection.thisMonth => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: now,
      ),
      _DateRangeSelection.lastMonth => DateTimeRange(
        start: DateTime(today.year, today.month - 1),
        end: DateTime(
          today.year,
          today.month,
          1,
        ).subtract(const Duration(milliseconds: 1)),
      ),
      _DateRangeSelection.custom => range,
    };
    setState(() => range = selectedRange);
  }

  Future<void> _exportExpenses() async {
    try {
      final file = await ExpenseTransferService.instance.exportExpenses();
      final result = await FileManager().shareFile(file);
      if (!mounted || result == null) return;
      UIUtils.showSnackBar(
        context: context,
        text: result.status == ShareResultStatus.success
            ? 'Expenses exported successfully'
            : 'Expense export was cancelled',
      );
    } catch (_) {
      if (!mounted) return;
      UIUtils.showSnackBar(
        context: context,
        text: 'Could not export expenses',
        bgColor: AppColors.red,
      );
    }
  }

  Future<void> _importExpenses() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (!mounted ||
        result == null ||
        result.files.isEmpty ||
        result.files.first.path == null) {
      return;
    }

    final imported = await ExpenseTransferService.instance.importExpenses(
      File(result.files.first.path!),
    );
    if (!mounted) return;
    if (imported) {
      await ref.read(expenseListProvider.notifier).load();
    }
    if (!mounted) return;
    UIUtils.showSnackBar(
      context: context,
      text: imported
          ? 'Expenses imported successfully'
          : 'Could not import expenses',
      bgColor: imported ? null : AppColors.red,
    );
  }

  Future<void> _deleteExpense(Expense expense) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('Remove "${expense.title}" from your records?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await ref.read(expenseListProvider.notifier).remove(expense.id);
    }
  }

  Future<void> _showExpenseEditor([Expense? expense]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ExpenseEditorSheet(
        expense: expense,
        onSave:
            (title, category, amount, spentAt, notes, paymentReference) async {
              final notifier = ref.read(expenseListProvider.notifier);
              if (expense == null) {
                await notifier.add(
                  title: title,
                  category: category,
                  amount: amount,
                  spentAt: spentAt,
                  notes: notes,
                  paymentReference: paymentReference,
                );
              } else {
                await notifier.edit(
                  id: expense.id,
                  title: title,
                  category: category,
                  amount: amount,
                  spentAt: spentAt,
                  notes: notes,
                  paymentReference: paymentReference,
                );
              }
            },
      ),
    );
  }
}

class _ExpenseEditorSheet extends StatefulWidget {
  const _ExpenseEditorSheet({required this.expense, required this.onSave});

  final Expense? expense;
  final Future<void> Function(
    String title,
    String category,
    int amount,
    DateTime spentAt,
    String? notes,
    String? paymentReference,
  )
  onSave;

  @override
  State<_ExpenseEditorSheet> createState() => _ExpenseEditorSheetState();
}

class _ExpenseEditorSheetState extends State<_ExpenseEditorSheet> {
  late final TextEditingController titleController;
  late final TextEditingController categoryController;
  late final TextEditingController amountController;
  late final TextEditingController notesController;
  late final TextEditingController paymentReferenceController;
  late DateTime spentAt;
  final formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd MMM yyyy');
  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense?.title);
    categoryController = TextEditingController(text: widget.expense?.category);
    amountController = TextEditingController(
      text: widget.expense == null ? '' : widget.expense!.amount.toString(),
    );
    notesController = TextEditingController(text: widget.expense?.notes);
    paymentReferenceController = TextEditingController(
      text: widget.expense?.paymentReference,
    );
    spentAt = widget.expense?.spentAt ?? DateTime.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    amountController.dispose();
    notesController.dispose();
    paymentReferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.expense == null ? 'Add expense' : 'Edit expense',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                textCapitalization: TextCapitalization.words,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Expense Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  return value.trim().length > 120
                      ? 'Maximum 120 characters'
                      : null;
                },
              ),
              TextFormField(
                controller: categoryController,
                textCapitalization: TextCapitalization.words,
                maxLength: 60,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  return value.trim().length > 60
                      ? 'Maximum 60 characters'
                      : null;
                },
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  final amount = int.tryParse(value ?? '');
                  return amount == null || amount <= 0
                      ? 'Enter a positive amount'
                      : null;
                },
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
              ),
              TextFormField(
                controller: paymentReferenceController,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'Payment reference (optional)',
                ),
                validator: (value) => value != null && value.length > 120
                    ? 'Maximum 120 characters'
                    : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Spent Date'),
                subtitle: Text(dateFormat.format(spentAt)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: spentAt,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => spentAt = picked);
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: saving ? null : _save,
                icon: const Icon(Icons.check),
                label: Text(
                  saving
                      ? 'Saving...'
                      : widget.expense == null
                      ? 'Save expense'
                      : 'Save changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    await widget.onSave(
      titleController.text.trim(),
      categoryController.text.trim(),
      int.parse(amountController.text),
      spentAt,
      notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      paymentReferenceController.text.trim().isEmpty
          ? null
          : paymentReferenceController.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }
}
