// profile_view.dart
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es mayor a 800, mostrar el layout de 3 columnas
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                // Columna de Publicaciones
                Flexible(
                  flex: 2,
                  child: _buildPostsSection(),
                ),
                // Columna de Datos Personales
                Flexible(
                  flex: 1,
                  child: _buildUserProfileSection(context),
                ),
                // Columna de Configuración
                Flexible(
                  flex: 1,
                  child: _buildEditProfileSection(context),
                ),
              ],
            );
          }
          // Si el ancho es entre 600 y 800, mostrar 2 columnas
          else if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Flexible(
                  flex: 2,
                  child: _buildPostsSection(),
                ),
                Flexible(
                  flex: 1,
                  child: _buildUserProfileSection(context),
                ),
              ],
            );
          }
          // Si es más pequeño que 600, mostrar 1 columna y permitir cambiar entre secciones
          else {
            return _buildSingleColumnView(context);
          }
        },
      ),
    );
  }

  Widget _buildSingleColumnView(BuildContext context) {
    int _currentIndex = 0;
    List<Widget> _views = [
      _buildPostsSection(),
      _buildUserProfileSection(context),
      _buildEditProfileSection(context),
    ];

    return Column(
      children: [
        Expanded(
          child: _views[_currentIndex],
        ),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _currentIndex = index;
            (context as Element).markNeedsBuild(); // Force rebuild to show selected view
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Publicaciones'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Editar'),
          ],
        ),
      ],
    );
  }

  Widget _buildPostsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mis Publicaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.article),
                    title: Text('Publicación #${index + 1}'),
                    subtitle: const Text('Contenido de la publicación...'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos Personales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_image.jpg'), // Imagen de perfil (reemplazar con la tuya)
          ),
          const SizedBox(height: 16),
          const Text('Nombre: Juan Pérez', style: TextStyle(fontSize: 18)),
          const Text('Email: juan.perez@example.com', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Acción para modificar datos personales
            },
            child: const Text('Modificar Perfil'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar Perfil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Descripción:'),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Escribe una nueva descripción...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Acción para guardar cambios
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Descripción actualizada')),
              );
            },
            child: const Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }
}