import 'package:flutter/material.dart';

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
    // Logic to log in the user, validate username and password
    if (_username == "admin" && _password == "password") { // Example login check
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _username = '';
    _password = '';
    notifyListeners();
  }
}
