import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/domain/services/transaction_service.dart';
import 'package:money_mingle/ui/pages/home/home_screen.dart';
import 'package:money_mingle/ui/pages/profile/profile_screen.dart';
import 'package:money_mingle/ui/pages/settings/settings_screen.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_form.dart';
import 'package:money_mingle/ui/pages/transaction/transactions_view_screen.dart';
import 'budget/budget_form.dart';
import 'budget/goals_form.dart';
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final TransactionService transactionService = TransactionService();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Carga inicial de transacciones
    transactionService.loadTransactions().then((_) {
      setState(() {});
    });
  }

  Future<void> _openForm(BuildContext context, TransactionType type) async {
    final tx = await Navigator.push<Transaction?>(
      context,
      MaterialPageRoute(builder: (_) => TransactionForm(type: type)),
    );
    if (tx != null) {
      await transactionService.addTransaction(tx);
      setState(() {});
    }
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
                _openForm(context, TransactionType.expense);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.add_circle, color: AppTheme.incomeColor),
              title: const Text('Agregar Ingreso'),
              onTap: () {
                Navigator.pop(context);
                _openForm(context, TransactionType.income);
              },
            ),
            // Presupuesto Mensual
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Presupuesto Mensual'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BudgetForm(),
                  ),
                );
              },
            ),

            // Meta de Ahorro
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Meta de Ahorro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GoalsForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        transactionService: transactionService,
      ),
      TransactionsViewScreen(
        transactions: transactionService.getAllTransactions(),
        save:         transactionService.saveTransactions,
      ),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Transacciones'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
