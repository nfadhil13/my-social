import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social/features/auth/domain/usecases/register_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterCubit extends FormCubit<Nothing, RegisterFormEntity, UserEntity> {
  final RegisterUsecase _registerUsecase;

  RegisterCubit(this._registerUsecase)
    : super(initialState: FormCubitReady(initialData: null));

  @override
  Future<Resource<UserEntity>> submitUsecase(RegisterFormEntity data) {
    return _registerUsecase(data);
  }

  Future<void> register(RegisterFormEntity form) async {
    await submit(form);
  }
}

typedef RegisterFormState = FormCubitState<Nothing, UserEntity>;
typedef RegisterFormPreparing = FormCubitPreparing<Nothing, UserEntity>;
typedef RegisterFormReady = FormCubitReady<Nothing, UserEntity>;
typedef RegisterFormPrepareError = FormCubitPrepareError<Nothing, UserEntity>;
typedef RegisterFormSubmitting = FormCubitSubmitting<Nothing, UserEntity>;
typedef RegisterFormSubmitSuccess = FormCubitSubmitSuccess<Nothing, UserEntity>;
typedef RegisterFormSubmitError = FormCubitSubmitError<Nothing, UserEntity>;
