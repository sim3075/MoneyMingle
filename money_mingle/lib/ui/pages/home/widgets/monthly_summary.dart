import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/models/transaction.dart';

class MonthlySummary extends StatelessWidget {
  const MonthlySummary({super.key, required List<Transaction> transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text("Tienes \$300 para gastar ese mes 💰"),
    );
  }
}