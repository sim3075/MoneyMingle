import 'package:flutter/material.dart';

Future<String?> showEditProfileDialog(
  BuildContext context,
  String label,
  String initialValue, {
  TextInputType keyboardType = TextInputType.text,
}) {
  final controller = TextEditingController(text: initialValue);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Editar $label'),
      content: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Guardar'),
          onPressed: () => Navigator.pop(context, controller.text.trim()),
        ),
      ],
    ),
  );
}