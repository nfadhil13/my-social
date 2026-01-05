import 'dart:io';
import 'package:http/http.dart' as http;

/// Abstract class for OpenAPI specification sources
sealed class OpenApiSource {
  // Returns the OpenAPI specification json string
  Future<String> getSpesificationAsString();
}

class OpenApiNetworkSource implements OpenApiSource {
  /// The URL to fetch the OpenAPI specification from
  final String url;

  /// Optional headers for the HTTP request
  final Map<String, String>? headers;

  /// Optional timeout in seconds (default: 30)
  final int timeoutSeconds;

  OpenApiNetworkSource({
    required this.url,
    this.headers,
    this.timeoutSeconds = 30,
  });

  @override
  Future<String> getSpesificationAsString() async {
    try {
      final uri = Uri.parse(url);
      final request = http.Request('GET', uri);

      if (headers != null) {
        request.headers.addAll(headers!);
      }

      final streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutSeconds),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return response.body;
        } catch (e) {
          throw Exception('Failed to parse OpenAPI specification as JSON: $e');
        }
      } else {
        throw Exception(
          'Failed to load OpenAPI specification: '
          'HTTP ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      throw Exception('Failed to connect to $url: ${e.message}');
    } on HttpException catch (e) {
      throw Exception(
        'HTTP error while fetching OpenAPI specification: ${e.message}',
      );
    } catch (e) {
      throw Exception('Error fetching OpenAPI specification from $url: $e');
    }
  }
}

class OpenApiFileSource implements OpenApiSource {
  final String filePath;

  OpenApiFileSource({required this.filePath});

  @override
  Future<String> getSpesificationAsString() async {
    try {
      final file = File(filePath);
      return file.readAsString();
    } catch (e) {
      throw Exception(
        'Failed to read OpenAPI specification from $filePath: $e',
      );
    }
  }
}
