import 'schema.dart';
import 'example.dart';
import 'media_type.dart';

/// Header definition (similar to Parameter)
class Header {
  /// Description
  final String? description;

  /// Required flag
  final bool? required;

  /// Deprecated flag
  final bool? deprecated;

  /// Allow empty value
  final bool? allowEmptyValue;

  /// Schema
  final Schema? schema;

  /// Example value
  final dynamic example;

  /// Examples map
  final Map<String, Example>? examples;

  /// Content (for complex media types)
  final Map<String, MediaType>? content;

  /// Style
  final String? style;

  /// Explode
  final bool? explode;

  /// Allow reserved
  final bool? allowReserved;

  Header({
    this.description,
    this.required,
    this.deprecated,
    this.allowEmptyValue,
    this.schema,
    this.example,
    this.examples,
    this.content,
    this.style,
    this.explode,
    this.allowReserved,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      description: json['description'] as String?,
      required: json['required'] as bool?,
      deprecated: json['deprecated'] as bool?,
      allowEmptyValue: json['allowEmptyValue'] as bool?,
      schema: json['schema'] != null
          ? Schema.fromJson(json['schema'] as Map<String, dynamic>)
          : null,
      example: json['example'],
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
      content: json['content'] != null
          ? Map<String, MediaType>.from(
              (json['content'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  MediaType.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      style: json['style'] as String?,
      explode: json['explode'] as bool?,
      allowReserved: json['allowReserved'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (description != null) 'description': description,
      if (required != null) 'required': required,
      if (deprecated != null) 'deprecated': deprecated,
      if (allowEmptyValue != null) 'allowEmptyValue': allowEmptyValue,
      if (schema != null) 'schema': schema!.toJson(),
      if (example != null) 'example': example,
      if (examples != null)
        'examples': examples!.map((key, value) => MapEntry(key, value.toJson())),
      if (content != null)
        'content': content!.map((key, value) => MapEntry(key, value.toJson())),
      if (style != null) 'style': style,
      if (explode != null) 'explode': explode,
      if (allowReserved != null) 'allowReserved': allowReserved,
    };
  }
}

