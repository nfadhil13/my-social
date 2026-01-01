import '../../models/index.dart';

class PostAuthRegisterApiResponse {
  PostAuthRegisterApiResponse({
    required this.responsemodel,
    required this.data,
  });

  factory PostAuthRegisterApiResponse.fromJson(Map<String, dynamic> json) {
    return PostAuthRegisterApiResponse(
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
