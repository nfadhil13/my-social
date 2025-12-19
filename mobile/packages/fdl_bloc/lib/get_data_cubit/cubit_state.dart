part of 'get_cubit.dart';

/// [CubitState] is a sealed class that represents the state of a cubit.
/// It is a subclass of [Equatable] and implements [CubitState].
/// It is used to represent the state of a cubit.
/// [T] is the type of the data of the cubit.
sealed class CubitState<T> extends Equatable {
  const CubitState();

  const factory CubitState.error({
    required BaseException exception,
    required void Function() onRetry,
  }) = CubitErrorState;
  const factory CubitState.loading() = CubitLoadingState;
  const factory CubitState.success({
    required T data,
    bool isRefreshing,
    required String message,
  }) = CubitSuccessState;

  @override
  List<Object?> get props => [isLoading];

  bool get isLoading;
}

/// [CubitErrorState] is a sealed class that represents the state of a cubit when it is in an error state.
/// It is a subclass of [CubitState].
/// It is used to represent the state of a cubit when it is in an error state.
/// [T] is the type of the data of the cubit.
class CubitErrorState<T> extends CubitState<T> {
  final BaseException exception;
  final FutureOr<void> Function() onRetry;

  const CubitErrorState({required this.exception, required this.onRetry});

  @override
  List<Object?> get props => [...super.props, exception, onRetry];

  @override
  bool get isLoading => false;
}

/// [CubitLoadingState] is a sealed class that represents the state of a cubit when it is loading.
/// It is a subclass of [CubitState].
/// It is used to represent the state of a cubit when it is loading.
/// [T] is the type of the data of the cubit.
class CubitLoadingState<T> extends CubitState<T> {
  const CubitLoadingState();

  @override
  bool get isLoading => true;
}

/// [CubitSuccessState] is a sealed class that represents the state of a cubit when it is in a success state.
/// It is a subclass of [CubitState].
/// It is used to represent the state of a cubit when it is in a success state.
/// [T] is the type of the data of the cubit.
class CubitSuccessState<T> extends CubitState<T> {
  final T data;
  final bool isRefreshing;
  final String message;

  const CubitSuccessState({
    required this.data,
    this.isRefreshing = false,
    required this.message,
  });

  @override
  List<Object?> get props => [data, isRefreshing, message, ...super.props];

  CubitSuccessState<T> toggleRefresh(bool isRefreshing) => CubitSuccessState<T>(
    data: data,
    isRefreshing: isRefreshing,
    message: message,
  );

  @override
  bool get isLoading => isRefreshing;
}
