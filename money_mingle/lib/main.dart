import 'package:flutter/material.dart';
import 'package:money_mingle/app_theme.dart';
import 'package:money_mingle/routes/app_routes.dart';

void main() {
  runApp(const MoneyMingleApp());
}

class MoneyMingleApp extends StatelessWidget {
  const MoneyMingleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyMingle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
