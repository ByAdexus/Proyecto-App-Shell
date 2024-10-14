// lib/viewmodels/main_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:kerudos/views/home_view.dart';

class MainViewModel with ChangeNotifier {
  Widget _selectedView = const HomeView();
  String _loggedInUser = ''; // Agrega esta línea para almacenar el usuario logueado

  Widget get selectedView => _selectedView;
  String get loggedInUser => _loggedInUser;

  set loggedInUser(String username) {
    _loggedInUser = username; // Asigna el nombre de usuario logueado
    notifyListeners();
  }

  void changeView(Widget view) {
    _selectedView = view;
    notifyListeners();
  }
}
