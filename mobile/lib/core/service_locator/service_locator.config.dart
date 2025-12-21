// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:my_social/core/db/secure_storage/secure_storage.dart' as _i770;
import 'package:my_social/core/service_locator/service_locator.dart' as _i918;
import 'package:my_social/core/session_handler/mocked/session_handler_mocked_impl.dart'
    as _i1066;
import 'package:my_social/core/session_handler/mocked/session_mocked_mapper.dart'
    as _i729;
import 'package:fdl_core/fdl_core.dart' as _i1023;
import 'package:my_social/features/auth/data/datasources/auth_local_dts.dart'
    as _i468;
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart'
    as _i114;
import 'package:my_social/features/auth/data/datasources/local/auth_local_dts_impl.dart'
    as _i156;
import 'package:my_social/features/auth/data/datasources/local/mapper/user_entity_local_mapper.dart'
    as _i801;
import 'package:my_social/features/auth/data/datasources/remote/mocked/auth_mocked_network_dts.dart'
    as _i481;
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

const String _mocked = 'mocked';

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
    gh.factory<_i729.SessionMockedMapper>(() => _i729.SessionMockedMapper());
    gh.factory<_i801.UserEntityLocalMapper>(
      () => _i801.UserEntityLocalMapper(),
    );
    gh.lazySingleton<_i481.AuthMockDB>(
      () => _i481.AuthMockDB(),
      registerFor: {_mocked},
    );
    gh.lazySingleton<_i770.SecureStorage>(
      () => _i770.SecureStorageImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i114.AuthNetworkDts>(
      () => _i481.AuthMockedNetworkDts(gh<_i481.AuthMockDB>()),
      registerFor: {_mocked},
    );
    gh.lazySingleton<_i1023.SessionHandler>(
      () => _i1066.SessionHandlerMockedImpl(
        gh<_i770.SecureStorage>(),
        gh<_i729.SessionMockedMapper>(),
      ),
      registerFor: {_mocked},
    );
    gh.factory<_i468.AuthLocalDts>(
      () => _i156.AuthLocalDtsImpl(
        gh<_i770.SecureStorage>(),
        gh<_i801.UserEntityLocalMapper>(),
      ),
    );
    gh.factory<_i516.AuthRepo>(
      () => _i67.AuthRepoImpl(
        gh<_i114.AuthNetworkDts>(),
        gh<_i468.AuthLocalDts>(),
        gh<_i1023.SessionHandler>(),
      ),
    );
    gh.factory<_i222.LoginUsecase>(
      () =>
          _i222.LoginUsecase(gh<_i1023.SessionHandler>(), gh<_i516.AuthRepo>()),
    );
    gh.factory<_i238.LogoutUsecase>(
      () => _i238.LogoutUsecase(
        gh<_i1023.SessionHandler>(),
        gh<_i516.AuthRepo>(),
      ),
    );
    gh.factory<_i29.RegisterUsecase>(
      () => _i29.RegisterUsecase(
        gh<_i1023.SessionHandler>(),
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
