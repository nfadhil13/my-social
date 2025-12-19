part of 'exception.dart';

class FormException extends BaseException {
  final Map<String, String> errors;
  const FormException({required this.errors, required super.message})
    : super(knownException: KnownException.formException);

  @override
  List<Object?> get props => [errors, ...super.props];
}
