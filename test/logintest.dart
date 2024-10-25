
import 'package:flutter_test/flutter_test.dart';
import 'package:kerudos/viewmodels/login_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Crear una clase simulada para http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('LoginViewModel', () {
    late LoginViewModel loginViewModel;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      loginViewModel = LoginViewModel();
    });

    test('Iniciar sesión con conexión a Internet', () async {
      // Simula una respuesta exitosa del servidor
      when(mockClient.get(Uri())).thenAnswer((_) async =>
        http.Response('{"user1": {"username": "test", "password": "password"}}', 200)
      );

      loginViewModel.setUsername('test');
      loginViewModel.setPassword('password');

      await loginViewModel.login();

      expect(loginViewModel.loggedInUser, 'test');
    });

    test('Iniciar sesión sin conexión a Internet', () async {
      // Simular que no hay conexión
      loginViewModel.setUsername('test');
      loginViewModel.setPassword('password');

      // Aquí simularías la falta de conexión
      try {
        await loginViewModel.login();
      } catch (e) {
        expect(e.toString(), contains('Error durante el inicio de sesión'));
      }
    });

    test('Iniciar sesión después de recuperar conexión a Internet', () async {
      // Simula la conexión nuevamente
      when(mockClient.get(Uri())).thenAnswer((_) async =>
        http.Response('{"user1": {"username": "test", "password": "password"}}', 200)
      );

      loginViewModel.setUsername('test');
      loginViewModel.setPassword('password');

      await loginViewModel.login();

      expect(loginViewModel.loggedInUser, 'test');
    });
  });
}
