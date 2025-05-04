import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';               // trae TransactionType
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/category_selector.dart';
import 'widgets/date_field.dart';
import 'widgets/note_field.dart';
import 'widgets/receipt_field.dart';

class TransactionForm extends StatefulWidget {
  final TransactionType type;
  const TransactionForm({ required this.type, Key? key }) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController  = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController   = TextEditingController();

  DateTime? _selectedDate;
  String?   _selectedCategory;
  XFile?    _receiptImage;
  final _picker = ImagePicker();

  final _expenseCats = [
    'Alimentación','Transporte','Vivienda',
    'Servicios','Salud','Ocio','Compras','Imprevistos'
  ];
  final _incomeCats  = ['Sueldo','Freelance','Inversiones','Regalos','Otros'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800, maxHeight: 800, imageQuality: 80,
    );
    if (img != null) setState(() => _receiptImage = img);
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
    Navigator.of(context).pop({
      'title':       title,
      'amount':      amt,
      'date':        _selectedDate,
      'category':    _selectedCategory,
      'note':        _noteController.text.trim(),
      'receiptPath': _receiptImage?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == TransactionType.expense;
    final cats      = isExpense ? _expenseCats : _incomeCats;

    return Scaffold(
      appBar: AppBar(
        title: Text(isExpense ? 'Agregar Gasto' : 'Agregar Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
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
          ReceiptField(
            image: _receiptImage,
            onPick: _pickImage,
          ),
          const Spacer(),
          CustomButton(
            text: isExpense ? 'Añadir gasto' : 'Añadir ingreso',
            onPressed: _submit,
          ),
        ]),
      ),
    );
  }
}
