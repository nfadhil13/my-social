library;

export 'models/login_request.dart';
export 'models/register_request.dart';
export 'models/login_response.dart';
export 'models/user_response.dart';
export 'models/register_response.dart';
export 'models/response_model.dart';
export 'models/models.dart';
export 'services/auth_service.dart';
export 'services/services.dart';

import 'package:fdl_core/api_client/api_client.dart';
import 'package:my_social_sdk/services/services.dart';

class MySocialSdk {
  final ApiClient apiClient;
  final AuthService authservice;

  MySocialSdk(this.apiClient) : authservice = AuthService(apiClient);
}
