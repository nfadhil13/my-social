import 'info.dart';
import 'server.dart';
import 'paths.dart';
import 'components.dart';
import 'security_requirement.dart';
import 'external_documentation.dart';

/// Root OpenAPI specification model
class OpenApiSpec {
  /// OpenAPI version (e.g., "3.0.0")
  final String openapi;

  /// API information
  final Info info;

  /// List of servers
  final List<Server>? servers;

  /// API paths and operations
  final Paths paths;

  /// Components (schemas, responses, parameters, etc.)
  final Components? components;

  /// Security requirements
  final List<SecurityRequirement>? security;

  /// Tags for grouping operations
  final List<Tag>? tags;

  /// External documentation
  final ExternalDocumentation? externalDocs;

  OpenApiSpec({
    required this.openapi,
    required this.info,
    required this.paths,
    this.servers,
    this.components,
    this.security,
    this.tags,
    this.externalDocs,
  });

  factory OpenApiSpec.fromJson(Map<String, dynamic> json) {
    return OpenApiSpec(
      openapi: json['openapi'] as String,
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      paths: Paths.fromJson(json['paths'] as Map<String, dynamic>),
      servers: json['servers'] != null
          ? (json['servers'] as List)
                .map((e) => Server.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      components: json['components'] != null
          ? Components.fromJson(json['components'] as Map<String, dynamic>)
          : null,
      security: json['security'] != null
          ? (json['security'] as List)
                .map(
                  (e) =>
                      SecurityRequirement.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      tags: json['tags'] != null
          ? (json['tags'] as List)
                .map((e) => Tag.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      externalDocs: json['externalDocs'] != null
          ? ExternalDocumentation.fromJson(
              json['externalDocs'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openapi': openapi,
      'info': info.toJson(),
      'paths': paths.toJson(),
      if (servers != null) 'servers': servers!.map((e) => e.toJson()).toList(),
      if (components != null) 'components': components!.toJson(),
      if (security != null)
        'security': security!.map((e) => e.toJson()).toList(),
      if (tags != null) 'tags': tags!.map((e) => e.toJson()).toList(),
      if (externalDocs != null) 'externalDocs': externalDocs!.toJson(),
    };
  }
}

/// Tag for grouping operations
class Tag {
  final String name;
  final String? description;
  final ExternalDocumentation? externalDocs;

  Tag({required this.name, this.description, this.externalDocs});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      description: json['description'] as String?,
      externalDocs: json['externalDocs'] != null
          ? ExternalDocumentation.fromJson(
              json['externalDocs'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (externalDocs != null) 'externalDocs': externalDocs!.toJson(),
    };
  }
}
