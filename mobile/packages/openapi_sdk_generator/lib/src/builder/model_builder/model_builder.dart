import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../../naming_conventions.dart';
import '../naming_utils.dart';
import '../../models/models.dart' hide Parameter;

/// Model builder that generates Dart model classes from OpenAPI specification
class ModelBuilder {
  final OpenApiSpec spec;
  final NamingConvention schemaNamingConvention;
  final NamingConvention propertyNamingConvention;
  final Map<String, String> schemaNameMap = {};

  DartFormatter get _formatter {
    // Lazy initialization to avoid languageVersion requirement during construction
    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);
  }

  ModelBuilder(
    this.spec,
    this.schemaNamingConvention,
    this.propertyNamingConvention,
  );

  /// Generate all model classes from the OpenAPI specification
  Map<String, ClassMetaData> generateModels() {
    final models = <String, ClassMetaData>{};

    if (spec.components?.schemas == null) {
      return models;
    }
    // class name -> file name
    Map<String, String> classFileNameMap = {};
    // First pass: collect all schema names
    for (final entry in spec.components!.schemas!.entries) {
      final schemaName = entry.key;
      final schema = entry.value;

      if (schema.ref != null) {
        continue; // Skip references, they'll be resolved later
      }

      if (schema.type == 'object' || schema.properties != null) {
        final dartClassName = NamingUtils.toPascalCase(
          schemaName,
          from: schemaNamingConvention,
        );
        schemaNameMap[schemaName] = dartClassName;
        classFileNameMap[dartClassName] = NamingUtils.toSnakeCase(
          schemaName,
          from: schemaNamingConvention,
        );
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
        final modelLibrary = _generateModelClass(
          dartClassName,
          schema,
          classFileNameMap,
        );
        final fileName = classFileNameMap[dartClassName]!;
        final code = _formatter.format('${modelLibrary.accept(DartEmitter())}');
        models[dartClassName] = ClassMetaData(
          code: code,
          fileName: '$fileName.dart',
        );
      }
    }

    return models;
  }

  Library _generateModelClass(
    String className,
    Schema schema,
    Map<String, String> classFileNameMap,
  ) {
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
      final fieldName = NamingUtils.toCamelCase(
        propName,
        from: propertyNamingConvention,
      );
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

    // Add fromJson factory
    classBuilder.constructors.add(_buildFromJsonFactory(className, schema));

    // // Add toJson method
    classBuilder.methods.add(_buildToJsonMethod(schema));

    library.body.add(classBuilder.build());

    for (final field in classBuilder.fields.build()) {
      final fieldType = field.type?.symbol;
      if (fieldType == null || !classFileNameMap.containsKey(fieldType)) {
        continue;
      }
      final fileName = classFileNameMap[fieldType];
      if (fileName == null) continue;
      library.directives.add(Directive.import('$fileName.dart'));
    }

    final lib = library.build();
    return lib;
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
      final fieldName = NamingUtils.toCamelCase(
        propName,
        from: propertyNamingConvention,
      );
      final isRequired = requiredFields.contains(propName);
      final isNullable = propSchema.nullable ?? false;

      final jsonAccess = refer('json').index(literalString(propName));
      final fromJsonExpr = _buildFromJsonExpression(propSchema, jsonAccess);

      if (isRequired && !isNullable) {
        returnStatements.add(
          Code('$fieldName: ${fromJsonExpr.accept(DartEmitter.scoped())},'),
        );
      } else {
        final nullCheck = isNullable
            ? jsonAccess
                  .notEqualTo(literalNull)
                  .conditional(fromJsonExpr, literalNull)
            : fromJsonExpr;
        returnStatements.add(
          Code('$fieldName: ${nullCheck.accept(DartEmitter.scoped())},'),
        );
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
      final fieldName = NamingUtils.toCamelCase(
        propName,
        from: propertyNamingConvention,
      );

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

    method.body = Code(
      'return ${literalMap(returnMap).accept(DartEmitter.scoped())};',
    );
    return method.build();
  }

  Expression _buildFromJsonExpression(Schema schema, Expression jsonValue) {
    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className =
          schemaNameMap[refName] ??
          NamingUtils.toPascalCase(refName, from: schemaNamingConvention);
      return refer(
        "$className.fromJson",
      ).call([jsonValue.asA(refer('Map<String, dynamic>'))], {}, []);
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
      final className =
          schemaNameMap[refName] ??
          NamingUtils.toPascalCase(refName, from: schemaNamingConvention);
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
}

class ClassMetaData {
  final String code;
  final String fileName;

  ClassMetaData({required this.code, required this.fileName});
}
