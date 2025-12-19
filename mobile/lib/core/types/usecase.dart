import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/core/session_handler/session.dart';
import 'package:flutter/material.dart';

abstract class _SessionHandler {
  final SessionHandler _sessionHandler;

  _SessionHandler(this._sessionHandler);

  Future<Session> requireSession() async {
    final session = await _sessionHandler.getSession();
    if (session == null) throw SessionExpiredException();
    return session;
  }
}

abstract class Usecase<Params, Result> extends _SessionHandler {
  Usecase(super._sessionHandler);

  Future<Resource<Result>> execute(Params params);

  Future<Resource<Result>> call(Params params) async {
    try {
      final result = await execute(params);
      return result;
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      return await handleError(e, stacktrace);
    }
  }

  Future<Resource<Result>> handleError(Object e, StackTrace stackTrace) async {
    return _handleError(_sessionHandler, e, stackTrace);
  }
}

abstract class UsecaseNoParams<Result> extends _SessionHandler {
  UsecaseNoParams(super._sessionHandler);

  Future<Resource<Result>> execute();

  Future<Resource<Result>> call() async {
    try {
      final result = await execute();
      return result;
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      return await handleError(_sessionHandler, e, stacktrace);
    }
  }

  Future<Resource<Result>> handleError(
    SessionHandler sessionHandler,
    Object e,
    StackTrace stackTrace,
  ) async {
    return _handleError(sessionHandler, e, stackTrace);
  }
}

Future<Resource<Result>> _handleError<Result>(
  SessionHandler sessionHandler,
  Object e,
  StackTrace stackTrace,
) async {
  if (e is SessionExpiredException) {
    await sessionHandler.clearSession();
    // getIt<AppRouter>().replaceAll([const LoginRoute()]);
  }
  if (e is! BaseException) {
    return Failure<Result>(exception: UnknonwnException());
  }

  return Failure<Result>(exception: e);
}

extension DataToResouceExt<T extends dynamic> on Future<T> {
  Future<Resource<T>> get asResource async => Success<T>(data: await this);
}
