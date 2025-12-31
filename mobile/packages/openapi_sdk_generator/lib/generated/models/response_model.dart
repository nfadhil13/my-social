class ResponseModel {
  ResponseModel({
    required this.message,
    required this.success,
    required this.errors,
  });

  final String message;

  final bool success;

  final Map<String, dynamic> errors;
}
