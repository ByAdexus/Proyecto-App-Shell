// lib/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/views/home_view.dart';
import 'package:kerudos/views/register_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart'; // Importa tu ViewModel
// Importa el NavigationViewModel

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 60, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Consumer<LoginViewModel>(
                    builder: (context, loginViewModel, child) {
                      return Column(
                        children: [
                          TextField(
                            onChanged: loginViewModel.setUsername,
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            onChanged: loginViewModel.setPassword,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await loginViewModel
                                  .login(); // Llama al método de inicio de sesión
                              if (loginViewModel.isLoggedIn) {
                                // Navigate to the home or main view after successful login
                                context
                                    .read<NavigationViewModel>()
                                    .changeView(const HomeView());
                              }
                            },
                            child: const Text('Iniciar Sesión',
                                style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Use NavigationViewModel to navigate to RegisterView
                              context
                                  .read<NavigationViewModel>()
                                  .changeView(const RegisterView());
                            },
                            child: const Text('No tienes cuenta? Regístrate',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
