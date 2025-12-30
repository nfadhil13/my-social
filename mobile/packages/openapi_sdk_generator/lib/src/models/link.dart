import 'server.dart';

/// Link object
class Link {
  /// Operation reference or operation ID
  final String? operationRef;

  /// Operation ID
  final String? operationId;

  /// Parameters
  final Map<String, dynamic>? parameters;

  /// Request body
  final dynamic requestBody;

  /// Description
  final String? description;

  /// Server
  final Server? server;

  Link({
    this.operationRef,
    this.operationId,
    this.parameters,
    this.requestBody,
    this.description,
    this.server,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      operationRef: json['operationRef'] as String?,
      operationId: json['operationId'] as String?,
      parameters: json['parameters'] != null
          ? Map<String, dynamic>.from(json['parameters'] as Map)
          : null,
      requestBody: json['requestBody'],
      description: json['description'] as String?,
      server: json['server'] != null
          ? Server.fromJson(json['server'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (operationRef != null) 'operationRef': operationRef,
      if (operationId != null) 'operationId': operationId,
      if (parameters != null) 'parameters': parameters,
      if (requestBody != null) 'requestBody': requestBody,
      if (description != null) 'description': description,
      if (server != null) 'server': server!.toJson(),
    };
  }
}

