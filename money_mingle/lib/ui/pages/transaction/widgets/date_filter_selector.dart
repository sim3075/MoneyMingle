import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFilter { day, week, month, year }

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
      case DateFilter.week:
        // Formato "Semana del 01/05 al 07/05"
        final start = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );
        final end = start.add(const Duration(days: 6));
        return 'Del ${DateFormat('dd/MM').format(start)} '
               'al ${DateFormat('dd/MM/yyyy').format(end)}';
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
      helpText: () {
        switch (filter) {
          case DateFilter.day:
            return 'Selecciona fecha';
          case DateFilter.week:
            return 'Selecciona una fecha dentro de la semana';
          case DateFilter.month:
            return 'Selecciona mes';
          case DateFilter.year:
            return 'Selecciona año';
        }
      }(),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final labels = {
      DateFilter.day: 'Día',
      DateFilter.week: 'Semana',
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
                label: Text(labels[f]!),
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
              labelText: {
                DateFilter.day: 'Fecha',
                DateFilter.week: 'Semana',
                DateFilter.month: 'Mes/Año',
                DateFilter.year: 'Año',
              }[filter],
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
