import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptField extends StatelessWidget {
  final XFile? image;
  final VoidCallback onPick;

  const ReceiptField({
    Key? key,
    required this.image,
    required this.onPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencia opcional',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(image!.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: Text(
                image == null ? 'Agregar foto' : 'Cambiar foto',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: onPick,
            ),
          ],
        ),
      ],
    );
  }
}
