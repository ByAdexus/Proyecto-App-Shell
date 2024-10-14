import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileViewModel with ChangeNotifier {
  String _username = '';
  String _email = '';
  List<Map<String, dynamic>> _posts = [];

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

  Future<void> loadUserData(String username) async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/users.json");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          data.forEach((key, user) {
            if (user['username'] == username) {
              _username = user['username'];
              _email = user['email'];
            }
          });
        }
      }
    } catch (error) {
      throw Exception("Error al cargar los datos del usuario: $error");
    }
    notifyListeners();
  }

  Future<void> loadUserPosts(String username) async {
    if (_posts.isNotEmpty) return; // Evita recargar si ya están cargadas
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        _posts.clear();
        if (data != null) {
          data.forEach((key, post) {
            if (post['author'] == username) {
              _posts.add({
                'title': post['title'],
                'description': post['description'],
                'timestamp': post['timestamp'],
                'id': key,
              });
            }
          });
        }
      }
    } catch (error) {
      throw Exception("Error al cargar las publicaciones: $error");
    }
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts/$postId.json");
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _posts.removeWhere((post) => post['id'] == postId);
        notifyListeners();
      } else {
        throw Exception("Error al eliminar la publicación");
      }
    } catch (error) {
      throw Exception("Error al eliminar la publicación: $error");
    }
  }

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
        throw Exception("Error al actualizar la publicación");
      }
    } catch (error) {
      throw Exception("Error al actualizar la publicación: $error");
    }
  }
}