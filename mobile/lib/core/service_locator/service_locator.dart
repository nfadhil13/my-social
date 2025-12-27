import 'package:fdl_core/fdl_core.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/service_locator/service_locator.config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social_sdk/my_social_sdk.dart';
import 'package:fdl_core/fdl_core.dart';

part 'core.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false, // default
  asExtension: true, // default
)
void configureDependencies(String environment) =>
    getIt.init(environment: environment);
