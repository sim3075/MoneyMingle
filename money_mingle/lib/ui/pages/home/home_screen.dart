import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/providers/transaction_providers.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
import 'widgets/goals_card.dart';
import 'widgets/graphs/expense_line_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionService = ref.watch(transactionServiceProvider);

    final net = transactionService.totalIncome - transactionService.totalExpense;
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
            Text(
              '\$${net.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ExpenseLineChart(expenses: expensesByDay),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoCard(
                  title: 'Ingresos',
                  value: '\$${transactionService.totalIncome.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
                InfoCard(
                  title: 'Gastos',
                  value: '\$${transactionService.totalExpense.toStringAsFixed(2)}',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            RecentTransactions(
              transactions: transactionService.getAllTransactions(),
            ),
            const SizedBox(height: 8),
            MonthlySummary(
              transactions: transactionService.getAllTransactions(),
            ),
            const SizedBox(height: 8),
            GoalsCard(
              transactions: transactionService.getAllTransactions(),
            ),
          ],
        ),
      ),
    );
  }
}
