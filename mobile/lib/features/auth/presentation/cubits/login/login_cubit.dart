import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social/features/auth/domain/usecases/login_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends FormCubit<Nothing, LoginFormEntity, UserEntity> {
  final LoginUsecase _loginUsecase;

  LoginCubit(this._loginUsecase)
    : super(initialState: FormCubitReady(initialData: Nothing()));

  @override
  Future<Resource<UserEntity>> submitUsecase(LoginFormEntity data) {
    return _loginUsecase(data);
  }

  Future<void> login(LoginFormEntity form) async {
    await submit(form);
  }
}

typedef LoginCubitState = FormCubitState<Nothing, UserEntity>;
typedef LoginCubitPreparing = FormCubitPreparing<Nothing, UserEntity>;
typedef LoginCubitReady = FormCubitReady<Nothing, UserEntity>;
typedef LoginCubitPrepareError = FormCubitPrepareError<Nothing, UserEntity>;
typedef LoginCubitSubmitting = FormCubitSubmitting<Nothing, UserEntity>;
typedef LoginCubitSubmitSuccess = FormCubitSubmitSuccess<Nothing, UserEntity>;
typedef LoginCubitSubmitError = FormCubitSubmitError<Nothing, UserEntity>;
