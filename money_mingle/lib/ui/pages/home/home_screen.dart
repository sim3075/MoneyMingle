import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'widgets/info_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/monthly_summary.dart';
import 'widgets/graphs/expense_line_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo: Gastos por día del mes
    final List<double> expenses = [
      200, 400, 300, 500, 700, 600, 800, 1000, 900, 1100,
      1000, 800, 700, 600, 500, 400, 300, 200, 100, 0,
      300, 500, 700, 900, 1100, 1000, 800, 600, 400, 200,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('April 2024')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico de línea adaptado a la pantalla
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3, // 30% de la altura de la pantalla
                child: ExpenseLineChart(expenses: expenses),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  InfoCard(
                    title: 'Income',
                    value: '\$3000',
                    color: AppTheme.incomeColor,
                  ),
                  InfoCard(
                    title: 'Expenses',
                    value: '\$1800',
                    color: AppTheme.expenseColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const RecentTransactions(),
              const SizedBox(height: 8),
              const MonthlySummary(),
            ],
          ),
        ),
      ),
    );
  }
}