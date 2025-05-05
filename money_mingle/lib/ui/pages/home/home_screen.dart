import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/home/home_controller.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
import 'widgets/goals_card.dart';
import '../../widgets/shared/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController()
      ..addListener(() => setState(() {}))
      ..loadTransactions();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.remove_circle, color: AppTheme.expenseColor),
              title: const Text('Agregar Gasto'),
              onTap: () {
                Navigator.pop(context);
                controller.openForm(context, TransactionType.expense);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.add_circle, color: AppTheme.incomeColor),
              title: const Text('Agregar Ingreso'),
              onTap: () {
                Navigator.pop(context);
                controller.openForm(context, TransactionType.income);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final net = controller.totalIncome - controller.totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Abril 2024')),
      drawer: AppDrawer(
        totalIncome:           controller.totalIncome,
        totalExpense:          controller.totalExpense,
        transactions:          controller.transactions,
        save:                  controller.saveTransactions,
        onTransactionsChanged: controller.loadTransactions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoCard(
                  title: 'Ingresos',
                  value: '\$${controller.totalIncome.toStringAsFixed(2)}',
                  color: AppTheme.incomeColor,
                ),
                InfoCard(
                  title: 'Gastos',
                  value: '\$${controller.totalExpense.toStringAsFixed(2)}',
                  color: AppTheme.expenseColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            RecentTransactions(transactions: controller.transactions),
            const SizedBox(height: 8),
            MonthlySummary(transactions: controller.transactions),
            const SizedBox(height: 8),
            GoalsCard(transactions: controller.transactions),
          ],
        ),
      ),
    );
  }
}