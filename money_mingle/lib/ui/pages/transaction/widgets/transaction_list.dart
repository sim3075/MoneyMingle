import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mingle/models/transaction.dart';

// lib/ui/pages/transactions/widgets/transactions_list.dart
class TransactionsList extends StatelessWidget {
  final List<Transaction> items;
  final void Function(Transaction) onEdit;
  final void Function(Transaction) onDelete;

  const TransactionsList({
    Key? key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text('No hay transacciones'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_,__) => const Divider(),
      itemBuilder: (ctx, i) {
        final tx = items[i];
        final isExpense = tx.type == TransactionType.expense;
        final color     = isExpense ? Colors.red : Colors.green;
        final sign      = isExpense ? '-' : '+';
        final dateLabel = DateFormat('dd/MM/yyyy').format(tx.date);
        return ListTile(
          leading: Icon(
            isExpense ? Icons.remove_shopping_cart : Icons.attach_money,
            color: color,
          ),
          title: Text(tx.title),
          subtitle: Text(dateLabel),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$sign \$${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(color: color),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(tx),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(tx),
              ),
            ],
          ),
        );
      },
    );
  }
}
