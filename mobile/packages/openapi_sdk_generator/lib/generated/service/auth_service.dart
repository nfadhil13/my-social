import 'package:dio/dio.dart';
import '../models/index.dart';
import 'result/index.dart';

class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  Future<AuthRegisterPostApiResponse> postAuthRegister(
    RegisterRequest body,
  ) async {
    final response = await _dio.post('/auth/register', data: body.toJson());
    return AuthRegisterPostApiResponse.fromJson(
      (response.data as Map<String, dynamic>),
    );
  }

  Future<AuthLoginPostApiResponse> postAuthLogin(LoginRequest body) async {
    final response = await _dio.post('/auth/login', data: body.toJson());
    return AuthLoginPostApiResponse.fromJson(
      (response.data as Map<String, dynamic>),
    );
  }
}
