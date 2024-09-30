// lib/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/views/home_view.dart';
import 'package:kerudos/views/register_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart'; // Importa tu ViewModel
// Importa el NavigationViewModel

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Center(
        child: Container(
          width: 400,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 60, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Consumer<LoginViewModel>(
                    builder: (context, loginViewModel, child) {
                      return Column(
                        children: [
                          TextField(
                            onChanged: loginViewModel.setUsername,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            onChanged: loginViewModel.setPassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await loginViewModel.login(); // Llama al método de inicio de sesión
                              if (loginViewModel.isLoggedIn) {
                                // Navigate to the home or main view after successful login
                                context.read<NavigationViewModel>().changeView(HomeView());
                              }
                            },
                            child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Use NavigationViewModel to navigate to RegisterView
                              context.read<NavigationViewModel>().changeView(RegisterView());
                            },
                            child: Text('No tienes cuenta? Regístrate', style: TextStyle(fontSize: 18)),
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
