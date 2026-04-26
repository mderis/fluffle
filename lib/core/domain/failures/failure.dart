sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'Server error',
    super.code,
    this.statusCode,
  });
}

final class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.code});
}

final class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    super.message = 'Validation failed',
    super.code,
    this.fieldErrors = const {},
  });
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error', super.code});
}
