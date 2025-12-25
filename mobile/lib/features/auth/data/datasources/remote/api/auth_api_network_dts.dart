import 'package:fdl_core/api_client/api_client.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/session_handler/network/network_session.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social_sdk/my_social_sdk.dart';

@Injectable(as: AuthNetworkDts, env: AppEnvironment.apiEnvironments)
class AuthApiNetworkDts implements AuthNetworkDts {
  final MySocialSdk _mySocialSdk;
  final SessionHandler _sessionHandler;
  AuthApiNetworkDts(this._mySocialSdk);

  AuthService get _authService => _mySocialSdk.authService;

  @override
  Future<UserEntity> login(LoginFormEntity loginForm) async {
    final result = await _authService.login(
      LoginRequest(email: loginForm.email, password: loginForm.password),
    );
    final user = result.data.user;
    _sessionHandler.setSession(
      NetworkSession(
        userId: user.id,
        email: user.email,
        token: result.data.accessToken,
        role: user.role.value,
      ),
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
