// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  String username = '';
  String password = '';
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> login() async {
    if (username.isNotEmpty && password.isNotEmpty) {
      // Aquí iría la lógica para autenticar al usuario
      // Simulación de autenticación
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      _isLoggedIn = true;
      notifyListeners();
      print('Iniciando sesión con: $username');
    } else {
      print('Por favor, completa todos los campos.');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('username')) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }
}
