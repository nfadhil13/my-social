#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:openapi_sdk_generator/openapi_sdk_generator.dart';
import 'package:openapi_sdk_generator/src/runner/generate.dart';
import 'package:openapi_sdk_generator/src/runner/help.dart';
import 'package:openapi_sdk_generator/src/utils/log.dart' as log;

/// Determines what the runner will do
enum GeneratorMode {
  generate, // default
}

/// To run this:
/// -> dart run openapi_sdk_generator generate <url/file>
///
/// Generates Flutter/Dart SDK from OpenAPI specification.
void main(List<String> arguments) async {
  GeneratorMode mode;
  log.Level logLevel = log.Level.normal;

  if (arguments.isNotEmpty) {
    if (const {'-h', '--help', 'help'}.contains(arguments[0])) {
      printHelp();
      return;
    }

    switch (arguments[0]) {
      case 'generate':
        mode = GeneratorMode.generate;
        break;
      default:
        mode = GeneratorMode.generate;
    }

    // Check for verbose flag
    for (final arg in arguments) {
      if (arg == '-v' || arg == '--verbose') {
        logLevel = log.Level.verbose;
      }
    }
  } else {
    mode = GeneratorMode.generate;
  }

  log.setLevel(logLevel);

  switch (mode) {
    case GeneratorMode.generate:
      log.info('Generating SDK...\n');
      break;
  }

  final stopwatch = Stopwatch()..start();

  // Parse arguments and create config
  late OpenApiSdkGeneratorConfig config;
  String? urlOrFile;
  try {
    final parser = _createArgumentParser();
    final filteredArguments = mode == GeneratorMode.generate
        ? arguments.skip(1).toList()
        : arguments;
    final results = parser.parse(filteredArguments);

    // Check for verbose flag from parsed results
    if (results['verbose'] as bool) {
      logLevel = log.Level.verbose;
      log.setLevel(logLevel);
    }

    // Get URL/file from positional arguments
    if (mode == GeneratorMode.generate) {
      final rest = results.rest;
      if (rest.isEmpty) {
        log.error('Error: URL or file path is required.');
        log.error('Usage: openapi_sdk_generator generate <url/file> [options]');
        exit(1);
      }
      urlOrFile = rest[0];
    }

    try {
      config = OpenApiSdkGeneratorConfig.fromParser(results, urlOrFile);
    } catch (e, stackTrace) {
      log.error('Error: $e');
      if (logLevel == log.Level.verbose) {
        log.error(stackTrace.toString());
      }
      exit(1);
    }
  } catch (e, stackTrace) {
    log.error('Error parsing arguments: $e');
    if (logLevel == log.Level.verbose) {
      log.error(stackTrace.toString());
    }
    exit(1);
  }

  // Route to appropriate handler
  switch (mode) {
    case GeneratorMode.generate:
      try {
        await runGenerateSdk(config);
        if (logLevel == log.Level.verbose) {
          log.verbose('\nGeneration done. (${stopwatch.elapsed})');
        }
      } catch (e, stackTrace) {
        log.error('Error: $e');
        if (logLevel == log.Level.verbose) {
          log.error(stackTrace.toString());
        }
        exit(1);
      }
      break;
  }
}

/// Creates and configures the argument parser
ArgParser _createArgumentParser() {
  return ArgParser()
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
      defaultsTo: 'openapi_sdk',
      help: 'Package name for generated SDK',
    )
    ..addOption(
      OpenApiSdkGeneratorConfig.inputTypeOption,
      abbr: 't',
      help:
          'Input type: json or yaml (auto-detected from file extension if not specified)',
      allowed: ['json', 'yaml'],
    )
    ..addOption(
      OpenApiSdkGeneratorConfig.timeoutOption,
      help: 'Timeout in seconds for fetching OpenAPI specification',
      defaultsTo: '30',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show this help message',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Enable verbose logging',
    );
}
