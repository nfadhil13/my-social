import 'package:my_social/core/env/environment.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/data/datasources/auth_network_dts.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthNetworkDts, env: [AppEnvironment.mocked])
class AuthMockedNetworkDts implements AuthNetworkDts {
  final AuthMockDB _authMockDB;
  AuthMockedNetworkDts(this._authMockDB);

  @override
  Future<UserEntity> login(LoginFormEntity loginForm) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = _authMockDB.users[loginForm.email];
    if (user == null) {
      throw ApiException(
        statusCode: 404,
        url: "login",
        message: "User not found",
      );
    }
    if (loginForm.password != user.password) {
      throw ApiException(
        statusCode: 401,
        url: "login",
        message: "Invalid password",
      );
    }
    return user;
  }

  @override
  Future<void> logout() {
    return Future.value();
  }

  @override
  Future<UserEntity> register(RegisterFormEntity registerForm) {
    final user = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: registerForm.fullName,
      email: registerForm.email,
      password: registerForm.password,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _authMockDB.users[registerForm.email] = user;
    return Future.value(user);
  }
}

@LazySingleton(env: [AppEnvironment.mocked])
class AuthMockDB {
  final Map<String, UserEntity> users = {};

  AuthMockDB() {
    users['test@test.com'] = UserEntity(
      id: '1',
      fullName: 'Test User',
      email: 'test@test.com',
      password: 'test',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    users['test2@test.com'] = UserEntity(
      id: '2',
      fullName: 'Test User 2',
      email: 'test2@test.com',
      password: 'test2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
