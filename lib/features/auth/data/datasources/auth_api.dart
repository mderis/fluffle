import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:app_template/features/auth/data/models/response/auth_response_dto.dart';
import 'package:app_template/features/auth/data/models/response/user_dto.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/v1/oauth/token')
  Future<AuthResponseDto> login(@Body() Map<String, dynamic> body);

  @POST('/v1/register')
  Future<AuthResponseDto> register(@Body() Map<String, dynamic> body);

  @DELETE('/v1/logout')
  Future<void> logout();

  @GET('/v1/user/profile')
  Future<UserResponseDto> getCurrentUser();

  @POST('/v1/forgotpassword')
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  @POST('/v1/resetpassword')
  Future<void> resetPassword(@Body() Map<String, dynamic> body);

  @PUT('/v1/user')
  Future<UserResponseDto> updateUser(@Body() Map<String, dynamic> body);
}
