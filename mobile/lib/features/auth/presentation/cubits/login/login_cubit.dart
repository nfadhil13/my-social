import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/usecases/login_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends FormCubit<Nothing, LoginFormEntity, Nothing> {
  final LoginUsecase _loginUsecase;

  LoginCubit(this._loginUsecase)
    : super(initialState: FormCubitReady(initialData: Nothing()));

  @override
  Future<Resource<Nothing>> submitUsecase(LoginFormEntity data) {
    return _loginUsecase(data);
  }

  Future<void> login(LoginFormEntity form) async {
    await submit(form);
  }
}

typedef LoginCubitState = FormCubitState<Nothing, Nothing>;
typedef LoginCubitPreparing = FormCubitPreparing<Nothing, Nothing>;
typedef LoginCubitReady = FormCubitReady<Nothing, Nothing>;
typedef LoginCubitPrepareError = FormCubitPrepareError<Nothing, Nothing>;
typedef LoginCubitSubmitting = FormCubitSubmitting<Nothing, Nothing>;
typedef LoginCubitSubmitSuccess = FormCubitSubmitSuccess<Nothing, Nothing>;
typedef LoginCubitSubmitError = FormCubitSubmitError<Nothing, Nothing>;
