// lib/components/sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blueGrey[800],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'KERUDOS',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'CustomFont'),
            ),
          ),
          _buildSidebarItem(icon: Icons.home, label: 'Home'),
          _buildSidebarItem(icon: Icons.search, label: 'Buscar'),
          _buildSidebarItem(icon: Icons.chat, label: 'Chatear'),
          _buildSidebarItem(icon: Icons.person, label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8), // Espacio entre íconos y texto
      ],
    );
  }
}
