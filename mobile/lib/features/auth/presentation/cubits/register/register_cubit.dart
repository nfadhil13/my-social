import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/usecases/register_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterCubit extends FormCubit<Nothing, RegisterFormEntity, Nothing> {
  final RegisterUsecase _registerUsecase;

  RegisterCubit(this._registerUsecase)
    : super(initialState: FormCubitReady(initialData: null));

  @override
  Future<Resource<Nothing>> submitUsecase(RegisterFormEntity data) {
    return _registerUsecase(data);
  }

  Future<void> register(RegisterFormEntity form) async {
    await submit(form);
  }
}

typedef RegisterFormState = FormCubitState<Nothing, Nothing>;
typedef RegisterFormPreparing = FormCubitPreparing<Nothing, Nothing>;
typedef RegisterFormReady = FormCubitReady<Nothing, Nothing>;
typedef RegisterFormPrepareError = FormCubitPrepareError<Nothing, Nothing>;
typedef RegisterFormSubmitting = FormCubitSubmitting<Nothing, Nothing>;
typedef RegisterFormSubmitSuccess = FormCubitSubmitSuccess<Nothing, Nothing>;
typedef RegisterFormSubmitError = FormCubitSubmitError<Nothing, Nothing>;
