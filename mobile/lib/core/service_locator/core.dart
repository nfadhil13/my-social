part of 'service_locator.dart';

@module
abstract class CoreModule {
  FlutterSecureStorage getFlutterSecureStorage() => FlutterSecureStorage();

  ApiClient getApiClient(
    AppEnvironment appEnvironment,
    SessionHandler sessionHandler,
  ) => ApiClientImpl(
    baseURL: appEnvironment.baseURL,
    sessionHandler: sessionHandler,
    errorHandler: ApiErrorHandler.defaultHandler(
      validationErrorExtractor: (statusCode, body) {
        final errors = body['errors'];
        if (errors == null ||
            errors is! Map<String, dynamic> ||
            errors.isEmpty) {
          return null;
        }
        return errors.map((key, value) {
          final errorList = value as List<dynamic>;
          return MapEntry(
            key,
            errorList
                .map((e) => e["code"]?.toString() ?? "UNKNOWN_ERROR")
                .toList(),
          );
        });
      },
      messageHandler: (statusCode, body) =>
          body['message'] as String? ?? "UNKNOWN_MESSAGE",
    ),
    successMessageHandler: (statusCode, body) =>
        body['message'] as String? ?? "UNKNOWN_MESSAGE",
  );

  MySocialSdk getMySocialSdk(ApiClient apiClient) => MySocialSdk(apiClient);
}
