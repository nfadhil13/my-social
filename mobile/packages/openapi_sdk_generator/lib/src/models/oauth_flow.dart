import 'oauth_scopes.dart';

/// OAuth flow
class OAuthFlow {
  /// Authorization URL
  final String? authorizationUrl;

  /// Token URL
  final String? tokenUrl;

  /// Refresh URL
  final String? refreshUrl;

  /// Scopes
  final OAuthScopes scopes;

  OAuthFlow({
    this.authorizationUrl,
    this.tokenUrl,
    this.refreshUrl,
    required this.scopes,
  });

  factory OAuthFlow.fromJson(Map<String, dynamic> json) {
    return OAuthFlow(
      authorizationUrl: json['authorizationUrl'] as String?,
      tokenUrl: json['tokenUrl'] as String?,
      refreshUrl: json['refreshUrl'] as String?,
      scopes: OAuthScopes.fromJson(json['scopes'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (authorizationUrl != null) 'authorizationUrl': authorizationUrl,
      if (tokenUrl != null) 'tokenUrl': tokenUrl,
      if (refreshUrl != null) 'refreshUrl': refreshUrl,
      'scopes': scopes.toJson(),
    };
  }
}

