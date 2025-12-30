import 'parameter.dart';
import 'request_body.dart';
import 'response.dart';
import 'security_requirement.dart';
import 'external_documentation.dart';
import 'callback.dart';
import 'server.dart';

/// HTTP operation
class Operation {
  /// List of tags
  final List<String>? tags;

  /// Summary
  final String? summary;

  /// Description
  final String? description;

  /// Operation ID (unique identifier)
  final String? operationId;

  /// List of parameters
  final List<Parameter>? parameters;

  /// Request body
  final RequestBody? requestBody;

  /// Responses
  final Map<String, Response> responses;

  /// Callbacks
  final Map<String, Callback>? callbacks;

  /// Deprecated flag
  final bool? deprecated;

  /// Security requirements
  final List<SecurityRequirement>? security;

  /// Servers
  final List<Server>? servers;

  /// External documentation
  final ExternalDocumentation? externalDocs;

  Operation({
    this.tags,
    this.summary,
    this.description,
    this.operationId,
    this.parameters,
    this.requestBody,
    required this.responses,
    this.callbacks,
    this.deprecated,
    this.security,
    this.servers,
    this.externalDocs,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      tags: json['tags'] != null
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : null,
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      operationId: json['operationId'] as String?,
      parameters: json['parameters'] != null
          ? (json['parameters'] as List)
              .map((e) => Parameter.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      requestBody: json['requestBody'] != null
          ? RequestBody.fromJson(json['requestBody'] as Map<String, dynamic>)
          : null,
      responses: Map<String, Response>.from(
        (json['responses'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            Response.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      callbacks: json['callbacks'] != null
          ? Map<String, Callback>.from(
              (json['callbacks'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Callback.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      deprecated: json['deprecated'] as bool?,
      security: json['security'] != null
          ? (json['security'] as List)
              .map((e) => SecurityRequirement.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      servers: json['servers'] != null
          ? (json['servers'] as List)
              .map((e) => Server.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      externalDocs: json['externalDocs'] != null
          ? ExternalDocumentation.fromJson(
              json['externalDocs'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (tags != null) 'tags': tags,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (operationId != null) 'operationId': operationId,
      if (parameters != null)
        'parameters': parameters!.map((e) => e.toJson()).toList(),
      if (requestBody != null) 'requestBody': requestBody!.toJson(),
      'responses': responses.map((key, value) => MapEntry(key, value.toJson())),
      if (callbacks != null)
        'callbacks': callbacks!.map((key, value) => MapEntry(key, value.toJson())),
      if (deprecated != null) 'deprecated': deprecated,
      if (security != null) 'security': security!.map((e) => e.toJson()).toList(),
      if (servers != null) 'servers': servers!.map((e) => e.toJson()).toList(),
      if (externalDocs != null) 'externalDocs': externalDocs!.toJson(),
    };
  }
}

