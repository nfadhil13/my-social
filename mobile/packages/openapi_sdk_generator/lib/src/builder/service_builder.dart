import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../naming_conventions.dart';
import 'naming_utils.dart';
import '../models/models.dart' as models;
import 'model_builder/model_builder.dart';
import 'package:code_builder/code_builder.dart' as cb;

class ServiceBuilder {
  final String packageName;
  final models.OpenApiSpec spec;
  final NamingConvention classNamingConvention;
  final NamingConvention propertyNamingConvention;
  final Map<String, String> schemaNameMap;
  final DartFormatter formatter;

  ServiceBuilder(
    this.spec,
    this.classNamingConvention,
    this.propertyNamingConvention,
    this.schemaNameMap,
    this.formatter,
    this.packageName,
  );

  GenerateServiceResult generateServices() {
    final services = <String, ClassMetaData>{};
    final serviceMethodMap = <String, List<ServiceMethod>>{};

    // Group operations by tag or create a default service
    for (final pathEntry in spec.paths.paths.entries) {
      final path = pathEntry.key;
      final pathItem = pathEntry.value;

      final operations = [
        if (pathItem.get != null) _OperationInfo('GET', pathItem.get!, path),
        if (pathItem.post != null) _OperationInfo('POST', pathItem.post!, path),
        if (pathItem.put != null) _OperationInfo('PUT', pathItem.put!, path),
        if (pathItem.delete != null)
          _OperationInfo('DELETE', pathItem.delete!, path),
        if (pathItem.patch != null)
          _OperationInfo('PATCH', pathItem.patch!, path),
      ];

      for (final opInfo in operations) {
        final operation = opInfo.operation;
        final method = opInfo.method;
        final tags = operation.tags ?? ['default'];
        final tag = tags.first;

        final serviceName = NamingUtils.toPascalCase(
          '${tag}_service',
          from: NamingConvention.snakeCase,
        );

        if (!serviceMethodMap.containsKey(serviceName)) {
          serviceMethodMap[serviceName] = [];
        }

        final methodName = _generateMethodName(operation, path, method);
        final pathParamsList = pathItem.parameters ?? <models.Parameter>[];
        final serviceMethod = _buildServiceMethod(
          methodName,
          method,
          path,
          operation,
          pathParamsList,
        );

        serviceMethodMap[serviceName]!.add(serviceMethod);
      }
    }

    // Generate service classes
    for (final entry in serviceMethodMap.entries) {
      final serviceName = entry.key;
      final methods = entry.value;

      final serviceClass = _generateServiceClass(serviceName, methods);
      final fileName = NamingUtils.toSnakeCase(
        serviceName,
        from: NamingConvention.pascalCase,
      );
      final code = formatter.format('${serviceClass.accept(DartEmitter())}');

      services[serviceName] = ClassMetaData(
        code: code,
        fileName: '$fileName.dart',
      );
    }

    final parentClass = _generateParentClass(services);
    final parentClassCode = formatter.format(
      '${parentClass.accept(DartEmitter())}',
    );

    return GenerateServiceResult(
      services: services,
      serviceClass: ClassMetaData(
        code: parentClassCode,
        fileName: '$packageName.dart',
      ),
    );
  }

