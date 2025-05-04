import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Transacciones recientes", style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text("Alimentación"),
          subtitle: Text("Hoy"),
          trailing: Text("- \$50"),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Salario"),
          subtitle: Text("Ayer"),
          trailing: Text("+ \$2000"),
        ),
      ],
    );
  }
}