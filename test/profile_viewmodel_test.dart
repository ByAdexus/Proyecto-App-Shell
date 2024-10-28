import 'package:flutter_test/flutter_test.dart';
import 'package:kerudos/viewmodels/profile_viewmodel.dart';

void main() {
  late ProfileViewModel profileViewModel;

  setUp(() {
    profileViewModel = ProfileViewModel();
  });

  group('ProfileViewModel', () {
    test('should set username correctly', () {
      profileViewModel.setUsername('TestUser');
      expect(profileViewModel.username, 'TestUser');
    });

    test('should set email correctly', () {
      profileViewModel.setEmail('test@example.com');
      expect(profileViewModel.email, 'test@example.com');
    });

    test('should load user data successfully', () async {
      // Mocking a successful HTTP response for user data
      // Implement a mocking strategy for HTTP requests as needed
      await profileViewModel.loadUserData('TestUser');
      expect(profileViewModel.username, 'TestUser');
      expect(profileViewModel.email, 'test@example.com'); // Ajustar según el mock
    });

    test('should throw error on failed user data load', () async {
      // Implementar una simulación para que falle la carga de datos
      expect(() => profileViewModel.loadUserData('InvalidUser'), throwsException);
    });
  });
}
