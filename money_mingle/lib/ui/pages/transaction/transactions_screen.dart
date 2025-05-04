import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/home/widgets/recent_transactions.dart';

class TransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  const TransactionsScreen({ Key? key, required this.transactions })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RecentTransactions(
          transactions: transactions,
          maxItems: transactions.length, // para mostrar todas
        ),
      ),
    );
  }
}
