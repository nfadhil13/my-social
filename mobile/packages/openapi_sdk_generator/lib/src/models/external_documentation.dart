/// External documentation
class ExternalDocumentation {
  final String? description;
  final String url;

  ExternalDocumentation({
    this.description,
    required this.url,
  });

  factory ExternalDocumentation.fromJson(Map<String, dynamic> json) {
    return ExternalDocumentation(
      description: json['description'] as String?,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (description != null) 'description': description,
    };
  }
}

