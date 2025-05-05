import 'package:money_mingle/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  List<Transaction> getAllTransactions() {
    return _transactions;
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('transactions');
    if (raw != null) {
      _transactions = Transaction.listFromJson(raw);
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
  }

  Future<void> deleteTransaction(Transaction tx) async {
    _transactions.remove(tx);
    await saveTransactions();
  }

  /// Obtiene los gastos agrupados por día del mes
  List<double> getExpensesByDay() {
    // Inicializa una lista de 30 días con valores en 0
    final List<double> expensesByDay = List.generate(30, (_) => 0.0);

    for (final transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        final day = transaction.date.day; // Obtiene el día del mes
        expensesByDay[day - 1] += transaction.amount; // Suma el gasto al día correspondiente
      }
    }

    return expensesByDay;
  }
}