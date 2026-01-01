import 'user_response.dart';

class LoginResponse {
  LoginResponse({required this.user, required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserResponse.fromJson((json['user'] as Map<String, dynamic>)),
      accessToken: (json['accessToken'] as String),
    );
  }

  final UserResponse user;

  final String accessToken;

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'accessToken': accessToken};
  }
}
