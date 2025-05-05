import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import '../transaction/transaction_controller.dart';
import 'widgets/date_filter_selector.dart';
import 'widgets/category_filter_selector.dart';
import 'widgets/transaction_list.dart';

class TransactionsViewScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Future<void> Function() save;

  const TransactionsViewScreen({
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
      )..loadTransactions(),
      child: Consumer<TransactionsController>(
        builder: (ctx, ctrl, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Transacciones'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    items:    ctrl.filtered,
                    onEdit:   (tx) => ctrl.edit(ctx, tx),
                    onDelete: (tx) => ctrl.delete(ctx, tx),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Exportar PDF Transacciones',
                  onPressed: () {
                    // TODO: implementar la acción de exportar PDF
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
