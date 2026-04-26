import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app_template/features/auth/domain/entities/auth_tokens.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

@freezed
abstract class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'token_type') required String tokenType,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}

extension AuthResponseDtoMapper on AuthResponseDto {
  AuthTokens toEntity() => AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
}
