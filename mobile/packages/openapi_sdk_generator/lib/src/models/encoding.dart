import 'header.dart';

/// Encoding information
class Encoding {
  /// Content type
  final String? contentType;

  /// Headers
  final Map<String, Header>? headers;

  /// Style
  final String? style;

  /// Explode
  final bool? explode;

  /// Allow reserved
  final bool? allowReserved;

  Encoding({
    this.contentType,
    this.headers,
    this.style,
    this.explode,
    this.allowReserved,
  });

  factory Encoding.fromJson(Map<String, dynamic> json) {
    return Encoding(
      contentType: json['contentType'] as String?,
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
      style: json['style'] as String?,
      explode: json['explode'] as bool?,
      allowReserved: json['allowReserved'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (contentType != null) 'contentType': contentType,
      if (headers != null)
        'headers': headers!.map((key, value) => MapEntry(key, value.toJson())),
      if (style != null) 'style': style,
      if (explode != null) 'explode': explode,
      if (allowReserved != null) 'allowReserved': allowReserved,
    };
  }
}

