import 'package:fdl_core/session_handler/session.dart';
import 'package:fdl_types/mapper/mapper.dart';
import 'package:injectable/injectable.dart';

class NetworkSession extends Session {
  final String token;
  final String role;

  const NetworkSession({required this.token, required this.role});

  @override
  List<Object?> get props => [token, role];
}

@injectable
class NetworkSessionMapper implements JSONMapper<NetworkSession> {
  static const String tokenKey = 'token';
  static const String roleKey = 'role';

  @override
  NetworkSession fromJson(dynamic json) {
    return NetworkSession(token: json[tokenKey], role: json[roleKey]);
  }

  @override
  Map<String, dynamic> toJson(NetworkSession object) {
    return {tokenKey: object.token, roleKey: object.role};
  }
}
