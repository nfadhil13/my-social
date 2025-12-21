import 'package:equatable/equatable.dart';
import 'package:fdl_core/api_client/api_client.dart';

abstract class Session extends Equatable {
  const Session();

  APISession? asApiSession() => null;
}

class SessionMocked extends Session {
  final String userId;
  final Map<String, dynamic>? metadata;

  const SessionMocked({required this.userId, this.metadata});

  @override
  List<Object?> get props => [userId, metadata];

  @override
  APISession? asApiSession() =>
      APISession(headers: {"Authorization": "Bearer $userId"});
}

abstract class SessionHandler {
  Future<Session?> getSession();
  Future<void> setSession(Session session);
  Future<void> clearSession();
}
