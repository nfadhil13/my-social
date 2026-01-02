import '../../models/index.dart';

class AuthLoginPostApiResponse {
  AuthLoginPostApiResponse({required this.responsemodel, required this.data});

  factory AuthLoginPostApiResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginPostApiResponse(
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
