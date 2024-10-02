// lib/components/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      color: Colors.grey[200], // Fondo claro
      padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 10), // Espacio antes del logo
          Center(
            child: Image.asset(
              './fox_logo.png', // Asegúrate de tener tu logo aquí
              height: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      {required IconData icon,
      required String text,
      required String linkText,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(linkText, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
