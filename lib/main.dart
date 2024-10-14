// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/main_view.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart'; // Importa el ProfileViewModel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()), // Agrega ProfileViewModel
        ChangeNotifierProxyProvider<LoginViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<LoginViewModel>()),
          update: (context, loginViewModel, homeViewModel) {
            if (homeViewModel == null) {
              return HomeViewModel(loginViewModel);
            }
            homeViewModel.updateLoginViewModel(loginViewModel);
            return homeViewModel;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Aplicación KERUDOS',
        theme: ThemeData(
          primaryColor: Colors.purple[200],
          scaffoldBackgroundColor: Colors.white,
          buttonTheme: ButtonThemeData(buttonColor: Colors.pink[200]),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
        home: const MainView(),
      ),
    );
  }
}
