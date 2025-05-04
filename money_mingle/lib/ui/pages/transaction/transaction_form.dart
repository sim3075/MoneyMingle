import 'package:flutter/material.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'widgets/category_selector.dart';
import 'widgets/note_field.dart';
import 'widgets/date_field.dart';

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
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  final List<String> _expenseCategories = [
    'Alimentación',
    'Transporte',
    'Vivienda',
    'Servicios',
    'Salud',
    'Ocio',
    'Compras',
    'Imprevistos',
  ];
  final List<String> _incomeCategories = [
    'Sueldo',
    'Freelance',
    'Inversiones',
    'Regalos',
    'Otros',
  ];


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es obligatorio')),
      );
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad incorrecto')),
      );
      return;
    }
    // TODO: Agregar logica de guardado de transacción
    Navigator.of(context).pop({'title': title, 'amount': amount});
  }

  @override
  Widget build(BuildContext context) {
     final isExpense = widget.type == TransactionType.expense;

    // 2) Escoger la lista adecuada
    final categories = isExpense
        ? _expenseCategories
        : _incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(isExpense ? 'Agregar Gasto' : 'Agregar Ingreso'),
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
              label: 'Cantidad',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 16),
            // --- Fecha ---
            DateField(
              selectedDate: _selectedDate,
              onDateChanged: (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 16),
            NoteField(controller: _noteController
            ),
            const SizedBox(height: 16),
            CategorySelector(
              selected: _selectedCategory,
              categories: categories,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const Spacer(),
            const SizedBox(height: 24),
            CustomButton(
              text: isExpense ? 'Añadir gasto' : 'Añadir Ingreso',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
