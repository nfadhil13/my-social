import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';

abstract class AuthNetworkDts {
  Future<UserEntity> login(LoginFormEntity loginForm);
  Future<UserEntity> register(RegisterFormEntity registerForm);
  Future<void> logout();
}
