part of '../api_client.dart';

// class APIResponseCode {
//   static const int success = 200; // success with data
//   static const int noContent = 201; // success with no data (no content)
//   static const int badRequest = 400; // failure, API rejected request
//   static const int unauthorised = 401; // failure, user is not authorised
//   static const int forbidden = 403; //  failure, API rejected request
//   static const int internalServerError = 500; // failure, crash in server side
//   static const int notFound = 404; // failure, not found
//   static const int invalidData = 422; // failure, not found

//   // local status code
//   static const int connectTimeout = -1;
//   static const int cancel = -2;
//   static const int receiveTimeout = -3;
//   static const int sendTimeout = -4;
//   static const int cacheError = -5;
//   static const int noInternetConnection = -6;
//   static const int locationDenied = -7;
//   static const int defaultError = -8;
//   static const int connectionError = -9;
// }

enum APIResponseCode {
  success(statusCode: 200, messsage: 'SUCCESS'),
  noContent(statusCode: 201, messsage: 'NO_CONTENT'),
  badRequest(statusCode: 400, messsage: 'BAD_REQUEST'),
  unauthorised(statusCode: 401, messsage: 'UNAUTHORISED'),
  forbidden(statusCode: 403, messsage: 'FORBIDDEN'),
  notFound(statusCode: 404, messsage: 'NOT_FOUND'),
  invalidData(statusCode: 422, messsage: 'INVALID_DATA'),
  internalServerError(statusCode: 500, messsage: 'INTERNAL_SERVER_ERROR'),

  // LOCAL STATUS CODE
  connectTimeout(statusCode: -1, messsage: 'CONNECT_TIMEOUT'),
  cancel(statusCode: -2, messsage: 'CANCEL'),
  receiveTimeout(statusCode: -3, messsage: 'RECEIVE_TIMEOUT'),
  sendTimeout(statusCode: -4, messsage: 'SEND_TIMEOUT'),
  cacheError(statusCode: -5, messsage: 'CACHE_ERROR'),
  noInternetConnection(statusCode: -6, messsage: 'NO_INTERNET_CONNECTION'),
  locationDenied(statusCode: -7, messsage: 'LOCATION_DENIED'),
  defaultError(statusCode: -8, messsage: 'DEFAULT_ERROR'),
  connectionError(statusCode: -9, messsage: 'CONNECTION_ERROR'),
  parsingJSONError(statusCode: -10, messsage: 'PARSING_JSON_ERROR');

  final int statusCode;
  final String messsage;

  const APIResponseCode({required this.statusCode, required this.messsage});

  static APIResponseCode fromStatusCode(int statusCode) {
    return APIResponseCode.values.firstWhereOrNull(
          (index, element) => element.statusCode == statusCode,
        ) ??
        APIResponseCode.defaultError;
  }

  ApiException toNetworkException([
    String? url,
    String? newMessage,
    String? exceptionMessage,
  ]) {
    return ApiException(
      message: newMessage ?? messsage,
      statusCode: statusCode,
      url: url ?? "UNKNOWN_URL",
    );
  }
}
