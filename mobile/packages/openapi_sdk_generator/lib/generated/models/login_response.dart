import 'user_response.dart';

class LoginResponse {
  LoginResponse({required this.user, required this.accessToken});

  final UserResponse user;

  final String accessToken;
}
