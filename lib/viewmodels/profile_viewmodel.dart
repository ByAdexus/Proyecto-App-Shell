import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileViewModel with ChangeNotifier {
  String _username = '';
  String _email = '';
  final List<Map<String, dynamic>> _posts = [];

  String get username => _username;
  String get email => _email;
  List<Map<String, dynamic>> get posts => _posts;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // Cargar datos del usuario con manejo de posibles valores nulos
  Future<void> loadUserData(String username) async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/users.json");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          data.forEach((key, user) {
            if (user['username'] == username) {
              _username = user['username'] ?? ''; // Manejar posibles valores nulos
              _email = user['email'] ?? ''; // Manejar posibles valores nulos
            }
          });
        }
      } else {
        throw Exception("Error al cargar los datos del usuario. Código de estado: ${response.statusCode}");
      }
    } catch (error) {
      print("Error al cargar los datos del usuario: $error");
      throw Exception("Error al cargar los datos del usuario: $error");
    }
    notifyListeners();
  }

  // Cargar publicaciones del usuario con manejo de posibles valores nulos
  Future<void> loadUserPosts(String username) async {
    if (_posts.isNotEmpty) return; // Evita recargar si ya están cargadas
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        _posts.clear(); // Limpia las publicaciones antes de cargar
        if (data != null) {
          data.forEach((key, post) {
            if (post['author'] == username) {
              _posts.add({
                'title': post['title'] ?? 'Sin título', // Manejar posibles valores nulos
                'description': post['description'] ?? 'Sin descripción', // Manejar posibles valores nulos
                'timestamp': post['timestamp'] ?? '', // Manejar posibles valores nulos
                'id': key,
              });
            }
          });
        }
      } else {
        throw Exception("Error al cargar las publicaciones. Código de estado: ${response.statusCode}");
      }
    } catch (error) {
      print("Error al cargar las publicaciones: $error");
      throw Exception("Error al cargar las publicaciones: $error");
    }
    notifyListeners();
  }

  // Eliminar publicación
  Future<void> deletePost(String postId) async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts/$postId.json");
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _posts.removeWhere((post) => post['id'] == postId);
        notifyListeners();
      } else {
        throw Exception("Error al eliminar la publicación. Código de estado: ${response.statusCode}");
      }
    } catch (error) {
      print("Error al eliminar la publicación: $error");
      throw Exception("Error al eliminar la publicación: $error");
    }
  }

  // Actualizar publicación
  Future<void> updatePost(String postId, String title, String description) async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts/$postId.json");
      final response = await http.patch(
        url,
        body: json.encode({
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode == 200) {
        final index = _posts.indexWhere((post) => post['id'] == postId);
        if (index != -1) {
          _posts[index]['title'] = title;
          _posts[index]['description'] = description;
          notifyListeners();
        }
      } else {
        throw Exception("Error al actualizar la publicación. Código de estado: ${response.statusCode}");
      }
    } catch (error) {
      print("Error al actualizar la publicación: $error");
      throw Exception("Error al actualizar la publicación: $error");
    }
  }
}
