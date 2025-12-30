import 'schema.dart';
import 'response.dart';
import 'parameter.dart';
import 'example.dart';
import 'request_body.dart';
import 'header.dart';
import 'security_scheme.dart';
import 'link.dart';
import 'callback.dart';

/// Components (reusable objects)
class Components {
  /// Schemas
  final Map<String, Schema>? schemas;

  /// Responses
  final Map<String, Response>? responses;

  /// Parameters
  final Map<String, Parameter>? parameters;

  /// Examples
  final Map<String, Example>? examples;

  /// Request bodies
  final Map<String, RequestBody>? requestBodies;

  /// Headers
  final Map<String, Header>? headers;

  /// Security schemes
  final Map<String, SecurityScheme>? securitySchemes;

  /// Links
  final Map<String, Link>? links;

  /// Callbacks
  final Map<String, Callback>? callbacks;

  Components({
    this.schemas,
    this.responses,
    this.parameters,
    this.examples,
    this.requestBodies,
    this.headers,
    this.securitySchemes,
    this.links,
    this.callbacks,
  });

  factory Components.fromJson(Map<String, dynamic> json) {
    return Components(
      schemas: json['schemas'] != null
          ? Map<String, Schema>.from(
              (json['schemas'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Schema.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      responses: json['responses'] != null
          ? Map<String, Response>.from(
              (json['responses'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Response.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      parameters: json['parameters'] != null
          ? Map<String, Parameter>.from(
              (json['parameters'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Parameter.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      examples: json['examples'] != null
          ? Map<String, Example>.from(
              (json['examples'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Example.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      requestBodies: json['requestBodies'] != null
          ? Map<String, RequestBody>.from(
              (json['requestBodies'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  RequestBody.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      headers: json['headers'] != null
          ? Map<String, Header>.from(
              (json['headers'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Header.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      securitySchemes: json['securitySchemes'] != null
          ? Map<String, SecurityScheme>.from(
              (json['securitySchemes'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  SecurityScheme.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      links: json['links'] != null
          ? Map<String, Link>.from(
              (json['links'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Link.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (schemas != null)
        'schemas': schemas!.map((key, value) => MapEntry(key, value.toJson())),
      if (responses != null)
        'responses': responses!.map((key, value) => MapEntry(key, value.toJson())),
      if (parameters != null)
        'parameters':
            parameters!.map((key, value) => MapEntry(key, value.toJson())),
      if (examples != null)
        'examples': examples!.map((key, value) => MapEntry(key, value.toJson())),
      if (requestBodies != null)
        'requestBodies':
            requestBodies!.map((key, value) => MapEntry(key, value.toJson())),
      if (headers != null)
        'headers': headers!.map((key, value) => MapEntry(key, value.toJson())),
      if (securitySchemes != null)
        'securitySchemes':
            securitySchemes!.map((key, value) => MapEntry(key, value.toJson())),
      if (links != null)
        'links': links!.map((key, value) => MapEntry(key, value.toJson())),
      if (callbacks != null)
        'callbacks': callbacks!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

