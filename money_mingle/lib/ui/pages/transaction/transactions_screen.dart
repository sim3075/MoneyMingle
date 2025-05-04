import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'widgets/date_filter_selector.dart';
import 'widgets/category_filter_selector.dart';
import 'widgets/transaction_list.dart';
import '../transaction/transaction_form.dart';
import '../budget/budget_form.dart';
import '../budget/goals_form.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final Future<void> Function() save;

  const TransactionsScreen({
    Key? key,
    required this.transactions,
    required this.save,
  }) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateFilter _dateFilter    = DateFilter.day;
  DateTime   _selectedDate  = DateTime.now();
  String?    _selectedCategory;

  final _expenseCats = [
    'Alimentación','Transporte','Vivienda',
    'Servicios','Salud','Ocio','Compras','Imprevistos'
  ];
  final _incomeCats  = ['Sueldo','Freelance','Inversiones','Regalos','Otros'];

  List<Transaction> get _filtered {
    return widget.transactions.where((tx) {
      final d = tx.date;
      bool byDate;
      switch (_dateFilter) {
        case DateFilter.day:
          byDate = d.year == _selectedDate.year
              && d.month == _selectedDate.month
              && d.day == _selectedDate.day;
          break;
        case DateFilter.week:
          final start = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
          final end   = start.add(const Duration(days: 6));
          byDate = (d.isAtSameMomentAs(start) || d.isAfter(start))
                && (d.isAtSameMomentAs(end)   || d.isBefore(end));
          break;
        case DateFilter.month:
          byDate = d.year == _selectedDate.year
              && d.month == _selectedDate.month;
          break;
        case DateFilter.year:
          byDate = d.year == _selectedDate.year;
          break;
      }
      final byCategory = _selectedCategory == null
          ? true
          : tx.category == _selectedCategory;
      return byDate && byCategory;
    }).toList();
  }

  List<String> get _allCategories => [
    ..._expenseCats,
    ..._incomeCats,
  ];

  Future<void> _showAddOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Presupuesto mensual'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Meta de ahorro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoalsForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle, color: Colors.red),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTransaction(Transaction tx) async {
    final updated = await Navigator.push<Transaction?>(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionForm(type: tx.type, initial: tx),
      ),
    );
    if (updated != null) {
      final idx = widget.transactions.indexOf(tx);
      setState(() => widget.transactions[idx] = updated);
      await widget.save();
    }
  }

  Future<void> _deleteTransaction(Transaction tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text('¿Seguro que deseas eliminar esta transacción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => widget.transactions.remove(tx));
      await widget.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateFilterSelector(
              filter: _dateFilter,
              selectedDate: _selectedDate,
              onFilterChanged: (f) => setState(() => _dateFilter = f),
              onDateChanged:   (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 16),
            CategoryFilterSelector(
              selected:   _selectedCategory,
              categories: _allCategories,
              onChanged:  (c) => setState(() => _selectedCategory = c),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TransactionsList(
                items:   _filtered,
                onEdit:  _editTransaction,
                onDelete:_deleteTransaction,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }
}
