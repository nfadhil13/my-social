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

class AppEnvironmentDev extends AppEnvironment {
  AppEnvironmentDev()
    : super(name: AppEnvironment.dev, baseURL: 'https://api.my-social.com');
}

class AppEnvironmentLocal extends AppEnvironment {
  AppEnvironmentLocal()
    : super(name: AppEnvironment.local, baseURL: 'https://api.my-social.com');
}

class AppEnvironmentProd extends AppEnvironment {
  AppEnvironmentProd()
    : super(name: AppEnvironment.prod, baseURL: 'https://api.my-social.com');
}

class AppEnvironmentMocked extends AppEnvironment {
  AppEnvironmentMocked()
    : super(name: AppEnvironment.mocked, baseURL: 'https://api.my-social.com');
}
