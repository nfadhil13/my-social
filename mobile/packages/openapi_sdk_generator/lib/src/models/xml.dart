/// XML representation
class Xml {
  /// Name
  final String? name;

  /// Namespace
  final String? namespace;

  /// Prefix
  final String? prefix;

  /// Attribute
  final bool? attribute;

  /// Wrapped
  final bool? wrapped;

  Xml({this.name, this.namespace, this.prefix, this.attribute, this.wrapped});

  factory Xml.fromJson(Map<String, dynamic> json) {
    return Xml(
      name: json['name'] as String?,
      namespace: json['namespace'] as String?,
      prefix: json['prefix'] as String?,
      attribute: json['attribute'] as bool?,
      wrapped: json['wrapped'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (namespace != null) 'namespace': namespace,
      if (prefix != null) 'prefix': prefix,
      if (attribute != null) 'attribute': attribute,
      if (wrapped != null) 'wrapped': wrapped,
    };
  }
}
