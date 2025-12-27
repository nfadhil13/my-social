import 'package:injectable/injectable.dart';
import 'package:my_social/core/session_handler/network/network_session.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/data/datasources/remote/api/mapper/request/login_request_mapper.dart';
import 'package:my_social/features/auth/data/datasources/remote/api/mapper/request/register_request_mapper.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social_sdk/my_social_sdk.dart';

@Injectable(as: AuthNetworkDts)
class AuthApiNetworkDts implements AuthNetworkDts {
  final MySocialSdk _mySocialSdk;
  final RegisterRequestMapper _registerRequestMapper;
  final LoginRequestMapper _loginRequestMapper;
  AuthApiNetworkDts(
    this._mySocialSdk,
    this._registerRequestMapper,
    this._loginRequestMapper,
  );

  AuthService get _authService => _mySocialSdk.authservice;

  @override
  Future<(NetworkSession, String)> login(LoginFormEntity loginForm) async {
    final result = await _authService.login(
      _loginRequestMapper.toData(loginForm),
    );
    return (
      NetworkSession(
        userId: result.data.user.id,
        email: result.data.user.email,
        token: result.data.accessToken,
        role: result.data.user.role.name,
      ),
      result.message,
    );
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<String> register(RegisterFormEntity registerForm) async {
    final result = await _authService.register(
      _registerRequestMapper.toData(registerForm),
    );
    return result.message;
  }
}
