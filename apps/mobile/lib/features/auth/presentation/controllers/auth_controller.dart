import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl();
});

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  final User? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState()) {
    checkAuthStatus();
  }

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    final Result<User?> result = await _repository.getCurrentUser();
    result.when(
      success: (User? user) {
        state = state.copyWith(user: user);
      },
      failure: (_) {},
    );
  }

  Future<bool> login(String emailOrPhone, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final Result<User> result = await _repository.login(emailOrPhone, password);

    return result.when(
      success: (User user) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      },
      failure: (Failure failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool consentGranted,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final Result<User> result = await _repository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      consentGranted: consentGranted,
    );

    return result.when(
      success: (User user) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      },
      failure: (Failure failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<void> updateProfile(User updated) async {
    state = state.copyWith(isLoading: true);
    final Result<User> result = await _repository.updateProfile(updated);
    result.when(
      success: (User user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      failure: (Failure failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (Ref ref) {
    final AuthRepository repository = ref.watch(authRepositoryProvider);
    return AuthController(repository);
  },
);