  Library _generateParentClass(Map<String, ClassMetaData> services) {
    final library = LibraryBuilder();
    library.directives.addAll([
      Directive.import('package:dio/dio.dart'),
      Directive.import('index.dart'),
    ]);

    final classBuilder = ClassBuilder()..name = 'Service';

    // Add constructor
    classBuilder.constructors.add(
      (ConstructorBuilder()
            ..initializers.add(
              Code(
                services.entries
                    .map((e) {
                      final key = e.key;
                      final fieldName = NamingUtils.toCamelCase(
                        key,
                        from: NamingConvention.pascalCase,
                      );
                      final classType = key;
                      return '$fieldName = $classType(_dio)';
                    })
                    .join(', '),
              ),
            )
            ..requiredParameters.add(
              (ParameterBuilder()
                    ..name = '_dio'
                    ..toThis = true)
                  .build(),
            ))
          .build(),
    );

    // Add Dio field
    classBuilder.fields.add(
      (FieldBuilder()
            ..name = '_dio'
            ..type = refer('Dio')
            ..modifier = FieldModifier.final$)
          .build(),
    );

    for (final entry in services.entries) {
      final serviceName = entry.key;
      final fieldName = NamingUtils.toCamelCase(
        serviceName,
        from: NamingConvention.pascalCase,
      );
      final classType = serviceName;

      // Add Dio field
      classBuilder.fields.add(
        (FieldBuilder()
              ..name = fieldName
              ..type = refer(classType)
              ..modifier = FieldModifier.final$)
            .build(),
      );
    }

    library.body.add(classBuilder.build());

    return library.build();
  }

  Library _generateServiceClass(String className, List<ServiceMethod> methods) {
    final library = LibraryBuilder();

    // Add imports
    library.directives.addAll([
      Directive.import('package:dio/dio.dart'),
      Directive.import('../models/index.dart'),
      Directive.import('result/index.dart'),
    ]);

    final classBuilder = ClassBuilder()..name = className;

    // Add Dio field
    classBuilder.fields.add(
      (FieldBuilder()
            ..name = '_dio'
            ..type = refer('Dio')
            ..modifier = FieldModifier.final$)
          .build(),
    );

    // Add constructor
    classBuilder.constructors.add(
      (ConstructorBuilder()
            ..requiredParameters.add(
              (ParameterBuilder()
                    ..name = '_dio'
                    ..toThis = true)
                  .build(),
            ))
          .build(),
    );

    // Add methods
    for (final method in methods) {
      classBuilder.methods.add(method.method);
    }

    library.body.add(classBuilder.build());
    return library.build();
  }

  ServiceMethod _buildServiceMethod(
    String methodName,
    String httpMethod,
    String path,
    models.Operation operation,
    List<models.Parameter> pathParameters,
  ) {
    final methodBuilder = MethodBuilder()
      ..modifier = MethodModifier.async
      ..name = methodName;

    // Determine return type
    final returnType = _resolveReturnType(operation, path, httpMethod);
    methodBuilder.returns = TypeReference(
      (b) => b
        ..symbol = 'Future'
        ..types.add(returnType),
    );

    // Collect all parameters
    final allParameters = <models.Parameter>[];
    allParameters.addAll(pathParameters);
    if (operation.parameters != null) {
      allParameters.addAll(operation.parameters!);
    }

    // Separate parameters by location
    final pathParams = allParameters.where((p) => p.in_ == 'path').toList();
    final queryParams = allParameters.where((p) => p.in_ == 'query').toList();

    // Add method parameters
    final methodParams = <ParameterBuilder>[];

    // Path parameters
    for (final param in pathParams) {
      final paramName = NamingUtils.toCamelCase(
        param.name,
        from: propertyNamingConvention,
      );
      final paramType = _resolveParameterType(param);
      final isRequired = param.required ?? false;
      methodParams.add(
        ParameterBuilder()
          ..name = paramName
          ..type = paramType
          ..required = isRequired,
      );
    }

    // Query parameters - use Map for simplicity
    if (queryParams.isNotEmpty) {
      methodParams.add(
        ParameterBuilder()
          ..name = 'queryParams'
          ..type = TypeReference(
            (b) => b
              ..symbol = 'Map'
              ..types.addAll([refer('String'), refer('dynamic')])
              ..isNullable = true,
          )
          ..named = true,
      );
    }

    // Request body
    if (operation.requestBody != null) {
      final bodyType = _resolveRequestBodyType(operation.requestBody!);
      methodParams.add(
        ParameterBuilder()
          ..name = 'body'
          ..type = bodyType,
      );
    }

    methodBuilder.requiredParameters.addAll(methodParams.map((p) => p.build()));

    // Build method body
    final bodyCode = _buildMethodBody(
      httpMethod,
      path,
      pathParams,
      queryParams,
      returnType,
      operation.requestBody != null,
    );

    methodBuilder.body = bodyCode;

    return ServiceMethod(method: methodBuilder.build());
  }

