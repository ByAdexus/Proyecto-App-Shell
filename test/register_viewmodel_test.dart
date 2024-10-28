import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerudos/viewmodels/register_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

void main() {
  late RegisterViewModel registerViewModel;

  setUp(() {
    registerViewModel = RegisterViewModel();
  });

  group('RegisterViewModel', () {
    test('should set username correctly', () {
      registerViewModel.setUsername('TestUser2');
      expect(registerViewModel.username, 'TestUser2');
    });

    test('should set password correctly', () {
      registerViewModel.setPassword('password123');
      expect(registerViewModel.password, 'password123');
    });

    test('should register user successfully', () async {
      // Simular contexto de Provider
      final context = _MockBuildContext();

      registerViewModel.setUsername('newuser2');
      registerViewModel.setPassword('password123');
      registerViewModel.setConfirmPassword('password123');

      await registerViewModel.register(context);
      expect(registerViewModel.isRegistered, true);
      expect(registerViewModel.isLoggedIn, true);
    });

    test('should throw error for empty username', () async {
      registerViewModel.setPassword('password123');
      registerViewModel.setConfirmPassword('password123');
      final context = _MockBuildContext();
      expect(() => registerViewModel.register(context), throwsException);
    });

    test('should throw error for mismatched passwords', () async {
      registerViewModel.setUsername('newuser3');
      registerViewModel.setPassword('password123');
      registerViewModel.setConfirmPassword('differentpassword');
      final context = _MockBuildContext();
      expect(() => registerViewModel.register(context), throwsException);
    });
  });
}

class _MockBuildContext extends Mock implements BuildContext {}
