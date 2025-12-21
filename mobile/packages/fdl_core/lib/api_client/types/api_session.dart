part of 'api_client.dart';

class APISession {
  final Map<String, String>? headers;
  final Map<String, String>? query;
  final Map<String, dynamic>? body;

  const APISession({this.headers, this.query, this.body});
}
