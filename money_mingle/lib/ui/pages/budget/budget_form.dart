import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
              onPressed: () {
                // TODO: guardar...
              },
            ),
          ],
        ),
      ),
    );
  }
}
