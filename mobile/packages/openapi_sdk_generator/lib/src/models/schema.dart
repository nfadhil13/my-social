import 'discriminator.dart';
import 'xml.dart';
import 'external_documentation.dart';

/// Schema definition
class Schema {
  /// Title
  final String? title;

  /// Multiple of
  final num? multipleOf;

  /// Maximum
  final num? maximum;

  /// Exclusive maximum
  final bool? exclusiveMaximum;

  /// Minimum
  final num? minimum;

  /// Exclusive minimum
  final bool? exclusiveMinimum;

  /// Max length
  final int? maxLength;

  /// Min length
  final int? minLength;

  /// Pattern (regex)
  final String? pattern;

  /// Max items
  final int? maxItems;

  /// Min items
  final int? minItems;

  /// Unique items
  final bool? uniqueItems;

  /// Max properties
  final int? maxProperties;

  /// Min properties
  final int? minProperties;

  /// Required properties
  final List<String>? required;

  /// Enum values
  final List<dynamic>? enumValues;

  /// Type (string, number, integer, boolean, array, object)
  final String? type;

  /// All of schemas
  final List<Schema>? allOf;

  /// One of schemas
  final List<Schema>? oneOf;

  /// Any of schemas
  final List<Schema>? anyOf;

  /// Not schema
  final Schema? not;

  /// Items schema (for arrays)
  final Schema? items;

  /// Properties
  final Map<String, Schema>? properties;

  /// Additional properties (bool or Schema)
  final dynamic additionalProperties;

  /// Description
  final String? description;

  /// Format
  final String? format;

  /// Default value
  final dynamic defaultValue;

  /// Nullable
  final bool? nullable;

  /// Discriminator
  final Discriminator? discriminator;

  /// Read only
  final bool? readOnly;

  /// Write only
  final bool? writeOnly;

  /// XML
  final Xml? xml;

  /// External documentation
  final ExternalDocumentation? externalDocs;

  /// Example
  final dynamic example;

  /// Deprecated
  final bool? deprecated;

  /// Reference (for $ref)
  final String? ref;

  Schema({
    this.title,
    this.multipleOf,
    this.maximum,
    this.exclusiveMaximum,
    this.minimum,
    this.exclusiveMinimum,
    this.maxLength,
    this.minLength,
    this.pattern,
    this.maxItems,
    this.minItems,
    this.uniqueItems,
    this.maxProperties,
    this.minProperties,
    this.required,
    this.enumValues,
    this.type,
    this.allOf,
    this.oneOf,
    this.anyOf,
    this.not,
    this.items,
    this.properties,
    this.additionalProperties,
    this.description,
    this.format,
    this.defaultValue,
    this.nullable,
    this.discriminator,
    this.readOnly,
    this.writeOnly,
    this.xml,
    this.externalDocs,
    this.example,
    this.deprecated,
    this.ref,
  });

  factory Schema.fromJson(Map<String, dynamic> json) {
    // Handle $ref
    if (json.containsKey('\$ref')) {
      return Schema(ref: json['\$ref'] as String);
    }

    return Schema(
      title: json['title'] as String?,
      multipleOf: json['multipleOf'] as num?,
      maximum: json['maximum'] as num?,
      exclusiveMaximum: json['exclusiveMaximum'] as bool?,
      minimum: json['minimum'] as num?,
      exclusiveMinimum: json['exclusiveMinimum'] as bool?,
      maxLength: json['maxLength'] as int?,
      minLength: json['minLength'] as int?,
      pattern: json['pattern'] as String?,
      maxItems: json['maxItems'] as int?,
      minItems: json['minItems'] as int?,
      uniqueItems: json['uniqueItems'] as bool?,
      maxProperties: json['maxProperties'] as int?,
      minProperties: json['minProperties'] as int?,
      required: json['required'] != null
          ? (json['required'] as List).map((e) => e.toString()).toList()
          : null,
      enumValues: json['enum'] != null ? json['enum'] as List<dynamic> : null,
      type: json['type'] as String?,
      allOf: json['allOf'] != null
          ? (json['allOf'] as List)
                .map((e) => Schema.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      oneOf: json['oneOf'] != null
          ? (json['oneOf'] as List)
                .map((e) => Schema.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      anyOf: json['anyOf'] != null
          ? (json['anyOf'] as List)
                .map((e) => Schema.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      not: json['not'] != null
          ? Schema.fromJson(json['not'] as Map<String, dynamic>)
          : null,
      items: json['items'] != null
          ? Schema.fromJson(json['items'] as Map<String, dynamic>)
          : null,
      properties: json['properties'] != null
          ? Map<String, Schema>.from(
              (json['properties'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Schema.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      additionalProperties: json['additionalProperties'],
      description: json['description'] as String?,
      format: json['format'] as String?,
      defaultValue: json['default'],
      nullable: json['nullable'] as bool?,
      discriminator: json['discriminator'] != null
          ? Discriminator.fromJson(
              json['discriminator'] as Map<String, dynamic>,
            )
          : null,
      readOnly: json['readOnly'] as bool?,
      writeOnly: json['writeOnly'] as bool?,
      xml: json['xml'] != null
          ? Xml.fromJson(json['xml'] as Map<String, dynamic>)
          : null,
      externalDocs: json['externalDocs'] != null
          ? ExternalDocumentation.fromJson(
              json['externalDocs'] as Map<String, dynamic>,
            )
          : null,
      example: json['example'],
      deprecated: json['deprecated'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    if (ref != null) {
      return {'\$ref': ref};
    }

    return {
      if (title != null) 'title': title,
      if (multipleOf != null) 'multipleOf': multipleOf,
      if (maximum != null) 'maximum': maximum,
      if (exclusiveMaximum != null) 'exclusiveMaximum': exclusiveMaximum,
      if (minimum != null) 'minimum': minimum,
      if (exclusiveMinimum != null) 'exclusiveMinimum': exclusiveMinimum,
      if (maxLength != null) 'maxLength': maxLength,
      if (minLength != null) 'minLength': minLength,
      if (pattern != null) 'pattern': pattern,
      if (maxItems != null) 'maxItems': maxItems,
      if (minItems != null) 'minItems': minItems,
      if (uniqueItems != null) 'uniqueItems': uniqueItems,
      if (maxProperties != null) 'maxProperties': maxProperties,
      if (minProperties != null) 'minProperties': minProperties,
      if (required != null) 'required': required,
      if (enumValues != null) 'enum': enumValues,
      if (type != null) 'type': type,
      if (allOf != null) 'allOf': allOf!.map((e) => e.toJson()).toList(),
      if (oneOf != null) 'oneOf': oneOf!.map((e) => e.toJson()).toList(),
      if (anyOf != null) 'anyOf': anyOf!.map((e) => e.toJson()).toList(),
      if (not != null) 'not': not!.toJson(),
      if (items != null) 'items': items!.toJson(),
      if (properties != null)
        'properties': properties!.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
      if (additionalProperties != null)
        'additionalProperties': additionalProperties,
      if (description != null) 'description': description,
      if (format != null) 'format': format,
      if (defaultValue != null) 'default': defaultValue,
      if (nullable != null) 'nullable': nullable,
      if (discriminator != null) 'discriminator': discriminator!.toJson(),
      if (readOnly != null) 'readOnly': readOnly,
      if (writeOnly != null) 'writeOnly': writeOnly,
      if (xml != null) 'xml': xml!.toJson(),
      if (externalDocs != null) 'externalDocs': externalDocs!.toJson(),
      if (example != null) 'example': example,
      if (deprecated != null) 'deprecated': deprecated,
    };
  }
}
