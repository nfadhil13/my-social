# OpenAPI SDK Generator

Command-line tool to generate Flutter/Dart SDK from OpenAPI specification.

## Features

- Generate Flutter/Dart SDK from OpenAPI specification (JSON format)
- Support for network-based sources (URL/localhost)
- Class-based code generation using `code_builder`
- Configurable through `pubspec.yaml` or command-line arguments

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  openapi_sdk_generator:
    path: ../openapi_sdk_generator
```

Then activate it:

```bash
dart pub global activate --source path packages/openapi_sdk_generator
```

Or use directly:

```bash
dart run openapi_sdk_generator
```

## Usage

### Command Line

```bash
# Using command-line arguments
dart run openapi_sdk_generator --url http://localhost:3000/api-json --output lib/generated --package my_sdk

# Or if activated globally
openapi-sdk-generator --url http://localhost:3000/api-json --output lib/generated
```

### Configuration via pubspec.yaml

Add configuration to your `pubspec.yaml`:

```yaml
openapi_sdk_generator:
  url: http://localhost:3000/api-json
  output_directory: lib/generated
  package_name: my_sdk
  timeout_seconds: 30 # optional
```

Then run:

```bash
dart run openapi_sdk_generator
```

## Command Line Options

```
--url, -u          OpenAPI specification URL (required)
--output, -o       Output directory (default: lib/generated)
--package, -p      Package name for generated SDK
--config, -c       Path to pubspec.yaml (default: pubspec.yaml)
--help, -h         Show help message
```

## Generated Files

The generator creates:

- `{output_directory}/models/` - All model classes from OpenAPI schemas
- `{output_directory}/models.dart` - Export file for all models

## Architecture

- `OpenApiSource`: Abstract class for specification sources
- `OpenApiNetworkSource`: Network-based implementation (JSON format)
- `ModelBuilder`: Generates Dart model classes using `code_builder`
- CLI: Command-line interface for easy usage

## Example

```bash
# Generate SDK from local backend
dart run openapi_sdk_generator \
  --url http://localhost:3000/api-json \
  --output lib/generated \
  --package my_sdk
```

This will generate all model classes in `lib/generated/models/` directory.
