part of '../api_client.dart';

/// Validation error extractor function type
///
/// Extracts validation errors from API response body
/// [statusCode] : HTTP status code
/// [body] : Response body (typically JSON)
/// Returns a map of field names to error messages
typedef ValidationErrorExtractor =
    Map<String, String> Function(int statusCode, dynamic body);

/// Api Error Handler
///
/// This is the base class for all API error handlers
///
/// It is used to handle API errors and convert them to appropriate [BaseException] types.
///
/// [messageHandler] : Optional handler to extract custom error messages from JSON response body.
///   If provided, this will be called with the status code and response body to extract
///   a user-friendly error message.
/// [validationErrorExtractor] : Optional handler to extract validation errors from JSON response body.
///   If provided, this will be called with the status code and response body to extract
///   field-level validation errors. If not provided, validation errors will not be extracted.
abstract class ApiErrorHandler {
  final String Function(int statusCode, dynamic body)? messageHandler;
  final ValidationErrorExtractor? validationErrorExtractor;

  factory ApiErrorHandler.defaultHandler({
    String Function(int statusCode, dynamic body)? messageHandler,
    ValidationErrorExtractor? validationErrorExtractor,
  }) {
    return APIErrorHandlerImpl(
      messageHandler: messageHandler,
      validationErrorExtractor: validationErrorExtractor,
    );
  }

  const ApiErrorHandler({this.messageHandler, this.validationErrorExtractor});

  /// Handles an error and converts it to a [BaseException]
  ///
  /// [error] : The error to handle (typically a [DioException] or [BaseException])
  /// [url] : The URL where the error occurred
  BaseException handleError(dynamic error, String url);
}

class APIErrorHandlerImpl extends ApiErrorHandler {
  const APIErrorHandlerImpl({
    super.messageHandler,
    super.validationErrorExtractor,
  });

  @override
  BaseException handleError(dynamic error, String url) {
    if (error is DioException) return _handleDioException(error, url);
    if (error is BaseException) return error;
    return APIResponseCode.defaultError.toNetworkException(url);
  }

  BaseException _handleDioException(DioException error, String url) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return APIResponseCode.connectTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.sendTimeout:
        return APIResponseCode.sendTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.receiveTimeout:
        return APIResponseCode.receiveTimeout.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error, url);
      case DioExceptionType.cancel:
        return APIResponseCode.cancel.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      case DioExceptionType.connectionError:
        // Check if it's actually a no internet connection issue
        if (error.response == null) {
          return APIResponseCode.noInternetConnection.toNetworkException(url);
        }
        return APIResponseCode.connectionError.toNetworkException(
          url,
          null,
          error.response?.statusMessage,
        );
      default:
        return _handleDefaultError(error, url);
    }
  }

  BaseException _handleBadResponse(DioException error, String url) {
    try {
      final statusCode = _getStatusCode(error);
      final responseCode = APIResponseCode.fromStatusCode(statusCode);
      final responseData = error.response?.data;
      final message = messageHandler?.call(statusCode, responseData);

      switch (responseCode) {
        case APIResponseCode.unauthorised:
          return SessionExpiredException();
        default:
          final validationErrors = validationErrorExtractor?.call(
            statusCode,
            responseData,
          );
          if (validationErrors != null && validationErrors.isNotEmpty) {
            return ApiFormException(
              url: url,
              statusCode: statusCode,
              message: message ?? responseCode.messsage,
              errors: validationErrors,
            );
          }
          return ApiException(
            statusCode: statusCode,
            url: url,
            message: message ?? responseCode.messsage,
          );
      }
    } catch (e, stackTrace) {
      debugPrint("Error _handleBadResponse: $e");
      debugPrintStack(stackTrace: stackTrace);
      return APIResponseCode.defaultError.toNetworkException(url);
    }
  }

  int _getStatusCode(DioException error) {
    final defaultStatusCode =
        error.response?.statusCode ?? APIResponseCode.defaultError.statusCode;
    return defaultStatusCode;
  }

  BaseException _handleDefaultError(DioException error, String url) {
    // Check for network connectivity issues
    // DioExceptionType.connectionError typically indicates no internet
    if (error.type == DioExceptionType.connectionError) {
      // Additional check: if there's no response and it's a connection error,
      // it's likely a network connectivity issue
      if (error.response == null) {
        return APIResponseCode.noInternetConnection.toNetworkException(url);
      }
    }

    // For unknown DioException types, return default error
    return APIResponseCode.defaultError.toNetworkException(url);
  }
}
