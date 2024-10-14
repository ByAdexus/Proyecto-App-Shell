import 'package:flutter/material.dart';
import 'package:kerudos/components/footer.dart';
import 'package:kerudos/components/header.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';
import 'package:kerudos/viewmodels/main_viewmodel.dart';
import 'package:kerudos/viewmodels/register_viewmodel.dart';
import 'package:provider/provider.dart';
import '../components/sidebar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => MainViewModel()), // Cambiado de NavigationViewModel a MainViewModel
      ],
      child: Scaffold(
        body: Row(
          children: [
            const Sidebar(), // Asegurarse de que Sidebar se construya correctamente
            Expanded(
              child: Column(
                children: [
                  const Header(), // Header en la parte superior
                  Expanded(
                    child: Consumer<MainViewModel>( // Cambiado de NavigationViewModel a MainViewModel
                      builder: (context, mainViewModel, _) {
                        return mainViewModel.selectedView; // Asegurarse de que esto sea válido
                      },
                    ),
                  ),
                  const Footer(), // Footer en la parte inferior
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
