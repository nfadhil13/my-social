import 'package:fdl_types/fdl_types.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';

@injectable
class LoginRequestMapper implements ToJSONMapper<LoginFormEntity> {
  @override
  toJson(LoginFormEntity object) {
    return {'email': object.email, 'password': object.password};
  }
}
