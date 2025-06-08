import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mingle/ui/widgets/shared/custom_textfield.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:money_mingle/ui/pages/auth/widgets/quote_carousel.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                'MoneyMingle',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const QuoteCarousel(),
              const Spacer(),
              CustomTextField(
                controller: emailController,
                label: 'Correo electrónico',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                label: 'Contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              const SizedBox(height: 24),
              // Botón de inicio de sesión con lógica de autenticación
              CustomButton(
                text: 'Iniciar Sesión',
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final authService = ref.read(authServiceProvider);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    await authService.signIn(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    Navigator.pop(context); // Quita el loader
                    Navigator.pushReplacementNamed(context, '/root-screen');
                  } on FirebaseAuthException catch (e) {
                    Navigator.pop(context); // Quita el loader
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Error al iniciar sesión')),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Iniciar sesión con Google',
                // icon: Icons.g_mobiledata, // O usa un widget con el logo de Google
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    await authService.signInWithGoogle();
                    Navigator.pop(context); // Quita el loader
                    Navigator.pushReplacementNamed(context, '/root-screen');
                  } on FirebaseAuthException catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Error al iniciar sesión con Google')),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
