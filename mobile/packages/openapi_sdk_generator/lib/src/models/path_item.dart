import 'operation.dart';
import 'parameter.dart';
import 'server.dart';

/// Path item (represents operations available on a single path)
class PathItem {
  /// Summary
  final String? summary;

  /// Description
  final String? description;

  /// GET operation
  final Operation? get;

  /// PUT operation
  final Operation? put;

  /// POST operation
  final Operation? post;

  /// DELETE operation
  final Operation? delete;

  /// OPTIONS operation
  final Operation? options;

  /// HEAD operation
  final Operation? head;

  /// PATCH operation
  final Operation? patch;

  /// TRACE operation
  final Operation? trace;

  /// List of parameters
  final List<Parameter>? parameters;

  /// Servers
  final List<Server>? servers;

  PathItem({
    this.summary,
    this.description,
    this.get,
    this.put,
    this.post,
    this.delete,
    this.options,
    this.head,
    this.patch,
    this.trace,
    this.parameters,
    this.servers,
  });

  factory PathItem.fromJson(Map<String, dynamic> json) {
    return PathItem(
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      get: json['get'] != null
          ? Operation.fromJson(json['get'] as Map<String, dynamic>)
          : null,
      put: json['put'] != null
          ? Operation.fromJson(json['put'] as Map<String, dynamic>)
          : null,
      post: json['post'] != null
          ? Operation.fromJson(json['post'] as Map<String, dynamic>)
          : null,
      delete: json['delete'] != null
          ? Operation.fromJson(json['delete'] as Map<String, dynamic>)
          : null,
      options: json['options'] != null
          ? Operation.fromJson(json['options'] as Map<String, dynamic>)
          : null,
      head: json['head'] != null
          ? Operation.fromJson(json['head'] as Map<String, dynamic>)
          : null,
      patch: json['patch'] != null
          ? Operation.fromJson(json['patch'] as Map<String, dynamic>)
          : null,
      trace: json['trace'] != null
          ? Operation.fromJson(json['trace'] as Map<String, dynamic>)
          : null,
      parameters: json['parameters'] != null
          ? (json['parameters'] as List)
                .map((e) => Parameter.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      servers: json['servers'] != null
          ? (json['servers'] as List)
                .map((e) => Server.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (get != null) 'get': get!.toJson(),
      if (put != null) 'put': put!.toJson(),
      if (post != null) 'post': post!.toJson(),
      if (delete != null) 'delete': delete!.toJson(),
      if (options != null) 'options': options!.toJson(),
      if (head != null) 'head': head!.toJson(),
      if (patch != null) 'patch': patch!.toJson(),
      if (trace != null) 'trace': trace!.toJson(),
      if (parameters != null)
        'parameters': parameters!.map((e) => e.toJson()).toList(),
      if (servers != null) 'servers': servers!.map((e) => e.toJson()).toList(),
    };
  }

  /// Get all operations in this path item
  List<Operation> get allOperations {
    final operations = <Operation>[];
    if (get != null) operations.add(get!);
    if (put != null) operations.add(put!);
    if (post != null) operations.add(post!);
    if (delete != null) operations.add(delete!);
    if (options != null) operations.add(options!);
    if (head != null) operations.add(head!);
    if (patch != null) operations.add(patch!);
    if (trace != null) operations.add(trace!);
    return operations;
  }
}
