part of '../api_client.dart';

class ApiResponse {
  final String url;
  final dynamic data;
  final int statusCode;
  final String message;
  final Map<String, dynamic> headers;
  final Session? session;

  ApiResponse({
    required this.data,
    this.url = "UNKNOWN_URL",
    required this.statusCode,
    required this.message,
    required this.headers,
    this.session,
  });
}
