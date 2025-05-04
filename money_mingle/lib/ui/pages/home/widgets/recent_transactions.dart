import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mingle/models/transaction.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final int maxItems;

  const RecentTransactions({
    Key? key,
    required this.transactions,
    this.maxItems = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = transactions.reversed.take(maxItems).toList();

    if (recent.isEmpty) {
      return Center(
        child: Text(
          'No hay transacciones recientes',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transacciones recientes',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recent.length,
          itemBuilder: (context, i) {
            final tx = recent[i];
            final isExpense = tx.type == TransactionType.expense;
            final color = isExpense ? Colors.red : Colors.green;
            final sign = isExpense ? '-' : '+';
            final dateLabel = DateFormat('dd/MM/yyyy').format(tx.date);

            return ListTile(
              leading: Icon(
                isExpense ? Icons.shopping_cart : Icons.attach_money,
                color: color,
              ),
              title: Text(tx.title),
              subtitle: Text(dateLabel),
              trailing: Text(
                '$sign \$${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(color: color),
              ),
            );
          },
        ),
      ],
    );
  }
}
