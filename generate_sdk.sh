# This script generates Flutter SDK code from the backend OpenAPI spec

# Fail script on any error
set -e

# Path to OpenAPI spec (adjust as needed)
OPENAPI_SPEC_PATH="${1:-http://localhost:3000/api-json}"
FLUTTER_SDK_OUTPUT_PATH="mobile/packages/my_social_sdk"

# Clean previous generated files (keep pubspec.yaml and other config)
echo "Cleaning previous generated SDK files..."
rm -rf "$FLUTTER_SDK_OUTPUT_PATH/lib/models"
rm -rf "$FLUTTER_SDK_OUTPUT_PATH/lib/services"
rm -f "$FLUTTER_SDK_OUTPUT_PATH/lib/my_social_sdk.dart"

# Generate Flutter SDK using custom TypeScript generator
echo "Generating Flutter SDK from OpenAPI spec: $OPENAPI_SPEC_PATH"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/backend"

bun run generate-dart-sdk --cwd ./scripts -- $OPENAPI_SPEC_PATH $FLUTTER_SDK_OUTPUT_PATH
echo "✅ Flutter SDK generated at $FLUTTER_SDK_OUTPUT_PATH"
