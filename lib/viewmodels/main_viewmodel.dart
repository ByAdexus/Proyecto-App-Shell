import 'package:flutter/material.dart';
import 'package:kerudos/views/home_view.dart';

class NavigationViewModel with ChangeNotifier {
  Widget _selectedView = const HomeView();

  Widget get selectedView => _selectedView;

  void changeView(Widget view) {
    _selectedView = view;
    notifyListeners();
  }
}
