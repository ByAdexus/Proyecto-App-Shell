import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_viewmodel.dart';

class HomeViewModel with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  LoginViewModel _loginViewModel;

  HomeViewModel(this._loginViewModel);

  List<Map<String, dynamic>> get posts => _posts;
  
  // Esta línea asume que el LoginViewModel tiene un método o propiedad llamada loggedInUser que devuelve un String.
  bool get isLoggedIn => _loginViewModel.loggedInUser.isNotEmpty;

  void updateLoginViewModel(LoginViewModel loginViewModel) {
    _loginViewModel = loginViewModel;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;

        _posts = data != null
            ? data.entries.map((entry) {
                return {
                  'id': entry.key,
                  'author': entry.value['author'],
                  'title': entry.value['title'],
                  'description': entry.value['description'],
                  'timestamp': entry.value['timestamp'],
                };
              }).toList()
            : [];
        notifyListeners();
      } else {
        throw Exception("Error al cargar las publicaciones.");
      }
    } catch (e) {
      throw Exception("Error al cargar las publicaciones: $e");
    }
  }

  Future<void> addPost(String title, String description) async {
    // Asegúrate de que el usuario esté autenticado antes de permitir agregar una publicación.
    if (_loginViewModel.loggedInUser.isEmpty) {
      throw Exception("Debes iniciar sesión para publicar.");
    }

    final postData = {
      "author": _loginViewModel.loggedInUser,
      "title": title,
      "description": description,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final url = Uri.parse("https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
      final response = await http.post(url, body: json.encode(postData));

      if (response.statusCode == 200) {
        await fetchPosts();  // Espera a que se obtengan las publicaciones después de añadir.
      } else {
        throw Exception("Error al publicar.");
      }
    } catch (e) {
      throw Exception("Error al publicar: $e");
    }
  }
}
