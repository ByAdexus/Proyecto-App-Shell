// lib/views/register_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart'; // Import your RegisterViewModel
import 'home_view.dart'; // Import HomeView to navigate to it

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Center(
        child: SizedBox(
          width: 400, // Fixed width for the card
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<RegisterViewModel>(
                builder: (context, registerViewModel, child) {
                  return Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add,
                            size: 60, color: Colors.green),
                        const SizedBox(height: 16),
                        const Text('Registro',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: registerViewModel.setUsername,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          onChanged: registerViewModel.setPassword,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          onChanged: registerViewModel.setConfirmPassword,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await registerViewModel.register();

                              // Navigate to HomeView after successful registration
                              context
                                  .read<NavigationViewModel>()
                                  .changeView(const HomeView());
                            } catch (e) {
                              // Mostrar mensaje de error en un SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: const Text('Registrar',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
