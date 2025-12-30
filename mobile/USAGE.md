# How to Use OpenAPI SDK Generator

## Setup

The package is already configured in your `pubspec.yaml`:

```yaml
dev_dependencies:
  openapi_sdk_generator:
    path: packages/openapi_sdk_generator
```

## Configuration

Add configuration to your `pubspec.yaml`:

```yaml
openapi_sdk_generator:
  url: http://localhost:3000/api-json
  output_directory: lib/generated
  package_name: my_sdk
```

## Usage

### Option 1: Using pubspec.yaml configuration

1. **Make sure your backend is running**:

   ```bash
   cd backend
   yarn start:dev
   ```

2. **Run the generator**:
   ```bash
   cd mobile
   dart run openapi_sdk_generator
   ```

### Option 2: Using command-line arguments

```bash
dart run openapi_sdk_generator \
  --url http://localhost:3000/api-json \
  --output lib/generated \
  --package my_sdk
```

### Option 3: Activate globally

```bash
# Activate the package globally
dart pub global activate --source path packages/openapi_sdk_generator

# Then use from anywhere
openapi-sdk-generator --url http://localhost:3000/api-json
```

## Generated Files

The generator creates:

- `lib/generated/models/` - All model classes from OpenAPI schemas
- `lib/generated/models.dart` - Export file for all models

## Using Generated Models

Import the generated models:

```dart
import 'package:my_social/lib/generated/models.dart';

// Use the generated models
final user = UserResponse.fromJson(jsonData);
final json = user.toJson();
```

## Command Line Options

```
--url, -u          OpenAPI specification URL (required)
--output, -o       Output directory (default: lib/generated)
--package, -p      Package name for generated SDK
--config, -c       Path to pubspec.yaml (default: pubspec.yaml)
--help, -h         Show help message
```
