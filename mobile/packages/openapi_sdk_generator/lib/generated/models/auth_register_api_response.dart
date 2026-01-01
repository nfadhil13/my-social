import 'response_model.dart';
import 'register_response.dart';

class AuthRegisterApiResponse {
  AuthRegisterApiResponse({required this.responsemodel, required this.data});

  factory AuthRegisterApiResponse.fromJson(Map<String, dynamic> json) {
    return AuthRegisterApiResponse(
      responsemodel: ResponseModel.fromJson((json as Map<String, dynamic>)),
      data: RegisterResponse.fromJson((json['data'] as Map<String, dynamic>)),
    );
  }

  final ResponseModel responsemodel;

  final RegisterResponse data;

  Map<String, dynamic> toJson() {
    return {};
  }
}
