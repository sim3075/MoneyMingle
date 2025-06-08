import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'widgets/edit_profile_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    final userService = ref.read(userServiceProvider);
    final reload = ref.watch(profileReloadProvider);

    return FutureBuilder(
      key: ValueKey(reload), // Fuerza rebuild al cambiar reload
      future: userService.getUser(uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
            automaticallyImplyLeading: false,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                                    ? NetworkImage(user.photoUrl!)
                                    : const AssetImage('lib/assets/images/usuario.png') as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(child: CircularProgressIndicator()),
                                    );
                                    final userService = ref.read(userServiceProvider);
                                    final newPhotoUrl = await userService.updateProfilePhoto(uid);
                                    Navigator.pop(context);
                                    if (newPhotoUrl != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Foto de perfil actualizada')),
                                      );
                                      ref.read(profileReloadProvider.notifier).state++;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            user?.displayName ?? 'Nombre de Usuario',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildEditableField(
                          context,
                          ref,
                          uid: uid,
                          icon: FontAwesomeIcons.envelope,
                          label: 'Correo Electrónico',
                          value: user?.email ?? '',
                          field: 'email',
                          enabled: false, // No editable por seguridad
                        ),
                        const Divider(),
                        _buildEditableField(
                          context,
                          ref,
                          uid: uid,
                          icon: FontAwesomeIcons.user,
                          label: 'Nombre',
                          value: user?.displayName ?? '',
                          field: 'displayName',
                        ),
                        const Divider(),
                        _buildEditableField(
                          context,
                          ref,
                          uid: uid,
                          icon: FontAwesomeIcons.moneyBill1Wave,
                          label: 'Presupuesto mensual',
                          value: user?.monthlyBudget?.toStringAsFixed(2) ?? '',
                          field: 'monthlyBudget',
                          keyboardType: TextInputType.number,
                        ),
                        const Divider(),
                        _buildEditableField(
                          context,
                          ref,
                          uid: uid,
                          icon: FontAwesomeIcons.piggyBank,
                          label: 'Meta de ahorro',
                          value: user?.savingsGoal?.toStringAsFixed(2) ?? '',
                          field: 'savingsGoal',
                          keyboardType: TextInputType.number,
                        ),
                        const Divider(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    WidgetRef ref, {
    required String uid,
    required IconData icon,
    required String label,
    required String value,
    required String field,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return ListTile(
      leading: FaIcon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: enabled
          ? IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () async {
                final newValue = await showEditProfileDialog(
                  context,
                  label,
                  value,
                  keyboardType: keyboardType,
                );
                if (newValue != null && newValue != value) {
                  final userService = ref.read(userServiceProvider);
                  dynamic parsedValue = newValue;
                  if (field == 'monthlyBudget' || field == 'savingsGoal') {
                    parsedValue = double.tryParse(newValue);
                  }
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );
                    await userService.updateUserField(uid, field, parsedValue);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dato actualizado')),
                    );
                    ref.read(profileReloadProvider.notifier).state++;
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar: $e')),
                    );
                  }
                }
              },
            )
          : null,
    );
  }
}