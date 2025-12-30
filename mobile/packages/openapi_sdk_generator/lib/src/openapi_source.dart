import 'models/models.dart';

/// Abstract class for OpenAPI specification sources
abstract class OpenApiSource {
  /// Fetches and parses the OpenAPI specification
  /// Returns the parsed OpenApiSpec object
  Future<OpenApiSpec> getSpecification();
}
