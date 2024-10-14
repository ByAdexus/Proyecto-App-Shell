// lib/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/views/home_view.dart';
import 'package:kerudos/views/register_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart'; // Importa tu ViewModel

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
                            onChanged: loginViewModel.setUsername, // Asegúrate de que este método exista
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            onChanged: loginViewModel.setPassword, // Asegúrate de que este método exista
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await loginViewModel.login(); // Llama al método de inicio de sesión

                                if (loginViewModel.loggedInUser.isNotEmpty) { // Cambiado para usar loggedInUser
                                  // Actualiza el nombre del usuario en MainViewModel
                                  context.read<MainViewModel>().loggedInUser = loginViewModel.loggedInUser;

                                  // Navegar a la vista principal si el login fue exitoso
                                  context.read<MainViewModel>().changeView(const HomeView());
                                } else {
                                  // Mostrar snackbar si el login falla
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Inicio de sesión fallido. Revisa tus credenciales.')),
                                  );
                                }
                              } catch (e) {
                                // Mostrar snackbar con el mensaje de error en caso de excepción
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                            child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navegar a RegisterView
                              context.read<MainViewModel>().changeView(const RegisterView());
                            },
                            child: const Text('No tienes cuenta? Regístrate', style: TextStyle(fontSize: 18)),
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
