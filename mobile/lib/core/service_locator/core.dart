part of 'service_locator.dart';

@module
abstract class CoreModule {
  FlutterSecureStorage getFlutterSecureStorage() => FlutterSecureStorage();
}
