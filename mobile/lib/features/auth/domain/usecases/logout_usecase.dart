import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/core/types/usecase.dart';
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUsecase extends UsecaseNoParams<Nothing> {
  final AuthRepo _repo;
  LogoutUsecase(super.sessionHandler, this._repo);

  @override
  Future<Resource<Nothing>> execute() => _repo.logout().asResource;
}
