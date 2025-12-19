part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];

  bool get isLoading => this is RegisterSubmitting;
}

class RegisterIdle extends RegisterState {
  const RegisterIdle();
}

class RegisterSubmitting extends RegisterState {
  const RegisterSubmitting();
}

class RegisterSuccess extends RegisterState {
  final UserEntity user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterError extends RegisterState {
  final BaseException exception;
  final Map<String, String> errors;

  const RegisterError(this.exception, this.errors);

  @override
  List<Object?> get props => [exception, errors];
}

