// lib/views/main_view.dart
import 'package:flutter/material.dart';
import 'package:kerudos/components/footer.dart';
import 'package:kerudos/components/header.dart';
import '../components/sidebar.dart'; // Asegúrate de importar el Sidebar
import 'home_view.dart';
import 'login_view.dart'; // Asegúrate de tener vistas para Login y Register
import 'register_view.dart';
//import 'chat_view.dart';
//import 'footer.dart';
//import 'header.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(), // Sidebar en la izquierda
          Expanded(
            child: Column(
              children: [
                Header(), // Header en la parte superior
                Expanded(
                  child: HomeView(), // Aquí irá el contenido principal (puedes cambiarlo después)
                ),
                Footer(), // Footer ocupando todo el ancho
              ],
            ),
          ),
        ],
      ),
    );
  }
}
