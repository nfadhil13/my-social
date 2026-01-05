import 'dart:convert';

import 'package:openapi_sdk_generator/src/models/openapi_spec.dart';
import 'package:yaml/yaml.dart';

enum InputTypeEnum { json, yaml }

sealed class InputType {
  Future<OpenApiSpec> parse(String specification);

  static InputType fromEnum(InputTypeEnum inputType) {
    switch (inputType) {
      case InputTypeEnum.json:
        return JsonInputType();
      case InputTypeEnum.yaml:
        return YamlInputType();
    }
  }
}

class JsonInputType implements InputType {
  JsonInputType();
  @override
  Future<OpenApiSpec> parse(String specification) async {
    return OpenApiSpec.fromJson(json.decode(specification));
  }
}

class YamlInputType implements InputType {
  YamlInputType();

  @override
  Future<OpenApiSpec> parse(String specification) async {
    final yamlMap = loadYaml(specification);
    return OpenApiSpec.fromJson((yamlMap as YamlMap).toMap());
  }
}

extension YamlMapConverter on YamlMap {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return v.toMap();
    } else if (v is YamlList) {
      var list = <dynamic>[];
      for (var e in v) {
        list.add(_convertNode(e));
      }
      return list;
    } else {
      return v;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    nodes.forEach((k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }
}
