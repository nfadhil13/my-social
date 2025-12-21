part of 'service_locator.dart';

@module
abstract class CoreModule {
  @Named('baseURL')
  String getBaseURL() => 'https://api.my-social.com';

  FlutterSecureStorage getFlutterSecureStorage() => FlutterSecureStorage();

  ApiClient getApiClient(
    @Named('baseURL') String baseURL,
    SessionHandler sessionHandler,
  ) => ApiClientImpl(baseURL: baseURL, sessionHandler: sessionHandler);
}
