class ResponseModel<T> {
  final String message;
  final T data;

  ResponseModel({required this.message, required this.data});

  static ResponseModel<T> fromJson<T>(dynamic json, T data) {
    return ResponseModel<T>(message: json['message'], data: data);
  }
}
