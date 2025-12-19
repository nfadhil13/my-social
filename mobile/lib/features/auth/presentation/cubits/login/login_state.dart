part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];

  bool get isLoading => this is LoginSubmitting;
}

class LoginIdle extends LoginState {
  const LoginIdle();
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final BaseException exception;
  final Map<String, String> errors;

  const LoginError(this.exception, this.errors);

  @override
  List<Object?> get props => [exception, errors];
}
