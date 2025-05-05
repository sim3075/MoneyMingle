import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_form.dart';
import 'package:money_mingle/ui/pages/transaction/widgets/date_filter_selector.dart';

class TransactionsController extends ChangeNotifier {
  final List<Transaction> transactions;
  final Future<void> Function() save;

  TransactionsController({
    required this.transactions,
    required this.save,
  });

  DateFilter _dateFilter   = DateFilter.day;
  DateTime   _selectedDate = DateTime.now();
  String?    _selectedCategory;

  DateFilter get dateFilter       => _dateFilter;
  DateTime   get selectedDate     => _selectedDate;
  String?    get selectedCategory => _selectedCategory;

  set dateFilter(DateFilter f) {
    _dateFilter = f;
    notifyListeners();
  }

  set selectedDate(DateTime d) {
    _selectedDate = d;
    notifyListeners();
  }

  set selectedCategory(String? c) {
    _selectedCategory = c;
    notifyListeners();
  }
  List<String> get expenseCategories => const [
        'Alimentación',
        'Transporte',
        'Vivienda',
        'Servicios',
        'Salud',
        'Ocio',
        'Compras',
        'Imprevistos',
      ];

  List<String> get incomeCategories => const [
        'Sueldo',
        'Freelance',
        'Inversiones',
        'Regalos',
        'Otros',
      ];

  List<Transaction> get filtered {
    return transactions.where((tx) {
      final d = tx.date;
      bool byDate;
      switch (_dateFilter) {
        case DateFilter.day:
          byDate = d.year == _selectedDate.year &&
              d.month == _selectedDate.month &&
              d.day == _selectedDate.day;
          break;
        case DateFilter.week:
          final start =
              _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
          final end = start.add(const Duration(days: 6));
          byDate = (d.isAtSameMomentAs(start) || d.isAfter(start)) &&
              (d.isAtSameMomentAs(end) || d.isBefore(end));
          break;
        case DateFilter.month:
          byDate =
              d.year == _selectedDate.year && d.month == _selectedDate.month;
          break;
        case DateFilter.year:
          byDate = d.year == _selectedDate.year;
          break;
      }
      final byCategory =
          _selectedCategory == null || tx.category == _selectedCategory;
      return byDate && byCategory;
    }).toList();
  }


  Future<void> loadTransactions() async {
    notifyListeners();
  }


  Future<void> openForm(BuildContext ctx, TransactionType type) async {
    final tx = await Navigator.push<Transaction?>(
      ctx,
      MaterialPageRoute(builder: (_) => TransactionForm(type: type)),
    );
    if (tx != null) {
      transactions.add(tx);
      await save();
      notifyListeners();
    }
  }

  Future<void> edit(BuildContext ctx, Transaction tx) async {
    final updated = await Navigator.push<Transaction?>(
      ctx,
      MaterialPageRoute(
        builder: (_) => TransactionForm(type: tx.type, initial: tx),
      ),
    );
    if (updated != null) {
      final idx = transactions.indexOf(tx);
      transactions[idx] = updated;
      await save();
      notifyListeners();
    }
  }

  Future<void> delete(BuildContext ctx, Transaction tx) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text('¿Seguro que deseas eliminarla?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirm == true) {
      transactions.remove(tx);
      await save();
      notifyListeners();
    }
  }
}
