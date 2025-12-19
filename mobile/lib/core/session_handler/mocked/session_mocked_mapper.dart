import 'package:my_social/core/session_handler/session.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:injectable/injectable.dart';

@injectable
class SessionMockedMapper implements JSONMapper<SessionMocked> {
  static const String userIdKey = 'userId';

  @override
  SessionMocked fromJson(dynamic json) {
    return SessionMocked(userId: json[userIdKey] as String);
  }

  @override
  Map<String, dynamic> toJson(SessionMocked object) {
    return {userIdKey: object.userId};
  }
}
