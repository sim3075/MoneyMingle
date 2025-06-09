import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_mingle/domain/services/user_service.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:money_mingle/ui/pages/transaction/widgets/date_field.dart';

class BudgetForm extends StatefulWidget {
  const BudgetForm({Key? key}) : super(key: key);

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  DateTime? _selectedDate;
  final _amountController = TextEditingController();
  final _userService = UserService();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    final raw = _amountController.text.trim();
    if (_selectedDate == null || raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y monto')),
      );
      return;
    }
    final amount = double.tryParse(raw);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monto inválido')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }

    await _userService.updateUserField(uid, 'monthlyBudget', amount);
    await _userService.updateUserField(
        uid, 'budgetDate', _selectedDate!.toIso8601String());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Presupuesto guardado correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presupuesto Mensual')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DateField(
              selectedDate: _selectedDate,
              onDateChanged: (d) => setState(() => _selectedDate = d),
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _amountController,
              label: 'Monto del presupuesto',
              icon: Icons.attach_money,
             
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Guardar Presupuesto',
              onPressed: _saveBudget,
            ),
          ],
        ),
      ),
    );
  }
}
