import 'package:flutter/material.dart';
import 'package:money_mingle/models/transaction.dart';               
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/category_selector.dart';
import 'widgets/date_field.dart';
import 'widgets/note_field.dart';
import 'widgets/receipt_field.dart';

class TransactionForm extends StatefulWidget {
  final TransactionType type;
  final Transaction? initial;    
  const TransactionForm({
    required this.type,
    this.initial,
    Key? key,
  }) : super(key: key);

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
  bool      _isFixed = false;     

  final _picker = ImagePicker();
  final _expenseCats = [
    'Alimentación','Transporte','Vivienda',
    'Servicios','Salud','Ocio','Compras','Imprevistos'
  ];
  final _incomeCats  = ['Sueldo','Freelance','Inversiones','Regalos','Otros'];

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      final tx = widget.initial!;
      _titleController.text   = tx.title;
      _amountController.text  = tx.amount.toString();
      _selectedDate           = tx.date;
      _selectedCategory       = tx.category;
      _noteController.text    = tx.note ?? '';
      _receiptImage = tx.receiptPath != null ? XFile(tx.receiptPath!) : null;
      _isFixed = tx.isFixed;             
    }
  }

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
    final newTx = Transaction(
      type:        widget.type,
      title:       title,
      amount:      amt,
      date:        _selectedDate ?? DateTime.now(),
      category:    _selectedCategory,
      note:        _noteController.text.trim(),
      receiptPath: _receiptImage?.path,
      isFixed:     _isFixed,      
    );
    Navigator.of(context).pop(newTx);
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
              ReceiptField(
                image: _receiptImage,
                onPick: _pickImage,
              ),
              CheckboxListTile(
                title: const Text('Recurrente (fijo)'),
                subtitle: const Text('Se añadirá automáticamente'),
                value: _isFixed,
                onChanged: (v) => setState(() => _isFixed = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: isExpense ? 'Añadir gasto' : 'Añadir ingreso',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
