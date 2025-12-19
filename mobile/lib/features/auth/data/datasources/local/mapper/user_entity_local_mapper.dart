import 'package:fdl_types/fdl_types.dart';
import 'package:my_social/features/auth/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserEntityLocalMapper implements JSONMapper<UserEntity> {
  @override
  UserEntity fromJson(dynamic json) {
    return UserEntity(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson(UserEntity object) {
    return {
      'id': object.id,
      'fullName': object.fullName,
      'email': object.email,
      'password': object.password,
      'createdAt': object.createdAt.toIso8601String(),
      'updatedAt': object.updatedAt.toIso8601String(),
    };
  }
}
