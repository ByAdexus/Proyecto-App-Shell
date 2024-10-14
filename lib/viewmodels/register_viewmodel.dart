// lib/viewmodels/register_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart'; // Asegúrate de importar LoginViewModel

class RegisterViewModel with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isRegistered = false;
  bool _isLoggedIn = false;

  String get username => _username;
  String get password => _password;
  bool get isRegistered => _isRegistered;
  bool get isLoggedIn => _isLoggedIn;

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

  Future<void> register(BuildContext context) async {
    if (_username.isNotEmpty && _password.isNotEmpty) {
      if (_password == _confirmPassword) {
        try {
          String normalizedUsername = _username.toLowerCase();
          final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/users.json");
          final response = await http.get(url);

          if (response.statusCode == 200) {
            final data = json.decode(response.body) as Map<String, dynamic>?;

            if (data != null) {
              bool usernameExists = data.values.any((user) => user['username'].toLowerCase() == normalizedUsername);
              if (usernameExists) {
                throw Exception("El nombre de usuario ya está en uso. Por favor elige otro.");
              }
            }

            Map<String, dynamic> userData = {
              "username": normalizedUsername,
              "password": _password, // Considera encriptar la contraseña
            };

            final postResponse = await http.post(
              url,
              body: json.encode(userData),
            );

            if (postResponse.statusCode == 200 || postResponse.statusCode == 201) {
              _isRegistered = true;
              _isLoggedIn = true;
              context.read<LoginViewModel>().setLoggedInUser(normalizedUsername);
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
    // Aquí puedes implementar la verificación del estado de inicio de sesión si es necesario.
    // Este método puede ser útil en el futuro si decides agregar más lógica de autenticación.
  }

  void logout() {
    _isLoggedIn = false;
    _username = '';
    _password = '';
    _confirmPassword = '';
    notifyListeners();
  }
}
