part of 'exception.dart';

class ApiException extends BaseException {
  final int statusCode;
  final String url;

  const ApiException({
    required this.statusCode,
    required this.url,
    required super.message,
  }) : super(knownException: KnownException.apiError);

  @override
  List<Object?> get props => [statusCode, url, message, knownException];
}

class ApiFormException extends ApiException {
  final Map<String, String> errors;
  const ApiFormException({
    required super.url,
    required this.errors,
    required super.statusCode,
    required super.message,
  });

  @override
  List<Object?> get props => [...super.props, errors];
}
