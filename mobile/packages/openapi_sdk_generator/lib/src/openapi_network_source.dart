import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'openapi_source.dart';
import 'models/models.dart';

/// Network-based OpenAPI specification source
/// Fetches the specification from a URL (localhost or remote) and parses it as JSON
class OpenApiNetworkSource implements OpenApiSource {
  /// The URL to fetch the OpenAPI specification from
  final String url;

  /// Optional headers for the HTTP request
  final Map<String, String>? headers;

  /// Optional timeout in seconds (default: 30)
  final int timeoutSeconds;

  OpenApiNetworkSource(this.url, {this.headers, this.timeoutSeconds = 30})
    : assert(url.isNotEmpty, 'URL cannot be empty');

  @override
  Future<OpenApiSpec> getSpecification() async {
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
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return OpenApiSpec.fromJson(jsonMap);
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
