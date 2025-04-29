import 'package:flutter/material.dart';
import 'package:money_mingle/ui/pages/auth/forgot_password_screen.dart';
import 'package:money_mingle/ui/pages/auth/register_screen.dart';
import 'package:money_mingle/ui/pages/home/home_screen.dart';
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
      initialRoute: '/login', 
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
