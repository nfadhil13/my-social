import 'package:fdl_types/fdl_types.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:my_social/features/auth/data/datasources/auth_local_dts.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthNetworkDts _authNetworkDts;
  final AuthLocalDts _authLocalDts;
  final SessionHandler _sessionHandler;

  AuthRepoImpl(this._authNetworkDts, this._authLocalDts, this._sessionHandler);

  @override
  Future<RepoResult<UserEntity>> login(LoginFormEntity loginForm) async {
    final user = await _authNetworkDts.login(loginForm);
    await _authLocalDts.saveUser(user);
    await _sessionHandler.setSession(SessionMocked(userId: user.id));
    return RepoResult(data: user);
  }

  @override
  Future<RepoResult<Nothing>> logout() async {
    await _authLocalDts.deleteUser();
    await _sessionHandler.clearSession();
    return RepoResult(data: Nothing());
  }

  @override
  Future<RepoResult<UserEntity>> register(
    RegisterFormEntity registerForm,
  ) async {
    final user = await _authNetworkDts.register(registerForm);
    await _authLocalDts.saveUser(user);
    return RepoResult(data: user);
  }
}
