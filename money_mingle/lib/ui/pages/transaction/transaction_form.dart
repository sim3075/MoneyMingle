import 'package:flutter/material.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';

enum TransactionType { expense, income }

class TransactionForm extends StatefulWidget {
  final TransactionType type;
  const TransactionForm({ required this.type, Key? key }) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es requerido')),
      );
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monto inválido')),
      );
      return;
    }
    // TODO: Agregar logica de guardado de transacción
    Navigator.of(context).pop({'title': title, 'amount': amount});
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == TransactionType.expense;
    return Scaffold(
      appBar: AppBar(
        title: Text(isExpense ? 'Registrar Gasto' : 'Registrar Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: _titleController,
              label: 'Título',
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _amountController,
              label: 'Monto',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: isExpense ? 'Guardar Gasto' : 'Guardar Ingreso',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
