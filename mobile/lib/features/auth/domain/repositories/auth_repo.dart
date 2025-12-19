import 'package:fdl_types/fdl_types.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';

abstract class AuthRepo {
  Future<RepoResult<UserEntity>> login(LoginFormEntity loginForm);
  Future<RepoResult<UserEntity>> register(RegisterFormEntity registerForm);
  Future<RepoResult<Nothing>> logout();
}
