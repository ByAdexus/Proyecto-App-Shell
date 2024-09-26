// lib/components/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      color: Colors.grey[200], // Fondo claro
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            icon: Icons.info,
            text: 'Información',
            linkText: 'Sobre nosotros',
            onTap: () {
              // Navegar a la página de información
            },
          ),
          _buildRow(
            icon: Icons.support,
            text: 'Soporte',
            linkText: 'Contacto',
            onTap: () {
              // Navegar a la página de soporte
            },
          ),
          _buildRow(
            icon: Icons.policy,
            text: 'Política',
            linkText: 'Privacidad',
            onTap: () {
              // Navegar a la política de privacidad
            },
          ),
          _buildRow(
            icon: Icons.question_answer,
            text: 'Ayuda',
            linkText: 'FAQ',
            onTap: () {
              // Navegar a la página de FAQ
            },
          ),
          SizedBox(height: 10), // Espacio antes del logo
          Center(
            child: Image.asset(
              'assets/images/zorro_logo.png', // Asegúrate de tener tu logo aquí
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required IconData icon, required String text, required String linkText, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text(linkText, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
