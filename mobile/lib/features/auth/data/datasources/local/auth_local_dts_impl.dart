import 'package:my_social/core/db/secure_storage/secure_storage.dart';
import 'package:my_social/features/auth/data/datasources/auth_local_dts.dart';
import 'package:my_social/features/auth/data/datasources/local/mapper/user_entity_local_mapper.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthLocalDts)
class AuthLocalDtsImpl implements AuthLocalDts {
  final SecureStorage _secureStorage;
  final UserEntityLocalMapper _mapper;

  static const String userKey = "FDL_USER_KEY";

  AuthLocalDtsImpl(this._secureStorage, this._mapper);

  @override
  Future<void> saveUser(UserEntity user) {
    return _secureStorage.saveJson(userKey, _mapper.toJson(user));
  }

  @override
  Future<void> deleteUser() {
    return _secureStorage.deleteString(userKey);
  }

  @override
  Future<UserEntity?> getUser() async {
    final json = await _secureStorage.getJson(userKey);
    if (json == null) return null;
    return _mapper.fromJson(json);
  }
}
