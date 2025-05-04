import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/models/transaction.dart';
import '../transaction/transaction_form.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
import '../../widgets/shared/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString('transactions');
    if (raw != null) {
      setState(() => _transactions = Transaction.listFromJson(raw));
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'transactions',
      Transaction.listToJson(_transactions),
    );
  }

  double get _totalIncome  => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get _totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  Future<void> _openForm(BuildContext ctx, TransactionType type) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      ctx,
      MaterialPageRoute(builder: (_) => TransactionForm(type: type)),
    );
    if (result != null) {
      setState(() {
        _transactions.add(Transaction(
          type:        type,
          title:       result['title'],
          amount:      result['amount'],
          date:        result['date'] ?? DateTime.now(),
          category:    result['category'],
          note:        result['note'],
          receiptPath: result['receiptPath'],
        ));
      });
      await _saveTransactions();
    }
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.remove_circle,
                color: AppTheme.expenseColor),
            title: const Text('Agregar Gasto'),
            onTap: () {
              Navigator.pop(context);
              _openForm(context, TransactionType.expense);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle,
                color: AppTheme.incomeColor),
            title: const Text('Agregar Ingreso'),
            onTap: () {
              Navigator.pop(context);
              _openForm(context, TransactionType.income);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final net = _totalIncome - _totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('April 2024')),
      drawer: AppDrawer(
        totalIncome:  _totalIncome,
        totalExpense: _totalExpense,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('\$${net.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InfoCard(
                title: 'Ingresos',
                value: '\$${_totalIncome.toStringAsFixed(2)}',
                color: AppTheme.incomeColor),
            InfoCard(
                title: 'Gastos',
                value: '\$${_totalExpense.toStringAsFixed(2)}',
                color: AppTheme.expenseColor),
          ]),
          const SizedBox(height: 16),
          RecentTransactions(transactions: _transactions),
          const SizedBox(height: 8),
          MonthlySummary(transactions: _transactions),
        ]),
      ),
    );
  }
}
