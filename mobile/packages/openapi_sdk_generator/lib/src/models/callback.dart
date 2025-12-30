import 'path_item.dart';

/// Callback definition
class Callback {
  /// Map of runtime expressions to path items
  final Map<String, PathItem> pathItems;

  Callback({required this.pathItems});

  factory Callback.fromJson(Map<String, dynamic> json) {
    return Callback(
      pathItems: Map<String, PathItem>.from(
        json.map(
          (key, value) => MapEntry(
            key,
            PathItem.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return pathItems.map((key, value) => MapEntry(key, value.toJson()));
  }
}

