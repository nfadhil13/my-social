import 'server_variable.dart';

/// Server information
class Server {
  /// Server URL
  final String url;

  /// Server description
  final String? description;

  /// Server variables
  final Map<String, ServerVariable>? variables;

  Server({
    required this.url,
    this.description,
    this.variables,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      url: json['url'] as String,
      description: json['description'] as String?,
      variables: json['variables'] != null
          ? Map<String, ServerVariable>.from(
              (json['variables'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  ServerVariable.fromJson(value as Map<String, dynamic>),
                ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (description != null) 'description': description,
      if (variables != null)
        'variables': variables!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

