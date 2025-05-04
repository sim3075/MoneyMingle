import 'package:flutter/material.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;
  const NoteField({ Key? key, required this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'Nota',
      icon: Icons.note,
    );
  }
}