  Code _buildMethodBody(
    String httpMethod,
    String path,
    List<models.Parameter> pathParams,
    List<models.Parameter> queryParams,
    Reference returnType,
    bool hasRequestBody,
  ) {
    final statements = <Code>[];

    // Build path string with parameter interpolation
    Expression pathExpression;
    if (pathParams.isEmpty) {
      pathExpression = literalString(path);
    } else {
      // Build path using string interpolation
      // Generate code like: final path = '/users/$userId/posts';
      String pathTemplate = path;
      for (final param in pathParams) {
        final paramNameCamel = NamingUtils.toCamelCase(
          param.name,
          from: propertyNamingConvention,
        );
        pathTemplate = pathTemplate.replaceAll(
          '{${param.name}}',
          '\$$paramNameCamel',
        );
      }

      // Assign path to a variable first
      statements.add(Code("final path = '$pathTemplate';"));
      pathExpression = refer('path');
    }

    // Build query parameters map if needed
    if (queryParams.isNotEmpty) {
      final queryParamsMap = refer(
        'queryParams',
      ).ifNullThen(literalMap({}, refer('String'), refer('dynamic')));
      statements.add(refer('queryParameters').assign(queryParamsMap).statement);
    }

    // Build Dio method call arguments
    final dioMethodArgs = <String, Expression>{
      if (queryParams.isNotEmpty) 'queryParameters': refer('queryParameters'),
      if (hasRequestBody) 'data': refer('body').property('toJson').call([]),
    };

    // Build Dio method call
    final dioMethod = refer('_dio').awaited
        .property(httpMethod.toLowerCase())
        .call([pathExpression], dioMethodArgs);

    // Create response variable
    statements.add(declareFinal('response').assign(dioMethod).statement);

    // Build return statement
    final returnExpression = _buildResponseParser(returnType);
    statements.add(returnExpression.returned.statement);

    return Block.of(statements);
  }

  Expression _buildResponseParser(Reference returnType) {
    final responseData = refer('response').property('data');
    final symbol = returnType.symbol;

    if (symbol == null) {
      return responseData;
    }

    // Check if it's a service result model
    if (symbol.endsWith('ApiResponse')) {
      return refer(symbol).property('fromJson').call([
        responseData.asA(
          TypeReference(
            (b) => b
              ..symbol = 'Map'
              ..types.addAll([refer('String'), refer('dynamic')]),
          ),
        ),
      ]);
    }

    // Check if it's a list
    if (symbol == 'List') {
      final types = (returnType as TypeReference).types;
      if (types.isNotEmpty) {
        final itemType = types.first;
        final itemSymbol = itemType.symbol;
        if (itemSymbol != null && itemSymbol.endsWith('ApiResponse')) {
          return responseData
              .asA(refer('List'))
              .property('map')
              .call([
                Method(
                  (b) => b
                    ..requiredParameters.add(
                      (ParameterBuilder()..name = 'e').build(),
                    )
                    ..body = refer(itemSymbol).property('fromJson').call([
                      refer('e').asA(
                        TypeReference(
                          (b) => b
                            ..symbol = 'Map'
                            ..types.addAll([refer('String'), refer('dynamic')]),
                        ),
                      ),
                    ]).code,
                ).closure,
              ])
              .property('toList')
              .call([]);
        }
      }
      return responseData.asA(refer('List'));
    }

    // Default: try to parse as model
    return refer(symbol).property('fromJson').call([
      responseData.asA(
        TypeReference(
          (b) => b
            ..symbol = 'Map'
            ..types.addAll([refer('String'), refer('dynamic')]),
        ),
      ),
    ]);
  }

