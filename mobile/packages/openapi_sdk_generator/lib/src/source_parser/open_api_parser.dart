import 'package:openapi_sdk_generator/src/source_parser/open_api_input_type.dart';

import '../models/models.dart';
import 'openapi_source.dart';

class OpenApiParser {
  final OpenApiSource source;
  final InputType inputType;

  OpenApiParser({required this.source, required this.inputType});

  static OpenApiParser fromInput(
    String input, {
    int timeoutSeconds = 30,
    Map<String, String>? headers,
    InputTypeEnum? inputTypeEnum,
  }) {
    // Detect if the input is a URL or a local file path.
    final bool isUrl =
        input.startsWith('http://') || input.startsWith('https://');
    late final OpenApiSource source;
    late final InputType inputType;

    if (isUrl) {
      source = OpenApiNetworkSource(url: input);
    } else {
      source = OpenApiFileSource(filePath: input);
    }

    // Choose inputType based on file extension (yaml/yml/json). Default to JsonInputType if unknown.
    if (inputTypeEnum != null) {
      inputType = InputType.fromEnum(inputTypeEnum);
    } else if (input.endsWith('.yaml') || input.endsWith('.yml')) {
      inputType = YamlInputType();
    } else {
      inputType = JsonInputType();
    }

    return OpenApiParser(source: source, inputType: inputType);
  }

  Future<OpenApiSpec> parse() async {
    final specification = await source.getSpesificationAsString();
    return inputType.parse(specification);
  }
}
