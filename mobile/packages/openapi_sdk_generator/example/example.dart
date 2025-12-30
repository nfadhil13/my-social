// Example usage of OpenAPI SDK Generator
// This file demonstrates how to use the generator

import 'package:openapi_sdk_generator/openapi_sdk_generator.dart';

// The builder will automatically process this file when build_runner is executed
// Make sure to configure openapi_sdk_generator in your pubspec.yaml

void main() async {
  // Example: Create a network source
  final networkSource = OpenApiNetworkSource(
    'http://localhost:3000/api-json',
    timeoutSeconds: 30,
  );

  final spec = await networkSource.getSpecification();

  // Example: Create a YAML source (for future use)
  // final yamlSource = OpenApiYamlSource('path/to/openapi.yaml');
}
