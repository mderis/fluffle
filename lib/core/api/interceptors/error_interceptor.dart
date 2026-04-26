import 'dart:io';

import 'package:dio/dio.dart';

import 'package:app_template/core/domain/failures/failure.dart';

/// Maps [DioException] to domain [Failure] types.
///
/// Throws a [Failure] subclass so repositories can catch it
/// directly in their try/catch blocks.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
      ),
    );
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timed out');

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _mapStatusCode(err);

      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Request cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: 'Invalid certificate');

      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          return const NetworkFailure();
        }
        return ServerFailure(message: err.message ?? 'Unknown error');
    }
  }

  Failure _mapStatusCode(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final message = data is Map ? data['message'] as String? : null;

    return switch (statusCode) {
      401 => AuthFailure(message: message ?? 'Unauthorized'),
      403 => AuthFailure(message: message ?? 'Forbidden'),
      422 => ValidationFailure(
          message: message ?? 'Validation failed',
          fieldErrors: _extractFieldErrors(data),
        ),
      final code? when code >= 400 && code < 500 => ServerFailure(
          message: message ?? 'Client error',
          statusCode: code,
        ),
      _ => ServerFailure(
          message: message ?? 'Server error',
          statusCode: statusCode,
        ),
    };
  }

  Map<String, List<String>> _extractFieldErrors(dynamic data) {
    if (data is! Map) return {};
    final errors = data['errors'];
    if (errors is! Map) return {};
    return errors.map(
      (key, value) => MapEntry(
        key.toString(),
        (value is List)
            ? value.map((e) => e.toString()).toList()
            : [value.toString()],
      ),
    );
  }
}
