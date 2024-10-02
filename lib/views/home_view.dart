// lib/views/home_view.dart
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildPublicationInput(),
          const SizedBox(height: 16.0),
          _buildFilters(),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: [
                _buildPostCard(
                  author: 'Juan Pérez',
                  title: 'Mis vacaciones en la playa',
                  description:
                      'Pasé un tiempo increíble en la playa, el clima fue perfecto.',
                ),
                const SizedBox(height: 16.0),
                _buildPostCard(
                  author: 'María López',
                  title: 'Receta de galletas',
                  description:
                      'Aquí te muestro cómo hacer unas deliciosas galletas.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationInput() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: '¿Qué estás pensando?',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 1')),
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 2')),
        ElevatedButton(onPressed: () {}, child: const Text('Filtro 3')),
      ],
    );
  }

  Widget _buildPostCard(
      {required String author,
      required String title,
      required String description}) {
    return Center(
      // Centra la tarjeta
      child: SizedBox(
        width: 600, // Ancho máximo de la tarjeta
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(
              horizontal: 16.0), // Reduce el espacio horizontal
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person,
                        color: Colors.purple), // Icono de usuario
                    const SizedBox(width: 8.0),
                    Text(author,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey)),
                ),
                const SizedBox(height: 8.0),
                Text(description),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite,
                      color: Colors.red), // Icono de corazón
                  label: const Text('Me gusta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
