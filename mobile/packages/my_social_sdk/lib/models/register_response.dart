class RegisterResponse {
  final String id;
  final String email;

  RegisterResponse({required this.id, required this.email});

  factory RegisterResponse.fromJson(dynamic json) {
    return RegisterResponse(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }
}
