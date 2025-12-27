import 'package:fdl_types/fdl_types.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social_sdk/models/models.dart';

@injectable
class LoginRequestMapper implements ToMapper<LoginFormEntity, LoginRequest> {
  @override
  LoginRequest toData(LoginFormEntity json) {
    return LoginRequest(email: json.email, password: json.password);
  }
}
