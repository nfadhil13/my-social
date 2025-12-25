import 'package:fdl_types/mapper/mapper.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';

class RegisterRequestMapper implements ToJSONMapper<RegisterFormEntity> {
  @override
  toJson(RegisterFormEntity object) {
    return {
      'email': object.email,
      'password': object.password,
      'name': object.fullName,
      'username': object.username,
    };
  }
}