  Reference _resolveReturnType(
    models.Operation operation,
    String path,
    String method,
  ) {
    // Find the first successful response (2xx)
    final successResponse = operation.responses.entries.firstWhere(
      (entry) => entry.key.startsWith('2'),
      orElse: () => operation.responses.entries.first,
    );

    if (successResponse.value.content == null) {
      return refer('void');
    }

    final jsonContent = successResponse.value.content!['application/json'];
    if (jsonContent == null || jsonContent.schema == null) {
      return refer('dynamic');
    }

    final schema = jsonContent.schema!;

    // Check if it's a service result model (allOf pattern)
    if (schema.allOf != null && schema.allOf!.isNotEmpty) {
      final snakeCaseClassName =
          '${path.split("/").skip(1).where((p) => p.isNotEmpty).map((value) => value.toLowerCase()).join("_")}_${method.toLowerCase()}_api_response';
      final dartClassName = NamingUtils.toPascalCase(
        snakeCaseClassName,
        from: NamingConvention.snakeCase,
      );
      return refer(dartClassName);
    }

    // Check if it's a reference
    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className =
          schemaNameMap[refName] ??
          NamingUtils.toPascalCase(refName, from: classNamingConvention);
      return refer(className);
    }

    // Check if it's an array
    if (schema.type == 'array' && schema.items != null) {
      final itemType = _resolveSchemaType(schema.items!);
      return TypeReference(
        (b) => b
          ..symbol = 'List'
          ..types.add(itemType),
      );
    }

    // Default
    return refer('dynamic');
  }

  Reference _resolveSchemaType(models.Schema schema) {
    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className =
          schemaNameMap[refName] ??
          NamingUtils.toPascalCase(refName, from: classNamingConvention);
      return refer(className);
    }

    switch (schema.type) {
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
      default:
        return refer('dynamic');
    }
  }

  Reference _resolveRequestBodyType(models.RequestBody requestBody) {
    final jsonContent = requestBody.content['application/json'];
    if (jsonContent == null || jsonContent.schema == null) {
      return refer('dynamic');
    }

    final schema = jsonContent.schema!;

    if (schema.ref != null) {
      final refName = _resolveRefName(schema.ref!);
      final className =
          schemaNameMap[refName] ??
          NamingUtils.toPascalCase(refName, from: classNamingConvention);
      return TypeReference(
        (b) => b
          ..symbol = className
          ..isNullable = !(requestBody.required ?? false),
      );
    }

    return refer('dynamic');
  }

  Reference _resolveParameterType(models.Parameter parameter) {
    final schema = parameter.schema;
    if (schema == null) {
      return refer('String');
    }

    final baseType = _resolveSchemaType(schema);
    final isRequired = parameter.required ?? false;

    if (isRequired) {
      return baseType;
    }

    return TypeReference(
      (b) => b
        ..symbol = baseType.symbol
        ..isNullable = true,
    );
  }

  String _generateMethodName(
    models.Operation operation,
    String path,
    String method,
  ) {
    // Generate from path and method
    final pathParts = path
        .split('/')
        .skip(1)
        .map((p) => p.toLowerCase())
        .join('_');

    final methodPrefix = method.toLowerCase();
    final nameParts = '${methodPrefix}_$pathParts';
    final result = NamingUtils.toCamelCase(
      nameParts,
      from: NamingConvention.snakeCase,
    );

    return result;
  }

  String _resolveRefName(String ref) {
    final parts = ref.split('/');
    return parts.last;
  }
}

class _OperationInfo {
  final String method;
  final models.Operation operation;
  final String path;

  _OperationInfo(this.method, this.operation, this.path);

  @override
  String toString() => "method: $method, operation: $operation, path: $path";
}

class ServiceMethod {
  final cb.Method method;

  ServiceMethod({required this.method});
}

class GenerateServiceResult {
  final Map<String, ClassMetaData> services;
  final ClassMetaData serviceClass;

  GenerateServiceResult({required this.services, required this.serviceClass});
}
