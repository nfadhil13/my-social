# This script generates Flutter SDK code from the backend OpenAPI spec

# Fail script on any error
set -e

# Path to OpenAPI spec (adjust as needed)
OPENAPI_SPEC_PATH="http://localhost:3000/api-json"
FLUTTER_SDK_OUTPUT_PATH="mobile/packages/my_social_api"


# Clean previous sdk output
echo "Cleaning previous SDK output..."
rm -rf $FLUTTER_SDK_OUTPUT_PATH

# Generate Flutter SDK using openapi-generator-cli
echo "Generating Flutter SDK..."
npx @openapitools/openapi-generator-cli generate \
  -i $OPENAPI_SPEC_PATH \
  -g dart-dio \
  -o $FLUTTER_SDK_OUTPUT_PATH \
  --additional-properties=pubName=my_social_api

echo "Flutter SDK generated at $FLUTTER_SDK_OUTPUT_PATH"
