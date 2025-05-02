import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'MoneyMingle Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Navegar a la pantalla de Dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Transactions'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Navegar a la pantalla de Transacciones
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Navegar a la pantalla de Perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Navegar a la pantalla de Configuración
            },
          ),
        ],
      ),
    );
  }
}