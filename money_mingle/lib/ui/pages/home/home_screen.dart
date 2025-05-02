import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
import '../../widgets/shared/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('April 2024'),
      ),
      drawer: const AppDrawer(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '\$1200',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                InfoCard(title: 'Income', value: '\$3000', color: AppTheme.incomeColor),
                InfoCard(title: 'Expenses', value: '\$1800', color: AppTheme.expenseColor),
              ],
            ),
            const SizedBox(height: 16),
            const RecentTransactions(),
            const SizedBox(height: 8),
            const MonthlySummary(),
          ],
        ),
      ),
    );
  }
}
