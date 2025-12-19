import 'package:my_social/features/auth/domain/entities/user.dart';

abstract class AuthLocalDts {
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> deleteUser();
}
