import 'package:equatable/equatable.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_cubit_state.dart';

/// [FormCubit] is a cubit that is used to manage a form.
/// [InitialData] is the initial data of the form.
/// [FormData] is the data of the form.
/// [Result] is the result of the form.
abstract class FormCubit<InitialData, FormData, Result>
    extends Cubit<FormCubitState<InitialData, Result>> {
  /// [FormCubit] constructor.
  /// [formCubitPreparing] is the initial state of the form cubit.
  /// [initialState] is the initial state of the form cubit.
  FormCubit({FormCubitState<InitialData, Result>? initialState})
    : super(initialState ?? FormCubitPreparing());

  /// [submitUsecase] is the usecase that is used to submit the form.
  /// [FormData] is the data of the form.
  /// [Result] is the result of the form.
  Future<Resource<Result>> submitUsecase(FormData data);

  /// [prepareUsecase] is the usecase that is used to prepare the form.
  /// [InitialData] is the initial data of the form.
  /// [prepareUsecase] can be null.
  /// If [prepareUsecase] is null, the form cubit will not prepare the data.
  Future<Resource<InitialData>>? prepareUsecase() {
    return null;
  }

  /// [onSuccessSubmit] is the function that is called when the form is submitted successfully.
  /// [Success] is the success result of the form.
  /// You can override this function to handle the success result.
  void onSuccessSubmit(Success<Result> result) {}

  /// [onErrorSubmit] is the function that is called when the form is submitted with an error.
  /// [BaseException] is the exception of the form.
  /// You can override this function to handle the error.
  void onErrorSubmit(BaseException exception) {}

  /// [prepare] is the function that is called to prepare the form.
  /// You can override this function to handle the prepare.
  /// [prepareUsecase] is the usecase that is used to prepare the form.
  /// [InitialData] is the initial data of the form.
  /// [prepareUsecase] can be null.
  /// If [prepareUsecase] is null, the form cubit will not prepare the data.
  Future<void> prepare() async {
    emit(FormCubitPreparing());
    final result = await prepareUsecase();
    if (result == null) {
      emit(FormCubitReady(initialData: null));
      return;
    }
    switch (result) {
      case Success():
        emit(FormCubitReady(initialData: result.data));
      case Failure():
        emit(FormCubitPrepareError(result.exception, prepare));
    }
  }

  /// [submit] is the function that is called to submit the form.
  /// [FormData] is the data of the form.
  /// You can override this function to handle the submit.
  Future<void> submit(FormData data) async {
    final state = this.state;
    if (state is! FormCubitReady<InitialData, Result> ||
        state is FormCubitSubmitting) {
      return;
    }
    emit(FormCubitSubmitting(initialData: state.initialData));
    final result = await submitUsecase(data);
    switch (result) {
      case Success():
        onSuccessSubmit(result);
        emit(
          FormCubitSubmitSuccess(
            message: result.message,
            initialData: state.initialData,
            resultData: result.data,
          ),
        );
      case Failure():
        final exception = result.exception;
        final errors = exception is ApiFormException
            ? exception.errors
            : <String, List<String>>{};

        onErrorSubmit(result.exception);
        emit(
          FormCubitSubmitError(
            result.exception,
            errors,
            initialData: state.initialData,
          ),
        );
    }
  }
}
