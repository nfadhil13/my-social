import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_style/dart_style.dart';
import 'package:openapi_sdk_generator/src/source_parser/open_api_input_type.dart';
import 'package:path/path.dart' as path;
import 'package:openapi_sdk_generator/openapi_sdk_generator.dart';
import 'package:openapi_sdk_generator/src/utils/log.dart' as log;

class OpenApiSdkGeneratorConfig {
  final String? url;
  final String outputDirectory;
  final String packageName;
  final NamingConvention classNamingConvention;
  final NamingConvention propertyNamingConvention;
  final InputTypeEnum? inputTypeEnum;
  final int timeoutSeconds;
  final Map<String, String>? headers;

  OpenApiSdkGeneratorConfig({
    required this.url,
    required this.outputDirectory,
    required this.packageName,
    required this.classNamingConvention,
    required this.propertyNamingConvention,
    this.inputTypeEnum,
    this.timeoutSeconds = 30,
    this.headers,
  });

  static const outputOption = 'output';
  static const packageNameOption = 'package_name';
  static const classNamingConventionOption = 'class_naming_convention';
  static const propertyNamingConventionOption = 'property_naming_convention';
  static const inputTypeOption = 'input_type';
  static const timeoutOption = 'timeout';

  static NamingConvention getNamingConvention(String? name) {
    if (name == null) {
      return NamingConvention.pascalCase;
    }
    return NamingConvention.values.firstWhere((e) => e.name == name);
  }

