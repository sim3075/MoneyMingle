import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/models/transaction.dart';

typedef OnAddTransaction = void Function(TransactionType type);
typedef OnAddBudget      = void Function();
typedef OnAddGoal        = void Function();

class AddOptionsSheet extends StatelessWidget {
  final OnAddTransaction onAddTransaction;
  final OnAddBudget      onAddBudget;
  final OnAddGoal        onAddGoal;

  const AddOptionsSheet({
    Key? key,
    required this.onAddTransaction,
    required this.onAddBudget,
    required this.onAddGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.remove_circle, color: AppTheme.expenseColor),
          title: const Text('Agregar Gasto'),
          onTap: () {
            Navigator.pop(context);
            onAddTransaction(TransactionType.expense);
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle, color: AppTheme.incomeColor),
          title: const Text('Agregar Ingreso'),
          onTap: () {
            Navigator.pop(context);
            onAddTransaction(TransactionType.income);
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text('Presupuesto Mensual'),
          onTap: () {
            Navigator.pop(context);
            onAddBudget();
          },
        ),
        ListTile(
          leading: const Icon(Icons.flag),
          title: const Text('Meta de Ahorro'),
          onTap: () {
            Navigator.pop(context);
            onAddGoal();
          },
        ),
        ListTile(
          leading: const Icon(Icons.cancel, color: Colors.red),
          title: const Text('Cancelar'),
          onTap: () => Navigator.pop(context),
        ),
      ]),
    );
  }
}
