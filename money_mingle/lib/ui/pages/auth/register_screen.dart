import 'package:flutter/material.dart';
import 'package:money_mingle/ui/widgets/shared/custom_button.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bienvenido a MoneyMingle 👋",
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Crea tu cuenta para comenzar a gestionar tus finanzas.",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),

            TextField(
              decoration: const InputDecoration(labelText: "Nombre completo"),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: "Correo electrónico"),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirmar contraseña"),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Registrarme",
                onPressed: () {
                  // Simulación de registro
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cuenta registrada (simulado)")),
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
