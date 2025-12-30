/// Server variable
class ServerVariable {
  /// Default value
  final String defaultValue;

  /// Enum values
  final List<String>? enumValues;

  /// Description
  final String? description;

  ServerVariable({
    required this.defaultValue,
    this.enumValues,
    this.description,
  });

  factory ServerVariable.fromJson(Map<String, dynamic> json) {
    return ServerVariable(
      defaultValue: json['default'] as String,
      enumValues: json['enum'] != null
          ? (json['enum'] as List).map((e) => e.toString()).toList()
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default': defaultValue,
      if (enumValues != null) 'enum': enumValues,
      if (description != null) 'description': description,
    };
  }
}

