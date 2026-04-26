import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/config/app_config.dart';
import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/features/auth/data/datasources/auth_api.dart';
import 'package:app_template/features/auth/data/models/response/auth_response_dto.dart';
import 'package:app_template/features/auth/data/models/response/user_dto.dart';
import 'package:app_template/features/auth/domain/entities/auth_tokens.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final FlutterSecureStorage _storage;
  final AppConfig _config;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  AuthRepositoryImpl({
    required AuthApi api,
    required FlutterSecureStorage storage,
    required AppConfig config,
  })  : _api = api,
        _storage = storage,
        _config = config;

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.login({
        'grant_type': 'password',
        'client_id': _config.authClientId,
        'client_secret': _config.authClientSecret,
        'username': email,
        'password': password,
      });
      await _storeTokens(response);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _api.register({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'client_id': _config.authClientId,
        'client_secret': _config.authClientSecret,
      });
      await _storeTokens(response);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _api.logout();
      await _clearTokens();
      return const Right(unit);
    } on DioException catch (e) {
      await _clearTokens();
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final response = await _api.getCurrentUser();
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await _api.forgotPassword({'email': email});
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _api.resetPassword({
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    required String id,
    String? name,
    String? username,
  }) async {
    try {
      final body = <String, dynamic>{'id': id};
      if (name != null) body['name'] = name;
      if (username != null) body['username'] = username;
      final response = await _api.updateUser(body);
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_extractFailure(e));
    }
  }

  Future<void> _storeTokens(AuthResponseDto response) async {
    await _storage.write(key: _accessTokenKey, value: response.accessToken);
    await _storage.write(key: _refreshTokenKey, value: response.refreshToken);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Failure _extractFailure(DioException e) {
    return e.error is Failure
        ? e.error as Failure
        : ServerFailure(message: e.message ?? 'Unknown error');
  }
}
