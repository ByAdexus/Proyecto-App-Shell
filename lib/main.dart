// lib/main.dart
import 'package:flutter/material.dart';
import 'package:kerudos/views/main_view.dart';
import 'views/main_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación KERUDOS',
      theme: ThemeData(
        primaryColor: Colors.purple[200], // Lila claro
        scaffoldBackgroundColor: Colors.white, // Fondo blanco
        buttonTheme: ButtonThemeData(buttonColor: Colors.pink[200]), // Botones en rosa
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: MainView(), // MainView como la vista principal
    );
  }
}
