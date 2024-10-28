import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kerudos/viewmodels/home_viewmodel.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';
import 'dart:convert';

class TestLoginViewModel extends ChangeNotifier implements LoginViewModel {
  String _loggedInUser = '';

  @override
  String get loggedInUser => _loggedInUser;

  void logIn(String user) {
    _loggedInUser = user;
    notifyListeners();
  }

  // Métodos no implementados
  @override
  Future<void> login() => Future.value();

  @override
  void logout() {}

  @override
  void setLoggedInUser(String username) {}

  @override
  void setPassword(String password) {}

  @override
  void setUsername(String username) {}

  @override
  String get username => '';
}

void main() {
  group('HomeViewModel Tests', () {
    late HomeViewModel homeViewModel;
    late TestLoginViewModel testLoginViewModel;

    setUp(() {
      testLoginViewModel = TestLoginViewModel();
      homeViewModel = HomeViewModel(testLoginViewModel);
    });

    test('debería inicializarse con una lista vacía de publicaciones', () {
      expect(homeViewModel.posts, isEmpty);
      print('Prueba 1: Inicialización exitosa con lista vacía.');
    });

    test('debería poder agregar una publicación y recuperarla', () async {
      testLoginViewModel.logIn('Usuario1');
      homeViewModel.updateLoginViewModel(testLoginViewModel);

      // Agregar una publicación
      await homeViewModel.addPost('Título de prueba', 'Descripción de prueba');
      print('Prueba 2: Publicación agregada.');

      // Verificar que se agregó la publicación
      expect(homeViewModel.posts.length, 1);
      expect(homeViewModel.posts.first['title'], 'Título de prueba');
      expect(homeViewModel.posts.first['description'], 'Descripción de prueba');
      expect(homeViewModel.posts.first['author'], 'Usuario1');
      print('Prueba 2: Verificación exitosa de la publicación agregada.');
    });

    test('debería poder recuperar publicaciones desde la API', () async {
      testLoginViewModel.logIn('Usuario1');
      homeViewModel.updateLoginViewModel(testLoginViewModel);

      // Agregar una publicación
      await homeViewModel.addPost('Título de prueba', 'Descripción de prueba');
      print('Prueba 3: Publicación agregada antes de recuperar.');

      // Recuperar publicaciones desde la API
      await homeViewModel.fetchPosts();
      print('Prueba 3: Recuperación de publicaciones desde la API.');

      // Verificar que la publicación está en la lista
      expect(homeViewModel.posts.length, 1);
      expect(homeViewModel.posts.first['title'], 'Título de prueba');
      expect(homeViewModel.posts.first['description'], 'Descripción de prueba');
      expect(homeViewModel.posts.first['author'], 'Usuario1');
      print('Prueba 3: Verificación exitosa de la publicación recuperada.');
    });
  });
}
