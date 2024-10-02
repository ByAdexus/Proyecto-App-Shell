// lib/viewmodels/register_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterViewModel with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _confirmPassword = ''; // New field for password confirmation
  bool _isRegistered = false; // Track registration state
  bool _isLoggedIn = false; // Track login state

  String get username => _username;
  String get password => _password;
  bool get isRegistered => _isRegistered; // Provide access to registration state
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
    // Logic to register the user
    if (_username.isNotEmpty && _password.isNotEmpty) {
      if (_password == _confirmPassword) { // Check if password matches confirmation
        // Save the user data in local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);
        await prefs.setString('password', _password); // You may want to hash this

        _isRegistered = true; // Set registration state
        _isLoggedIn = true; // Automatically log in the user
        notifyListeners();
      } else {
        throw Exception("Las contraseñas no coinciden"); // Passwords do not match
      }
    } else {
      throw Exception("Por favor, completa todos los campos"); // Fields cannot be empty
    }
  }

  Future<void> checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (storedPassword != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');

    _isLoggedIn = false;
    _username = '';
    _password = '';
    _confirmPassword = ''; // Reset confirm password
    notifyListeners();
  }
}
