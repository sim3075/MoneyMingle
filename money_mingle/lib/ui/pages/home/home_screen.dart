import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Datos quemados
    final double income = 3000;
    final double expenses = 1800;
    final double balance = income - expenses;
    final List<Map<String, String>> transactions = [
      {"name": "Groceries", "date": "Today", "amount": "-\$50"},
      {"name": "Salary", "date": "Yesterday", "amount": "+\$2000"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\$${balance.toStringAsFixed(0)}",
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard("Income", income, Colors.green),
                _buildSummaryCard("Expenses", expenses, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            Text("Recent Transactions",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),

            const SizedBox(height: 12),

            ...transactions.map((tx) => ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(tx["name"]!),
                  subtitle: Text(tx["date"]!),
                  trailing: Text(
                    tx["amount"]!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: tx["amount"]!.contains("-") ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: Impementar funcionalidad de agragar gasto
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String label, double amount, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
