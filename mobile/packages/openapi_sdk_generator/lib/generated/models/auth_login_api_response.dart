import 'response_model.dart';
import 'login_response.dart';

class AuthLoginApiResponse {
  AuthLoginApiResponse({required this.responsemodel, required this.data});

  factory AuthLoginApiResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginApiResponse(
      responsemodel: ResponseModel.fromJson((json as Map<String, dynamic>)),
      data: LoginResponse.fromJson((json['data'] as Map<String, dynamic>)),
    );
  }

  final ResponseModel responsemodel;

  final LoginResponse data;

  Map<String, dynamic> toJson() {
    return {};
  }
}
