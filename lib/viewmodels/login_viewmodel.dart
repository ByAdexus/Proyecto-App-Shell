import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para codificar y decodificar JSON

class LoginViewModel with ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoggedIn = false; // Track login state

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn; // Provide access to login state

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<void> login() async {
    if (_username.isNotEmpty && _password.isNotEmpty) {
      try {
        // URL de tu API de Firebase
        final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/users.json");

        // Realizar una solicitud GET para obtener los usuarios y validar credenciales
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Decodificar la respuesta de JSON
          final data = json.decode(response.body) as Map<String, dynamic>?;

          if (data != null) {
            // Iterar sobre los usuarios en Firebase para validar el login
            data.forEach((key, user) {
              if (user['username'] == _username && user['password'] == _password) {
                _isLoggedIn = true;
              }
            });

            if (_isLoggedIn) {
              notifyListeners();
            } else {
              throw Exception("Usuario o contraseña incorrectos");
            }
          } else {
            throw Exception("No se encontraron usuarios en la base de datos");
          }
        } else {
          throw Exception("Error al conectar con la base de datos");
        }
      } catch (e) {
        throw Exception("Error durante el inicio de sesión: $e");
      }
    } else {
      throw Exception("Por favor, completa todos los campos");
    }
  }

  void logout() {
    // No necesitamos interactuar con Firebase para cerrar sesión, solo limpiamos el estado local
    _isLoggedIn = false;
    _username = '';
    _password = '';
    notifyListeners();
  }
}
