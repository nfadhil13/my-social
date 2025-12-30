import 'schema.dart';
import 'example.dart';
import 'encoding.dart';

/// Media type definition
class MediaType {
  /// Schema
  final Schema? schema;

  /// Example value
  final dynamic example;

  /// Examples map
  final Map<String, Example>? examples;

  /// Encoding
  final Map<String, Encoding>? encoding;

  MediaType({
    this.schema,
    this.example,
    this.examples,
    this.encoding,
  });

  factory MediaType.fromJson(Map<String, dynamic> json) {
    return MediaType(
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
      encoding: json['encoding'] != null
          ? Map<String, Encoding>.from(
              (json['encoding'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Encoding.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (schema != null) 'schema': schema!.toJson(),
      if (example != null) 'example': example,
      if (examples != null)
        'examples': examples!.map((key, value) => MapEntry(key, value.toJson())),
      if (encoding != null)
        'encoding': encoding!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

