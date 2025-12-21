part of '../api_client.dart';

class MockedResult {
  final dynamic result;
  final int statusCode;
  final Map<String, String> headers;

  const MockedResult({
    this.result,
    this.statusCode = 200,
    this.headers = const {},
  });
}
