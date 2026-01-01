#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:openapi_sdk_generator/openapi_sdk_generator.dart';

void main(List<String> arguments) async {
  try {
    final parser = ArgParser()
      ..addOption(
        OpenApiSdkGeneratorConfig.urlOption,
        abbr: 'u',
        help: 'OpenAPI specification URL',
      )
      ..addOption(
        OpenApiSdkGeneratorConfig.outputOption,
        abbr: 'o',
        help: 'Output directory for generated SDK',
        defaultsTo: 'lib/generated',
      )
      ..addOption(
        OpenApiSdkGeneratorConfig.classNamingConventionOption,
        abbr: 'c',
        help: 'Schema naming convention',
        defaultsTo: NamingConvention.pascalCase.name,
      )
      ..addOption(
        OpenApiSdkGeneratorConfig.propertyNamingConventionOption,
        abbr: 'f',
        help: 'Property naming convention',
        defaultsTo: NamingConvention.camelCase.name,
      )
      ..addOption(
        OpenApiSdkGeneratorConfig.packageNameOption,
        abbr: 'p',
        help: 'Package name for generated SDK',
      )
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Show this help message',
      );

    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('OpenAPI SDK Generator');
      print('');
      print('Usage:');
      print('  dart run openapi_sdk_generator [options]');
      print('');
      print('Options:');
      print(parser.usage);
      exit(0);
    }

    late OpenApiSdkGeneratorConfig config;

    try {
      config = OpenApiSdkGeneratorConfig.fromParser(results);
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);
      exit(1);
    }

    final url = config.url;
    if (url == null || url.isEmpty) {
      print(
        'Error: URL is required. Provide --url or configure in pubspec.yaml',
      );
      exit(1);
    }

    final outputDir = config.outputDirectory;

    print('🚀 OpenAPI SDK Generator');
    print('');
    print('📡 Fetching OpenAPI specification from: $url');

    // Create source and fetch spec
    final source = OpenApiNetworkSource(url);
    final spec = await source.getSpecification();

    print('✅ Fetched OpenAPI specification');
    print('   Title: ${spec.info.title}');
    print('   Version: ${spec.info.version}');
    print('');

    // Generate models
    print('🔨 Generating SDK models...');
    final modelBuilder = ModelBuilder(
      spec,
      config.classNamingConvention,
      config.propertyNamingConvention,
    );
    final models = modelBuilder.generateModels();

    print('✅ Generated ${models.length} model classes');
    print('');

    // Determine output directory
    final currentDir = Directory.current;
    final outputDirectory = Directory(
      path.join(currentDir.path, outputDir, 'models'),
    );
    await outputDirectory.create(recursive: true);

    // Write model files
    print('📝 Writing model files...');
    for (final entry in models.entries) {
      final fileName = entry.value.fileName;
      final content = entry.value;
      final file = File(path.join(outputDirectory.path, fileName));
      await file.writeAsString(content.code);
      print('   ✓ $fileName');
    }

    // Generate models.dart export file
    if (models.isNotEmpty) {
      final exportBuffer = StringBuffer();
      exportBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
      exportBuffer.writeln('// Generated from OpenAPI specification');
      exportBuffer.writeln('// Title: ${spec.info.title}');
      exportBuffer.writeln('// Version: ${spec.info.version}');
      exportBuffer.writeln('');

      for (final key in models.keys) {
        final exportName = models[key]!.fileName.replaceAll('.dart', '');
        exportBuffer.writeln("export 'models/$exportName.dart';");
      }

      final exportFile = File(
        path.join(outputDirectory.parent.path, 'models.dart'),
      );
      await exportFile.writeAsString(exportBuffer.toString());
      print('   ✓ models.dart');
    }

    print('');
    print('✨ SDK generation complete!');
    print('   Output: ${outputDirectory.path}');
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
    exit(1);
  }
}

class OpenApiSdkGeneratorConfig {
  final String? url;
  final String outputDirectory;
  final String? packageName;
  final NamingConvention classNamingConvention;
  final NamingConvention propertyNamingConvention;

  OpenApiSdkGeneratorConfig({
    required this.url,
    required this.outputDirectory,
    required this.packageName,
    required this.classNamingConvention,
    required this.propertyNamingConvention,
  });

  static const urlOption = 'url';
  static const outputOption = 'output';
  static const packageNameOption = 'package_name';
  static const classNamingConventionOption = 'class_naming_convention';
  static const propertyNamingConventionOption = 'property_naming_convention';

  static NamingConvention getNamingConvention(String? name) {
    if (name == null) {
      return NamingConvention.pascalCase;
    }
    return NamingConvention.values.firstWhere((e) => e.name == name);
  }

  factory OpenApiSdkGeneratorConfig.fromParser(ArgResults results) {
    return OpenApiSdkGeneratorConfig(
      url: results[OpenApiSdkGeneratorConfig.urlOption] as String?,
      outputDirectory:
          results[OpenApiSdkGeneratorConfig.outputOption] as String? ??
          'lib/generated',
      packageName:
          results[OpenApiSdkGeneratorConfig.packageNameOption] as String?,
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
    );
  }
}
