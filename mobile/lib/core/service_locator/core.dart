part of 'service_locator.dart';

@module
abstract class CoreModule {
  FlutterSecureStorage getFlutterSecureStorage() => FlutterSecureStorage();

  AppEnvironment getAppEnvironment() => AppEnvironmentLocal();

  ApiClient getApiClient(
    AppEnvironment appEnvironment,
    SessionHandler sessionHandler,
  ) => ApiClientImpl(
    baseURL: appEnvironment.baseURL,
    sessionHandler: sessionHandler,
  );

  MySocialSdk getMySocialSdk(ApiClient apiClient) => MySocialSdk(apiClient);
}
