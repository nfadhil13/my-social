import 'package:injectable/injectable.dart';

sealed class AppEnvironment {
  static const mocked = 'mocked';
  static const local = 'local';
  static const dev = 'dev';
  static const prod = 'prod';

  final String name;
  final String baseURL;

  static const List<String> apiEnvironments = [local, dev, prod];

  AppEnvironment({required this.name, required this.baseURL});
}

@Injectable(as: AppEnvironment, env: [AppEnvironment.dev])
class AppEnvironmentDev extends AppEnvironment {
  AppEnvironmentDev()
    : super(name: AppEnvironment.dev, baseURL: 'https://api.my-social.com');
}

@Injectable(as: AppEnvironment, env: [AppEnvironment.local])
class AppEnvironmentLocal extends AppEnvironment {
  AppEnvironmentLocal()
    : super(name: AppEnvironment.local, baseURL: 'http://localhost:3000');
}

@Injectable(as: AppEnvironment, env: [AppEnvironment.prod])
class AppEnvironmentProd extends AppEnvironment {
  AppEnvironmentProd()
    : super(name: AppEnvironment.prod, baseURL: 'https://api.my-social.com');
}

@Injectable(as: AppEnvironment, env: [AppEnvironment.mocked])
class AppEnvironmentMocked extends AppEnvironment {
  AppEnvironmentMocked()
    : super(name: AppEnvironment.mocked, baseURL: 'https://api.my-social.com');
}
