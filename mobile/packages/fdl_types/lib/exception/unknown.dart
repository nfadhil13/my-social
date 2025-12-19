part of 'exception.dart';

class UnknonwnException extends BaseException {
  UnknonwnException()
    : super(
        message: KnownException.unknown.name,
        knownException: KnownException.unknown,
      );
}
