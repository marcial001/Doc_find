/// Base class for all domain and data failures.
sealed class Failure {
  const Failure(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' (code: $code)' : ''}';
}

/// Validation failure for form inputs.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

/// Authentication failure.
final class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

/// Network or offline failure.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

/// Server or generic unknown failure.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

/// Permission denied failure (camera, location).
final class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.code]);
}
