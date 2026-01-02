import '../../models/index.dart';

class AuthRegisterPostApiResponse {
  AuthRegisterPostApiResponse({
    required this.responsemodel,
    required this.data,
  });

  factory AuthRegisterPostApiResponse.fromJson(Map<String, dynamic> json) {
    return AuthRegisterPostApiResponse(
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
