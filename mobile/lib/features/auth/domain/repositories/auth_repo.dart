import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';

abstract class AuthRepo {
  Future<RepoResult<Nothing>> login(LoginFormEntity loginForm);
  Future<RepoResult<Nothing>> register(RegisterFormEntity registerForm);
  Future<RepoResult<Nothing>> logout();
}
