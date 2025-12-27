import 'package:fdl_types/mapper/mapper.dart';
import 'package:injectable/injectable.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social_sdk/models/models.dart';

@Injectable()
class RegisterRequestMapper
    implements ToMapper<RegisterFormEntity, RegisterRequest> {
  @override
  RegisterRequest toData(RegisterFormEntity json) {
    return RegisterRequest(
      email: json.email,
      password: json.password,
      name: json.fullName,
      username: json.username,
    );
  }
}
