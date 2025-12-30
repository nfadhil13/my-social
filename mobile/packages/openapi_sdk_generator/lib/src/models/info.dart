/// API information
class Info {
  /// API title
  final String title;

  /// API version
  final String version;

  /// API description
  final String? description;

  /// Terms of service URL
  final String? termsOfService;

  /// Contact information
  final Contact? contact;

  /// License information
  final License? license;

  Info({
    required this.title,
    required this.version,
    this.description,
    this.termsOfService,
    this.contact,
    this.license,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      title: json['title'] as String,
      version: json['version'] as String,
      description: json['description'] as String?,
      termsOfService: json['termsOfService'] as String?,
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'] as Map<String, dynamic>)
          : null,
      license: json['license'] != null
          ? License.fromJson(json['license'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'version': version,
      if (description != null) 'description': description,
      if (termsOfService != null) 'termsOfService': termsOfService,
      if (contact != null) 'contact': contact!.toJson(),
      if (license != null) 'license': license!.toJson(),
    };
  }
}

/// Contact information
class Contact {
  final String? name;
  final String? url;
  final String? email;

  Contact({this.name, this.url, this.email});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String?,
      url: json['url'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (email != null) 'email': email,
    };
  }
}

/// License information
class License {
  final String name;
  final String? url;

  License({required this.name, this.url});

  factory License.fromJson(Map<String, dynamic> json) {
    return License(name: json['name'] as String, url: json['url'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, if (url != null) 'url': url};
  }
}
