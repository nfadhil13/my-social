import 'oauth_flows.dart';

/// Security scheme definition
class SecurityScheme {
  /// Type (apiKey, http, oauth2, openIdConnect)
  final String type;

  /// Description
  final String? description;

  /// Name (for apiKey)
  final String? name;

  /// In location (for apiKey: query, header, cookie)
  final String? in_;

  /// Scheme (for http)
  final String? scheme;

  /// Bearer format (for http bearer)
  final String? bearerFormat;

  /// Flows (for oauth2)
  final OAuthFlows? flows;

  /// OpenID Connect URL (for openIdConnect)
  final String? openIdConnectUrl;

  SecurityScheme({
    required this.type,
    this.description,
    this.name,
    this.in_,
    this.scheme,
    this.bearerFormat,
    this.flows,
    this.openIdConnectUrl,
  });

  factory SecurityScheme.fromJson(Map<String, dynamic> json) {
    return SecurityScheme(
      type: json['type'] as String,
      description: json['description'] as String?,
      name: json['name'] as String?,
      in_: json['in'] as String?,
      scheme: json['scheme'] as String?,
      bearerFormat: json['bearerFormat'] as String?,
      flows: json['flows'] != null
          ? OAuthFlows.fromJson(json['flows'] as Map<String, dynamic>)
          : null,
      openIdConnectUrl: json['openIdConnectUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (description != null) 'description': description,
      if (name != null) 'name': name,
      if (in_ != null) 'in': in_,
      if (scheme != null) 'scheme': scheme,
      if (bearerFormat != null) 'bearerFormat': bearerFormat,
      if (flows != null) 'flows': flows!.toJson(),
      if (openIdConnectUrl != null) 'openIdConnectUrl': openIdConnectUrl,
    };
  }
}

