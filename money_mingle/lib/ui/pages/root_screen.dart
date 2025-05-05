import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/ui/pages/home/home_screen.dart';
import 'package:money_mingle/ui/pages/profile/profile_screen.dart';
import 'package:money_mingle/ui/pages/stats/stats_screen.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_form.dart';
import 'package:money_mingle/ui/pages/transaction/transaction_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  void _openForm(BuildContext context, TransactionType type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TransactionForm(type: type)),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.remove_circle,
                    color: AppTheme.expenseColor,
                  ),
                  title: const Text('Agregar Gasto'),
                  onTap: () {
                    Navigator.pop(context);
                    _openForm(context, TransactionType.expense);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.add_circle,
                    color: AppTheme.incomeColor,
                  ),
                  title: const Text('Agregar Ingreso'),
                  onTap: () {
                    Navigator.pop(context);
                    _openForm(context, TransactionType.income);
                  },
                ),
              ],
            ),
          ),
    );
  }

  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TransactionScreen(),
    ProfileScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Transacciones'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuraciones'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
