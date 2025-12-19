part of 'form_cubit.dart';

/// [FormCubitState] is a sealed class that represents the state of a form cubit.
/// It is a subclass of [Equatable] and implements [FormCubitState].
/// It is used to represent the state of a form cubit.
/// [InitialData] is the initial data of the form cubit.
/// [InitialData] can be null
/// [ResultData] is the result data of the form cubit.
sealed class FormCubitState<InitialData, ResultData> extends Equatable {
  @override
  List<Object?> get props => [];

  bool get isLoading =>
      this is FormCubitPreparing || this is FormCubitSubmitting;
}

/// [FormCubitPreparing] is a sealed class that represents the state of a form cubit when it is preparing.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is preparing.
/// Will be emitted when [FormCubit.prepare] is called.
class FormCubitPreparing<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {}

/// [FormCubitPrepareError] is a sealed class that represents the state of a form cubit when it is preparing.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is preparing.
/// Will be emitted when [FormCubit.prepare] is called and there is an error returende from [FormCubit.prepareUsecase].
class FormCubitPrepareError<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {
  final BaseException exception;
  final void Function() onRetry;
  FormCubitPrepareError(this.exception, this.onRetry);

  @override
  List<Object?> get props => [exception, onRetry];
}

/// [FormCubitReady] is a sealed class that represents the state of a form cubit when it is ready.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is ready.
/// Will be emitted when [FormCubit.prepare] is called and there is no error.
/// When [FormCubit.prepareUsecase] is null [InitialData] will be null.
/// [InitialData] is the initial data of the form cubit.
/// [InitialData] can be null
class FormCubitReady<InitialData, ResultData>
    extends FormCubitState<InitialData, ResultData> {
  /// [initialData] is the initial data of the form cubit.
  /// [initialData] can be null
  /// Give [FormCubit.prepare] to initialize the initial data.
  final InitialData? initialData;

  FormCubitReady({required this.initialData});

  @override
  List<Object?> get props => [initialData];
}

/// [FormCubitSubmitSuccess] is a sealed class that represents the state of a form cubit when it is submitting.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is submitting.
/// Will be emitted when [FormCubit.submit] is called and there is no error.
/// [ResultData] is the result data of the form cubit.
/// [message] is the message of the form cubit.
class FormCubitSubmitSuccess<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  final ResultData resultData;
  final String message;
  FormCubitSubmitSuccess({
    required super.initialData,
    required this.resultData,
    required this.message,
  });

  @override
  List<Object?> get props => [resultData, initialData];
}

/// [FormCubitSubmitError] is a sealed class that represents the state of a form cubit when it is submitting.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is submitting.
/// Will be emitted when [FormCubit.submit] is called and there is an error returende from [FormCubit.submitUsecase].
/// [exception] is the exception of the form cubit.
/// [errors] is the errors of the form cubit. Can be used to show errors to the user.
class FormCubitSubmitError<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  final BaseException exception;
  final Map<String, String> errors;

  FormCubitSubmitError(
    this.exception,
    this.errors, {
    required super.initialData,
  });

  @override
  List<Object?> get props => [exception];
}

/// [FormCubitSubmitting] is a sealed class that represents the state of a form cubit when it is submitting.
/// It is a subclass of [FormCubitState].
/// It is used to represent the state of a form cubit when it is submitting (loading).
/// Will be emitted when [FormCubit.submit] is called.
/// [InitialData] is the initial data of the form cubit.
/// [InitialData] can be null
/// [ResultData] is the result data of the form cubit.
class FormCubitSubmitting<InitialData, ResultData>
    extends FormCubitReady<InitialData, ResultData> {
  FormCubitSubmitting({required super.initialData});
}
