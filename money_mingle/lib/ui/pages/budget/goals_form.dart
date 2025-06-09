import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_mingle/domain/services/user_service.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:money_mingle/ui/pages/transaction/widgets/date_field.dart';

class GoalsForm extends StatefulWidget {
  const GoalsForm({Key? key}) : super(key: key);

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime? _dueDate;
  final _userService = UserService();

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final title = _titleController.text.trim();
    final rawTarget = _targetController.text.trim();
    if (title.isEmpty || rawTarget.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }
    final target = double.tryParse(rawTarget);
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objetivo inválido')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Aquí puedes:
    // 1) Simplemente actualizar savingsGoal en el documento de usuario:
    await _userService.updateUserField(uid, 'savingsGoal', target);
    await _userService.updateUserField(
        uid, 'goalTitle', title);
    await _userService.updateUserField(
        uid, 'goalDueDate', _dueDate!.toIso8601String());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meta guardada correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meta de Ahorro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _titleController,
              label: 'Título de la meta',
              icon: Icons.flag,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _targetController,
              label: 'Objetivo (\$)',
              icon: Icons.savings,
            ),

            const SizedBox(height: 16),

            DateField(
              selectedDate: _dueDate,
              onDateChanged: (d) => setState(() => _dueDate = d),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Agregar Meta',
              onPressed: _saveGoal,
            ),
          ],
        ),
      ),
    );
  }
}
