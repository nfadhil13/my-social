import 'package:fdl_core/api_client/api_client.dart';
import 'package:fdl_core/session_handler/session.dart';
import 'package:my_social/core/env/environment.dart';
import 'package:my_social/core/service_locator/service_locator.config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/core/session_handler/network/network_session_handler.dart';
import 'package:my_social_sdk/my_social_sdk.dart';

part 'core.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false, // default
  asExtension: true, // default
)
void configureDependencies(String environment) =>
    getIt.init(environment: environment);
