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
  final _formKey = GlobalKey<FormState>();
  String? _title;
  double? _amount;

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == TransactionType.expense;
    return Scaffold(
      appBar: AppBar(
        title: Text(isExpense ? 'Registrar Gasto' : 'Registrar Ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onSaved: (v) => _title = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _amount = double.tryParse(v ?? ''),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  return double.tryParse(v) == null ? 'Número inválido' : null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: Text(isExpense ? 'Guardar Gasto' : 'Guardar Ingreso'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //logica luego
      Navigator.of(context).pop(); 
    }
  }
}
