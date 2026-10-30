import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({MockAuthDataSource? dataSource})
    : _dataSource = dataSource ?? MockAuthDataSource();

  final MockAuthDataSource _dataSource;

  @override
  Future<Result<User>> login(String emailOrPhone, String password) {
    return _dataSource.login(emailOrPhone, password);
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool consentGranted,
  }) {
    return _dataSource.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      consentGranted: consentGranted,
    );
  }

  @override
  Future<Result<User?>> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<Result<User>> updateProfile(User user) {
    return _dataSource.updateProfile(user);
  }

  @override
  Future<Result<void>> changePassword(
    String currentPassword,
    String newPassword,
  ) {
    return _dataSource.changePassword(currentPassword, newPassword);
  }

  @override
  Future<Result<void>> deleteAccount() {
    return _dataSource.deleteAccount();
  }

  @override
  Future<Result<void>> logout() {
    return _dataSource.logout();
  }
}
