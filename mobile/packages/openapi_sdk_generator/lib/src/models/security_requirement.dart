/// Security requirement (map of scheme name to scopes)
class SecurityRequirement {
  final Map<String, List<String>> requirements;

  SecurityRequirement({required this.requirements});

  factory SecurityRequirement.fromJson(Map<String, dynamic> json) {
    return SecurityRequirement(
      requirements: Map<String, List<String>>.from(
        json.map(
          (key, value) => MapEntry(
            key.toString(),
            value is List
                ? value.map((e) => e.toString()).toList()
                : <String>[],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return requirements;
  }
}

