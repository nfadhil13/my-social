/// Example value
class Example {
  /// Summary
  final String? summary;

  /// Description
  final String? description;

  /// Value
  final dynamic value;

  /// External value URL
  final String? externalValue;

  Example({
    this.summary,
    this.description,
    this.value,
    this.externalValue,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      value: json['value'],
      externalValue: json['externalValue'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
      if (externalValue != null) 'externalValue': externalValue,
    };
  }
}

