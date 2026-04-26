import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app_template/core/domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    String? name,
    String? username,
    String? avatar,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@freezed
abstract class UserResponseDto with _$UserResponseDto {
  const factory UserResponseDto({
    required UserDto data,
  }) = _UserResponseDto;

  factory UserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserResponseDtoFromJson(json);
}

extension UserDtoMapper on UserDto {
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        username: username,
        avatarUrl: avatar,
        emailVerifiedAt: emailVerifiedAt != null
            ? DateTime.tryParse(emailVerifiedAt!)
            : null,
      );
}
