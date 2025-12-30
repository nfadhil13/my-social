#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:openapi_sdk_generator/openapi_sdk_generator.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('url', abbr: 'u', help: 'OpenAPI specification URL')
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output directory for generated SDK',
      defaultsTo: 'lib/generated',
    )
    ..addOption('package', abbr: 'p', help: 'Package name for generated SDK')
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Path to pubspec.yaml (defaults to current directory)',
      defaultsTo: 'pubspec.yaml',
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

  try {
    // Try to read config from pubspec.yaml
    final configPath = results['config'] as String;
    final configFile = File(configPath);

    Map<String, dynamic>? config;
    if (await configFile.exists()) {
      final pubspecContent = await configFile.readAsString();
      final pubspec = loadYaml(pubspecContent) as Map;

      if (pubspec.containsKey('openapi_sdk_generator')) {
        final openApiConfig = pubspec['openapi_sdk_generator'] as Map;
        config = {
          'url': results['url'] as String? ?? openApiConfig['url'] as String?,
          'output_directory':
              results['output'] as String? ??
              openApiConfig['output_directory'] as String? ??
              'lib/generated',
          'package_name':
              results['package'] as String? ??
              openApiConfig['package_name'] as String?,
        };
      }
    }

    // Use command line args if config not found
    config ??= {
      'url': results['url'] as String?,
      'output_directory': results['output'] as String? ?? 'lib/generated',
      'package_name': results['package'] as String?,
    };

    final url = config['url'] as String?;
    if (url == null || url.isEmpty) {
      print(
        'Error: URL is required. Provide --url or configure in pubspec.yaml',
      );
      exit(1);
    }

    final outputDir = config['output_directory'] as String? ?? 'lib/generated';

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
    final modelBuilder = ModelBuilder(spec);
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
      final fileName = entry.key;
      final content = entry.value;
      final file = File(path.join(outputDirectory.path, fileName));
      await file.writeAsString(content);
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

      for (final fileName in models.keys) {
        final exportName = fileName.replaceAll('.dart', '');
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
    print('❌ Error: $e');
    print(stackTrace);
    exit(1);
  }
}
