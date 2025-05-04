import 'package:flutter/material.dart';

class CategoryFilterSelector extends StatelessWidget {
  final String? selected;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const CategoryFilterSelector({
    Key? key,
    required this.selected,
    required this.categories,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Insertamos "Todas" como primera opción
    final items = ['Todas', ...categories];
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Categoría',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selected ?? 'Todas',
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (value) {
            // Si el usuario elige "Todas", devolvemos null
            onChanged(value == 'Todas' ? null : value);
          },
        ),
      ),
    );
  }
}
