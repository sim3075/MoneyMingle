import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';
import 'package:money_mingle/providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¿Olvidaste tu contraseña?",
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              "Ingresa tu correo electrónico y te enviaremos un enlace para recuperarla.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Correo electrónico"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Enviar enlace de recuperación",
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Por favor ingresa tu correo electrónico")),
                    );
                    return;
                  }
                  final authService = ref.read(authServiceProvider);
                  try {
                    await authService.resetPassword(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Correo de recuperación enviado")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
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
