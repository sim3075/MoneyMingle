import 'package:flutter/material.dart';
//import 'package:money_mingle/app_theme.dart';
//import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/domain/services/transaction_service.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
//import 'widgets/goals_card.dart';
import 'widgets/graphs/expense_line_chart.dart';

class HomeScreen extends StatelessWidget {
  final TransactionService transactionService;

  const HomeScreen({super.key, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    final expensesByDay = transactionService.getExpensesByDay();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mayo 2025'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseLineChart(expenses: expensesByDay),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoCard(
                  title: 'Income',
                  value: '\$${transactionService.totalIncome.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
                InfoCard(
                  title: 'Expenses',
                  value: '\$${transactionService.totalExpense.toStringAsFixed(2)}',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            RecentTransactions(transactions: transactionService.getAllTransactions()),
            const SizedBox(height: 8),
            MonthlySummary(transactions: transactionService.getAllTransactions()),
          ],
        ),
      ),
    );
  }
}