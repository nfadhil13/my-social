import 'package:bloc/bloc.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:my_social/features/auth/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase _registerUsecase;

  RegisterCubit(this._registerUsecase) : super(const RegisterIdle());

  Future<void> register(RegisterFormEntity form) async {
    emit(const RegisterSubmitting());

    final result = await _registerUsecase(form);

    switch (result) {
      case Success(data: final user):
        emit(RegisterSuccess(user));
      case Failure(exception: final exception):
        emit(
          RegisterError(exception, {
            if (exception is FormException) ...exception.errors,
          }),
        );
    }
  }
}
