import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerudos/viewmodels/home_viewmodel.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';

void main() {
  late HomeViewModel homeViewModel;
  late LoginViewModel loginViewModel;

  setUp(() {
    loginViewModel = LoginViewModel();
    homeViewModel = HomeViewModel(loginViewModel);
  });

  group('HomeViewModel', () {
    test('should fetch posts successfully', () async {
      // Mocking a successful HTTP response for fetching posts
      // Implement a mocking strategy for HTTP requests as needed
      await homeViewModel.fetchPosts();
      expect(homeViewModel.posts, isNotEmpty);
    });

    test('should throw error on failed post fetch', () async {
      // Implementar una simulación para que falle la carga de publicaciones
      expect(() => homeViewModel.fetchPosts(), throwsException);
    });

    test('should allow adding a post when logged in', () async {
      loginViewModel.setLoggedInUser('TestUser');

      await homeViewModel.addPost('Test Title', 'Test Description');
      expect(homeViewModel.posts, isNotEmpty);
    });

    test('should throw error when trying to add post without login', () async {
      expect(() => homeViewModel.addPost('Test Title', 'Test Description'), throwsException);
    });

    test('should toggle like for a post', (BuildContext context) async {
      // Simular un post y que el usuario esté logueado
      loginViewModel.setLoggedInUser('TestUser');
      await homeViewModel.toggleLike('postId', context);

      // Verifica que el like se haya añadido
      // Ajustar según la lógica de tu aplicación
    } as Function());
  });
}
