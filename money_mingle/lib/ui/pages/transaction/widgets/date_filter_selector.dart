import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFilter { day, month, year }

class DateFilterSelector extends StatelessWidget {
  final DateFilter filter;
  final DateTime selectedDate;
  final ValueChanged<DateFilter> onFilterChanged;
  final ValueChanged<DateTime> onDateChanged;

  const DateFilterSelector({
    Key? key,
    required this.filter,
    required this.selectedDate,
    required this.onFilterChanged,
    required this.onDateChanged,
  }) : super(key: key);

  String get _label {
    switch (filter) {
      case DateFilter.day:
        return DateFormat('dd/MM/yyyy').format(selectedDate);
      case DateFilter.month:
        return DateFormat('MM/yyyy').format(selectedDate);
      case DateFilter.year:
        return DateFormat('yyyy').format(selectedDate);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: filter == DateFilter.year
          ? 'Selecciona año'
          : filter == DateFilter.month
              ? 'Selecciona mes'
              : 'Selecciona fecha',
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final icons = {
      DateFilter.day: 'Día',
      DateFilter.month: 'Mes',
      DateFilter.year: 'Año',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: DateFilter.values.map((f) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(icons[f]!),
                selected: filter == f,
                onSelected: (_) => onFilterChanged(f),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _pickDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: filter == DateFilter.day
                  ? 'Fecha'
                  : filter == DateFilter.month
                      ? 'Mes/Año'
                      : 'Año',
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            child: Text(_label),
          ),
        ),
      ],
    );
  }
}

