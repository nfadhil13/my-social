class ResponseModel {
  ResponseModel({
    required this.message,
    required this.success,
    required this.errors,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: (json['message'] as String),
      success: (json['success'] as bool),
      errors: (json['errors'] as Map<String, dynamic>),
    );
  }

  final String message;

  final bool success;

  final Map<String, dynamic> errors;

  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success, 'errors': errors};
  }
}
