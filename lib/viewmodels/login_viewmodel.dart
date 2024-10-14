import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para codificar y decodificar JSON

class LoginViewModel with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _loggedInUser = ''; // Almacena el nombre de usuario logueado

  String get username => _username;
  String get loggedInUser => _loggedInUser; // Acceso al nombre de usuario logueado

  void setLoggedInUser(String username) {
  _loggedInUser = username;
  notifyListeners();
}

void setUsername(String username) {  // Agrega este método
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
                _loggedInUser = user['username']; // Asigna el nombre de usuario logueado
              }
            });

            if (_loggedInUser.isNotEmpty) {
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
    // Limpia el nombre de usuario logueado
    _loggedInUser = '';
    _username = '';
    _password = '';
    notifyListeners();
  }
}
