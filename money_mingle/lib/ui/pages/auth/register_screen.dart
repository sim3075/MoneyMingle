import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/domain/services/auth_service.dart';
import 'package:money_mingle/providers/auth_providers.dart';
//import 'package:money_mingle/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:money_mingle/models/user.dart' as app_model;
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Crear cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenido a MoneyMingle 👋",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Crea tu cuenta para comenzar a gestionar tus finanzas.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre completo"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar contraseña",
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Registrarme",
                onPressed: () async {
                  if (passwordController.text != confirmController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Las contraseñas no coinciden"),
                      ),
                    );
                    return;
                  }
                  final authService = ref.read(authServiceProvider);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    final cred = await authService.register(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    await registerUser(ref, cred.user!);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/root-screen');
                  } on FirebaseAuthException catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'Error al registrar'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
