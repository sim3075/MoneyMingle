import 'package:flutter/material.dart';
import 'package:money_mingle/domain/services/transaction_service.dart';
import 'package:money_mingle/ui/pages/root_screen.dart';
import 'package:money_mingle/ui/pages/auth/forgot_password_screen.dart';
import 'package:money_mingle/ui/pages/auth/register_screen.dart';
import 'package:money_mingle/ui/pages/auth/login_screen.dart';
import 'package:money_mingle/ui/pages/home/home_screen.dart';
import 'package:money_mingle/ui/pages/profile/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String rootScreen = '/root-screen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      forgotPassword: (context) => ForgotPasswordScreen(),
      home: (context) => HomeScreen(transactionService: TransactionService()),
      profile: (context) => ProfileScreen(),
      rootScreen: (context) => RootScreen()
    };
  }
}
