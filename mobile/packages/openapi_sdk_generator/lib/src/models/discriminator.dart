/// Discriminator for polymorphism
class Discriminator {
  /// Property name
  final String propertyName;

  /// Mapping of values to schemas
  final Map<String, String>? mapping;

  Discriminator({
    required this.propertyName,
    this.mapping,
  });

  factory Discriminator.fromJson(Map<String, dynamic> json) {
    return Discriminator(
      propertyName: json['propertyName'] as String,
      mapping: json['mapping'] != null
          ? Map<String, String>.from(
              (json['mapping'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyName': propertyName,
      if (mapping != null) 'mapping': mapping,
    };
  }
}

