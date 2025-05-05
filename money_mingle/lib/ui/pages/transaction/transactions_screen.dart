import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_mingle/models/transaction.dart';
import '../budget/budget_form.dart';
import '../budget/goals_form.dart';
import '../transaction/transaction_controller.dart';
import 'widgets/add_options_sheet.dart';
import 'widgets/date_filter_selector.dart';
import 'widgets/category_filter_selector.dart';
import 'widgets/transaction_list.dart';

class TransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Future<void> Function() save;

  const TransactionsScreen({
    Key? key,
    required this.transactions,
    required this.save,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionsController>(
      create: (_) => TransactionsController(
        transactions: transactions,
        save: save,
      ),
      child: Consumer<TransactionsController>(
        builder: (ctx, ctrl, _) => Scaffold(
          appBar: AppBar(title: const Text('Transacciones')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateFilterSelector(
                  filter:         ctrl.dateFilter,
                  selectedDate:   ctrl.selectedDate,
                  onFilterChanged:(f) => ctrl.dateFilter = f,
                  onDateChanged:  (d) => ctrl.selectedDate = d,
                ),
                const SizedBox(height: 16),
                CategoryFilterSelector(
                  selected:   ctrl.selectedCategory,
                  categories: [
                    ...ctrl.expenseCategories,
                    ...ctrl.incomeCategories,
                  ],
                  onChanged:  (c) => ctrl.selectedCategory = c,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TransactionsList(
                    items:   ctrl.filtered,
                    onEdit:  (tx) => ctrl.edit(ctx, tx),
                    onDelete:(tx) => ctrl.delete(ctx, tx),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => AddOptionsSheet(
                onAddTransaction: (type) => ctrl.openForm(ctx, type),
                onAddBudget:      ()     => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetForm()),
                ),
                onAddGoal:        ()     => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoalsForm()),
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
