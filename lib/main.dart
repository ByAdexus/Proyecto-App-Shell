import 'package:flutter/material.dart';
import 'components/sidebar.dart';  
import 'components/header.dart';   
import 'components/footer.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Shell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),                // Barra superior con opciones
      drawer: Sidebar(),                // Barra lateral fija
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Aquí irá el contenido dinámico (publicaciones, chats, etc.)',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),    // Pie de página
    );
  }
}
