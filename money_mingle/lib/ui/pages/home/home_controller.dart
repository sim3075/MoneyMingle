import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> openForm(BuildContext context, TransactionType type) async {
    final tx = await Navigator.push<Transaction?>(
      context,
      MaterialPageRoute(builder: (_) => TransactionForm(type: type)),
    );
    if (tx != null) {
      await addTransaction(tx);
    }
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('transactions');
    if (raw != null) {
      _transactions = Transaction.listFromJson(raw);
      notifyListeners();
    }
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'transactions',
      Transaction.listToJson(_transactions),
    );
  }

  Future<void> addTransaction(Transaction tx) async {
    _transactions.add(tx);
    await saveTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(Transaction tx) async {
    _transactions.remove(tx);
    await saveTransactions();
    notifyListeners();
  }
}
