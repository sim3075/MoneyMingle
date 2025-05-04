import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'widgets/date_filter_selector.dart';
import 'widgets/category_filter_selector.dart';
import 'widgets/transaction_list.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionsScreen({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateFilter _dateFilter = DateFilter.day;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  // Tus categorías fijas:
  final _expenseCats = [
    'Alimentación', 'Transporte', 'Vivienda',
    'Servicios', 'Salud', 'Ocio', 'Compras', 'Imprevistos'
  ];
  final _incomeCats = [
    'Sueldo', 'Freelance', 'Inversiones', 'Regalos', 'Otros'
  ];

  List<Transaction> get _filtered {
    return widget.transactions.where((tx) {
      final d = tx.date;
      // 1) Filtrar por fecha
      final byDate = () {
        switch (_dateFilter) {
          case DateFilter.day:
            return d.year == _selectedDate.year
                && d.month == _selectedDate.month
                && d.day == _selectedDate.day;
          case DateFilter.month:
            return d.year == _selectedDate.year
                && d.month == _selectedDate.month;
          case DateFilter.year:
            return d.year == _selectedDate.year;
        }
      }();
      // 2) Filtrar por categoría (si null, todo)
      final byCategory = _selectedCategory == null
          ? true
          : tx.category == _selectedCategory;

      return byDate && byCategory;
    }).toList();
  }

  // Combina ambas listas para el dropdown
  List<String> get _allCategories => [
    ..._expenseCats,
    ..._incomeCats,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de fecha (día / mes / año)
            DateFilterSelector(
              filter:         _dateFilter,
              selectedDate:   _selectedDate,
              onFilterChanged:(f) => setState(() => _dateFilter = f),
              onDateChanged:  (d) => setState(() => _selectedDate = d),
            ),

            const SizedBox(height: 16),

            // Selector de categoría (incluye "Todas")
            CategoryFilterSelector(
              selected:   _selectedCategory,
              categories: _allCategories,
              onChanged:  (c) => setState(() => _selectedCategory = c),
            ),

            const SizedBox(height: 24),

            // Lista filtrada
            Expanded(
              child: TransactionsList(items: _filtered),
            ),
          ],
        ),
      ),
    );
  }
}
