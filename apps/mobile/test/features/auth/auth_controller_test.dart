import 'package:doc_find/core/constants/app_constants.dart';
import 'package:doc_find/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:doc_find/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:doc_find/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockAuthDataSource dataSource;
  late AuthRepositoryImpl repository;
  late AuthController controller;

  setUp(() {
    dataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(dataSource: dataSource);
    controller = AuthController(repository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('AuthController', () {
    test('logs in successfully with mock demo credentials', () async {
      final bool success = await controller.login(
        AppConstants.mockDemoEmail,
        AppConstants.mockDemoPassword,
      );

      expect(success, isTrue);
      expect(controller.state.isAuthenticated, isTrue);
      expect(controller.state.user?.name, 'K. N.');
      expect(controller.state.errorMessage, isNull);
    });

    test('logs in successfully using phone number', () async {
      final bool success = await controller.login(
        '670000000',
        AppConstants.mockDemoPassword,
      );

      expect(success, isTrue);
      expect(controller.state.isAuthenticated, isTrue);
    });

    test('fails login with invalid password and sets error', () async {
      final bool success = await controller.login(
        AppConstants.mockDemoEmail,
        'wrongpassword',
      );

      expect(success, isFalse);
      expect(controller.state.isAuthenticated, isFalse);
      expect(controller.state.errorMessage, isNotNull);
    });

    test('registers successfully with consent granted', () async {
      final bool success = await controller.register(
        name: 'Jean Paul',
        phone: '690112233',
        email: 'jean@docfind.cm',
        password: 'password123',
        consentGranted: true,
      );

      expect(success, isTrue);
      expect(controller.state.isAuthenticated, isTrue);
      expect(controller.state.user?.name, 'Jean Paul');
    });

    test('fails registration if consent is not granted', () async {
      final bool success = await controller.register(
        name: 'Jean Paul',
        phone: '690112233',
        email: 'jean@docfind.cm',
        password: 'password123',
        consentGranted: false,
      );

      expect(success, isFalse);
      expect(controller.state.isAuthenticated, isFalse);
      expect(controller.state.errorMessage, contains('Law No. 2024/017'));
    });

    test('fails registration if email already exists', () async {
      final bool success = await controller.register(
        name: 'Duplicate User',
        phone: '699999999',
        email: AppConstants.mockDemoEmail,
        password: 'password123',
        consentGranted: true,
      );

      expect(success, isFalse);
      expect(controller.state.errorMessage, contains('already exists'));
    });

    test('logs out and clears state', () async {
      await controller.login(
        AppConstants.mockDemoEmail,
        AppConstants.mockDemoPassword,
      );
      expect(controller.state.isAuthenticated, isTrue);

      await controller.logout();
      expect(controller.state.isAuthenticated, isFalse);
      expect(controller.state.user, isNull);
    });
  });
}
