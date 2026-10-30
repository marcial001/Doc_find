import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/data/datasources/mock_seed_data.dart';
import '../../../../shared/domain/entities/user.dart';

class MockAuthDataSource {
  MockAuthDataSource() {
    _users.add(MockSeedData.mockUser);
    _passwords[MockSeedData.mockUser.email] = AppConstants.mockDemoPassword;
    _passwords[MockSeedData.mockUser.phone] = AppConstants.mockDemoPassword;
  }

  final List<User> _users = <User>[];
  final Map<String, String> _passwords = <String, String>{};
  User? _currentUser;

  Future<Result<User>> login(String emailOrPhone, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final String trimmed = emailOrPhone.trim();
    final String normalizedPhone = Validators.normalizePhone(trimmed);

    final User matchedUser = _users.firstWhere(
      (User u) =>
          u.email.toLowerCase() == trimmed.toLowerCase() ||
          u.phone == normalizedPhone,
      orElse: () => const User(id: '', name: '', email: '', phone: ''),
    );

    if (matchedUser.id.isEmpty) {
      return Result.failure(
        const AuthFailure('Invalid email/phone or password.'),
      );
    }

    final String? expectedPw =
        _passwords[matchedUser.email] ?? _passwords[matchedUser.phone];
    if (expectedPw != password) {
      return Result.failure(
        const AuthFailure('Invalid email/phone or password.'),
      );
    }

    _currentUser = matchedUser;
    return Result.success(matchedUser);
  }

  Future<Result<User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool consentGranted,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!consentGranted) {
      return Result.failure(
        const ValidationFailure(
          'Consent required under Law No. 2024/017 to create an account.',
        ),
      );
    }

    final String normalizedPhone = Validators.normalizePhone(phone);
    final String cleanEmail = email.trim().toLowerCase();

    final bool exists = _users.any(
      (User u) =>
          u.email.toLowerCase() == cleanEmail || u.phone == normalizedPhone,
    );
    if (exists) {
      return Result.failure(
        const AuthFailure(
          'An account with this email or phone number already exists.',
        ),
      );
    }

    final User newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      phone: normalizedPhone,
    );

    _users.add(newUser);
    _passwords[cleanEmail] = password;
    _passwords[normalizedPhone] = password;
    _currentUser = newUser;

    return Result.success(newUser);
  }

  Future<Result<User?>> getCurrentUser() async {
    return Result.success(_currentUser);
  }

  Future<Result<User>> updateProfile(User user) async {
    final int index = _users.indexWhere((User u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
    _currentUser = user;
    return Result.success(user);
  }

  Future<Result<void>> logout() async {
    _currentUser = null;
    return Result.success(null);
  }
}
