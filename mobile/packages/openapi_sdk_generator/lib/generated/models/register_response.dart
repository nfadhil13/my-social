class RegisterResponse {
  RegisterResponse({required this.id, required this.email});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: (json['id'] as String),
      email: (json['email'] as String),
    );
  }

  final String id;

  final String email;

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }
}
