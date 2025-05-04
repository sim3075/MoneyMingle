import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateField({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'Selecciona fecha';
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Fecha',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) onDateChanged(date);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(displayText),
        ),
      ),
    );
  }
}
