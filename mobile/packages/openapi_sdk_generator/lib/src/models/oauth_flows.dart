import 'oauth_flow.dart';

/// OAuth flows
class OAuthFlows {
  /// Implicit flow
  final OAuthFlow? implicit;

  /// Password flow
  final OAuthFlow? password;

  /// Client credentials flow
  final OAuthFlow? clientCredentials;

  /// Authorization code flow
  final OAuthFlow? authorizationCode;

  OAuthFlows({
    this.implicit,
    this.password,
    this.clientCredentials,
    this.authorizationCode,
  });

  factory OAuthFlows.fromJson(Map<String, dynamic> json) {
    return OAuthFlows(
      implicit: json['implicit'] != null
          ? OAuthFlow.fromJson(json['implicit'] as Map<String, dynamic>)
          : null,
      password: json['password'] != null
          ? OAuthFlow.fromJson(json['password'] as Map<String, dynamic>)
          : null,
      clientCredentials: json['clientCredentials'] != null
          ? OAuthFlow.fromJson(
              json['clientCredentials'] as Map<String, dynamic>)
          : null,
      authorizationCode: json['authorizationCode'] != null
          ? OAuthFlow.fromJson(
              json['authorizationCode'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (implicit != null) 'implicit': implicit!.toJson(),
      if (password != null) 'password': password!.toJson(),
      if (clientCredentials != null)
        'clientCredentials': clientCredentials!.toJson(),
      if (authorizationCode != null)
        'authorizationCode': authorizationCode!.toJson(),
    };
  }
}

