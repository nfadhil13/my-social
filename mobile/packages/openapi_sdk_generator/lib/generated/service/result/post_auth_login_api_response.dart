import '../../models/index.dart';

class PostAuthLoginApiResponse {
  PostAuthLoginApiResponse({required this.responsemodel, required this.data});

  factory PostAuthLoginApiResponse.fromJson(Map<String, dynamic> json) {
    return PostAuthLoginApiResponse(
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
