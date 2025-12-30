import 'header.dart';
import 'media_type.dart';
import 'link.dart';

/// Response definition
class Response {
  /// Description
  final String description;

  /// Headers
  final Map<String, Header>? headers;

  /// Content (media types)
  final Map<String, MediaType>? content;

  /// Links
  final Map<String, Link>? links;

  Response({
    required this.description,
    this.headers,
    this.content,
    this.links,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      description: json['description'] as String,
      headers: json['headers'] != null
          ? Map<String, Header>.from(
              (json['headers'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Header.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      content: json['content'] != null
          ? Map<String, MediaType>.from(
              (json['content'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  MediaType.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
      links: json['links'] != null
          ? Map<String, Link>.from(
              (json['links'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  Link.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      if (headers != null)
        'headers': headers!.map((key, value) => MapEntry(key, value.toJson())),
      if (content != null)
        'content': content!.map((key, value) => MapEntry(key, value.toJson())),
      if (links != null)
        'links': links!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

