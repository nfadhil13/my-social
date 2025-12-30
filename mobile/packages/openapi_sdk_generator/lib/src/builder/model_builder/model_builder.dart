import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../../models/models.dart' hide Parameter;

/// Model builder that generates Dart model classes from OpenAPI specification
class ModelBuilder {
  final OpenApiSpec spec;
  final Map<String, String> schemaNameMap = {};

  DartFormatter get _formatter {
    // Lazy initialization to avoid languageVersion requirement during construction
    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);
  }

  ModelBuilder(this.spec);

  /// Generate all model classes from the OpenAPI specification
  Map<String, String> generateModels() {
    final models = <String, String>{};

    if (spec.components?.schemas == null) {
      return models;
    }

    // First pass: collect all schema names
    for (final entry in spec.components!.schemas!.entries) {
      final schemaName = entry.key;
      final schema = entry.value;

      if (schema.ref != null) {
        continue; // Skip references, they'll be resolved later
      }

      if (schema.type == 'object' || schema.properties != null) {
        final dartClassName = _toPascalCase(schemaName);
        schemaNameMap[schemaName] = dartClassName;
      }
    }

    // Second pass: generate model classes
    for (final entry in spec.components!.schemas!.entries) {
      final schemaName = entry.key;
      final schema = entry.value;
      if (schema.ref != null) {
        continue;
      }

      if (schema.type == 'object' || schema.properties != null) {
        final dartClassName = schemaNameMap[schemaName]!;
        final modelLibrary = _generateModelClass(dartClassName, schema);
        final fileName = _toSnakeCase(schemaName);
        final code = _formatter.format('${modelLibrary.accept(DartEmitter())}');
        models['$fileName.dart'] = code;
      }
    }

    return models;
  }

  Library _generateModelClass(String className, Schema schema) {
    final library = LibraryBuilder();

    final classBuilder = ClassBuilder()..name = className;
    if (schema.properties == null || schema.properties!.isEmpty) {
      // Empty class
      library.body.add(classBuilder.build());
      return library.build();
    }

    final requiredFields = schema.required ?? [];

    // Generate fields
    final constructorParams = <ParameterBuilder>[];
    for (final entry in schema.properties!.entries) {
      final propName = entry.key;
      final propSchema = entry.value;
      final isRequired = requiredFields.contains(propName);
      final isNullable = propSchema.nullable ?? false;
      final fieldName = _toCamelCase(propName);
      final dartType = _resolveDartTypeReference(propSchema);
      // Add field
      classBuilder.fields.add(
        (FieldBuilder()
              ..name = fieldName
              ..type = dartType
              ..modifier = FieldModifier.final$)
            .build(),
      );

      // Add constructor parameter
      constructorParams.add(
        ParameterBuilder()
          ..name = fieldName
          ..named = true
          ..required = isRequired && !isNullable
          ..toThis = true,
      );
    }

    // Add constructor
    classBuilder.constructors.add(
      (ConstructorBuilder()
            ..optionalParameters.addAll(
              constructorParams.map((p) => p.build()),
            ))
          .build(),
    );

    // // Add fromJson factory
    // classBuilder.constructors.add(_buildFromJsonFactory(className, schema));

    // // Add toJson method
    // classBuilder.methods.add(_buildToJsonMethod(schema));

    library.body.add(classBuilder.build());
    return library.build();
  }

  Constructor _buildFromJsonFactory(String className, Schema schema) {
    final factory = ConstructorBuilder()
      ..factory = true
      ..name = 'fromJson'
      ..requiredParameters.add(
        (ParameterBuilder()
              ..name = 'json'
              ..type = refer('Map<String, dynamic>'))
            .build(),
      );

    if (schema.properties == null || schema.properties!.isEmpty) {
      factory.body = Code('return $className();');
      return factory.build();
    }

    final requiredFields = schema.required ?? [];
    final returnStatements = <Code>[];

    for (final entry in schema.properties!.entries) {
      final propName = entry.key;
      final propSchema = entry.value;
      final fieldName = _toCamelCase(propName);
      final isRequired = requiredFields.contains(propName);
      final isNullable = propSchema.nullable ?? false;

      final jsonAccess = refer('json').index(literalString(propName));
      final fromJsonExpr = _buildFromJsonExpression(propSchema, jsonAccess);

      if (isRequired && !isNullable) {
        returnStatements.add(Code('$fieldName: $fromJsonExpr,'));
      } else {
        final nullCheck = isNullable
            ? jsonAccess
                  .notEqualTo(literalNull)
                  .conditional(fromJsonExpr, literalNull)
            : fromJsonExpr;
        returnStatements.add(Code('$fieldName: $nullCheck,'));
      }
    }

    factory.body = Block.of([
      Code('return $className('),
      ...returnStatements,
      const Code(');'),
    ]);

    return factory.build();
  }

  Method _buildToJsonMethod(Schema schema) {
    final method = MethodBuilder()
      ..name = 'toJson'
      ..returns = refer('Map<String, dynamic>');

    if (schema.properties == null || schema.properties!.isEmpty) {
      method.body = const Code('return {};');
      return method.build();
    }

    final returnMap = <String, Expression>{};
    for (final entry in schema.properties!.entries) {
      final propName = entry.key;
      final propSchema = entry.value;
      final fieldName = _toCamelCase(propName);

      final toJsonExpr = _buildToJsonExpression(propSchema, refer(fieldName));
      final isNullable = propSchema.nullable ?? false;

      if (isNullable) {
        returnMap[propName] = refer(
          fieldName,
        ).notEqualTo(literalNull).conditional(toJsonExpr, literalNull);
      } else {
        returnMap[propName] = toJsonExpr;
      }
    }

    method.body = Code('return ${literalMap(returnMap)};');
    return method.build();
  }

  Expression _buildFromJsonExpression(Schema schema, Expression jsonValue) {
    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className = schemaNameMap[refName] ?? _toPascalCase(refName);
      return refer(className).call(
        [],
        {'json': jsonValue.asA(refer('Map<String, dynamic>'))},
        [refer('fromJson')],
      );
    }

    switch (schema.type) {
      case 'string':
        return jsonValue.asA(refer('String'));
      case 'integer':
        return jsonValue.asA(refer('num')).property('toInt').call([]);
      case 'number':
        return jsonValue.asA(refer('num')).property('toDouble').call([]);
      case 'boolean':
        return jsonValue.asA(refer('bool'));
      case 'array':
        if (schema.items != null) {
          final itemExpr = _buildFromJsonExpression(schema.items!, refer('e'));
          return jsonValue
              .asA(refer('List'))
              .property('map')
              .call([
                Method(
                  (b) => b
                    ..requiredParameters.add(
                      (ParameterBuilder()..name = 'e').build(),
                    )
                    ..body = itemExpr.code,
                ).closure,
              ])
              .property('toList')
              .call([]);
        }
        return jsonValue.asA(refer('List'));
      case 'object':
        return jsonValue.asA(refer('Map<String, dynamic>'));
      default:
        return jsonValue;
    }
  }

  Expression _buildToJsonExpression(Schema schema, Expression fieldValue) {
    if (schema.ref != null) {
      return fieldValue.property('toJson').call([]);
    }

    switch (schema.type) {
      case 'string':
      case 'integer':
      case 'number':
      case 'boolean':
        return fieldValue;
      case 'array':
        if (schema.items != null) {
          final itemExpr = _buildToJsonExpression(schema.items!, refer('e'));
          return fieldValue
              .property('map')
              .call([
                Method(
                  (b) => b
                    ..requiredParameters.add(
                      (ParameterBuilder()..name = 'e').build(),
                    )
                    ..body = itemExpr.code,
                ).closure,
              ])
              .property('toList')
              .call([]);
        }
        return fieldValue;
      case 'object':
        if (schema.properties != null) {
          return fieldValue.property('toJson').call([]);
        }
        return fieldValue;
      default:
        return fieldValue;
    }
  }

  Reference _resolveDartTypeReference(Schema schema) {
    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className = schemaNameMap[refName] ?? _toPascalCase(refName);
      final ref = refer(className);
      return schema.nullable ?? false
          ? TypeReference(
              (b) => b
                ..symbol = className
                ..isNullable = true,
            )
          : ref;
    }

    if (schema.enumValues != null && schema.enumValues!.isNotEmpty) {
      final ref = refer('String');
      return schema.nullable ?? false
          ? TypeReference(
              (b) => b
                ..symbol = 'String'
                ..isNullable = true,
            )
          : ref;
    }

    final baseRef = _getPrimitiveTypeReference(schema.type);
    if (schema.nullable ?? false) {
      if (baseRef is TypeReference) {
        return TypeReference(
          (b) => b
            ..symbol = baseRef.symbol
            ..types.addAll(baseRef.types)
            ..isNullable = true,
        );
      }
      return TypeReference(
        (b) => b
          ..symbol = baseRef.symbol
          ..isNullable = true,
      );
    }
    return baseRef;
  }

  Reference _getPrimitiveTypeReference(String? type) {
    switch (type) {
      case 'string':
        return refer('String');
      case 'integer':
        return refer('int');
      case 'number':
        return refer('double');
      case 'boolean':
        return refer('bool');
      case 'array':
        return TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(refer('dynamic')),
        );
      case 'object':
        return TypeReference(
          (b) => b
            ..symbol = 'Map'
            ..types.addAll([refer('String'), refer('dynamic')]),
        );
      default:
        return refer('dynamic');
    }
  }

  String _resolveRefName(String ref) {
    // Handle $ref format: #/components/schemas/ModelName
    final parts = ref.split('/');
    return parts.last;
  }

  String _toPascalCase(String str) {
    if (str.isEmpty) return str;
    final parts = str.split(RegExp(r'[-_\s]+'));
    return parts.map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).join();
  }

  String _toCamelCase(String str) {
    if (str.isEmpty) return str;
    final pascal = _toPascalCase(str);
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  String _toSnakeCase(String str) {
    return str
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'[-_\s]+'), '_')
        .replaceFirst(RegExp(r'^_'), '')
        .toLowerCase();
  }
}
