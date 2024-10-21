import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html; // Importar dart:html para acceso a localStorage
import 'login_viewmodel.dart';

class HomeViewModel with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  LoginViewModel _loginViewModel;

  HomeViewModel(this._loginViewModel);

  List<Map<String, dynamic>> get posts => _posts;

  bool get isLoggedIn => _loginViewModel.loggedInUser.isNotEmpty;

  // Getter para acceder al nombre de usuario logueado
  String get loggedInUser => _loginViewModel.loggedInUser;

  void updateLoginViewModel(LoginViewModel loginViewModel) {
    _loginViewModel = loginViewModel;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    try {
      final url = Uri.parse(
          "https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
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
                  'likes': entry.value['likes'] ?? [], // Se añade el campo de 'likes'
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
    if (_loginViewModel.loggedInUser.isEmpty) {
      throw Exception("Debes iniciar sesión para publicar.");
    }

    final postData = {
      "author": _loginViewModel.loggedInUser,
      "title": title,
      "description": description,
      "timestamp": DateTime.now().toIso8601String(),
      "likes": [], // Se inicializa una lista vacía para los 'likes'
    };

    try {
      final url = Uri.parse(
          "https://red-social-961f9-default-rtdb.firebaseio.com/posts.json");
      final response = await http.post(url, body: json.encode(postData));

      if (response.statusCode == 200) {
        await fetchPosts();
      } else {
        throw Exception("Error al publicar.");
      }
    } catch (e) {
      throw Exception("Error al publicar: $e");
    }
  }

  Future<void> toggleLike(String postId, BuildContext context) async {
    if (_loginViewModel.loggedInUser.isEmpty) {
      // Muestra un mensaje de error en lugar de lanzar una excepción
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes iniciar sesión para dar un like.")),
      );
      return; // Sale del método si no está logueado
    }

    final postIndex = _posts.indexWhere((post) => post['id'] == postId);
    if (postIndex != -1) {
      List<String> likes = List<String>.from(_posts[postIndex]['likes']);
      final user = _loginViewModel.loggedInUser;

      if (likes.contains(user)) {
        likes.remove(user); // Si ya dio like, lo quita
      } else {
        likes.add(user); // Si no ha dado like, lo añade
      }

      try {
        final url = Uri.parse(
            "https://red-social-961f9-default-rtdb.firebaseio.com/posts/$postId.json");
        final response = await http.patch(
          url,
          body: json.encode({'likes': likes}),
        );

        if (response.statusCode == 200) {
          // Actualiza la lista local de posts
          _posts[postIndex]['likes'] = likes;
          notifyListeners(); // Notifica a los listeners para que actualicen la UI
        } else {
          // Si la actualización falla, almacenar en localStorage para sincronizar
          await _storePendingLike(postId, likes);
        }
      } catch (e) {
        // Si hay un error, almacenar en localStorage para sincronizar
        await _storePendingLike(postId, likes);
      }
    }
  }

  Future<void> _storePendingLike(String postId, List<String> likes) async {
    // Obtener likes pendientes existentes
    List<Map<String, dynamic>> pendingLikes = jsonDecode(
        (html.window.localStorage['pendingLikes'] ?? '[]'));

    // Agregar nueva acción de like a los pendientes
    pendingLikes.add({'postId': postId, 'likes': likes});

    // Guardar likes pendientes en localStorage
    html.window.localStorage['pendingLikes'] = jsonEncode(pendingLikes);
  }
}
