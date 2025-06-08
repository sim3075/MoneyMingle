import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_controller.dart';
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

  void _showExportPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exportar PDF'),
        content: const Text('Exportar historial de transacciones a PDF.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('EXPORTAR'),
          ),
        ],
      ),
    );
  }

  void _showExportExcelDialog(BuildContext context) {
    final ctrl = Provider.of<TransactionsController>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exportar Excel'),
        content: const Text('Exportar historial de transacciones a Excel.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ctrl.exportToExcel(context);
            },
            child: const Text('EXPORTAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionsController>(
      create: (_) => TransactionsController(
        transactions: transactions,
        save: save,
      )..loadTransactions(),
      child: Consumer<TransactionsController>(
        builder: (context, ctrl, _) => Scaffold(
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
                  filter: ctrl.dateFilter,
                  selectedDate: ctrl.selectedDate,
                  onFilterChanged: (f) => ctrl.dateFilter = f,
                  onDateChanged: (d) => ctrl.selectedDate = d,
                ),
                const SizedBox(height: 16),
                CategoryFilterSelector(
                  selected: ctrl.selectedCategory,
                  categories: [
                    ...ctrl.expenseCategories,
                    ...ctrl.incomeCategories,
                  ],
                  onChanged: (c) => ctrl.selectedCategory = c,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TransactionsList(
                    items: ctrl.filtered,
                    onEdit: (tx) => ctrl.edit(context, tx),
                    onDelete: (tx) => ctrl.delete(context, tx),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Exportar PDF',
                          child: IconButton(
                            icon: const Icon(Icons.picture_as_pdf),
                            color: Colors.green.shade800,
                            onPressed: () => _showExportPdfDialog(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Tooltip(
                          message: 'Exportar Excel',
                          child: IconButton(
                            icon: const Icon(Icons.table_chart),
                            color: Colors.green.shade800,
                            onPressed: () => _showExportExcelDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
