// lib/views/register_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart'; // Import your RegisterViewModel
import 'home_view.dart'; // Import HomeView to navigate to it

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Center(
        child: Container(
          width: 400, // Fixed width for the card
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<RegisterViewModel>( 
                builder: (context, registerViewModel, child) {
                  return Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, size: 60, color: Colors.green),
                        SizedBox(height: 16),
                        Text('Registro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextField(
                          onChanged: registerViewModel.setUsername,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          onChanged: registerViewModel.setPassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          onChanged: registerViewModel.setConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await registerViewModel.register();
                              
                              // Navigate to HomeView using NavigationViewModel after successful registration
                              context.read<NavigationViewModel>().changeView(HomeView());
                            } catch (e) {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: Text('Registrar', style: TextStyle(fontSize: 18)),
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
