import 'package:fdl_core/session_handler/session.dart';
import 'package:fdl_types/mapper/mapper.dart';
import 'package:injectable/injectable.dart';

class NetworkSession extends Session {
  final String userId;
  final String email;
  final String token;
  final String role;

  const NetworkSession({
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, email, token, role];
}

@injectable
class NetworkSessionMapper implements JSONMapper<NetworkSession> {
  static const String tokenKey = 'token';
  static const String roleKey = 'role';
  static const String userIdKey = 'userId';
  static const String emailKey = 'email';

  @override
  NetworkSession fromJson(dynamic json) {
    return NetworkSession(
      token: json[tokenKey],
      role: json[roleKey],
      userId: json[userIdKey],
      email: json[emailKey],
    );
  }

  @override
  Map<String, dynamic> toJson(NetworkSession object) {
    return {
      tokenKey: object.token,
      roleKey: object.role,
      userIdKey: object.userId,
      emailKey: object.email,
    };
  }
}
