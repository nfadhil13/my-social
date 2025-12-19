import 'package:my_social/core/db/secure_storage/secure_storage.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/session_handler/mocked/session_mocked_mapper.dart';
import 'package:my_social/core/session_handler/session.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SessionHandler, env: [AppEnvironment.mocked])
class SessionHandlerMockedImpl implements SessionHandler {
  final SecureStorage _secureStorage;
  final SessionMockedMapper _mapper;

  static const String sessionKey = 'FDL_SESSION_KEY';

  SessionHandlerMockedImpl(this._secureStorage, this._mapper);

  @override
  Future<Session?> getSession() async {
    final json = await _secureStorage.getJson(sessionKey);
    if (json == null) return null;
    return _mapper.fromJson(json);
  }

  @override
  Future<void> setSession(Session session) {
    if (session is! SessionMocked) {
      throw ArgumentError('Session must be SessionMocked');
    }
    return _secureStorage.saveJson(sessionKey, _mapper.toJson(session));
  }

  @override
  Future<void> clearSession() {
    return _secureStorage.deleteString(sessionKey);
  }
}
