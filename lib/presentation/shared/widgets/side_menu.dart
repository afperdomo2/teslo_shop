import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/presentation/features/auth/login/screens/login_screen.dart';
import 'package:teslo_app/presentation/providers/auth_provider.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider.select((state) => state.authStatus));
    final authenticatedUser = ref.watch(authProvider.select((state) => state.user));
    final logoutUser = ref.read(authProvider.notifier).logout;

    return authStatus == AuthStatus.authenticated
        ? Drawer(
            child: Column(
              children: [
                // Header del menú con información del usuario
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Color(0xFF1976D2)),
                      ),
                      SizedBox(height: 12),
                      Text(
                        authenticatedUser!.fullName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authenticatedUser.email,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Opciones del menú
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 20),

                      // Opción Productos
                      ListTile(
                        leading: const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFF1976D2),
                          size: 28,
                        ),
                        title: const Text(
                          'Productos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.goNamed('products');
                        },
                      ),

                      // const Divider(height: 30),
                    ],
                  ),
                ),

                // Botón de cerrar sesión
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red, size: 28),
                        title: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Logout inmediato sin diálogo de confirmación
                          logoutUser('Sesión cerrada por el usuario');
                          context.goNamed(LoginScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Drawer(
            child: Center(
              child: Text(
                'Por favor, inicia sesión para ver el menú.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
  }
}
