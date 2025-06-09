import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mingle/providers/transaction_providers.dart';
import 'package:money_mingle/providers/user_provider.dart';
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
    final userService = ref.watch(userServiceProvider);
    final net = transactionService.totalIncome - transactionService.totalExpense;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder(
      future: uid != null ? userService.getUser(uid) : Future.value(null),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final userBudget = user?.monthlyBudget ?? 0.0;
        final budgetActual = userBudget + net;

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
                // Presupuesto actual
                Card(
                  color: Colors.blue.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                    title: const Text('Presupuesto actual'),
                    trailing: Text(
                      '\$${budgetActual.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ExpenseLineChart(expenses: transactionService.getExpensesByDay()),
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
      },
    );
  }
}
