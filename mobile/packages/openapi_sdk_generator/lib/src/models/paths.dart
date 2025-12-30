import 'path_item.dart';

/// API paths
class Paths {
  final Map<String, PathItem> paths;

  Paths({required this.paths});

  factory Paths.fromJson(Map<String, dynamic> json) {
    return Paths(
      paths: Map<String, PathItem>.from(
        json.map(
          (key, value) =>
              MapEntry(key, PathItem.fromJson(value as Map<String, dynamic>)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return paths.map((key, value) => MapEntry(key, value.toJson()));
  }
}
