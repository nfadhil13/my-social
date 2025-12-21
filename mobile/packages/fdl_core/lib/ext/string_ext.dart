extension StringExt on String {
  /// Capitalize The First Letter
  /// ```dart
  /// final capitalized = "hello".capitalize;
  /// ```
  /// Result = "Hello"
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
