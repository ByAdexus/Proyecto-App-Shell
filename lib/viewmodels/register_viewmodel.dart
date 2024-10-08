// lib/viewmodels/register_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterViewModel with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _confirmPassword = ''; // New field for password confirmation
  bool _isRegistered = false; // Track registration state
  bool _isLoggedIn = false; // Track login state

  String get username => _username;
  String get password => _password;
  bool get isRegistered =>
      _isRegistered; // Provide access to registration state
  bool get isLoggedIn => _isLoggedIn; // Provide access to login state

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  Future<void> register() async {
  if (_username.isNotEmpty && _password.isNotEmpty) {
    if (_password == _confirmPassword) {
      try {
        // Normalizar el nombre de usuario a minúsculas
        String normalizedUsername = _username.toLowerCase();

        // Paso 1: Verificar si el nombre de usuario ya existe
        final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/users.json");
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>?;

          // Si hay datos en la base de datos, verificar si el nombre de usuario ya existe
          if (data != null) {
            bool usernameExists = data.values.any((user) => user['username'].toLowerCase() == normalizedUsername);

            if (usernameExists) {
              throw Exception("El nombre de usuario ya está en uso. Por favor elige otro.");
            }
          }

          // Paso 2: Si el nombre de usuario es único, proceder con el registro
          Map<String, dynamic> userData = {
            "username": normalizedUsername, // Guardar el username en minúsculas
            "password": _password, // Considera encriptar la contraseña
          };

          final postResponse = await http.post(
            url,
            body: json.encode(userData),
          );

          if (postResponse.statusCode == 200) {
            _isRegistered = true; // Usuario registrado con éxito
            _isLoggedIn = true; // Iniciar sesión automáticamente
            notifyListeners();
          } else {
            throw Exception("Error al registrar al usuario. Código de estado: ${postResponse.statusCode}");
          }
        } else {
          throw Exception("Error al conectar con la base de datos. Código de estado: ${response.statusCode}");
        }
      } catch (e) {
        throw Exception("Error al registrar al usuario: $e");
      }
    } else {
      throw Exception("Las contraseñas no coinciden");
    }
  } else {
    throw Exception("Por favor, completa todos los campos");
  }
}


  Future<void> checkLoggedInStatus() async {
    try {
      final url = Uri.parse(
          "https://red-social-961f9-default-rtdb.firebaseio.com/users.json");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          data.forEach((key, user) {
            if (user['username'] == _username &&
                user['password'] == _password) {
              _isLoggedIn = true;
              notifyListeners();
            }
          });
        }
      } else {
        throw Exception("Error al verificar el estado del usuario.");
      }
    } catch (e) {
      throw Exception("Error al verificar el estado del usuario: $e");
    }
  }

  void logout() async {
    // No necesitamos eliminar nada de Firebase, solo limpiar el estado local
    _isLoggedIn = false;
    _username = '';
    _password = '';
    _confirmPassword = ''; // Resetear confirmación de contraseña
    notifyListeners();
  }
}
