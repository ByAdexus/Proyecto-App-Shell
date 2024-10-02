import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  // Lista de contactos
  final List<Contact> contacts = [
    Contact(name: 'Alice', message: 'Hola! ¿Cómo estás?', time: '10:30 AM'),
    Contact(name: 'Bob', message: '¿Listo para la reunión?', time: '9:45 AM'),
  ];

  // La pestaña actual seleccionada
  String? currentChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Row(
        children: [
          // Lista de contactos a la izquierda
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.message),
                  trailing: Text(contact.time),
                  onTap: () {
                    setState(() {
                      currentChat = contact
                          .name; // Cambia a la pestaña de chat correspondiente
                    });
                  },
                );
              },
            ),
          ),
          // Vista de chat a la derecha
          Expanded(
            flex: 2,
            child: currentChat != null
                ? ChatTab(contactName: currentChat!)
                : const Center(
                    child: Text('Selecciona un contacto para chatear')),
          ),
        ],
      ),
    );
  }
}

// Clase para los contactos
class Contact {
  final String name;
  final String message;
  final String time;

  Contact({required this.name, required this.message, required this.time});
}

// Vista del chat para el contacto seleccionado
class ChatTab extends StatelessWidget {
  final String contactName;

  const ChatTab({super.key, required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(contactName),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Número de mensajes de ejemplo
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Mensaje ${index + 1}'), // Mensajes de ejemplo
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Acción de enviar mensaje (puedes agregar la lógica aquí)
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
