import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text("Groceries"),
          subtitle: Text("Today"),
          trailing: Text("- \$50"),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Salary"),
          subtitle: Text("Yesterday"),
          trailing: Text("+ \$2000"),
        ),
      ],
    );
  }
}