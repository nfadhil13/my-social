import 'package:equatable/equatable.dart';

sealed class Session extends Equatable {
  const Session();

  String getUserId();
}

class SessionMocked extends Session {
  final String userId;
  final Map<String, dynamic>? metadata;

  const SessionMocked({required this.userId, this.metadata});

  @override
  List<Object?> get props => [userId, metadata];

  @override
  String getUserId() => userId;
}

abstract class SessionHandler {
  Future<Session?> getSession();
  Future<void> setSession(Session session);
  Future<void> clearSession();
}
