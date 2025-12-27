import 'package:fdl_types/fdl_types.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUsecase extends Usecase<LoginFormEntity, Nothing> {
  final AuthRepo _repo;
  LoginUsecase(super.sessionHandler, this._repo);

  @override
  Future<Resource<Nothing>> execute(LoginFormEntity params) =>
      _repo.login(params).asResource;
}
