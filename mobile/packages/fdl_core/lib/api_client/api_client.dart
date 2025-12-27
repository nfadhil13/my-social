import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fdl_core/ext/list_ext.dart';
import 'package:fdl_core/session_handler/session.dart';
import 'package:fdl_types/exception/exception.dart';
import 'package:flutter/foundation.dart';

part 'types/api_response.dart';
part 'types/mocked_result.dart';
part 'api_client_impl.dart';
part 'types/api_session.dart';
part 'interceptor/session_interceptor.dart';
part 'error_handler/api_error_handler.dart';
part 'error_handler/response_code.dart';

abstract class ApiClient {
  final String baseURL;
  final SessionHandler? sessionHandler;

  final ApiErrorHandler errorHandler;
  final String Function(int statusCode, dynamic body)? successMessageHandler;

  const ApiClient({
    this.sessionHandler,
    required this.baseURL,
    required this.errorHandler,
    this.successMessageHandler,
  });

  /// Post Request
  ///
  /// This is the base class for all post requests
  ///
  /// It is used to make post requests and handle the responses
  /// [path] : The path of the request
  /// [mapper] : The mapper to map the response to a data type
  /// [headers] : The headers of the request
  /// [body] : The body of the request
  /// [session] : The session of the request
  /// [query] : The query of the request
  /// [shouldPrint] : Whether to print the request and response
  Future<ApiResponse> post<T>({
    required String path,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  /// Get Request
  ///
  /// This is the base class for all get requests
  ///
  /// It is used to make get requests and handle the responses
  /// [path] : The path of the request
  /// [mapper] : The mapper to map the response to a data type
  /// [headers] : The headers of the request
  /// [query] : The query of the request
  /// [shouldPrint] : Whether to print the request and response
  /// [session] : The session of the request
  /// [body] : The body of the request
  /// [mockResult] : The mocked result of the request
  Future<ApiResponse> get<T>({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    dynamic body,
    MockedResult? mockResult,
  });

  /// Delete Request
  ///
  /// This is the base class for all delete requests
  ///
  /// It is used to make delete requests and handle the responses
  /// [path] : The path of the request
  /// [mapper] : The mapper to map the response to a data type
  /// [headers] : The headers of the request
  /// [body] : The body of the request
  /// [session] : The session of the request
  /// [query] : The query of the request
  /// [shouldPrint] : Whether to print the request and response
  /// [mockResult] : The mocked result of the request
  Future<ApiResponse> delete<T>({
    required String path,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  /// Put Request
  ///
  /// This is the base class for all put requests
  ///
  /// It is used to make put requests and handle the responses
  /// [path] : The path of the request
  /// [mapper] : The mapper to map the response to a data type
  /// [headers] : The headers of the request
  /// [body] : The body of the request
  /// [session] : The session of the request
  /// [query] : The query of the request
  /// [shouldPrint] : Whether to print the request and response
  /// [mockResult] : The mocked result of the request
  Future<ApiResponse> put<T>({
    required String path,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  // Future<APIResult<T>> multipartRequest<T>({
  //   required String path,
  //   required HttpRequestType requestType,
  //   required MapFromNetwork<T> mapper,
  //   Map<String, String>? headers,
  //   Future<APIResult<T>?> Function(http.Response response) plainHandler,
  //   Map<String, dynamic> fields = const {},
  //   String? bearerToken,
  //   query,
  //   bool shouldPrint = false,
  //   MockedResult? mockResult,
  // });
}
