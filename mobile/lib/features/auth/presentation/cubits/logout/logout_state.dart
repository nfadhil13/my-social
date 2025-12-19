part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];

  bool get isLoading => this is LogoutLoading;
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

class LogoutError extends LogoutState {
  final BaseException exception;

  const LogoutError(this.exception);

  @override
  List<Object?> get props => [exception];
}

