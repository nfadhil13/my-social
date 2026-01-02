import 'dart:io';

import 'package:openapi_sdk_generator/src/naming_conventions.dart';

abstract class NamingUtils {
  final NamingConvention source;
  final NamingConvention target;
  NamingUtils({required this.source, required this.target});

  static String toPascalCase(String str, {required NamingConvention from}) {
    return _PascalCaseNamingUtils(source: from).convert(str);
  }

  static String toCamelCase(String str, {required NamingConvention from}) {
    return _CamelCaseNamingUtils(source: from).convert(str);
  }

  static String toSnakeCase(String str, {required NamingConvention from}) {
    return _SnakeCaseNamingUtils(source: from).convert(str);
  }

  String convert(String str) {
    switch (source) {
      case NamingConvention.pascalCase:
        return fromPascalCase(str);
      case NamingConvention.camelCase:
        return fromCamelCase(str);
      case NamingConvention.snakeCase:
        return fromSnakeCase(str);
    }
  }

  String fromPascalCase(String str);
  String fromCamelCase(String str);
  String fromSnakeCase(String str);
}

class _PascalCaseNamingUtils extends NamingUtils {
  _PascalCaseNamingUtils({required super.source})
    : super(target: NamingConvention.pascalCase);

  @override
  String fromPascalCase(String str) {
    return str;
  }

  @override
  String fromCamelCase(String str) {
    // Convert camelCase to PascalCase
    if (str.isEmpty) return str;
    return str.split(RegExp(r'[-_\s]+')).map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).join();
  }

  @override
  String fromSnakeCase(String str) {
    // Convert snake_case to PascalCase
    if (str.isEmpty) return str;
    return str.split('_').map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).join();
  }
}

class _CamelCaseNamingUtils extends NamingUtils {
  _CamelCaseNamingUtils({required super.source})
    : super(target: NamingConvention.camelCase);

  @override
  String fromPascalCase(String str) {
    // Convert PascalCase to camelCase
    if (str.isEmpty) return str;
    return str.split(RegExp(r'[-_\s]+')).map((part) {
      if (part.isEmpty) return '';
      return part[0].toLowerCase() + part.substring(1).toLowerCase();
    }).join();
  }

  @override
  String fromCamelCase(String str) {
    return str;
  }

  @override
  String fromSnakeCase(String str) {
    // Convert snake_case to camelCase
    if (str.isEmpty) return str;
    final sections = str.split('_');
    final result = <String>[];
    bool isFirst = true;
    for (final section in sections) {
      if (section.isEmpty) return '';
      String item = section;
      if (!isFirst) {
        item = item[0].toUpperCase() + item.substring(1).toLowerCase();
      }
      result.add(item);
      isFirst = false;
    }
    return result.join('');
  }
}

class _SnakeCaseNamingUtils extends NamingUtils {
  _SnakeCaseNamingUtils({required super.source})
    : super(target: NamingConvention.snakeCase);

  @override
  String fromPascalCase(String str) {
    // Conver PascalCase to snake_case
    return str
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'[-_\s]+'), '_')
        .replaceFirst(RegExp(r'^_'), '')
        .toLowerCase();
  }

  @override
  String fromCamelCase(String str) {
    // Convert camelCase to snake_case
    return str
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'[-_\s]+'), '_')
        .replaceFirst(RegExp(r'^_'), '')
        .toLowerCase();
  }

  @override
  String fromSnakeCase(String str) {
    return str;
  }
}
