class UserResponse {
  UserResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: (json['id'] as String),
      email: (json['email'] as String),
      username: (json['username'] as String),
      role: (json['role'] as String),
    );
  }

  final String id;

  final String email;

  final String username;

  final String role;

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'username': username, 'role': role};
  }
}
