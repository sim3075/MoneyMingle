import 'package:flutter/material.dart';

class EditProfileDialog extends StatelessWidget {
  final String title;
  final String initialValue;
  final Function(String) onSave;

  const EditProfileDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(
        'Editar $title',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

void showEditProfileDialog(BuildContext context, String label, String value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditProfileDialog(
        title: label,
        initialValue: value,
        onSave: (newValue) {
          print('Nuevo valor para $label: $newValue');
        },
      );
    },
  );
}