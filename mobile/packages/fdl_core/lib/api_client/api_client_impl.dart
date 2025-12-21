part of 'api_client.dart';

class ApiClientImpl extends ApiClient {
  final Dio _dio;
  ApiClientImpl({
    required super.baseURL,
    super.successMessageHandler,
    Dio? dio,
    ApiErrorHandler? errorHandler,
    super.sessionHandler,
  }) : _dio = _DioFactory._createDio(baseURL, inputDio: dio),
       super(
         errorHandler:
             errorHandler ??
             ApiErrorHandler.defaultHandler(
               messageHandler: successMessageHandler,
             ),
       );

  Options _getOptions(
    Map<String, String>? headers, {
    bool shouldPrint = false,
  }) {
    return Options(extra: {"shouldPrint": shouldPrint});
  }

  @override
  Future<ApiResponse> delete<T>({
    required String path,
    Map<String, String>? headers,
    body,

    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,

    mockResult: mockResult,
    request: () => _dio.delete(
      path,
      options: _getOptions(headers, shouldPrint: shouldPrint),
      data: body,
      queryParameters: query,
    ),
  );

  @override
  Future<ApiResponse> get<T>({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    body,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request: () => _dio.get(
      path,
      options: _getOptions(headers, shouldPrint: shouldPrint),
      data: body ?? {},
      queryParameters: query,
    ),
  );

  @override
  Future<ApiResponse> post<T>({
    required String path,
    Map<String, String>? headers,
    body,

    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,

    mockResult: mockResult,
    request: () => _dio.post(
      path,
      options: _getOptions(headers, shouldPrint: shouldPrint),
      data: body,
      queryParameters: query,
    ),
  );

  @override
  Future<ApiResponse> put<T>({
    required String path,
    Map<String, String>? headers,
    body,

    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) => _handleRequest(
    path: path,
    headers: headers,
    body: body,
    shouldPrint: shouldPrint,
    mockResult: mockResult,
    request: () => _dio.put(
      path,
      options: _getOptions(headers, shouldPrint: shouldPrint),
      data: body,
      queryParameters: query,
    ),
  );

  Response _mockRequest(MockedResult mockedResult, String path) {
    return Response(
      requestOptions: RequestOptions(path: path),
      data: mockedResult.result,
      headers: Headers.fromMap({
        for (var entry in mockedResult.headers.entries)
          entry.key: [entry.value],
      }),
      statusCode: mockedResult.statusCode,
    );
  }

  Future<ApiResponse> _handleRequest<T>({
    required String path,
    required Map<String, String>? headers,
    required body,
    required Future<Response> Function() request,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    try {
      final response = mockResult != null
          ? _mockRequest(mockResult, path)
          : await request();
      final statusCode = response.statusCode ?? 0;
      return ApiResponse(
        url: response.realUri.toString(),
        data: response.data,
        message: successMessageHandler?.call(statusCode, response.data) ?? "",
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map,
      );
    } catch (e, stackTrace) {
      // coverage:ignore-line
      if (shouldPrint) {
        debugPrint("Error APIClientImpl: $e");
        debugPrintStack(stackTrace: stackTrace);
      }
      throw errorHandler.handleError(e, path);
    }
  }
}

class _DioFactory {
  static Dio _createDio(
    String baseURL, {
    Dio? inputDio,
    SessionHandler? sessionHandler,
  }) {
    return inputDio ?? Dio(BaseOptions(baseUrl: baseURL))
      ..interceptors.add(SessionInterceptor(getUserSession: sessionHandler));
  }
}
