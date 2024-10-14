import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/viewmodels/register_viewmodel.dart';
import 'package:kerudos/views/chat_view.dart';
import 'package:kerudos/views/search_view.dart';
import 'package:provider/provider.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';
import 'package:kerudos/views/home_view.dart';
import 'package:kerudos/views/login_view.dart';
import 'package:kerudos/views/profile_view.dart'; // Importar ProfileView

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    var loginViewModel = context.watch<LoginViewModel>(); // Observar el estado de login
    var registerViewModel = context.watch<RegisterViewModel>();

    return Container(
      width: 100,
      color: Colors.blueGrey[800],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'KERUDOS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Home
          _buildSidebarItem(
            icon: Icons.home,
            label: 'Home',
            onTap: () {
              context.read<MainViewModel>().changeView(const HomeView());
            },
          ),
          // Buscar
          _buildSidebarItem(
            icon: Icons.search,
            label: 'Buscar',
            onTap: () {
              context.read<MainViewModel>().changeView(const SearchView());
            },
          ),
          // Chatear
          _buildSidebarItem(
              icon: Icons.chat,
              label: 'Chatear',
              onTap: loginViewModel.loggedInUser.isNotEmpty || registerViewModel.isLoggedIn
                  ? () {
                      context.read<MainViewModel>().changeView(const ChatView());
                    }
                  : null, // Desactivar si no está logueado
              enabled: loginViewModel.loggedInUser.isNotEmpty ||
                  registerViewModel.isLoggedIn // Habilitar o no según login
              ),
          // Perfil (Dependiendo del estado de autenticación)
          _buildSidebarItem(
            icon: Icons.person,
            label: 'Perfil',
            onTap: loginViewModel.loggedInUser.isNotEmpty || registerViewModel.isLoggedIn
                ? () {
                    context.read<MainViewModel>().changeView(
                        const ProfileView()); // Si está autenticado, mostrar el perfil
                  }
                : () {
                    context.read<MainViewModel>().changeView(
                        const LoginView()); // Si no está autenticado, redirigir a login
                  },
            enabled: true, // Siempre habilitado pero redirige según estado
          ),
          // Logout
          _buildSidebarItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: loginViewModel.loggedInUser.isNotEmpty || registerViewModel.isLoggedIn
                ? () {
                    loginViewModel.logout(); // Cerrar sesión
                    registerViewModel.logout();
                    context.read<MainViewModel>().changeView(const LoginView()); // Redirigir a login
                  }
                : null,
            enabled: loginViewModel.loggedInUser.isNotEmpty || registerViewModel.isLoggedIn,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback? onTap, // Permitir nulo para deshabilitar
    bool enabled = true, // Habilitado por defecto
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null, // Solo activar si está habilitado
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5, // Opacidad si está deshabilitado
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            Text(label, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8), // Espacio entre ícono y texto
          ],
        ),
      ),
    );
  }
}
