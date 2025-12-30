import 'media_type.dart';

/// Request body definition
class RequestBody {
  /// Description
  final String? description;

  /// Content (media types)
  final Map<String, MediaType> content;

  /// Required flag
  final bool? required;

  RequestBody({
    this.description,
    required this.content,
    this.required,
  });

  factory RequestBody.fromJson(Map<String, dynamic> json) {
    return RequestBody(
      description: json['description'] as String?,
      content: Map<String, MediaType>.from(
        (json['content'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            MediaType.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      required: json['required'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (description != null) 'description': description,
      'content': content.map((key, value) => MapEntry(key, value.toJson())),
      if (required != null) 'required': required,
    };
  }
}

