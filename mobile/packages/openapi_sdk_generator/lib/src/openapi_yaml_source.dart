// import 'dart:io';
// import 'openapi_source.dart';

// /// YAML file-based OpenAPI specification source
// /// Reads the specification from a local YAML file
// class OpenApiYamlSource implements OpenApiSource {
//   /// The path to the YAML file
//   final String filePath;

//   OpenApiYamlSource(this.filePath)
//     : assert(filePath.isNotEmpty, 'File path cannot be empty');

//   @override
//   Future<String> getSpecification() async {
//     try {
//       final file = File(filePath);

//       if (!await file.exists()) {
//         throw Exception('OpenAPI specification file not found: $filePath');
//       }

//       return await file.readAsString();
//     } on FileSystemException catch (e) {
//       throw Exception(
//         'Failed to read OpenAPI specification file: ${e.message}',
//       );
//     } catch (e) {
//       throw Exception('Error reading OpenAPI specification from $filePath: $e');
//     }
//   }
// }
