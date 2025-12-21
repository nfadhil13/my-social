import 'package:fdl_core/api_client/api_client.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';

@Injectable(as: AuthNetworkDts, env: AppEnvironment.apiEnvironments)
class AuthApiNetworkDts implements AuthNetworkDts {
  final ApiClient _apiClient;

  AuthApiNetworkDts(this._apiClient);

  @override
  Future<UserEntity> login(LoginFormEntity loginForm) async {
    final result = await _apiClient.post(
      path: 'auth/login',
      body: {'email': loginForm.email, 'password': loginForm.password},
    );
    return UserEntity(
      id: result.data['id'],
      fullName: result.data['fullName'],
      email: result.data['email'],
      password: loginForm.password,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> register(RegisterFormEntity registerForm) async {
    final result = await _apiClient.post(
      path: 'auth/register',
      body: {'email': registerForm.email, 'password': registerForm.password},
    );
    return UserEntity(
      id: result.data['id'],
      fullName: result.data['fullName'],
      email: result.data['email'],
      password: registerForm.password,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
