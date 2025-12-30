/// OAuth scopes (map of scope name to description)
class OAuthScopes {
  final Map<String, String> scopes;

  OAuthScopes({required this.scopes});

  factory OAuthScopes.fromJson(Map<String, dynamic> json) {
    return OAuthScopes(
      scopes: Map<String, String>.from(
        json.map((key, value) => MapEntry(key.toString(), value.toString())),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return scopes;
  }
}

