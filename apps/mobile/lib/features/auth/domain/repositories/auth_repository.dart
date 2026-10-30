import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String emailOrPhone, String password);

  Future<Result<User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool consentGranted,
  });

  Future<Result<User?>> getCurrentUser();

  Future<Result<User>> updateProfile(User user);

  Future<Result<void>> changePassword(
    String currentPassword,
    String newPassword,
  );

  Future<Result<void>> deleteAccount();

  Future<Result<void>> logout();
}
