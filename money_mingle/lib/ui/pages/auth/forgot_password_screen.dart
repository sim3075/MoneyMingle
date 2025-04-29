import 'package:flutter/material.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            Text("Ingresa tu correo electrónico y te enviaremos un enlace para recuperarla.",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),

            TextField(
              decoration: const InputDecoration(labelText: "Correo electrónico"),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Enviar enlace de recuperación",
                onPressed: () {
                  // Simulación de recuperación
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Correo de recuperación enviado (simulado)")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
