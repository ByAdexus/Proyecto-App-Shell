import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('Menú de Navegación'),
          ),
          ListTile(
            title: Text('Inicio'),
            onTap: null,
          ),
          ListTile(
            title: Text('Perfil'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
