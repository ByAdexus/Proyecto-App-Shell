import 'package:flutter/material.dart';
import 'package:kerudos/components/footer.dart';
import 'package:kerudos/components/header.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/viewmodels/register_viewmodel.dart';
import 'package:provider/provider.dart';
import '../components/sidebar.dart';
import 'home_view.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()), // Make sure this is included
      ],
      child: Scaffold(
        body: Row(
          children: [
            Sidebar(), // Ensure Sidebar is properly built
            Expanded(
              child: Column(
                children: [
                  Header(), // Header at the top
                  Expanded(
                    child: Consumer<NavigationViewModel>(
                      builder: (context, navigationViewModel, _) {
                        return navigationViewModel.selectedView; // Ensure this is valid
                      },
                    ),
                  ),
                  Footer(), // Footer at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
