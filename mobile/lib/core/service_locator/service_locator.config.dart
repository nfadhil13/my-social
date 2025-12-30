// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fdl_core/fdl_core.dart' as _i970;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:my_social/core/db/secure_storage/secure_storage.dart' as _i770;
import 'package:my_social/core/env/environment.dart' as _i492;
import 'package:my_social/core/service_locator/service_locator.dart' as _i918;
import 'package:my_social/core/session_handler/network/network_session.dart'
    as _i946;
import 'package:my_social/core/session_handler/network/network_session_handler.dart'
    as _i530;
import 'package:my_social/features/auth/data/datasources/auth_local_dts.dart'
    as _i468;
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart'
    as _i114;
import 'package:my_social/features/auth/data/datasources/local/auth_local_dts_impl.dart'
    as _i156;
import 'package:my_social/features/auth/data/datasources/local/mapper/user_entity_local_mapper.dart'
    as _i801;
import 'package:my_social/features/auth/data/datasources/remote/api/auth_api_network_dts.dart'
    as _i394;
import 'package:my_social/features/auth/data/datasources/remote/api/mapper/request/login_request_mapper.dart'
    as _i654;
import 'package:my_social/features/auth/data/datasources/remote/api/mapper/request/register_request_mapper.dart'
    as _i478;
import 'package:my_social/features/auth/data/repositories/auth_repo_impl.dart'
    as _i67;
import 'package:my_social/features/auth/domain/repositories/auth_repo.dart'
    as _i516;
import 'package:my_social/features/auth/domain/usecases/login_usecase.dart'
    as _i222;
import 'package:my_social/features/auth/domain/usecases/logout_usecase.dart'
    as _i238;
import 'package:my_social/features/auth/domain/usecases/register_usecase.dart'
    as _i29;
import 'package:my_social/features/auth/presentation/cubits/login/login_cubit.dart'
    as _i294;
import 'package:my_social/features/auth/presentation/cubits/logout/logout_cubit.dart'
    as _i1008;
import 'package:my_social/features/auth/presentation/cubits/register/register_cubit.dart'
    as _i727;
import 'package:my_social_sdk/my_social_sdk.dart' as _i885;

const String _local = 'local';
const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    gh.factory<_i558.FlutterSecureStorage>(
      () => coreModule.getFlutterSecureStorage(),
    );
    gh.factory<_i946.NetworkSessionMapper>(() => _i946.NetworkSessionMapper());
    gh.factory<_i801.UserEntityLocalMapper>(
      () => _i801.UserEntityLocalMapper(),
    );
    gh.factory<_i654.LoginRequestMapper>(() => _i654.LoginRequestMapper());
    gh.factory<_i478.RegisterRequestMapper>(
      () => _i478.RegisterRequestMapper(),
    );
    gh.factory<_i492.AppEnvironment>(
      () => _i492.AppEnvironmentLocal(),
      registerFor: {_local},
    );
    gh.factory<_i492.AppEnvironment>(
      () => _i492.AppEnvironmentDev(),
      registerFor: {_dev},
    );
    gh.factory<_i492.AppEnvironment>(
      () => _i492.AppEnvironmentProd(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i770.SecureStorage>(
      () => _i770.SecureStorageImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i468.AuthLocalDts>(
      () => _i156.AuthLocalDtsImpl(
        gh<_i770.SecureStorage>(),
        gh<_i801.UserEntityLocalMapper>(),
      ),
    );
    gh.lazySingleton<_i970.SessionHandler>(
      () => _i530.SessionHandlerNetworkImpl(
        gh<_i770.SecureStorage>(),
        gh<_i946.NetworkSessionMapper>(),
      ),
    );
    gh.factory<_i970.ApiClient>(
      () => coreModule.getApiClient(
        gh<_i492.AppEnvironment>(),
        gh<_i970.SessionHandler>(),
      ),
    );
    gh.factory<_i885.MySocialSdk>(
      () => coreModule.getMySocialSdk(gh<_i970.ApiClient>()),
    );
    gh.factory<_i114.AuthNetworkDts>(
      () => _i394.AuthApiNetworkDts(
        gh<_i885.MySocialSdk>(),
        gh<_i478.RegisterRequestMapper>(),
        gh<_i654.LoginRequestMapper>(),
      ),
    );
    gh.factory<_i516.AuthRepo>(
      () => _i67.AuthRepoImpl(
        gh<_i114.AuthNetworkDts>(),
        gh<_i468.AuthLocalDts>(),
        gh<_i970.SessionHandler>(),
      ),
    );
    gh.factory<_i222.LoginUsecase>(
      () =>
          _i222.LoginUsecase(gh<_i970.SessionHandler>(), gh<_i516.AuthRepo>()),
    );
    gh.factory<_i238.LogoutUsecase>(
      () =>
          _i238.LogoutUsecase(gh<_i970.SessionHandler>(), gh<_i516.AuthRepo>()),
    );
    gh.factory<_i29.RegisterUsecase>(
      () => _i29.RegisterUsecase(
        gh<_i970.SessionHandler>(),
        gh<_i516.AuthRepo>(),
      ),
    );
    gh.factory<_i294.LoginCubit>(
      () => _i294.LoginCubit(gh<_i222.LoginUsecase>()),
    );
    gh.factory<_i727.RegisterCubit>(
      () => _i727.RegisterCubit(gh<_i29.RegisterUsecase>()),
    );
    gh.factory<_i1008.LogoutCubit>(
      () => _i1008.LogoutCubit(gh<_i238.LogoutUsecase>()),
    );
    return this;
  }
}

class _$CoreModule extends _i918.CoreModule {}
