import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/providers/transaction_providers.dart';
import 'widgets/category_filter_selector.dart';
import 'widgets/date_filter_selector.dart';
import 'widgets/transaction_list.dart';
import 'package:money_mingle/ui/pages/transaction/widgets/transaction_edit_form.dart';

class TransactionsViewScreen extends ConsumerStatefulWidget {
  const TransactionsViewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionsViewScreen> createState() => _TransactionsViewScreenState();
}

class _TransactionsViewScreenState extends ConsumerState<TransactionsViewScreen> {
  bool _loading = true;

  DateTime? _selectedDate;
  String? _selectedCategory;
  DateFilter _dateFilter = DateFilter.day;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await ref.read(transactionServiceProvider).loadTransactions();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final txService = ref.watch(transactionServiceProvider);
    var transactions = txService.transactions;

    // Filtros locales
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      transactions = transactions.where((tx) => tx.category == _selectedCategory).toList();
    }
    if (_selectedDate != null) {
      transactions = transactions.where((tx) =>
        tx.date.year == _selectedDate!.year &&
        tx.date.month == _selectedDate!.month &&
        tx.date.day == _selectedDate!.day
      ).toList();
    }

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
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
              filter: _dateFilter,
              selectedDate: _selectedDate ?? DateTime.now(),
              onFilterChanged: (f) => setState(() => _dateFilter = f),
              onDateChanged:   (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 16),
            CategoryFilterSelector(
              selected:   _selectedCategory,
              categories: [
                'Alimentación','Transporte','Vivienda','Servicios','Salud',
                'Ocio','Compras','Imprevistos','Sueldo','Freelance',
                'Inversiones','Regalos','Otros',
              ],
              onChanged:  (c) => setState(() => _selectedCategory = c),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TransactionsList(
                items: transactions,
                 onEdit: (tx) async {
                  final updated = await Navigator.push<Transaction?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionEditForm(transaction: tx),
                    ),
                  );
                  if (updated != null) {
                    await ref.read(transactionServiceProvider).updateTransaction(updated);
                    setState(() {});
                  }
                },
                 onDelete: (tx) async {
                  await ref.read(transactionServiceProvider).deleteTransaction(tx);
                  setState(() {});
                },
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
                    IconButton(
                      tooltip: 'Exportar PDF',
                      icon: const Icon(Icons.picture_as_pdf),
                      color: Colors.green.shade800,
                      onPressed: () => _exportPdf(context),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      tooltip: 'Exportar Excel',
                      icon: const Icon(Icons.table_chart),
                      color: Colors.green.shade800,
                      onPressed: () => _exportExcel(context),
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

  void _exportPdf(BuildContext context) {
    final txService = ref.read(transactionServiceProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportar PDF'),
        content: const Text('¿Quieres exportar todas las transacciones a PDF?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final path = await txService.exportToPdf();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF guardado en:\n$path')),
              );
            },
            child: const Text('EXPORTAR'),
          ),
        ],
      ),
    );
  }

  void _exportExcel(BuildContext context) {
    final txService = ref.read(transactionServiceProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportar Excel'),
        content: const Text('¿Quieres exportar todas las transacciones a Excel?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final path = await txService.exportToExcel();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Excel guardado en:\n$path')),
              );
            },
            child: const Text('EXPORTAR'),
          ),
        ],
      ),
    );
  }
}