  static InputTypeEnum? getInputType(String? name) {
    if (name == null) {
      return null;
    }
    try {
      return InputTypeEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static InputTypeEnum? detectInputTypeFromPath(String? path) {
    if (path == null) return null;
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.yaml') || lowerPath.endsWith('.yml')) {
      return InputTypeEnum.yaml;
    }
    if (lowerPath.endsWith('.json')) {
      return InputTypeEnum.json;
    }
    return null;
  }

  factory OpenApiSdkGeneratorConfig.fromParser(
    ArgResults results,
    String? urlOrFile,
  ) {
    final inputTypeArg =
        results[OpenApiSdkGeneratorConfig.inputTypeOption] as String?;
    final inputTypeEnum = inputTypeArg != null
        ? getInputType(inputTypeArg)
        : detectInputTypeFromPath(urlOrFile);

    final timeoutArg =
        results[OpenApiSdkGeneratorConfig.timeoutOption] as String?;
    final timeoutSeconds = timeoutArg != null
        ? int.tryParse(timeoutArg) ?? 30
        : 30;

    return OpenApiSdkGeneratorConfig(
      url: urlOrFile,
      outputDirectory:
          results[OpenApiSdkGeneratorConfig.outputOption] as String? ??
          'lib/generated',
      packageName:
          results[OpenApiSdkGeneratorConfig.packageNameOption] as String? ??
          'openapi_sdk',
      classNamingConvention: getNamingConvention(
        results[OpenApiSdkGeneratorConfig.classNamingConventionOption]
                as String? ??
            NamingConvention.pascalCase.name,
      ),
      propertyNamingConvention: getNamingConvention(
        results[OpenApiSdkGeneratorConfig.propertyNamingConventionOption]
                as String? ??
            NamingConvention.camelCase.name,
      ),
      inputTypeEnum: inputTypeEnum,
      timeoutSeconds: timeoutSeconds,
      headers: null, // TODO: Add headers support if needed
    );
  }
}

/// Fetches the OpenAPI specification from the given URL
Future<OpenApiSpec> _fetchOpenApiSpec(
  String url, {
  int timeoutSeconds = 30,
  Map<String, String>? headers,
  InputTypeEnum? inputTypeEnum,
}) async {
  log.info('📡 Fetching OpenAPI specification from: $url');
  final source = OpenApiParser.fromInput(
    url,
    timeoutSeconds: timeoutSeconds,
    headers: headers,
    inputTypeEnum: inputTypeEnum,
  );
  final spec = await source.parse();
  log.info('✅ Fetched OpenAPI specification');
  log.info('   Title: ${spec.info.title}');
  log.info('   Version: ${spec.info.version}');
  log.info('');
  return spec;
}

/// Generates model classes from the OpenAPI specification
({
  ModelBuilder modelBuilder,
  Map<String, ClassMetaData> models,
  Map<String, ClassMetaData> serviceModels,
})
_generateModels(
  OpenApiSpec spec,
  OpenApiSdkGeneratorConfig config,
  DartFormatter formatter,
) {
  log.info('🔨 Generating SDK models...');
  final modelBuilder = ModelBuilder(
    spec,
    config.classNamingConvention,
    config.propertyNamingConvention,
    formatter,
  );
  final generatedModelResult = modelBuilder.generateModels();
  log.info('✅ Generated ${generatedModelResult.models.length} model classes');
  log.info('');

  return (
    modelBuilder: modelBuilder,
    models: generatedModelResult.models,
    serviceModels: generatedModelResult.serviceModels,
  );
}

/// Generates service classes from the OpenAPI specification
({Map<String, ClassMetaData> services, ClassMetaData serviceClass})
_generateServices(
  OpenApiSpec spec,
  OpenApiSdkGeneratorConfig config,
  ModelBuilder modelBuilder,
  DartFormatter formatter,
) {
  log.info('🔨 Generating SDK services...');
  final serviceBuilder = ServiceBuilder(
    spec,
    config.classNamingConvention,
    config.propertyNamingConvention,
    modelBuilder.schemaNameMap,
    formatter,
    config.packageName,
  );
  final generatedServiceResult = serviceBuilder.generateServices();
  log.info(
    '✅ Generated ${generatedServiceResult.services.length} service classes',
  );
  log.info('');

  return (
    services: generatedServiceResult.services,
    serviceClass: generatedServiceResult.serviceClass,
  );
}

/// Creates output directories for generated files
Future<Map<String, Directory>> _createOutputDirectories(
  String outputDir,
) async {
  final currentDir = Directory.current;
  final modelOutputDirectory = Directory(
    path.join(currentDir.path, outputDir, 'models'),
  );
  final serviceOutputDirectory = Directory(
    path.join(currentDir.path, outputDir, 'service/result'),
  );
  final serviceClassOutputDirectory = Directory(
    path.join(currentDir.path, outputDir, 'service'),
  );

  await modelOutputDirectory.create(recursive: true);
  await serviceOutputDirectory.create(recursive: true);
  await serviceClassOutputDirectory.create(recursive: true);

  return {
    'models': modelOutputDirectory,
    'serviceResult': serviceOutputDirectory,
    'serviceClass': serviceClassOutputDirectory,
  };
}

/// Writes model files to disk
Future<void> _writeModelFiles(
  Map<String, ClassMetaData> models,
  Directory modelOutputDirectory,
  Map<String, ClassMetaData> serviceModels,
  Directory serviceOutputDirectory,
) async {
  log.info('📝 Writing model files...');
  for (final entry in models.entries) {
    final fileName = entry.value.fileName;
    final content = entry.value;
    final file = File(path.join(modelOutputDirectory.path, fileName));
    await file.writeAsString(content.code);
  }

  log.info('📝 Writing service result model files...');
  for (final entry in serviceModels.entries) {
    final fileName = entry.value.fileName;
    final content = entry.value;
    final file = File(path.join(serviceOutputDirectory.path, fileName));
    await file.writeAsString(content.code);
  }
}

/// Writes service files to disk
Future<void> _writeServiceFiles(
  Map<String, ClassMetaData> services,
  Directory serviceClassOutputDirectory,
  ClassMetaData serviceClass,
) async {
  log.info('📝 Writing service files...');
  for (final entry in services.entries) {
    final fileName = entry.value.fileName;
    final content = entry.value;
    final file = File(path.join(serviceClassOutputDirectory.path, fileName));
    await file.writeAsString(content.code);
  }

  final serviceClassFile = File(
    path.join(serviceClassOutputDirectory.path, serviceClass.fileName),
  );
  await serviceClassFile.writeAsString(serviceClass.code);
}

/// Generates export files (index.dart) for models and services
Future<void> _generateExportFiles({
  required Map<String, ClassMetaData> models,
  required Map<String, ClassMetaData> serviceModels,
  required Map<String, ClassMetaData> services,
  required OpenApiSpec spec,
  required Directory modelOutputDirectory,
  required Directory serviceOutputDirectory,
  required Directory serviceClassOutputDirectory,
}) async {
  // Generate models/index.dart export file
  if (models.isNotEmpty) {
    final exportBuffer = StringBuffer();
    exportBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    exportBuffer.writeln('// Generated from OpenAPI specification');
    exportBuffer.writeln('// Title: ${spec.info.title}');
    exportBuffer.writeln('// Version: ${spec.info.version}');
    exportBuffer.writeln('');

    for (final key in models.keys) {
      final exportName = models[key]!.fileName.replaceAll('.dart', '');
      exportBuffer.writeln("export '$exportName.dart';");
    }

    final exportFile = File(path.join(modelOutputDirectory.path, 'index.dart'));
    await exportFile.writeAsString(exportBuffer.toString());
    log.info('   ✓ models/index.dart');
  }

  // Generate service/result/index.dart export file
  if (serviceModels.isNotEmpty) {
    final exportBuffer = StringBuffer();
    exportBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    exportBuffer.writeln('// Generated from OpenAPI specification');
    exportBuffer.writeln('// Title: ${spec.info.title}');
    exportBuffer.writeln('// Version: ${spec.info.version}');
    exportBuffer.writeln('');

    for (final key in serviceModels.keys) {
      final exportName = serviceModels[key]!.fileName.replaceAll('.dart', '');
      exportBuffer.writeln("export '$exportName.dart';");
    }

    final exportFile = File(
      path.join(serviceOutputDirectory.path, 'index.dart'),
    );
    await exportFile.writeAsString(exportBuffer.toString());
    log.info('   ✓ service/result/index.dart');
  }

  // Generate service/index.dart export file
  if (services.isNotEmpty) {
    final exportBuffer = StringBuffer();
    exportBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    exportBuffer.writeln('// Generated from OpenAPI specification');
    exportBuffer.writeln('// Title: ${spec.info.title}');
    exportBuffer.writeln('// Version: ${spec.info.version}');
    exportBuffer.writeln('');

    for (final key in services.keys) {
      final exportName = services[key]!.fileName.replaceAll('.dart', '');
      exportBuffer.writeln("export '$exportName.dart';");
    }

    final exportFile = File(
      path.join(serviceClassOutputDirectory.path, 'index.dart'),
    );
    await exportFile.writeAsString(exportBuffer.toString());
    log.info('   ✓ service/index.dart');
  }
}

/// Main function to generate SDK from OpenAPI specification
Future<void> runGenerateSdk(OpenApiSdkGeneratorConfig config) async {
  final url = config.url;
  if (url == null || url.isEmpty) {
    log.error(
      'Error: URL is required. Provide --url or configure in pubspec.yaml',
    );
    exit(1);
  }

  log.info('🚀 OpenAPI SDK Generator');
  log.info('');

  // STEP 1: Fetch OpenAPI specification
  final spec = await _fetchOpenApiSpec(
    url,
    timeoutSeconds: config.timeoutSeconds,
    headers: config.headers,
    inputTypeEnum: config.inputTypeEnum,
  );

  // STEP 2: Initialize formatter
  final formatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  );

