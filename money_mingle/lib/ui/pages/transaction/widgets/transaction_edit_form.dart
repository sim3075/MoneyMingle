import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import '../widgets/category_selector.dart';
import '../widgets/date_field.dart';
import '../widgets/note_field.dart';

class TransactionEditForm extends StatefulWidget {
  final Transaction transaction;
  const TransactionEditForm({Key? key, required this.transaction}) : super(key: key);

  @override
  State<TransactionEditForm> createState() => _TransactionEditFormState();
}

class _TransactionEditFormState extends State<TransactionEditForm> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  DateTime? _selectedDate;
  String? _selectedCategory;
  bool _isFixed = false;

  final _expenseCats = [
    'Alimentación','Transporte','Vivienda','Servicios','Salud','Ocio','Compras','Imprevistos'
  ];
  final _incomeCats  = ['Sueldo','Freelance','Inversiones','Regalos','Otros'];

  @override
  void initState() {
    super.initState();
    _titleController  = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _noteController   = TextEditingController(text: widget.transaction.note ?? '');
    _selectedDate     = widget.transaction.date;
    _selectedCategory = widget.transaction.category;
    _isFixed          = widget.transaction.isFixed;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amt   = double.tryParse(_amountController.text.trim());
    if (title.isEmpty || amt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa título y cantidad')),
      );
      return;
    }

    // Usa copyWith para conservar el id
    final updatedTx = widget.transaction.copyWith(
      title: title,
      amount: amt,
      date: _selectedDate ?? DateTime.now(),
      category: _selectedCategory,
      note: _noteController.text.trim(),
      isFixed: _isFixed,
      // receiptPath se conserva automáticamente
    );

    Navigator.of(context).pop(updatedTx);
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.transaction.type == TransactionType.expense;
    final cats      = isExpense ? _expenseCats : _incomeCats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Transacción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              DateField(
                selectedDate: _selectedDate,
                onDateChanged: (d) => setState(() => _selectedDate = d),
              ),
              const SizedBox(height: 16),
              NoteField(controller: _noteController),
              const SizedBox(height: 16),
              CategorySelector(
                selected:   _selectedCategory,
                categories: cats,
                onChanged:  (v) => setState(() => _selectedCategory = v),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Recurrente (fijo)'),
                subtitle: const Text('Se añadirá automáticamente'),
                value: _isFixed,
                onChanged: (v) => setState(() => _isFixed = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Actualizar',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
