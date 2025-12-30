class Responsemodel {
  Responsemodel({
    required this.message,
    required this.data,
    required this.success,
    required this.errors,
  });

  final String message;

  final Map<String, dynamic> data;

  final bool success;

  final Map<String, dynamic> errors;
}
