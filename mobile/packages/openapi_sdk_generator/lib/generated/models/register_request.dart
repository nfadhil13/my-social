class RegisterRequest {
  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: (json['email'] as String),
      password: (json['password'] as String),
      name: (json['name'] as String),
      username: (json['username'] as String),
    );
  }

  final String email;

  final String password;

  final String name;

  final String username;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'username': username,
    };
  }
}
