part of 'exception.dart';

// ignore: constant_identifier_names
enum ApiErrorType { userNotFound, invalidPassword, userAlreadyExists }

class ApiException extends BaseException {
  final int statusCode;

  const ApiException({required this.statusCode, required super.message})
    : super(knownException: KnownException.apiError);

  @override
  List<Object?> get props => [statusCode, message, knownException];
}
