import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/pages/transaction/transactions_screen.dart';

class AppDrawer extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final List<Transaction> transactions;

  const AppDrawer({
    Key? key,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'MoneyMingle Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          // Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a la pantalla de Dashboard
            },
          ),

          // Transacciones
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Transacciones'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingresos:  \$${totalIncome.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  'Gastos:    \$${totalExpense.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionsScreen(
                    transactions: transactions,
                  ),
                ),
              );
            },
          ),

          // Perfil
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a la pantalla de Perfil
            },
          ),

          // Ajustes
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a la pantalla de Ajustes
            },
          ),
        ],
      ),
    );
  }
}
