import 'package:openapi_sdk_generator/src/utils/log.dart' as log;

void printHelp() {
  log.info('''
OpenAPI SDK Generator: Generate Flutter/Dart SDK from OpenAPI specification.

Main command:
  dart run openapi_sdk_generator generate <url/file> - Generates the SDK from OpenAPI specification.

Commands:
  generate <url/file>                 Generate SDK from OpenAPI specification URL or file path

Options:
  --output, -o                        Output directory (default: lib/generated)
  --package_name, -p                  Package name for generated SDK (default: openapi_sdk)
  --class_naming_convention, -c       Schema naming convention (default: pascalCase)
  --property_naming_convention, -f    Property naming convention (default: camelCase)
  --input_type, -t                    Input type: json or yaml (auto-detected from file extension if not specified)
  --timeout                           Timeout in seconds for fetching OpenAPI specification (default: 30)
  --verbose, -v                       Enable verbose logging
  --help, -h                          Show this help message

Examples:
  dart run openapi_sdk_generator generate http://localhost:3000/api-json
  dart run openapi_sdk_generator generate http://localhost:3000/api-json --output lib/generated
  dart run openapi_sdk_generator generate http://localhost:3000/api-json --output lib/generated --package my_sdk
  dart run openapi_sdk_generator generate ./openapi.json --output lib/generated
  dart run openapi_sdk_generator generate ./openapi.yaml --input_type yaml --output lib/generated
  dart run openapi_sdk_generator generate http://localhost:3000/api-yaml --input_type yaml

For more information, visit
  https://github.com/your-repo/openapi_sdk_generator
''');
}

