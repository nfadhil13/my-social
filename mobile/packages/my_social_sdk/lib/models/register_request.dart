class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String username;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
  });

  dynamic toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'username': username,
    };
  }
}