  // STEP 3: Generate models
  final modelResult = _generateModels(spec, config, formatter);
  final modelBuilder = modelResult.modelBuilder;
  final models = modelResult.models;
  final serviceModels = modelResult.serviceModels;

  // STEP 4: Generate services
  final serviceResult = _generateServices(
    spec,
    config,
    modelBuilder,
    formatter,
  );
  final services = serviceResult.services;
  final serviceClass = serviceResult.serviceClass;

  // STEP 5: Create output directories
  final outputDirs = await _createOutputDirectories(config.outputDirectory);
  final modelOutputDirectory = outputDirs['models']!;
  final serviceOutputDirectory = outputDirs['serviceResult']!;
  final serviceClassOutputDirectory = outputDirs['serviceClass']!;

  // STEP 6: Write files to disk
  await _writeModelFiles(
    models,
    modelOutputDirectory,
    serviceModels,
    serviceOutputDirectory,
  );
  await _writeServiceFiles(services, serviceClassOutputDirectory, serviceClass);

  // STEP 7: Generate export files
  await _generateExportFiles(
    models: models,
    serviceModels: serviceModels,
    services: services,
    spec: spec,
    modelOutputDirectory: modelOutputDirectory,
    serviceOutputDirectory: serviceOutputDirectory,
    serviceClassOutputDirectory: serviceClassOutputDirectory,
  );

  log.info('');
  log.info('✨ SDK generation complete!');
  log.info('   Output: ${modelOutputDirectory.path}');
}
