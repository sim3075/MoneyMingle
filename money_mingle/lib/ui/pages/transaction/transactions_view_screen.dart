import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';

class TransactionsViewScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsViewScreen({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
        automaticallyImplyLeading: false,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'No hay transacciones registradas.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction.type == TransactionType.income
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        transaction.type == TransactionType.income
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      transaction.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$${transaction.amount.toStringAsFixed(2)} - ${transaction.date}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Acción de editar (no funcional por ahora)
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Acción de eliminar (no funcional por ahora)
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}