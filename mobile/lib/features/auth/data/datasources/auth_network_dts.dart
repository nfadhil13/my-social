import 'package:my_social/core/session_handler/network/network_session.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';

abstract class AuthNetworkDts {
  Future<(NetworkSession, String)> login(LoginFormEntity loginForm);
  Future<String> register(RegisterFormEntity registerForm);
  Future<void> logout();
}
