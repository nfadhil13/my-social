import 'package:fdl_types/fdl_types.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:my_social/features/auth/data/datasources/auth_local_dts.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthNetworkDts _authNetworkDts;
  final AuthLocalDts _authLocalDts;
  final SessionHandler _sessionHandler;

  AuthRepoImpl(this._authNetworkDts, this._authLocalDts, this._sessionHandler);

  @override
  Future<RepoResult<Nothing>> login(LoginFormEntity loginForm) async {
    final (session, message) = await _authNetworkDts.login(loginForm);
    await _sessionHandler.setSession(session);
    return RepoResult(data: const Nothing(), message: message);
  }

  @override
  Future<RepoResult<Nothing>> logout() async {
    await _authLocalDts.deleteUser();
    await _sessionHandler.clearSession();
    return RepoResult(data: Nothing());
  }

  @override
  Future<RepoResult<Nothing>> register(RegisterFormEntity registerForm) async {
    final result = await _authNetworkDts.register(registerForm);
    return RepoResult(data: const Nothing(), message: result);
  }
}
