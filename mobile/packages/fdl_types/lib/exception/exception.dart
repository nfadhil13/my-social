import 'package:equatable/equatable.dart';

part 'unknown.dart';
part 'api_error.dart';
part 'session_expired.dart';
part 'form_exception.dart';

enum KnownException { unknown, apiError, sessionExpired, formException }

class BaseException extends Equatable implements Exception {
  final String message;
  final KnownException knownException;

  const BaseException({required this.message, required this.knownException});

  @override
  List<Object?> get props => [message, knownException];
}
