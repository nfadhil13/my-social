class UserResponse {
  final String id;
  final String email;
  final String username;
  final UserResponseRoleEnum role;

  UserResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory UserResponse.fromJson(dynamic json) {
    return UserResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: UserResponseRoleEnum.fromJson(
        json['UserResponseRoleEnum'] as String,
      ),
    );
  }
}

enum UserResponseRoleEnum {
  user('USER'),
  admin('ADMIN');

  final String value;

  const UserResponseRoleEnum(this.value);

  static UserResponseRoleEnum fromJson(String value) {
    return UserResponseRoleEnum.values.firstWhere((e) => e.value == value);
  }
}
