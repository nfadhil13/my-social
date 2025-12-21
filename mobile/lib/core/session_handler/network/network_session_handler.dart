import 'package:my_social/core/db/secure_storage/secure_storage.dart';
import 'package:fdl_core/fdl_core.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/session_handler/network/network_session.dart';

@LazySingleton(as: SessionHandler, env: AppEnvironment.apiEnvironments)
class SessionHandlerNetworkImpl implements SessionHandler {
  final SecureStorage _secureStorage;
  final NetworkSessionMapper _mapper;

  static const String sessionKey = 'MY_SOCIAL_SESSION_KEY';

  SessionHandlerNetworkImpl(this._secureStorage, this._mapper);

  @override
  Future<Session?> getSession() async {
    final json = await _secureStorage.getJson(sessionKey);
    if (json == null) return null;
    return _mapper.fromJson(json);
  }

  @override
  Future<void> setSession(Session session) {
    if (session is! NetworkSession) {
      throw ArgumentError('Session must be SessionMocked');
    }
    return _secureStorage.saveJson(sessionKey, _mapper.toJson(session));
  }

  @override
  Future<void> clearSession() {
    return _secureStorage.deleteString(sessionKey);
  }
}
