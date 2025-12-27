import 'package:fdl_core/fdl_core.dart';
import 'package:fdl_types/exception/exception.dart';
import '../models/models.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<ResponseModel<RegisterResponse>> register(
    RegisterRequest? register, {
    bool shouldPrint = false,
  }) async {
    final response = await _client.post(
      path: '/auth/register',
      body: register?.toJson(),
      shouldPrint: shouldPrint,
    );

    if (response.data == null) {
      return throw ApiException(
        message: 'DATA_NULL',
        statusCode: 500,
        url: response.url,
      );
    }
    if (response.data is! Map<String, dynamic>) {
      return throw ApiException(
        message: 'DATA_UNKNOWN_TYPE',
        statusCode: 500,
        url: response.url,
      );
    }
    return ResponseModel.fromJson(
      response.data,
      RegisterResponse.fromJson(response.data["data"]),
    );
  }

  Future<ResponseModel<LoginResponse>> login(
    LoginRequest? login, {
    bool shouldPrint = false,
  }) async {
    final response = await _client.post(
      path: '/auth/login',
      body: login?.toJson(),
      shouldPrint: shouldPrint,
    );

    if (response.data == null) {
      return throw ApiException(
        message: 'DATA_NULL',
        statusCode: 500,
        url: response.url,
      );
    }
    if (response.data is! Map<String, dynamic>) {
      return throw ApiException(
        message: 'DATA_UNKNOWN_TYPE',
        statusCode: 500,
        url: response.url,
      );
    }
    return ResponseModel.fromJson(
      response.data,
      LoginResponse.fromJson(response.data["data"]),
    );
  }
}
