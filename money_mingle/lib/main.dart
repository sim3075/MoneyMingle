import 'package:flutter/material.dart';
import 'ui/pages/auth/login_screen.dart';
import 'app_theme.dart';

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
      home: LoginScreen(), 
    );
  }
}
