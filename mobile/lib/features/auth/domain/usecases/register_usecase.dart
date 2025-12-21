import 'package:fdl_types/fdl_types.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUsecase extends Usecase<RegisterFormEntity, UserEntity> {
  final AuthRepo _repo;
  RegisterUsecase(super.sessionHandler, this._repo);

  @override
  Future<Resource<UserEntity>> execute(RegisterFormEntity params) =>
      _repo.register(params).asResource;
}
