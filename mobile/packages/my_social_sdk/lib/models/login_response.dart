import 'user_response.dart';

class LoginResponse {
  final UserResponse user;
  final String accessToken;
  final String random;

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.random,
  });

  factory LoginResponse.fromJson(dynamic json) {
    return LoginResponse(
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      random: json['random'] as String,
    );
  }
}
